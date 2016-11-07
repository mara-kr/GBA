module se_mux_4_to_1
    #(parameter width=4)
    (output logic [width-1:0] out,
    input logic [width-1:0] in0, in1, in2, in3,
    input logic [1:0] select);

    always_comb begin
        case (select)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end
endmodule: se_mux_4_to_1


