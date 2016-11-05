`default_nettype none
/** VGA module for graphics pipeline - reads out of double buffer
 * and outputs to Zedboard VGA interface
 *
 *  NOTE: clk_wiz_0 should take the Zedboard's 100Mhz clock
 *        and output a 50.330Mhz clock.
 *
 */

// For 16.78Mhz clock, 240x160:
//      4 cycles per pixels
//      308 dots/line (with blank)
//      1232 cycles/line
//      228 lines/screen (with blank)
//      280896 cycles/screen
//      59.727Hz refresh rate

`define HSYNC_CYCLES 1596
`define HDISP_CYCLES 1280
`define HPW_CYCLES 190
`define HBP_CYCLES 95
/*
`define HSYNC_CYCLES 1600
`define HDISP_CYCLES 1280
`define HPW_CYCLES 192
`define HBP_CYCLES 96
*/
`define HDISP_START (`HPW_CYCLES + `HBP_CYCLES)


`define VSYNC_LINES 528
`define VDISP_LINES 480
`define VBP_LINES 36
`define VPW_LINES 2
/*
`define VSYNC_LINES 525
`define VDISP_LINES 480
`define VBP_LINES 33
`define VPW_LINES 2
*/
`define VDISP_START (`VPW_LINES + `VBP_LINES)

`define NUM_ROWS 480
`define NUM_COLS 640

`define GBA_ROWS 160
`define GBA_COLS 240
`define GBA_COLS_WIDTH 8

`define GBA_PIXELS (`GBA_ROWS * `GBA_COLS)

module vga_counter
    #(parameter WIDTH = 8,
      parameter MAX = 1)
    (input  logic clock, reset,
     input  logic en,
     output logic [WIDTH-1:0] out);

    (* mark_debug= "true" *) logic [WIDTH-1:0] next_out;

    always_comb begin
        if(out + 1 == MAX) next_out = {WIDTH{1'b0}};
        else next_out = out+1;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)  out <= 0;
        else if(en) out <= next_out;
        else        out <= out;
    end
endmodule: vga_counter

module vga_rangecheck
   #(parameter WIDTH = 8,
     parameter LOW = 0,
     parameter HI = 1)
   (input  logic [WIDTH-1:0] val,
    output logic in_range);

    assign in_range = LOW <= val && val < HI;
endmodule: vga_rangecheck

// Track columns by cycle, track rows by line (numbers are smaller)
module vga
   (input  logic clock, reset,
    output logic [8:0] row,
    output logic [9:0] col,
    output logic HS, VS);

    logic [10:0] h_cycles, v_lines;
    logic row_end, HS_L, VS_L;

    assign col = (h_cycles - `HDISP_START) >> 1;
    assign row = v_lines - `VDISP_START;
    assign row_end = h_cycles == (`HSYNC_CYCLES - 1);
    assign {HS, VS} = {~HS_L, ~VS_L};

    vga_counter #(11, `HSYNC_CYCLES) hct (clock, reset, 1'b1, h_cycles);
    vga_counter #(11, `VSYNC_LINES) vct (clock, reset, row_end, v_lines);

    vga_rangecheck #(11, 0, `HPW_CYCLES) hsync (h_cycles, HS_L);
    vga_rangecheck #(11, 0, `VPW_LINES) vsync (v_lines, VS_L);

endmodule: vga


// TODO Make VGA color be data when addr is in range, and black otherwise
// TODO Addr should be VGA index + 1
module vga_top(
    input  logic clock, reset,
    (* mark_debug = "true" *) input  logic [14:0] data,
    (* mark_debug = "true" *) output logic [16:0] addr,
    (* mark_debug = "true" *) output logic [3:0] VGA_R, VGA_G, VGA_B,
    output logic VGA_HS, VGA_VS);

    (* mark_debug = "true" *) logic [8:0] row;
    (* mark_debug = "true" *) logic [9:0] col;
    (* mark_debug = "true" *) logic [16:0] curr_addr;

    // Ignore LSB of color from graphics since we only have 4 bits
    logic on_screen;
    assign on_screen = row[8:1] < `GBA_ROWS && col[9:1] < `GBA_COLS;
    assign VGA_R = (on_screen) ? data[14:11] : 4'h0;
    assign VGA_G = (on_screen) ? data[9:6] : 4'h0;
    assign VGA_B = (on_screen) ? data[4:1] : 4'h0;

    // Synchronous reads, don't make out of bounds accesses
    assign addr = (row[8:1] < `GBA_ROWS && col[9:1] < `GBA_COLS) ? curr_addr : 17'd0;

    vga vga (.clock, .reset, .HS(VGA_HS), .VS(VGA_VS), .row, .col);
    //vga vga (.CLOCK_50(clock), .reset(reset), .HS(VGA_HS), .VS(VGA_VS), .row, .col, .blank());
    addr_calc calc (.clock, .reset, .row, .col, .addr(curr_addr));

endmodule: vga_top


