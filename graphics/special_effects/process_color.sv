module process_color (
    input logic [4:0] first,
    input logic [4:0] second,
    input logic [15:0] alpha,
    input logic [15:0] Y,
    input logic [1:0] control,
    output logic [4:0] color);
    
    logic [4:0] coeff_1;
    logic [4:0] coeff_2;
    logic [4:0] data_2;
    logic [4:0] result1;
    logic [4:0] result2;


    se_mux_4_to_1 #(5) mux1(.in0(alpha[4:0]), .in1(alpha[4:0]), .in2(5'h1F),
        .in3(5'h1F), .select(control), .out(coeff_1));
    
    se_mux_4_to_1 #(5) mux2(.in0(second), .in1(second), .in2(5'd31-first),
        .in3(5'h1F), .select(control), .out(data_2));

    assign coeff2 = control[1] ? Y[4:0] : alpha[12:8];
    
    //effects multiplier
    logic [8:0] mul_1;
    logic [8:0] mul_2;

    assign mul2 = coeff_2[3:0] * data_2;
    assign mul1 = coeff_1[3:0] * first;

    assign result2 = (coeff_2[4]) ? data_2 : mul_2[8:4];
    assign result1 = (coeff_1[4]) ? first : mul_1[8:4];

    assign color = (&control) ? (result1 - result2) : (result1 + result2);

endmodule: process_color
