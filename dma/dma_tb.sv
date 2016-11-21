`default_nettype none
`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"

module dma_tb (
    input logic clk,  rst_n,
    // Memory interface
    input logic pause,
    output logic [31:0] test_addr,
    output wire   [31:0] rdata,
    output logic [31:0] registers [`NUM_IO_REGS-1:0],
    output logic [15:0] vcount, hcount,
    output logic check_correctness,
    output logic all_passed);

    logic [15:0] controlL0, controlH0;
    logic [15:0] srcAddrL0, srcAddrH0;
    logic [15:0] destAddrL0, destAddrH0;

    logic [15:0] controlL1, controlH1;
    logic [15:0] srcAddrL1, srcAddrH1;
    logic [15:0] destAddrL1, destAddrH1;

    logic [15:0] controlL2, controlH2;
    logic [15:0] srcAddrL2, srcAddrH2;
    logic [15:0] destAddrL2, destAddrH2;

    logic [15:0] controlL3, controlH3;
    logic [15:0] srcAddrL3, srcAddrH3;
    logic [15:0] destAddrL3, destAddrH3;


    assign registers[`DMA0CNT_L_IDX][15:0] = controlL0;
    assign registers[`DMA0CNT_H_IDX][31:16] = controlH0;
    assign registers[`DMA0SAD_L_IDX][15:0] = srcAddrL0;
    assign registers[`DMA0SAD_H_IDX][31:16] = srcAddrH0;
    assign registers[`DMA0DAD_L_IDX][15:0] = destAddrL0;
    assign registers[`DMA0DAD_H_IDX][31:16] = destAddrH0;

    assign registers[`DMA1CNT_L_IDX][15:0] = controlL1;
    assign registers[`DMA1CNT_H_IDX][31:16] = controlH1;
    assign registers[`DMA1SAD_L_IDX][15:0] = srcAddrL1;
    assign registers[`DMA1SAD_H_IDX][31:16] = srcAddrH1;
    assign registers[`DMA1DAD_L_IDX][15:0] = destAddrL1;
    assign registers[`DMA1DAD_H_IDX][31:16] = destAddrH1;

    assign registers[`DMA2CNT_L_IDX][15:0] = controlL2;
    assign registers[`DMA2CNT_H_IDX][31:16] = controlH2;
    assign registers[`DMA2SAD_L_IDX][15:0] = srcAddrL2;
    assign registers[`DMA2SAD_H_IDX][31:16] = srcAddrH2;
    assign registers[`DMA2DAD_L_IDX][15:0] = destAddrL2;
    assign registers[`DMA2DAD_H_IDX][31:16] = destAddrH2;

    assign registers[`DMA3CNT_L_IDX][15:0] = controlL3;
    assign registers[`DMA3CNT_H_IDX][31:16] = controlH3;
    assign registers[`DMA3SAD_L_IDX][15:0] = srcAddrL3;
    assign registers[`DMA3SAD_H_IDX][31:16] = srcAddrH3;
    assign registers[`DMA3DAD_L_IDX][15:0] = destAddrL3;
    assign registers[`DMA3DAD_H_IDX][31:16] = destAddrH3;

    logic passed, all_passed;
    logic [10:0] count_time;

     always_ff @(posedge clk, negedge rst_n) begin
        if (rst_n == 0) begin
            count_time <= 0;
            all_passed <= 1;
        end
        else if (~pause)begin
            count_time <= count_time + 1;
            all_passed <= all_passed && passed;
        end
        else begin
            count_time <= count_time;
            all_passed <= all_passed;
        end
    end



     test_fsm fsm(.clk, .rst_n,
        .controlL0, .controlH0,
        .srcAddrL0, .srcAddrH0,
        .destAddrL0, .destAddrH0,

        .controlL1, .controlH1,
        .srcAddrL1, .srcAddrH1,
        .destAddrL1, .destAddrH1,

        .controlL2, .controlH2,
        .srcAddrL2, .srcAddrH2,
        .destAddrL2, .destAddrH2,

        .controlL3, .controlH3,
        .srcAddrL3, .srcAddrH3,
        .destAddrL3, .destAddrH3,
        .check_correctness,
        .count_time, .passed,
        .test_addr, .rdata,
        .pause,
        .hcount);

endmodule: dma_tb



`default_nettype wire
