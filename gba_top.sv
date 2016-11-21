/* gba_top.sv
 *
 *  Top module for the Game Boy Advance.
 *
 *  Team N64
 */

`include "gba_core_defines.vh"
`include "gba_mmio_defines.vh"

module gba_top (
    input  logic  GCLK,
    (* mark_debug = "true" *) input  logic  BTND,
    input  logic [7:0] SW,
    input  logic JA1,
    output logic JA2, JA3,
    output logic [7:0] LD,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    output logic VGA_VS, VGA_HS,
    output logic AC_ADR0, AC_ADR1, AC_GPIO0, AC_MCLK, AC_SCK,
    input  logic AC_GPIO1, AC_GPIO2, AC_GPIO3,
    inout  wire  AC_SDA);

    // 16.776 MHz clock for GBA/memory system
    logic gba_clk;
    clk_wiz_0 clk0 (.clk_in1(GCLK), .gba_clk);

    // Buttons register output
    logic [15:0] buttons;

    // CPU
    logic  [4:0] mode;
    logic        nIRQ, abort;

    // Interrupt signals
    logic [15:0] reg_IF, reg_IE, reg_ACK;
    logic        timer0, timer1, timer2, timer3;

    // DMA
    logic        dmaActive, sound_req;
    logic        dma0, dma1, dma2, dma3;
    logic  [3:0] disable_dma;
    logic        sound_req1, sound_req2;

    // Memory signals
    (* mark_debug = "true" *) logic [31:0] bus_addr, bus_wdata, bus_rdata;
    (* mark_debug = "true" *) logic  [1:0] bus_size;
    (* mark_debug = "true" *) logic        bus_pause, bus_write;
    logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr;
    logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr;
    logic [31:0] gfx_vram_A_addr2;
    logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data;
    logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data;
    logic [31:0] gfx_vram_A_data2;

    logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0];

    // Graphics
    logic [15:0] vcount;
    logic [8:0]  hcount;
    logic        vblank, hblank;
    assign vcount = 16'd0; // TODO Map to Grapics controller port
    //assign vblank = (vcount == 16'd160); // TODO Make 1 cycle assertion
    //assign hblank = (hcount == 9'd240); // TODO Make 1 cycle assertion
    assign {vblank, hblank} = 2'd0;



    assign abort = 1'b0;
    assign gfx_vram_A_addr = 32'b0;
    assign gfx_vram_A_addr2 = 32'b0;
    assign gfx_vram_B_addr = 32'b0;
    assign gfx_vram_C_addr = 32'b0;
    assign gfx_oam_addr = 32'b0;
    assign gfx_palette_bg_addr = 32'b0;
    assign gfx_palette_obj_addr = 32'b0;

    // CPU
    cpu_top cpu (.clock(gba_clk), .reset(BTND), .nIRQ, .pause(bus_pause),
                 .abort, .mode,
                 .dmaActive, .rdata(bus_rdata), .addr(bus_addr),
                 .wdata(bus_wdata), .size(bus_size), .write(bus_write));

    interrupt_controller intc
        (.clock(gba_clock), .reset(BTND), .cpu_mode(mode), .nIRQ,
         .ime(IO_reg_datas[`IME_IDX][0]), .reg_IF, .reg_ACK,
         .reg_IE(IO_reg_datas[`IE_IDX][15:0]),
         .vblank(1'b0), .hblank(1'b0),
         .vcount_match(1'b0), .timer0, .timer1,
         .timer2, .timer3, .serial(1'b0), .keypad(1'b0),
         .game_pak(1'b0), .dma0, .dma1, .dma2, .dma3);

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

                 .buttons, .vcount, .reg_IF, .int_acks(reg_ACK));

    dma_top dma (.clk(gba_clk), .rst_b(~BTND), .registers(IO_reg_datas),
                 .addr(bus_addr), .rdata(bus_rdata), .wdata(bus_wdata),
                 .size(bus_size), .wen(bus_write), .active(dmaActive),
                 .disable_dma(), .irq0(dma0), .irq1(dma1), .irq2(dma2),
                 .irq3(dma3), .mem_wait(bus_pause), .sound_req1, .sound_req2,
                 .vcount(vcount), .hcount({7'd0, hcount}));

    timer_top timers (.clock_16(gba_clk), .reset(BTND), .IO_reg_datas,
                      .genIRQ0(timer0), .genIRQ1(timer1), .genIRQ2(timer2),
                      .genIRQ3(timer3));

    gba_audio_top audio (.clk_100(GCLK), .reset(BTND), .AC_ADR0, .AC_ADR1,
                     .AC_GPIO1, .AC_GPIO2, .AC_GPIO3, .AC_MCLK, .AC_SCK,
                     .AC_SDA, .IO_reg_datas, .sound_req1, .sound_req2);


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
