/* SNES Controller (controller controller) module
 *
 * See interace.txt for details on specification.
 * vdd should be +5v, gnd should be at 0v.
 *
 * Cycle repeats at 60Hz rate, or every 16.67ms.
 * Data cycle takes 210us - 12*16(data) + 12(pulse) + 6(wait)
 */

`define US_CYCLES 100  // Cycles per microsecond - 100MHz clock
`define WAIT_CYCLES (16460 * `US_CYCLES)  // 16.46 ms (16.67ms - 210us)
`define CYC_WIDTH ($clog2(`WAIT_CYCLES))
`define LATCH_PULSE_CYCLES (12 * `US_CYCLES)
`define LATCH_WAIT_CYCLES  (6 * `US_CYCLES)
`define LATCH_CYCLES (6 * `US_CYCLES) // (half the full (12us) clock)

module controller
    (output logic        vdd, data_latch, data_clock, gnd,
     output logic [15:0] buttons,
     input  logic        serial_data, clock, reset_n);

     assign {vdd, gnd} = {1'b1, 1'b0}; // Sure hope this works

     enum logic [2:0] {WAIT, LATCH_PULSE, LATCH_WAIT, CYC_HI, CYC_LO} cs, ns;

     logic [`CYC_WIDTH-1:0] cycle_cnt;
     logic [3:0] button_cyc_cnt;
     logic cycle_clr, button_clr, button_en;

     counter #(`CYC_WIDTH) cycles (.clock, .reset_n, .enable(1'b1),
                                   .clear(cycle_clr), .D(cycle_cnt));
     counter #(4) button_cycles (.clock, .reset_n, .enable(button_en),
                                 .clear(button_clr), .D(button_cyc_cnt));

     always_ff @(posedge clock, negedge reset_n) begin
         if (~reset_n) begin
             cs <= WAIT;
             buttons <= 16'd0;
         end else begin
             cs <= ns;
             if (button_en) buttons[button_cyc_cnt] <= serial_data;
             else buttons <= buttons;
         end
     end

     always_comb begin
         cycle_clr = 1'b0;
         button_en = 1'b0;
         button_clr = 1'b0;
         data_latch = 1'b0;
         data_clock = 1'b0;
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
                     ns = CYC_HI;
                     cycle_clr = 1'b1;
                 end else begin
                     ns = LATCH_WAIT;
                 end
             end
             CYC_HI: begin
                 data_clock = 1'b1;
                 if (cycle_cnt == `LATCH_CYCLES) begin
                     ns = CYC_LO;
                     cycle_clr = 1'b1;
                 end else begin
                     ns = CYC_HI;
                 end
             end
             CYC_LO: begin
                 if (cycle_cnt == `LATCH_CYCLES) begin
                     if (button_cyc_cnt == 4'd15) begin
                         ns = WAIT;
                         button_clr = 1'b1;
                     end else begin
                         ns = CYC_HI;
                         button_en = 1'b1;
                     end
                 end else begin
                     ns = CYC_LO;
                 end
             end
         endcase
     end

endmodule: controller

module counter
   #(parameter WIDTH=8)
    (output logic [WIDTH-1:0] D,
     input  logic clock, reset_n, enable, clear);

     always_ff @(posedge clock, negedge reset_n) begin
         if (~reset_n || clear) D <= 0;
         else if (enable) D <= D + 1;
         else D <= D;
     end

endmodule: counter
