////
//// register: A register which may be reset to an arbitrary value
////
//// width       (param)  - Bit width of register
//// q           (output) - Current value of register
//// d           (input)  - Next value of register
//// clk         (input)  - Clock (positive edge-sensitive)
//// enable      (input)  - Load new value?
//// clear       (input)  - Clear register value to reset_value
//// reset       (input)  - System reset
////
module register(q, d, clk, clear, enable, rst_b);

   parameter
            width = 32;

   output logic [(width-1):0] q;
   input logic [(width-1):0]  d;
   input logic clk, clear, enable, rst_b;

   always @(posedge clk or negedge rst_b)
     if (~rst_b)
       q <= 0;
     else if (clear)
       q <= 0;
     else if (enable)
       q <= d;

endmodule // register

////
//// mag_comp: Variable width magnitude comparator
////
//// width (param)  - bit width of inputs
//// altb  (output) - a < b
//// aeqb  (output) - a == b
//// agtb  (output) - a > b
//// a     (input)  - Operand1
//// b     (input)  - Operand2
////
module mag_comp
  #(parameter width=4)
  (output logic altb, aeqb, agtb,
   input  logic [width-1:0] a,
   input  logic [width-1:0] b);

  assign altb = a < b;
  assign agtb = a > b;
  assign aeqb = a == b;

endmodule: mag_comp

////
//// mux_2_to_1: Variable width 2-to-1 multiplexer
////
//// width (param)  - Bit width of operands and output
//// y     (output) - multiplexer output
//// i0    (input)  - input line 0
//// i1    (input)  - input line 1
//// s     (input)  - select which input line passes to output
////
module mux_2_to_1
  #(parameter width=4)
  (output logic [width-1:0] y,
  input logic [width-1:0] i0, i1,
  input logic s);

  assign y = s ? i1 : i0;

endmodule: mux_2_to_1

////
//// counter: up/down counter with parallel load, synchronous clear
////          and asynchronous reset
////
//// width  (param)  - bit width of counter
//// q      (output) - count value
//// d      (input)  - parallel load value
//// clk    (input)  - Clock (positive edge-sensitive)
//// enable (input)  - count?
//// clear  (input)  - synchronous clear to zero
//// load   (input)  - parallel load?
//// up     (input)  - count up?
////
module counter
  #(parameter width=4)
  (output logic [width-1:0] q,
  input logic [width-1:0] d,
  input logic clk, enable, clear, load, up, rst_b);

  logic [width-1:0] ns;

  always_ff @(posedge clk, negedge rst_b)
    if(~rst_b)
      q <= 0;
    else
      q <= ns;

  always_comb begin
    if(clear)
      ns = 'b0;
    else if(load)
      ns = d;
    else if(enable)
      ns = up ? q + 1 : q - 1;
    else
      ns = q;
  end

endmodule: counter
