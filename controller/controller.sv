/* SNES Controller (controller controller) module
 *
 * See interace.txt for details on specification.
 *
 * Cycle repeats at 60Hz rate, or every 16.67ms.
 * Data cycle takes 210us - 12*16(data) + 12(pulse) + 6(wait)
 */

//NOTE: change US_CYCLES to 100, WAIT_CYCLES to ((16460 * `US_CYCLES) - 1)

`define US_CYCLES 100  // Cycles per microsecond - 100MHz clock
`define WAIT_CYCLES ((16400 * `US_CYCLES) - 1)  // 16.46 ms (16.67ms - 210us)
`define CYC_WIDTH ($clog2(`WAIT_CYCLES))
`define LATCH_PULSE_CYCLES ((12 * `US_CYCLES) - 1)
`define LATCH_WAIT_CYCLES  ((6 * `US_CYCLES) - 1)
`define LATCH_CYCLES ((6 * `US_CYCLES) - 1) // (half the full (12us) clock)

module controller
    (output logic        data_latch, data_clock,
     output logic [15:0] buttons,
     input  logic        serial_data, clock, reset_n);

     enum logic [2:0] {WAIT, LATCH_PULSE, LATCH_WAIT, CYC_HI, CYC_LO} cs, ns;

     logic [`CYC_WIDTH-1:0] cycle_cnt;
     logic [3:0] button_cyc_cnt;
     logic cycle_clr, button_clr, button_en;

     controller_counter #(`CYC_WIDTH)
        cycles (.clock, .reset_n, .enable(1'b1), .clear(cycle_clr),
                .D(cycle_cnt));

     controller_counter #(4)
        button_cycles (.clock, .reset_n, .enable(button_en),
                       .clear(button_clr), .D(button_cyc_cnt));

     // State register
     always_ff @(posedge clock, negedge reset_n) begin
         if (~reset_n) cs <= WAIT;
         else cs <= ns;
     end

     // Buttons register
     always_ff @(negedge data_clock, negedge reset_n) begin
         if (~reset_n) buttons <= 16'd0;
         else buttons[button_cyc_cnt] <= ~serial_data;
     end

     always_comb begin
         cycle_clr = 1'b0;
         button_en = 1'b0;
         button_clr = 1'b0;
         data_latch = 1'b0;
         data_clock = 1'b1;
         ns = WAIT;
         case (cs)
             WAIT: begin
                 if (cycle_cnt == `WAIT_CYCLES) begin
                     ns = LATCH_PULSE;
                     cycle_clr = 1'b1;
                 end else begin
                     ns = WAIT;
                 end
             end
             LATCH_PULSE: begin
                 data_latch = 1'b1;
                 if (cycle_cnt == `LATCH_PULSE_CYCLES) begin
                     ns = LATCH_WAIT;
                     cycle_clr = 1'b1;
                 end else begin
                     ns = LATCH_PULSE;
                 end
             end
             LATCH_WAIT: begin
                 if (cycle_cnt == `LATCH_WAIT_CYCLES) begin
                     ns = CYC_LO;
                     cycle_clr = 1'b1;
                 end else begin
                     ns = LATCH_WAIT;
                 end
             end
             CYC_LO: begin
                 data_clock = 1'b0;
                 if (cycle_cnt == `LATCH_CYCLES) begin
                     ns = CYC_HI;
                     cycle_clr = 1'b1;
                 end else begin
                     ns = CYC_LO;
                 end
             end
             CYC_HI: begin
                 if (cycle_cnt == `LATCH_CYCLES) begin
                     cycle_clr = 1'b1;
                     button_en = 1'b1;
                     if (button_cyc_cnt == 4'd14) begin
                         ns = WAIT;
                     end else begin
                         ns = CYC_LO;
                     end
                 end else begin
                     ns = CYC_HI;
                 end
             end
         endcase
     end

endmodule: controller

module controller_counter
   #(parameter WIDTH=8)
    (output logic [WIDTH-1:0] D,
     input  logic clock, reset_n, enable, clear);

     always_ff @(posedge clock, negedge reset_n) begin
         if (~reset_n || clear) D <= 0;
         else if (enable) D <= D + 1;
         else D <= D;
     end

endmodule: controller_counter

/*
// To run (and get something useful), set WAIT_CYCLES to 20 and US_CYCLES to 1
module controller_tb;
    logic        data_latch, data_clock;
    logic [15:0] buttons;
    logic        serial_data, clock, reset_n;

    controller dut (.*);
    initial begin
        $monitor("buttons = %b_%b_%b_%b", buttons[15:12], buttons[11:8],
            buttons[7:4], buttons[3:0]);
        clock = 0;
        reset_n = 1;
        #1 reset_n <= 0;
        #1 reset_n <= 1;
        forever #1 clock <= ~clock;
    end

    initial begin
        serial_data = 1'b1;
        #600 $finish;
    end

endmodule: controller_tb
*/
