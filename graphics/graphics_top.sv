`default_nettype none
`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module graphics_top(
    input logic clock, reset,

    input logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data,
    input logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data,
    input logic [31:0] gfx_vram_A_data2,
    input logic [31:0] registers [`NUM_IO_REGS-1:0],

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

    assign winin = registers[`WININ_IDX][15:0];
    assign winout = registers[`WINOUT_IDX][31:16];
    assign dispcnt = registers[`DISPCNT_IDX][15:0];
    assign win0H = registers[`WIN0H_IDX][15:0];
    assign win1H = registers[`WIN1H_IDX][31:16];
    assign win0V = registers[`WIN0V_IDX][15:0];
    assign win1V = registers[`WIN1V_IDX][31:16];
    assign vcount = registers[`VCOUNT_IDX][23:16];
    assign bldcnt = registers[`BLDCNT_IDX][15:0];
    assign bldalpha = registers[`BLDALPHA_IDX][31:16];
    assign bldy = registers[`BLDY_IDX][15:0];
    assign bg0cnt = registers[`BG0CNT_IDX][15:0];
    assign bg1cnt = registers[`BG1CNT_IDX][31:16];
    assign bg2cnt = registers[`BG2CNT_IDX][15:0];
    assign bg3cnt = registers[`BG3CNT_IDX][31:16];
    assign bg0hofs = registers[`BG0HOFS_IDX][15:0];
    assign bg1hofs = registers[`BG1HOFS_IDX][15:0];
    assign bg2hofs = registers[`BG2HOFS_IDX][15:0];
    assign bg3hofs = registers[`BG3HOFS_IDX][15:0];
    assign bg0vofs = registers[`BG0VOFS_IDX][31:16];
    assign bg1vofs = registers[`BG1VOFS_IDX][31:16];
    assign bg2vofs = registers[`BG2VOFS_IDX][31:16];
    assign bg3vofs = registers[`BG3VOFS_IDX][31:16];

    assign bg2x = registers[`BG2X_L_IDX][27:0];
    assign bg3x = registers[`BG3X_L_IDX][27:0];
    assign bg2y = registers[`BG2Y_L_IDX][27:0];
    assign bg3y = registers[`BG3Y_L_IDX][27:0];

    assign bg2pa = registers[`BG2PA_IDX][15:0];
    assign bg2pb = registers[`BG2PB_IDX][31:16];
    assign bg2pc = registers[`BG2PC_IDX][15:0];
    assign bg2pd = registers[`BG2PD_IDX][31:16];
    assign bg3pa = registers[`BG3PA_IDX][15:0];
    assign bg3pb = registers[`BG3PB_IDX][31:16];
    assign bg3pc = registers[`BG3PC_IDX][15:0];
    assign bg3pd = registers[`BG3PD_IDX][31:16];
    assign mosaic = registers[`MOSAIC_IDX][15:0];

    logic [14:0] pe_color0;
    logic [14:0] pe_color1;
    logic [19:0] pe_layer0;
    logic [19:0] pe_layer1;
    logic [4:0] pe_effects;
    (* mark_debug = "true" *)logic [19:0] bg;
    logic [19:0] obj;

    (* mark_debug = "true" *)logic [16:0] bg_addr;
    (* mark_debug = "true" *)logic [14:0] obj_addr;
    (* mark_debug = "true" *)logic [15:0] obj_data;
    (* mark_debug = "true" *)logic [15:0] bg_screen_addr;
    (* mark_debug = "true" *) logic [15:0] bg_VRAM_data;
    (* mark_debug = "true" *) logic [15:0] bg_screen_data;
    logic [2:0] bgmode;
    logic [7:0] hcount;

    assign gfx_vram_A_addr[31:16] = 16'b0;
    assign gfx_vram_B_addr[31:14] = 18'b0;
    assign gfx_vram_C_addr[31:14] = 18'b0;
    assign gfx_vram_A_addr2[31:16] = 16'b0;

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
        .vcount, .hcount,
        .dispcnt, .mosaic_mmio_reg(mosaic), .bgmode);
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
