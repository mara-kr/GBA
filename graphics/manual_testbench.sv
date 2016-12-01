`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"
`default_nettype none

module manual_bench (
    input  logic [7:0] SW,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    input  logic       BTND, BTNR, BTNL,
    output  logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr,
    output  logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr,
    output  logic [31:0] gfx_vram_A_addr2,
    input  logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data,
    input  logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data,
    input  logic [31:0] gfx_vram_A_data2,
    input  logic        graphics_clock, vga_clock,
    (* mark_debug = "true" *) output logic        VGA_HS,
    (* mark_debug = "true" *) output logic        VGA_VS
    );

    logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0];

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
    logic [15:0] bg2pd;
    logic [15:0] bg3pa;
    logic [15:0] bg3pb;
    logic [15:0] bg3pc;
    logic [15:0] bg3pd;
    logic [15:0] mosaic;

    logic reset;

    assign reset = BTND;

    assign IO_reg_datas[`WININ_IDX][15:0] = winin;
    assign IO_reg_datas[`WINOUT_IDX][31:16] = winout;
    assign IO_reg_datas[`DISPCNT_IDX][15:0] = dispcnt; //
    assign IO_reg_datas[`WIN0H_IDX][15:0] = win0H;
    assign IO_reg_datas[`WIN1H_IDX][31:16] = win1H;
    assign IO_reg_datas[`WIN0V_IDX][15:0] = win0V;
    assign IO_reg_datas[`WIN1V_IDX][31:16] = win1V;
    assign IO_reg_datas[`VCOUNT_IDX][15:8] = vcount;
    assign IO_reg_datas[`BLDCNT_IDX][15:0] = bldcnt;
    assign IO_reg_datas[`BLDALPHA_IDX][31:16] = bldalpha;
    assign IO_reg_datas[`BLDY_IDX][15:0] = bldy;
    
    assign IO_reg_datas[`BG0CNT_IDX][15:0] = bg0cnt;
    assign IO_reg_datas[`BG1CNT_IDX][31:16] = bg1cnt;
    assign IO_reg_datas[`BG2CNT_IDX][15:0] = bg2cnt;
    assign IO_reg_datas[`BG3CNT_IDX][31:16] = bg3cnt;
    
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
    assign IO_reg_datas[`BG2PB_IDX][31:16] = bg2pb;
    assign IO_reg_datas[`BG2PC_IDX][15:0] = bg2pc;
    assign IO_reg_datas[`BG2PD_IDX][31:16] = bg2pd;
    assign IO_reg_datas[`BG3PA_IDX][15:0] = bg3pa;
    assign IO_reg_datas[`BG3PB_IDX][31:16] = bg3pb;
    assign IO_reg_datas[`BG3PC_IDX][15:0] = bg3pc;
    assign IO_reg_datas[`BG3PD_IDX][31:16] = bg3pd;
    assign IO_reg_datas[`MOSAIC_IDX][15:0] = mosaic;
    
    assign dispcnt = {3'b111, 1'b1, SW[3:0], 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 3'b001};
    //no windows
    //display layers specified by switches
    //no forced blank
    //1-dimensional obj vram
    //enable hblank processing
    //display bitmap frame 0
    //bg mode 001 - BG 0 & 1 are char bgs, BG2 is rotation/scaling

    assign bg0cnt = {2'b0, 1'b0, 4'b0, SW[4], 1'b0, SW[5], 2'b0, 2'b01, 2'b11};
    //256x256 char background
    //screen base block 0
    //16-bit color
    //mosaic if SW[5]; 1'b0
    //character base block 1
    //priority = 11 (lowest priority)

    assign bg1cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b01, 2'b10};
    //256x256 char background
    //screen base block 2
    //256-bit color
    //mosaic if SW[5]; 1'b0
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg2cnt = {2'b01, 1'b0, 5'd6, 1'b1, SW[5], 2'b00, 2'b01, 2'b01};
    //256x256 rotation char background
    //no wraparound
    //screen base bGlock 6
    //256-bit color
    //no mosaic
    //character base block 1
    //priority = 01 (second highest priority)

    assign bg3cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b01, 2'b00};
    //256x256 char background
    //screen base block 4
    //16-bit color
    //mosaic if SW[5]; 1'b0
    //character base block 1
    //priority = 00 (highest priority)

    assign mosaic = 16'h3333; // 4x mosaicing in all directions for BG and OBJ


    //TODO: don't know what these registers are, but they have to be defined
    assign bg2x = 27'b0;
    assign bg3x = 27'b0;
    assign bg2y = 27'b0;
    assign bg3y = 27'b0;

    assign bg0hofs = SW[7] ? 16'd128 : 16'b0;
    assign bg1hofs = SW[7] ? 16'd128 : 16'b0;
    assign bg2hofs = SW[7] ? 16'd128 : 16'b0;
    assign bg3hofs = SW[7] ? 16'd128 : 16'b0;
    assign bg0vofs = SW[7] ? 16'd128 : 16'b0;
    assign bg1vofs = SW[7] ? 16'd128 : 16'b0;
    assign bg2vofs = SW[7] ? 16'd128 : 16'b0;
    assign bg3vofs = SW[7] ? 16'd128 : 16'b0;

    //default BG2 to no rotation
    //rotate 45 degrees if SW[6] is set 
    assign bg2pa = SW[6] ? 16'h00B5 : 16'h0100;
    assign bg2pb = SW[6] ? 16'h80B5 : 16'h0000;
    assign bg2pc = SW[6] ? 16'h00B5 : 16'h0000;
    assign bg2pd = SW[6] ? 16'h00B5 : 16'h0100;
    assign bg3pa = 16'h0100;
    assign bg3pb = 16'h0000;
    assign bg3pc = 16'h0000;
    assign bg3pd = 16'h0100;

    //window 0 covers left third of the screen
    assign win0H = 16'h0050;
    assign win0V = 16'h0050;

    //window 1 covers right third of the screen
    assign win1H = 16'hA0F0;
    assign win1V = 16'h50A0;

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
    logic [14:0] graphics_color, vga_color;
    logic [16:0] graphics_addr, vga_addr;
   
    logic [14:0] buffer0_dout, buffer1_dout;
    logic [16:0] buffer0_address, buffer1_address;
    logic [14:0] buffer0_din, buffer1_din;
    logic buffer0_ce, buffer1_ce;
    logic buffer0_we, buffer1_we;

    //dbl_buffer buffers

    blk_mem_gen_0 buf0 (.clka(vga_clock), .addra(buffer0_address), .dina(buffer0_din), .douta(buffer0_dout), .ena(buffer0_ce), .wea(buffer0_we));
    blk_mem_gen_1 buf1 (.clka(vga_clock), .addra(buffer1_address), .dina(buffer1_din), .douta(buffer1_dout), .ena(buffer1_ce), .wea(buffer1_we));

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
    graphics_top(.clock(graphics_clock), .reset,
                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_oam_data, .gfx_palette_bg_data, .gfx_palette_obj_data,
                 .gfx_vram_A_data2,
                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_oam_addr, .gfx_palette_bg_addr, .gfx_palette_obj_addr,
                 .gfx_vram_A_addr2,
                 .registers(IO_reg_datas),
                 .output_color(graphics_color));

endmodule: manual_bench

module dblbuffer_driver(
    (* mark_debug = "true" *)output logic toggle,
    (* mark_debug = "true" *)output logic wen,
    input logic graphics_clock,
    (* mark_debug = "true" *)output logic [16:0] graphics_addr,
    output logic [7:0] vcount,
    input logic clk,
    input logic rst_b
    );
    
    assign vcount = row;
    
    dbdriver_counter #(20, 842687) toggler(.clk, .rst_b, .en(1'b1), .clear(1'b0), .last(toggle), .Q());
    
    logic [18:0] timer;
    (* mark_debug = "true" *)logic [7:0] row;
    (* mark_debug = "true" *)logic [8:0] col;
    
    (* mark_debug = "true" *)logic step_row;
    (* mark_debug = "true" *)logic next_frame;
    logic step;
    assign step = timer[1] & timer[0];
    dbdriver_counter #(19, 280895) sync(.clk(graphics_clock), .en(1'b1), .clear(1'b0), .rst_b, .last(next_frame), .Q(timer));
    dbdriver_counter #(16, 38399) addrs(.clk(graphics_clock), .en(wen & step), .clear(next_frame & step), .rst_b, .last(), .Q(graphics_addr));

    dbdriver_counter #(8, 227) rows(.clk(graphics_clock), .en(step_row & step), .clear(next_frame & step), .rst_b, .last(), .Q(row));
    dbdriver_counter #(9, 307) cols(.clk(graphics_clock), .en(step), .clear(next_frame & step), .rst_b, .last(step_row), .Q(col));

    assign wen = row < 8'd160 && col < 9'd240;
    
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

`default_nettype wire
