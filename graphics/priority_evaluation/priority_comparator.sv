module priority_comparator (
    input logic [19:0] inputA,
    input logic [19:0] inputB,
    input [4:0] mask,
    output logic replace);

    logic out_validA;
    logic out_validB;
    logic AgtB;

    valid validA (.A(inputA), .mask(mask), .valid(out_validA));
    valid validB (.A(inputB), .mask(mask), .valid(out_validB));

    pe_mag_comp #(2) (.agtb(AgtB), .a(A[19:17]), .b(B[19:17]));

    assign replace = out_validA & (AgtB | ~out_validB);
endmodule: priority_comparator

