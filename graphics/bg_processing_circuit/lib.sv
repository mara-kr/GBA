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
module bg_register(q, d, clk, clear, enable, rst_b);

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
//// adder: 32-bit adder without carry
////
//// out (output) - adder result
//// in1 (input)  - Operand1
//// in2 (input)  - Operand2
//// sub (input)  - Subtract?
////
module bg_adder(out, in1, in2, sub);
   output logic [31:0] out;
   input  logic [31:0] in1, in2;
   input  logic        sub;

   assign        out = sub?(in1 - in2):(in1 + in2);

endmodule // adder

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
module bg_mag_comp
  #(parameter width=4)
  (output logic altb, aeqb, agtb,
   input  logic [width-1:0] a,
   input  logic [width-1:0] b);

  assign altb = a < b;
  assign agtb = a > b;
  assign aeqb = a == b;

endmodule: bg_mag_comp

////
//// mux_2_to_1: Variable width 2-to-1 multiplexer
////
//// width (param)  - Bit width of operands and output
//// y     (output) - multiplexer output
//// i0    (input)  - input line 0
//// i1    (input)  - input line 1
//// s     (input)  - select which input line passes to output
////
module bg_mux_2_to_1
  #(parameter width=4)
  (output logic [width-1:0] y,
  input logic [width-1:0] i0, i1,
  input logic s);

  assign y = s ? i1 : i0;

endmodule: bg_mux_2_to_1

module bg_mux_4_to_1
  #(parameter width=16)
  (output logic [width-1:0] y,
   input logic [width-1:0] i0,
   input logic [width-1:0] i1,
   input logic [width-1:0] i2,
   input logic [width-1:0] i3,
   input logic [1:0] s);

  always_comb begin
    case(s)
      2'd0: y = i0;
      2'd1: y = i1;
      2'd2: y = i2;
      2'd3: y = i3;
    endcase
  end

endmodule: bg_mux_4_to_1

////
//// decoder: Variable size one-hot decoder
////
//// width (param)  - number of lines in output bus
//// sw    (param)  - bit width of select line
//// d     (output) - one hot output bus
//// i     (input)  - one hot select
//// en    (input)  - enable decoder output
////
module bg_decoder
  #(parameter width=4,
              sw=2)
  (output logic [width-1:0] d,
  input logic [sw-1:0] i,
  input logic en);

  always_comb begin
    d = 0;
    d[i] = en;
  end

endmodule: bg_decoder

////
//// demultiplexer: Variable sized, variable bit width demultiplexer
////
//// dw (param)  - number of output lines
//// bw (param)  - bit width of input lines
//// sw (param)  - bit width of select line
//// o  (output) - output lines
//// g  (input)  - value to pass through demux
//// s  (input)  - select output line to pass value onto
////
module bg_demultiplexer
  #(parameter dw=4,
              bw=4,
              sw=2)
  (output logic [dw-1:0][bw-1:0] o,
  input logic [bw-1:0] g,
  input logic [sw-1:0] s);

  always_comb begin
    o = 0;
    o[s] = g;
  end

endmodule: bg_demultiplexer

////
//// register_clear: Variable sized register with synchronous clear
////
//// width       (param)  - Bit width of register
//// q           (output) - Current value of register
//// d           (input)  - Next value of register
//// clk         (input)  - Clock (positive edge-sensitive)
//// enable      (input)  - Load new value?
//// clear       (input)  - Synchronous clear to zero
////
module bg_register_clear
  #(parameter width=4)
  (output logic [width-1:0] q,
  input logic [width-1:0] d,
  input logic clk, enable, clear);

  always_ff @(posedge clk)
    if(enable)
      q <= d;
    else if(clear)
      q <= 0;
    else
      q <= d;

endmodule: bg_register_clear

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
module bg_counter
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

endmodule: bg_counter
