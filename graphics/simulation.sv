`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module sim_bench;
    
    logic [7:0] SW;
    logic       reset, BTNR, BTNL;
    logic        graphics_clock;
    
    logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr;
    logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr;
    logic [31:0] gfx_vram_A_addr2;
    logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data;
    logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data;
    logic [31:0] gfx_vram_A_data2;
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

    assign bg1cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b10};
    //256x256 char background
    //screen base block 2
    //256-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg2cnt = {2'b0, 1'b0, 5'd2, 1'b1, 1'b0, 2'b00, 2'b01};
    //256x256 char background
    //no wraparound
    //screen base block 6
    //256-bit color
    //no mosaic
    //character base block 1
    //priority = 10 (second lowest priority)

    assign bg3cnt = {2'b0, 1'b0, 5'd2, 1'b1, SW[5], 2'b00, 2'b00};
    //256x256 char background
    //screen base block 4
    //16-bit color
    //mosaic if SW[5]
    //character base block 1
    //priority = 00 (highest priority)

    assign mosaic = 16'h3333; // 4x mosaicing in all directions for BG and OBJ
    
    //TODO: don't know what these registers are, but they have to be defined
    assign bg2x = 27'b0;
    assign bg3x = 27'b0;
    assign bg2y = 27'b0;
    assign bg3y = 27'b0;
    assign vcount = 8'b0;

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
    assign win0H = 16'h0050;
    assign win0V = 16'h00A0;

    //window 1 covers right third of the screen
    assign win1H = 16'hA0F0;
    assign win1V = 16'h00A0;

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
    logic vga_block;
    logic [15:0] graphics_color;
    logic [16:0] graphics_addr, vga_addr;
   
    logic [14:0] buffer0_dout, buffer1_dout;
    logic [16:0] buffer0_address, buffer1_address;
    logic [14:0] buffer0_din, buffer1_din;
    logic buffer0_ce, buffer1_ce;
    logic buffer0_we, buffer1_we;

    //mem
    mem_vram_A   vramA(.addr(gfx_vram_A_addr), .clock(graphics_clock), 
                .data(gfx_vram_A_data));
    mem_palette palette(.addr(gfx_palette_bg_addr), .clock(graphics_clock), 
                .data(gfx_palette_bg_data));
    mem_vram_A   vramA2(.addr(gfx_vram_A_addr2), .clock(graphics_clock), 
                .data(gfx_vram_A_data2));
    mem_obj    obj(.addr(gfx_palette_obj_addr), .clock(graphics_clock), 
                .data(gfx_palette_obj_data));
    //graphics
    graphics_top top(.clock(graphics_clock), .reset,
                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_oam_data, .gfx_palette_bg_data, .gfx_palette_obj_data,
                 .gfx_vram_A_data2,
                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_oam_addr, .gfx_palette_bg_addr, .gfx_palette_obj_addr,
                 .gfx_vram_A_addr2, .registers(IO_reg_datas),
                 .output_color(graphics_color));

    initial begin
        $monitor ("graphics_clock=%b, graphics_color=%h", graphics_clock, graphics_color);
        graphics_clock <= 0;
        reset <= 1;
        #2 reset <= 0;
        BTNL <= 1;
        BTNR <= 1;
        SW <= 8'b00001111; //enable all backgrounds. disable objs
        #32 $finish;
    end
    always
        #1 graphics_clock = !graphics_clock; 

endmodule: sim_bench

module mem_vram_A (
    input logic [31:0] addr,
    input logic clock,
    output logic [31:0] data);

    logic [31:0] vram_A [16383:0];
    initial begin
        $readmemh("vram_a_sim.txt", vram_A);
    end

    always_ff @(posedge clock) begin
        data <= vram_A[addr[31:2]];
        $display("data=%h addr=%h word=%h",data, addr, addr[31:2]);
    end
endmodule: mem_vram_A

module mem_vram_A2 (
    input logic [31:0] addr,
    input logic clock,
    output logic [31:0] data);

    logic [31:0] vram_A2 [16383:0];
    initial begin
        $readmemh("vram_a_sim.txt", vram_A2);
    end

    always_ff @(posedge clock) begin
        data <= vram_A2[addr[31:2]];
    end
endmodule: mem_vram_A2

module mem_palette (
    input logic [31:0] addr,
    input logic clock,
    output logic [31:0] data);

    logic [31:0] palette_bg [127:0];
    initial begin
        $readmemh("palette_sim.txt", palette_bg);
    end

    always_ff @(posedge clock) begin
        data <= palette_bg[addr[31:2]];
    end
endmodule: mem_palette

module mem_obj (
    input logic [31:0] addr,
    input logic clock,
    output logic [31:0] data);

    logic [31:0] obj_data [127:0];
    initial begin
        $readmemh("vram_a_sim.txt", obj_data);
    end

    always_ff @(posedge clock) begin
        data <= obj_data[addr[31:2]];
    end
endmodule: mem_obj

`default_nettype wire
