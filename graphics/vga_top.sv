`default_nettype none
/** VGA module for graphics pipeline
 *
 *  NOTE: clk_wiz_0 should take the Zedboard's 100Mhz clock
 *        and output a 50.330Mhz clock.
 *
 *  TODO: Add interface for double buffering
 */

// For 16.78Mhz clock, 240x160:
//      4 cycles per pixels
//      308 dots/line (with blank)
//      1232 cycles/line
//      228 lines/screen (with blank)
//      280896 cycles/screen
//      59.727Hz refresh rate

`define HSYNC_CYCLES 1611
`define HDISP_CYCLES 1288
`define HPW_CYCLES 193
`define HBP_CYCLES 97
`define HDISP_START (`HPW_CYCLES + `HBP_CYCLES)
`define HDISP_END (`HDISP_START + `HDISP_CYCLES)

`define VSYNC_LINES 521
`define VDISP_LINES 480
`define VBP_LINES 29
`define VPW_LINES 2
`define VDISP_START (`VPW_LINES + `VBP_LINES)
`define VDISP_END (`VDISP_START + `VDISP_LINES)

`define NUM_ROWS 480
`define NUM_COLS 320

module vga_counter
    #(parameter WIDTH = 8,
      parameter MAX = 1)
    (input  logic clock, reset,
     input  logic en,
     output logic [WIDTH-1:0] out);

    always_ff @(posedge clock, posedge reset) begin
        if (reset || (out + 1 == MAX)) out <= 0;
        else out <= (en) ? out+1 : out;
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
    output logic HS, VS,
    output logic [8:0] row,
    output logic [9:0] col);

    logic [10:0] h_cycles, v_lines;
    logic row_end, HS_L, VS_L;

    assign col = (h_cycles - `HDISP_START) >> 1;
    assign row = v_lines - `VPW_LINES - `VBP_LINES;
    assign row_end = h_cycles == (`HSYNC_CYCLES - 1);
    assign {HS, VS} = {~HS_L, ~VS_L};

    vga_counter #(11, `HSYNC_CYCLES) hct (clock, reset, 1'b1, h_cycles);
    vga_counter #(11, `VSYNC_LINES) vct (clock, reset, row_end, v_lines);

    vga_rangecheck #(11, 0, `HPW_CYCLES) hsync (h_cycles, HS_L);
    vga_rangecheck #(11, 0, `VPW_LINES) vsync (v_lines, VS_L);
endmodule: vga

// If SW0 high, display horizontal test pattern, otherwise display
// standard vertical test pattern
module vga_top_testpattern (
    input  logic GCLK, BTND,
    input  logic [7:0] SW,
    output logic [7:0] LD,
    output logic VGA_HS, VGA_VS,
    output logic [3:0] VGA_R, VGA_B, VGA_G);

    logic c_red, r_red;
    logic [1:0] c_green, r_green;
    logic [3:0] c_blue, r_blue;
    logic [8:0] row;
    logic [9:0] col;

    logic GBA_CLK;
    clk_wiz_0 clk_wiz (.clk_in1(GCLK), .reset(BTND), .clk_out1(GBA_CLK));

    always_comb begin
        if (SW[0]) begin
            VGA_R = r_red ? 4'hF : 4'h0;
            VGA_G = |r_green ? 4'hF : 4'h0;
            VGA_B = |r_blue ? 4'hF : 4'h0;
        end else begin
            VGA_R = c_red ? 4'hF : 4'h0;
            VGA_G = |c_green ? 4'hF : 4'h0;
            VGA_B = |c_blue ? 4'hF : 4'h0;
        end
    end

    vga vga (.clock(GBA_CLK), .reset(BTND), .HS(VGA_HS), .VS(VGA_VS),
             .row(row), .col(col));

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
