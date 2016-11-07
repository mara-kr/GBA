module priority_comparator (
    input logic [19:0] inputA,
    input logic [19:0] inputB,
    input [4:0] mask,
    output logic replace);

    logic out_validA;
    logic out_validB;
    logic AgtB;

    pe_valid validA (.A(inputA), .mask(mask), .valid(out_validA));
    pe_valid validB (.A(inputB), .mask(mask), .valid(out_validB));

    assign AgtB = (inputA[19:17] > inputB[19:17]) ? 1 : 0;

    assign replace = out_validA & (AgtB | ~out_validB);
endmodule: priority_comparator