module addr_calc(
    input  logic clock, reset,
    input  logic [8:0] row,
    input  logic [9:0] col,
    output logic [16:0] addr);
    
    logic updateable;
    vga_counter #(1, 2) update_counter(.clock, .reset, .en(1'b1), .out(updateable));

    (* mark_debug="true" *)logic [16:0] rows_idx, next_row_idx;
    
    always_ff @(posedge clock, posedge reset)
        if(reset)
            rows_idx <= 0;
        else
            rows_idx <= next_row_idx;
            
    //advance to the next row at the end of the current row
    always_comb begin
        next_row_idx = rows_idx;
        if(updateable) begin
            if(col == `NUM_COLS-1) begin
                if(row == 9'h1FF) begin
                    next_row_idx = 0;
                end            
                else begin
                    if(row[0]) begin
                        next_row_idx = rows_idx + `GBA_COLS;
                    end
                end
            end
        end
    end

    assign addr = rows_idx + col[9:1];

endmodule: addr_calc

/*
// If SW0 high, display horizontal test pattern, otherwise display
// standard vertical test pattern
module vga_top_testpattern (
    input  logic GCLK, BTND,
    input  logic [7:0] SW,
    output logic [7:0] LD,
    (* mark_debug = "true" *) output logic VGA_HS, VGA_VS,
    (* mark_debug = "true" *) output logic [3:0] VGA_R, VGA_B, VGA_G);

    logic c_red, r_red;
    logic [1:0] c_green, r_green;
    logic [3:0] c_blue, r_blue;
    (* mark_debug = "true" *) logic [8:0] row;
    (* mark_debug = "true" *) logic [9:0] col;

    logic GBA_CLK;
    logic [1:0] divider;

    // clk_wiz_0 clk_wiz (.clk_in1(GCLK), .reset(BTND), .clk_out1(GBA_CLK));
    always_ff @(posedge GCLK, posedge BTND) begin
        if (BTND) divider <= 2'b0;
        else divider <= divider + 1;
    end
    assign GBA_CLK = divider[1];

    always_comb begin
        // "Random" test pattern"
        if (SW[1] && (row < (`GBA_ROWS << 1)) && (col < (`GBA_COLS << 1))) begin
            VGA_R = ((row ^ col[8:0]) + row);
            VGA_B = ((row ^ col[8:0]));
            VGA_G = ((row ^ col[8:0]) - row - col[8:0]);
        end else if (SW[1]) begin
            VGA_R = 4'd0;
            VGA_G = 4'd0;
            VGA_B = 4'd0;
        end
        else if (SW[0]) begin
            VGA_R = r_red ? {3'h7, row[0]} : 4'h0;
            VGA_G = |r_green ? {3'h7, row[0]} : 4'h0;
            VGA_B = |r_blue ? {3'h7, row[0]} : 4'h0;
        end else begin
            if (row < 10'd240) begin
                VGA_R = c_red ? {3'h7, row[0]} : 4'h0;
                VGA_G = |c_green ? {3'h7, row[0]} : 4'h0;
                VGA_B = |c_blue ? {3'h7, row[0]} : 4'h0;
            end else begin
                VGA_R = {3'h7, row[0]};
                VGA_G = {3'h7, row[0]};
                VGA_B = {3'h7, row[0]};
            end
        end
    end

    vga vga (.clock(GBA_CLK), .reset(BTND), .HS(VGA_HS), .VS(VGA_VS), .row, .col);

    vga_rangecheck #(10, 10'd320, 10'd640) cr  (col, c_red);
    vga_rangecheck #(10, 10'd160, 10'd320) cg0 (col, c_green[0]);
    vga_rangecheck #(10, 10'd480, 10'd640) cg1 (col, c_green[1]);
    vga_rangecheck #(10, 10'd80,  10'd160) cb0 (col, c_blue[0]);
    vga_rangecheck #(10, 10'd240, 10'd320) cb1 (col, c_blue[1]);
    vga_rangecheck #(10, 10'd400, 10'd480) cb2 (col, c_blue[2]);
    vga_rangecheck #(10, 10'd560, 10'd640) cb3 (col, c_blue[3]);

    vga_rangecheck #(9, 9'd240, 9'd480) rr (row, r_red);
    vga_rangecheck #(9, 9'd120, 9'd240) rg0 (row, r_green[0]);
    vga_rangecheck #(9, 9'd360, 9'd480) rg1 (row, r_green[1]);
    vga_rangecheck #(9, 9'd60,  9'd120) rb0 (row, r_blue[0]);
    vga_rangecheck #(9, 9'd180, 9'd240) rb1 (row, r_blue[1]);
    vga_rangecheck #(9, 9'd300, 9'd360) rb2 (row, r_blue[2]);
    vga_rangecheck #(9, 9'd420, 9'd480) rb3 (row, r_blue[3]);

    assign LD = SW;
endmodule: vga_top_testpattern
*/

/*
module vga_sim_top;
    logic clock, reset;
    logic [7:0] SW, LD;
    logic VGA_VS, VGA_HS;
    logic [3:0] VGA_R, VGA_G, VGA_B;

    vga_top_testpattern dut (.GCLK(clock), .BTND(reset), .*);

    initial begin
        reset = 1'b0;
        clock = 1'b0;
        SW = 8'b0;
        reset <= 1'b1;
        #1 reset <= 1'b0;
        forever #1 clock <= ~clock;
    end

    initial begin
        #8000000 $finish;
    end
endmodule: vga_sim_top
*/
