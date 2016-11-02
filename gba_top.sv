/* gba_top.sv
 *
 *  Top module for the Game Boy Advance.
 *
 *  Team N64
 */

`include "gba_core_defines.vh"

module gba_top (
    input  logic  GCLK, BTND,
    input  logic [7:0] SW,
    input  logic JA1,
    output logic JA2, JA3,
    output logic [7:0] LD,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    output logic VGA_VS, VGA_HS);

    // 16.776 MHz clock for GBA/memory system */
    logic gba_clk;
    clk_wiz_0 clk0 (.clk_in1(GCLK), .reset(BTND), .gba_clk);
    
    // Buttons register output
    logic [15:0] buttons;

    // Memory signals
    logic [31:0] bus_addr, bus_wdata, bus_rdata;
    logic  [1:0] bus_size;
    logic        bus_pause, bus_write;
    logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr;
    logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr;
    logic [31:0] gfx_vram_A_addr2;
    logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data;
    logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data;
    logic [31:0] gfx_vram_A_data2;
    
    logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0];
    
    
    assign LD = (SW[0]) ? buttons[15:8] : buttons[7:0];

    // BRAM memory controller
    mem_top mem (.clock(GCLK), .reset(BTND), .bus_addr, .bus_wdata, .bus_rdata,
                 .bus_size, .bus_pause, .bus_write,

                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_palette_obj_addr, .gfx_palette_bg_addr,
                 .gfx_vram_A_addr2,

                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_palette_obj_data, .gfx_palette_bg_data,
                 .gfx_vram_A_data2,
                 
                 .IO_reg_datas);

    // Interface for SNES controller
    controller cont (.clock(GCLK), .reset(BTND), .data_latch(JA2),
                     .data_clock(JA3), .serial_data(JA1), .buttons);

endmodule: gba_top
