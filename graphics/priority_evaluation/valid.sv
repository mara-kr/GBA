module valid (
    input logic A,
    input logic [4:0] mask,
    output logic valid);

    logic mux_result;


    pe_mux_4_to_1 #(1) mux(.out(mux_result), 
                    .in0(mask[0]), 
                    .in1(mask[1]), 
                    .in2(mask[2]), 
                    .in3(mask[3]), 
                    .select(A[9:8]))
   assign valid = ((A[17] && mask[4]) || mux_result) && (A[15] || A[16])
endmodule valid


