`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module manual_bench (
    input  logic [7:0] SW,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    input  logic       BTND,
    input  logic       GCLK);


    logic [15:0] winin;
    logic [15:0] winout;
    logic [15:0] dispcnt;
    logic [15:0] win0H;
    logic [15:0] win1H;
    logic [15:0] win0V;
    logic [15:0] win1V;
    logic [15:0] bldcnt;
    logic [15:0] bldalpha;
    logic [15:0] bldy;
    logic [7:0] vcount;
    logic [15:0] bg0cnt;
    logic [15:0] bg1cnt;
    logic [15:0] bg2cnt;
    logic [15:0] bg3cnt;
    logic [15:0] bg0hofs;
    logic [15:0] bg1hofs;
    logic [15:0] bg2hofs;
    logic [15:0] bg3hofs;
    logic [15:0] bg0vofs;
    logic [15:0] bg1vofs;
    logic [15:0] bg2vofs;
    logic [15:0] bg3vofs;
    logic [27:0] bg2x;
    logic [27:0] bg3x;
    logic [27:0] bg2y;
    logic [27:0] bg3y;
    logic [15:0] bg2pa;
    logic [15:0] bg2pb;
    logic [15:0] bg2pc;
    logic [15:0] bg3pd;
    logic [15:0] mosaic;

    logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0];

    logic clock, reset;

    assign reset = BTND;

    assign IO_reg_datas[`WININ_IDX][15:0] = winin;
    assign IO_reg_datas[`WINOUT_IDX][31:16] = winout;
    assign IO_reg_datas[`DISPCNT_IDX][15:0] = dispcnt; //
    assign IO_reg_datas[`WIN0H_IDX][15:0] = win0H;
    assign IO_reg_datas[`WIN1H_IDX][31:16] = win1H;
    assign IO_reg_datas[`WIN0V_IDX][15:0] = win0V;
    assign IO_reg_datas[`WIN1V_IDX][31:16] = win1V;
    assign IO_reg_datas[`VCOUNT_IDX][7:0] = vcount;
    assign IO_reg_datas[`BLDCNT_IDX][15:0] = bldcnt;
    assign IO_reg_datas[`BLDALPHA_IDX][31:16] = bldalpha;
    assign IO_reg_datas[`BLDY_IDX][15:0] = bldy;
    
    assign IO_reg_datas[`BG0CNT_IDX][15:0] = bg0cnt;
    assign IO_reg_datas[`BG1CNT_IDX][31:16] = bg1cnt;
    assign IO_reg_datas[`BG2CNT_IDX][15:0] = bg2cnt;
    assign IO_reg_datas[`BG3CNT_IDX][31:0] = bg3cnt;
    
    assign IO_reg_datas[`BG0HOFS_IDX][15:0] = bg0hofs;
    assign IO_reg_datas[`BG1HOFS_IDX][15:0] = bg1hofs;
    assign IO_reg_datas[`BG2HOFS_IDX][15:0] = bg2hofs;
    assign IO_reg_datas[`BG3HOFS_IDX][15:0] = bg3hofs;
    
    assign IO_reg_datas[`BG0VOFS_IDX][31:16] = bg0vofs;
    assign IO_reg_datas[`BG1VOFS_IDX][31:16] = bg1vofs;
    assign IO_reg_datas[`BG2VOFS_IDX][31:16] = bg2vofs;
    assign IO_reg_datas[`BG3VOFS_IDX][31:16] = bg3vofs;

    assign IO_reg_datas[`BG2X_L_IDX][27:0] = bg2x;
    assign IO_reg_datas[`BG3X_L_IDX][27:0] = bg3x;
    assign IO_reg_datas[`BG2Y_L_IDX][27:0] = bg2y;
    assign IO_reg_datas[`BG3Y_L_IDX][27:0] = bg3y;

    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg2pa;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg2pb;
    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg2pc;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg2pd;
    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg3pa;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg3pb;
    assign IO_reg_datas[`BG2PA_IDX][15:0] = bg3pc;
    assign IO_reg_datas[`BG2PA_IDX][31:16] = bg3pd;
    assign IO_reg_datas[`MOSAIC_IDX][15:0] = mosaic;
    
    assign dispcnt = {3'b111, SW[4:0], 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 3'b001};
    //no windows
    //display layers specified by switches
    //no forced blank
    //1-dimensional obj vram
    //enable hblank processing
    //display bitmap frame 0
    //bg mode 001 - BG 0 & 1 are char bgs, BG2 is rotation/scaling

    assign bg0cnt = {2'b0, 1'b0, 5'b0, 1'b0, SW[5], 2'b00, 2'b11};
    //256x256 char background
    //screen base block 0
    //16-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 11 (lowest priority)

    assign bg1cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b11};
    //256x256 char background
    //screen base block 2
    //256-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg2cnt = {2'b0, 1'b0, 5'd2, 1'b1, 1'b0, 2'b00, 2'b11};
    //256x256 char background
    //no wraparound
    //screen base block 6
    //256-bit color
    //no mosaic
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg3cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b11};
    //256x256 char background
    //screen base block 4
    //16-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 00 (highest priority)

    assign mosaic = 16'h3333; // 4x mosaicing in all directions for BG and OBJ

    assign bg0hofs = 16'b0;
    assign bg1hofs = 16'b0;
    assign bg2hofs = 16'b0;
    assign bg3hofs = 16'b0;
    assign bg0vofs = 16'b0;
    assign bg1vofs = 16'b0;
    assign bg2vofs = 16'b0;
    assign bg3vofs = 16'b0;

    //default BG2 to no rotation
    //rotate 45 degrees if SW[6] is set 
    assign bg2pa = SW[6] ? 16'h005A : 16'h0100;
    assign bg2pb = SW[6] ? 16'h805A : 16'h0000;
    assign bg2pc = SW[6] ? 16'h005A : 16'h0000;
    assign bg2pd = SW[6] ? 16'h005A : 16'h0100;
    assign bg3pa = 16'h0100;
    assign bg3pb = 16'h0000;
    assign bg3pc = 16'h0000;
    assign bg3pd = 16'h0100;

    //window 0 covers left third of the screen
    assign win0h = 16'h0050;
    assign win0v = 16'h00A0;

    //window 1 covers right third of the screen
    assign win1h = 16'hA0F0;
    assign win1v = 16'h00A0;

    //enable display in win0 if BTNL is pressed, in win1 if BTNR
    assign winin = {2'b0, {6{BTNR}}, 2'b0, {6{BTNL}}};
    assign winout = 16'hFFFF; //always display outside of windows

    //disable special effects
    assign bldcnt = 16'h0000;

    //special effects will do.. something?
    assign bldalpha = 16'h001F;
    assign bldy = 16'h001F;

    //module instantiations
    logic wen, toggle;
    logic graphics_clock, vga_block;
    logic [14:0] graphics_color, vga_color;
    logic [16:0] graphics_addr, vga_addr;
   
    logic [14:0] buffer0_dout, buffer1_dout;
    logic [16:0] buffer0_address, buffer1_address;
    logic [14:0] buffer0_din, buffer1_din;
    logic buffer0_ce, buffer1_ce;
    logic buffer0_we, buffer1_we;
    //clock wiz
    design_1_clk_wiz_0_1 clk_wiz(.clk_in1(GCLK), .clk_out1(vga_clock), .clk_out2(graphics_clock), .reset(BTND));

    //dbl_buffer buffers
    testbench_wrapper brams(.buffer0_addr(buffer0_address), .buffer0_clk(vga_clock), .buffer0_din, .buffer0_dout, .buffer0_en(buffer0_ce), .buffer0_we,
                            .buffer1_addr(buffer1_address), .buffer1_clk(vga_clock), .buffer1_din, .buffer1_dout, .buffer1_en(buffer1_ce), .buffer1_we);

    //interface between graphics and dbl_buffer
    dblbuffer_driver driver(.toggle, .wen, .graphics_clock, .vcount, .graphics_addr, .clk(vga_clock), .rst_b(~BTND));

    //double_buffer
    double_buffer video_buf(.ap_clk(vga_clock), .ap_rst_n(~BTND), .graphics_addr, .graphics_color, .toggle, .vga_addr, .wen, .vga_color,
                            .buffer0_address, .buffer1_address,
                            .buffer0_din, .buffer1_din,
                            .buffer0_dout, .buffer1_dout,
                            .buffer0_ce, .buffer1_ce,
                            .buffer0_we, .buffer1_we);
    //vga
    vga_top video(.clock(vga_clock), .reset(BTND), .data(vga_color), .addr(vga_addr), .VGA_R, .VGA_G, .VGA_B, .VGA_HS, .VGA_VS);

    //graphics
    graphics_top(.clock(graphics_clock), .reset, .IO_reg_datas,
                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_oam_data, .gfx_palette_bg_data, .gfx_pallete_obj_data,
                 .gfx_vram_A_data2m,
                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_oam_addr, .gfx_palette_bg_addr, .gfx_palette_obj_addr,
                 .gfx_vram_A_addr2,
                 .output_color(graphics_color));

endmodule: manual_bench

module dblbuffer_driver(
    output logic toggle,
    output logic wen,
    input logic graphics_clock,
    output logic [16:0] graphics_addr,
    output logic [7:0] vcount,
    input logic clk,
    input logic rst_b
    );
    
    assign vcount = row;
    
    dbdriver_counter #(20, 842687) toggler(.clk, .rst_b, .en(1'b1), .last(toggle), .Q());
    
    logic [18:0] addr;
    logic [7:0] row;
    logic [8:0] col;
    
    logic step_row;
    logic next_frame;
    assign graphics_addr = addr[18:2];
    dbdriver_counter #(19, 280895) addrs(.clk(graphics_clock), .en(1'b1), .clear(1'b0), .rst_b, .last(next_frame), .Q(addr));

    dbdriver_counter #(8, 159) rows(.clk(graphics_clock), .en(step_row & addr[1] & addr[0]), .clear(next_frame & addr[1] & addr[0]), .rst_b, .last(), .Q(row));
    dbdriver_counter #(9, 239) cols(.clk(graphics_clock), .en(addr[1] & addr[0]), .clear(next_frame & addr[1] & addr[0]), .rst_b, .last(step_row), .Q(col));

    assign wen = graphics_addr < 38400;
    
endmodule

module dbdriver_counter 
    #(
    parameter WIDTH=18,
    parameter MAX = 210671
    )
    (
    input logic clk,
    input logic rst_b,
    input logic en,
    input logic clear,
    output logic [WIDTH-1:0] Q,
    output logic last
    );
    
    assign last = Q == MAX;
    
    logic [WIDTH-1:0] next;
        
    always_comb begin
        if(clear) begin
            next = 0;    
        end
        else if(~en) begin
            next = Q;
        end
        else if(last) begin
            next = 0;
        end
        else begin
            next = Q + 1;
        end
    end 

    always_ff @(posedge clk, negedge rst_b) begin
        if(~rst_b) begin
            Q <= 0;
        end
        else begin
            Q <= next;
        end
    end
endmodule
