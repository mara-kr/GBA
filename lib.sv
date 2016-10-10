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
//// register: A register which may be reset to an arbitrary value
////
//// width       (param)  - Bit width of register
//// reset_value (param)  - Value loaded into register on reset
//// q           (output) - Current value of register
//// d           (input)  - Next value of register
//// clk         (input)  - Clock (positive edge-sensitive)
//// enable      (input)  - Load new value?
//// clear       (input)  - Clear register value to reset_value
//// reset       (input)  - System reset
////
module pc_register(q, d, clk, clear, enable, rst_b);

   parameter
            width = 32,
            reset_value = 0;

   output logic [(width-1):0] q;
   input logic [(width-1):0]  d;
   input logic clk, clear, enable, rst_b;

   always @(posedge clk or negedge rst_b)
     if (~rst_b)
       q <= reset_value;
     else if (clear)
       q <= reset_value;
     else if (enable)
       q <= d;

endmodule // pc_register

////
//// adder: 32-bit adder without carry
////
//// out (output) - adder result
//// in1 (input)  - Operand1
//// in2 (input)  - Operand2
//// sub (input)  - Subtract?
////
module adder(out, in1, in2, sub);
   output logic [31:0] out;
   input  logic [31:0] in1, in2;
   input  logic        sub;

   assign        out = sub?(in1 - in2):(in1 + in2);

endmodule // adder


////
//// add_const: An adder that adds a fixed constant value
////
//// add_value (param)  - constant to add to input
//// out       (output) - adder result
//// in        (input)  - Operand
////
module add_const(out, in);

   parameter add_value = 1;

   output logic [31:0] out;
   input  logic [31:0] in;

   assign   out = in + add_value;

endmodule // adder

////
//// saturating_adder: Saturating +-1 adder
////
//// width (param)  - Bit width of operand and output
//// sum   (output) - Result of saturating count
//// a     (input)  - Operand1
//// up    (input)  - Count up
////
module saturating_adder
  #(parameter width=32)
  (output logic [width-1:0] sum,
   input  logic [width-1:0] a,
   input  logic             up);

  always_comb begin
    if(up)
      sum = (a == {width{1'b1}}) ? a : a + 1;
    else
      sum = (a == 0) ? a : a - 1;
  end

endmodule: saturating_adder

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
//// decoder: Variable size one-hot decoder
////
//// width (param)  - number of lines in output bus
//// sw    (param)  - bit width of select line
//// d     (output) - one hot output bus
//// i     (input)  - one hot select
//// en    (input)  - enable decoder output
////
module decoder
  #(parameter width=4,
              sw=2)
  (output logic [width-1:0] d,
  input logic [sw-1:0] i,
  input logic en);

  always_comb begin
    d = 0;
    d[i] = en;
  end

endmodule: decoder

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
module demultiplexer
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

endmodule: demultiplexer

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
module register_clear
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

endmodule: register_clear

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

////
//// shifter: compute arithmetic/logical shifts
////
//// width     (param)  - Bit width of operand1 and output
//// sw        (param)  - Bit width of operand2
//// shift_out (output) - Shifted result
//// shift_in  (input)  - Data to be shifted
//// shamt     (input)  - Offset to shift by
//// left      (input)  - shift left?
//// logical   (input)  - logical shift?
////
module shifter
  #(parameter width=32,
              sw=5)
  (output logic [width-1:0] shift_out,
  input logic [width-1:0] shift_in,
  input logic [sw-1:0] shamt,
  input logic left, logical);

  always_comb begin
    if(left)
      shift_out = shift_in << shamt;
    else if(logical)
      shift_out = shift_in >> shamt;
    else
      shift_out = $signed(shift_in) >>> shamt;
  end

endmodule: shifter

////
//// sign_extender: sign extend a value
////
//// initial_width (param)  - Bit width of input
//// final_width   (param)  - Bit width of output
//// out           (output) - Result of sign extension
//// in            (input)  - Value to sign extend
////
module sign_extender
  #(parameter initial_width=16,
              final_width=32)
  (output logic [final_width-1:0] out,
  input logic [initial_width-1:0] in);

  always_comb begin
    out[initial_width-1:0] = in;
    out[final_width-1:initial_width] = in[initial_width-1] ? 'b1 : 'b0;
    //TODO: verify sign extension works for signed values
  end

