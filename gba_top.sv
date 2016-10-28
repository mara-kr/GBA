/* gba_top.sv
 *
 *  Top module for the Game Boy Advance.
 *
 *  Team N64
 */

module gba_top (
    input  logic  GCLK, BTND,
    input  logic [7:0] SW,
    input  logic JA1,
    output logic JA2, JA3,
    output logic [7:0] LD);


    logic [15:0] buttons;

    /* Memory signals */
    logic [31:0] bus_addr, bus_wdata, bus_rdata;
    logic  [1:0] bus_size;
    logic        bus_pause, bus_write;
    logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr;
    logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr;
    logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data;
    logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data;

    assign LD = (SW[0]) ? buttons[15:8] : buttons[7:0];

    mem_top mem (.clock(GCLK), .reset(BTND), .bus_addr, .bus_wdata, .bus_rdata,
                 .bus_size, .bus_pause, .bus_write,

                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_palette_obj_addr, .gfx_palette_bg_addr,

                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_palette_obj_data, .gfx_palette_bg_data);

    controller cont (.clock(GCLK), .reset(BTND), .data_latch(JA2),
                     .data_clock(JA3), .serial_data(JA1), .buttons);

endmodule: gba_top
