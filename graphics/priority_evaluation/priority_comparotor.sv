module priority_comparator (
    input logic [19:0] inputA,
    input logic [19:0] inputB,
    input [4:0] mask);

    logic validA;
    logic validB;
    logic AgtB;

    valid validA (.A(inputA), .mask(mask), .valid(validA))
    valid validA (.A(inputB), .mask(mask), .valid(validB))

    pe_mag_comp #(2) (.agtb(AgtB), .a(A[19:17]), .b(B[19:17]));


    always_comb 
endmodule priority_comparator

