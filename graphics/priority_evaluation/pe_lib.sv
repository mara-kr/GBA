module pe_mux_2_to_1
    #(parameter width=4)
    (output logic [width-1:0] out,
    input logic [width-1:0] in0, in1,
    input logic select);

    assign out = select ? in1: in0

endmodule pe_mux_2_to_1

module pe_mux_4_to_1
    #(parameter width=4)
    (output logic [width-1:0] out,
    input logic [width-1:0] in0, in1, in2, in3,
    input logic [1:0] select);

    always_comb begin
        case (A)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase

endmodule pe_mux_2_to_1


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
module pe_mag_comp
  #(parameter width=4)
  (output logic altb, aeqb, agtb,
   input  logic [width-1:0] a,
   input  logic [width-1:0] b);

  assign altb = a < b;
  assign agtb = a > b;
  assign aeqb = a == b;

endmodule: pe_mag_comp
