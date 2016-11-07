module match_target (
    input logic [19:0] layer,
    input logic [5:0] targets,
    output logic match);

    logic target;
    se_mux_4_to_1 #(1) target_mux(.in0(targets[0]), .in1(targets[1]), 
            .in2(targets[2]), .in3(targets[3]), 
            .select(layer[10:9]), .out(target));
    assign match = ((layer[8] & targets[4]) | target) & layer[15] | (~layer[15] & targets[5]);
endmodule: match_target
