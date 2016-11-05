/* gba_top.sv
 *
 *  Top module for the Game Boy Advance.
 *
 *  Team N64
 */

`include "gba_core_defines.vh"
`include "gba_mmio_defines.vh"

module gba_top (
    input  logic  GCLK, BTND,
    input  logic [7:0] SW,
    input  logic JA1,
    output logic JA2, JA3,
    output logic [7:0] LD,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    output logic VGA_VS, VGA_HS);

    // 16.776 MHz clock for GBA/memory system
    logic gba_clk;
    clk_wiz_0 clk0 (.clk_in1(GCLK), .reset(BTND), .gba_clk);

    // Buttons register output
    logic [15:0] buttons;

    logic [15:0] vcount;
    assign vcount = 16'd0; // TODO Map to Grapics controller port

    // CPU
    logic        nIRQ, pause, abort;

    // DMA
    logic        dmaActive

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

    // CPU
    cpu_top cpu (.clock(gba_clk), .reset(BTND), .nIRQ, .pause, .abort,
                 .dmaActive, .rdata(bus_rdata), .addr(bus_addr),
                 .wdata(bus_wdata), .size(bus_size), .write(bus_write));

    // BRAM memory controller
    mem_top mem (.clock(gba_clk), .reset(BTND), .bus_addr, .bus_wdata, .bus_rdata,
                 .bus_size, .bus_pause, .bus_write,

                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_palette_obj_addr, .gfx_palette_bg_addr,
                 .gfx_vram_A_addr2,

                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_palette_obj_data, .gfx_palette_bg_data,
                 .gfx_vram_A_data2,

                 .IO_reg_datas,

                 .buttons, .vcount);

    // Interface for SNES controller
    controller cont (.clock(GCLK), .reset(BTND), .data_latch(JA2),
                     .data_clock(JA3), .serial_data(JA1), .buttons);

    // Controller for debug output on LEDs
    led_controller led (.led_reg0(IO_reg_datas[`LED_REG0_IDX]),
                        .led_reg1(IO_reg_datas[`LED_REG1_IDX]),
                        .led_reg2(IO_reg_datas[`LED_REG2_IDX]),
                        .led_reg3(IO_reg_datas[`LED_REG3_IDX]),
                        .buttons, .LD, .SW);

endmodule: gba_top

// LED controller for mapping debug output
module led_controller (
    input  logic [7:0] SW,
    input  logic [31:0] led_reg0, led_reg1, led_reg2, led_reg3,
    input  logic [15:0] buttons,
    output logic [7:0] LD);

    always_comb begin
        case (SW)
            8'h0: LD = led_reg0[7:0];
            8'h1: LD = led_reg0[15:8];
            8'h2: LD = led_reg0[23:16];
            8'h3: LD = led_reg0[31:24];
            8'h4: LD = led_reg1[7:0];
            8'h5: LD = led_reg1[15:8];
            8'h6: LD = led_reg1[23:16];
            8'h7: LD = led_reg1[31:24];
            8'h8: LD = led_reg2[7:0];
            8'h9: LD = led_reg2[15:8];
            8'hA: LD = led_reg2[23:16];
            8'hB: LD = led_reg2[31:24];
            8'hC: LD = led_reg3[7:0];
            8'hD: LD = led_reg3[15:8];
            8'hE: LD = led_reg3[23:16];
            8'hF: LD = led_reg3[31:24];
            default: LD = (SW[7]) ? buttons[15:8] : buttons [7:0];
        endcase
    end
endmodule: led_controller
