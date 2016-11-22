`default_nettype none
`include "../gba_mmio_defines.vh"
`include "../gba_core_defines.vh"

module timer_top (
    input logic clock_16,
    input logic reset,
    input logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0],
    output logic genIRQ0,
    output logic genIRQ1,
    output logic genIRQ2,
    output logic genIRQ3,
    output logic [15:0] internal_TM0CNT_L,
    output logic [15:0] internal_TM1CNT_L,
    output logic [15:0] internal_TM2CNT_L,
    output logic [15:0] internal_TM3CNT_L,);

    wire [15:0] TM0CNT_L, TM1CNT_L;
    wire [15:0] TM2CNT_L, TM3CNT_L;
    logic [15:0] TM0CNT_H, TM1CNT_H;
    logic [15:0] TM2CNT_H, TM3CNT_H;

    assign TM0CNT_L = IO_reg_datas[`TM0CNT_L_IDX][15:0];
    assign TM1CNT_L = IO_reg_datas[`TM1CNT_L_IDX][15:0];
    assign TM2CNT_L = IO_reg_datas[`TM2CNT_L_IDX][15:0];
    assign TM3CNT_L = IO_reg_datas[`TM3CNT_L_IDX][15:0];

    assign TM0CNT_H = IO_reg_datas[`TM0CNT_L_IDX][31:16];
    assign TM1CNT_H = IO_reg_datas[`TM1CNT_L_IDX][31:16];
    assign TM2CNT_H = IO_reg_datas[`TM2CNT_L_IDX][31:16];
    assign TM3CNT_H = IO_reg_datas[`TM3CNT_L_IDX][31:16];

    timer timer0(
        .clock_16,
        .reset,
        .TMxCNT_L(TM0CNT_L),
        .internal_TMxCNT_L(internal_TM0CNT_L),
        .TMxCNT_H(TM0CNT_H),
        .genIRQ(genIRQ0),
        .prev_timer(16'hFF));

     timer timer1(
        .clock_16,
        .reset,
        .TMxCNT_L(TM1CNT_L),
        .internal_TMxCNT_L(internal_TM1CNT_L),
        .TMxCNT_H(TM1CNT_H),
        .genIRQ(genIRQ1),
        .prev_timer(TM0CNT_L));

     timer timer2(
        .clock_16,
        .reset,
        .TMxCNT_L(TM2CNT_L),
        .internal_TMxCNT_L(internal_TM2CNT_L),
        .TMxCNT_H(TM2CNT_H),
        .genIRQ(genIRQ2),
        .prev_timer(TM1CNT_L));

     timer timer3(
        .clock_16,
        .reset,
        .TMxCNT_L(TM3CNT_L),
        .internal_TMxCNT_L(internal_TM3CNT_L),
        .TMxCNT_H(TM3CNT_H),
        .genIRQ(genIRQ3),
        .prev_timer(TM2CNT_L));

endmodule: timer_top

`default_nettype wire

