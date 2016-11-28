module priority_comparator (
    input logic [19:0] inputA,
    input logic [19:0] inputB,
    input [4:0] mask,
    input logic [1:0] bgno,
    output logic replace);

    logic out_validA;
    logic out_validB;
    logic AltB;

    pe_valid validA (.A(inputA), .mask(mask), .valid(out_validA), .bgno);
    pe_valid validB (.A(inputB), .mask(mask), .valid(out_validB), .bgno);

    assign AltB = (inputA[19:17] < inputB[19:17]) ? 1 : 0;

    assign replace = out_validA & (AltB | ~out_validB);
endmodule: priority_comparator

