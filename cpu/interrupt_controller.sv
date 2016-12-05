// Interrupt interface from system to CPU

`include "../gba_core_defines.vh"

module interrupt_controller(
    input  logic        clock, reset,
    output logic        nIRQ,

    (* mark_debug = "true" *) input  logic        ime, // Interrupt master enable
    output logic [15:0] reg_IF, // Interrupt Request Flags
    (* mark_debug = "true" *) input  logic [15:0] reg_IE,
    input  logic [15:0] reg_ACK,

    input  logic  [4:0] cpu_mode,
    input  logic  [8:0] hcount,
    input  logic  [7:0] vcount, set_vcount,

    input  logic        timer0, timer1, timer2, timer3,
    input  logic        serial, keypad, game_pak,
    input  logic        dma0, dma1, dma2, dma3);

    logic [13:0] ints_recd;  // Received interrupts
    logic [13:0] int_ack;    // If interrupt is being acknowledged
    logic [13:0] int_assert; // Whether interrupt is asserted

    (* mark_debug = "true" *) logic vblank, hblank;
    logic vblank_reg, hblank_reg;
    logic vcount_match, vcount_match_reg;

    // Logic to make vblank/hblank/vcount match be asserted for 1 cycle
    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            vblank_reg <= 1'b0;
            hblank_reg <= 1'b0;
            vcount_match_reg <= 1'b0;
        end else begin
            vblank_reg <= (vcount == 8'd160);
            hblank_reg <= (hcount == 9'd240);
            vcount_match_reg <= (vcount == set_vcount);
        end
    end

    assign vblank = (vcount == 8'd160) & ~(vblank_reg);
    assign hblank = (hcount == 9'd240) & ~(hblank_reg);
    assign vcount_match = (vcount == set_vcount) & ~(vcount_match_reg);

    always_ff @(posedge clock, posedge reset) begin
        if (reset) nIRQ <= 1'b1;
        else nIRQ <= ~((cpu_mode != `CPSR_IRQ) & |int_assert & ime);
    end


    assign int_ack = reg_ACK[13:0];
    assign int_assert = reg_IE[13:0] & ints_recd;
    assign reg_IF = {2'b0, int_assert}; // Don't show interrupt if not enabled

    int_reg vb (.d(vblank), .q(ints_recd[0]), .clr(int_ack[0]), .*);
    int_reg hb (.d(hblank), .q(ints_recd[1]), .clr(int_ack[1]), .*);
    int_reg vc (.d(vcount_match), .q(ints_recd[2]), .clr(int_ack[2]), .*);
    int_reg t0 (.d(timer0), .q(ints_recd[3]), .clr(int_ack[3]), .*);
    int_reg t1 (.d(timer1), .q(ints_recd[4]), .clr(int_ack[4]), .*);
    int_reg t2 (.d(timer2), .q(ints_recd[5]), .clr(int_ack[5]), .*);
    int_reg t3 (.d(timer3), .q(ints_recd[6]), .clr(int_ack[6]), .*);
    int_reg se (.d(serial), .q(ints_recd[7]), .clr(int_ack[7]), .*);
    int_reg d0 (.d(dma0), .q(ints_recd[8]), .clr(int_ack[8]), .*);
    int_reg d1 (.d(dma1), .q(ints_recd[9]), .clr(int_ack[9]), .*);
    int_reg d2 (.d(dma2), .q(ints_recd[10]), .clr(int_ack[10]), .*);
    int_reg d3 (.d(dma3), .q(ints_recd[11]), .clr(int_ack[11]), .*);
    int_reg ke (.d(keypad), .q(ints_recd[12]), .clr(int_ack[12]), .*);
    int_reg gp (.d(game_pak), .q(ints_recd[13]), .clr(int_ack[13]), .*);

endmodule: interrupt_controller

// Register - loads when D is high
module int_reg (
    input  logic clock, reset,
    input  logic d, clr,
    output logic q);

    always_ff @(posedge clock, posedge reset) begin
        if (reset || clr) q <= 1'b0;
        else if (d) q <= d;
    end
endmodule: int_reg
