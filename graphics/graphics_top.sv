`default_nettype none
`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module graphics_top(
    input logic clock, reset,

    input logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0],
    input logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data,
    input logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data,
    input logic [31:0] gfx_vram_A_data2,

    output  logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr,
    output  logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr,
    output  logic [31:0] gfx_vram_A_addr2,
    output logic [15:0] output_color);

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

    assign winin = IO_reg_datas[`WININ_IDX][15:0];
    assign winout = IO_reg_datas[`WINOUT_IDX][31:16];
    assign dispcnt = IO_reg_datas[`DISPCNT_IDX][15:0];
    assign win0H = IO_reg_datas[`WIN0H_IDX][15:0];
    assign win1H = IO_reg_datas[`WIN1H_IDX][31:16];
    assign win0V = IO_reg_datas[`WIN0V_IDX][15:0];
    assign win1V = IO_reg_datas[`WIN1V_IDX][31:16];
    assign vcount = IO_reg_datas[`VCOUNT_IDX][7:0];
    assign bldcnt = IO_reg_datas[`BLDCNT_IDX][15:0];
    assign bldalpha = IO_reg_datas[`BLDALPHA_IDX][31:16];
    assign bldy = IO_reg_datas[`BLDY_IDX][15:0];
    
    assign bg0cnt = IO_reg_datas[`BG0CNT_IDX][15:0];
    assign bg1cnt = IO_reg_datas[`BG1CNT_IDX][31:16];
    assign bg2cnt = IO_reg_datas[`BG2CNT_IDX][15:0];
    assign bg3cnt = IO_reg_datas[`BG3CNT_IDX][31:0];
    
    assign bg0hofs = IO_reg_datas[`BG0HOFS_IDX][15:0];
    assign bg1hofs = IO_reg_datas[`BG1HOFS_IDX][15:0];
    assign bg2hofs = IO_reg_datas[`BG2HOFS_IDX][15:0];
    assign bg3hofs = IO_reg_datas[`BG3HOFS_IDX][15:0];
    
    assign bg0vofs = IO_reg_datas[`BG0VOFS_IDX][31:16];
    assign bg1vofs = IO_reg_datas[`BG1VOFS_IDX][31:16];
    assign bg2vofs = IO_reg_datas[`BG2VOFS_IDX][31:16];
    assign bg3vofs = IO_reg_datas[`BG3VOFS_IDX][31:16];

    assign bg2x = IO_reg_datas[`BG2X_L_IDX][27:0];
    assign bg3x = IO_reg_datas[`BG3X_L_IDX][27:0];
    assign bg2y = IO_reg_datas[`BG2Y_L_IDX][27:0];
    assign bg3y = IO_reg_datas[`BG3Y_L_IDX][27:0];

    assign bg2pa = IO_reg_datas[`BG2PA_IDX][15:0];
    assign bg2pb = IO_reg_datas[`BG2PA_IDX][31:16];
    assign bg2pc = IO_reg_datas[`BG2PA_IDX][15:0];
    assign bg2pd = IO_reg_datas[`BG2PA_IDX][31:16];
    assign bg3pa = IO_reg_datas[`BG2PA_IDX][15:0];
    assign bg3pb = IO_reg_datas[`BG2PA_IDX][31:16];
    assign bg3pc = IO_reg_datas[`BG2PA_IDX][15:0];
    assign bg3pd = IO_reg_datas[`BG2PA_IDX][31:16];
    assign mosaic = IO_reg_datas[`MOSAIC_IDX][15:0];

    logic [14:0] pe_color0;
    logic [14:0] pe_color1;
    logic [19:0] pe_layer0;
    logic [19:0] pe_layer1;
    logic [4:0] pe_effects;
    logic [19:0] bg;
    logic [19:0] obj;

    logic [16:0] bg_addr;
    logic [14:0] obj_addr;
    logic [15:0] obj_data;
    logic [15:0] bg_screen_addr;
    logic [15:0] bg_VRAM_data;
    logic [15:0] bg_screen_data;
    logic [2:0] bgmode;
    logic [7:0] hcount;

    //Background
    bg_processing_circuit bg_circ(
        .bg0cnt, .bg1cnt, 
        .bg2cnt, .bg3cnt,
        .bg0hofs, .bg1hofs, 
        .bg2hofs, .bg3hofs,
        .bg0vofs, .bg1vofs, 
        .bg2vofs, .bg3vofs,
        .bg2x, .bg3x,
        .bg2y, .bg3y, .bg2pa, 
        .bg2pb, .bg2pc, .bg2pd,
        .bg3pa, .bg3pb, .bg3pc, .bg3pd,
        .dispcnt, .mosaic,
        .hcount,
        .bgmode, .bg_addr,
        .bg_screen_addr, 
        .bg_VRAM_data, .bg_screen_data,
        .bg_packet(bg),
        .clock, .rst_b(~reset));

    vram_controller vram(.bg_addr, .bg_screen_addr, .obj_addr,
        .bg_data(bg_VRAM_data), .obj_data, .bg_screen_data,
        //address is 16 bits
        .graphics_VRAM_A_addr(gfx_vram_A_addr[15:0]),
        .graphics_VRAM_B_addr(gfx_vram_B_addr[13:0]),
        .graphics_VRAM_C_addr(gfx_vram_C_addr[13:0]),
        .graphics_VRAM_A_addr2(gfx_vram_A_addr2[15:0]),
        .graphics_VRAM_A_data(gfx_vram_A_data),
        .graphics_VRAM_B_data(gfx_vram_B_data),
        .graphics_VRAM_C_data(gfx_vram_C_data),
        .graphics_VRAM_A_data2(gfx_vram_A_data2),
        .bgmode,
        .clock);

    //Object
    obj_top obj_circ(.clock, .reset,
        .OAM_mem_addr(gfx_oam_addr), .VRAM_mem_addr(obj_addr),
        .obj_packet(obj),
        .OAM_mem_data(gfx_oam_data), .VRAM_mem_data(obj_data),
        .vcount(vcount + 8'b1), .hcount,
        .dispcnt, .bgmode);
    //row is 3 ahead of VCOUNT
    //Priority Evaluation
    pe_top pe( 
        .clock, .reset,
        .BG(bg), .OBJ(obj),
        .winin, .winout,.dispcnt,
        .win0H, .win1H, .win0V, .win1V,
        .vcount,
        .gfx_palette_bg_data,
        .gfx_palette_obj_data,
        .gfx_palette_bg_addr,
        .gfx_palette_obj_addr,
        .pe_color0, .pe_color1,
        .pe_layer0, .pe_layer1,
        .pe_effects);

    //Special Effects
    special_color_proc se(
        .layer0(pe_layer0), .bldcnt,
        .effects(pe_effects),
        .layer1(pe_layer1),
        .color0(pe_color0),
        .color1(pe_color1),
        .bldalpha, .bldy, .color(output_color));

endmodule: graphics_top