endmodule: sign_extender

/* A Kogge-Stone Adder/Subtractor. See wikipedia */
module ks_add_sub
  #(parameter WIDTH=32)
  (output logic [WIDTH-1:0] out, out_and, out_xor,
   output logic carry_out,
   input  logic [WIDTH-1:0] in1, in2,
   input  logic              sub);

  logic [WIDTH-1:0] A, B;
  logic [WIDTH:0] p, g, p_layer1, g_layer1, p_layer2, g_layer2;
  logic [WIDTH:0] p_layer3, g_layer3, p_layer4, g_layer4;
  logic [WIDTH:0] p_layer5, g_layer5;

  assign A = in1;
  assign B = in2 ^ {WIDTH{sub}};
  assign p = {A ^ B, 1'b0}; /* Carry Propagate */
  assign g = {A & B, sub}; /* Carry Generate */

  assign out_and = g[WIDTH:1];
  assign out_xor = p[WIDTH:1];
`ifndef NO_KS
  assign carry_out = g_layer5[WIDTH-1];

  genvar i;
  generate
    for (i = 0; i <= WIDTH; i++) begin : LAYER_1
      if (i < 1)
        assign {p_layer1[i], g_layer1[i]} = {p[i], g[i]};
      else
        ks_unit u1 (.p(p_layer1[i]), .g(g_layer1[i]), .pi(p[i]),
                    .gi(g[i]), .pi_prev(p[i-1]), .gi_prev(g[i-1]));
    end
  endgenerate

  generate
    for (i = 0; i <= WIDTH; i++) begin : LAYER_2
      if (i < 2)
        assign {p_layer2[i], g_layer2[i]} = {p_layer1[i], g_layer1[i]};
      else
        ks_unit u2 (.p(p_layer2[i]), .g(g_layer2[i]), .pi(p_layer1[i]),
                    .gi(g_layer1[i]),
                    .pi_prev(p_layer1[i-2]), .gi_prev(g_layer1[i-2]));
    end
  endgenerate

  generate
    for (i = 0; i <= WIDTH; i++) begin : LAYER_3
      if (i < 4)
        assign {p_layer3[i], g_layer3[i]} = {p_layer2[i], g_layer2[i]};
      else
        ks_unit u3 (.p(p_layer3[i]), .g(g_layer3[i]), .pi(p_layer2[i]),
                    .gi(g_layer2[i]),
                    .pi_prev(p_layer2[i-4]), .gi_prev(g_layer2[i-4]));
    end
  endgenerate

  generate
    for (i = 0; i <= WIDTH; i++) begin : LAYER_4
      if (i < 8)
        assign {p_layer4[i], g_layer4[i]} = {p_layer3[i], g_layer3[i]};
      else
        ks_unit u4 (.p(p_layer4[i]), .g(g_layer4[i]), .pi(p_layer3[i]),
                    .gi(g_layer3[i]),
                    .pi_prev(p_layer3[i-8]), .gi_prev(g_layer3[i-8]));
    end
  endgenerate

  generate
    for (i = 0; i <= WIDTH; i++) begin : LAYER_5
      if (i < 16)
        assign {p_layer5[i], g_layer5[i]} = {p_layer4[i], g_layer4[i]};
      else
        ks_unit u5 (.p(p_layer5[i]), .g(g_layer5[i]), .pi(p_layer4[i]),
                    .gi(g_layer4[i]),
                    .pi_prev(p_layer4[i-16]), .gi_prev(g_layer4[i-16]));
    end
  endgenerate

  generate
    for (i = 0; i < WIDTH; i++) begin: OUTPUT
      assign out[i] =  p[i+1] ^ g_layer5[i];
    end
  endgenerate
`else
  assign {carry_out, out} = (sub) ? in1 - in2 : in1 + in2;
`endif

endmodule: ks_add_sub

module ks_unit
  (output logic p, g,
   input  logic pi, gi, pi_prev, gi_prev);

  assign p = pi & pi_prev;
  assign g = (pi & gi_prev) | gi;

endmodule: ks_unit

