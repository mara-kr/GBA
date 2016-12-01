 module pe_window_masker (
    input logic obj,
    input logic win0,
    input logic win1,
    input logic [15:0] winin,
    input logic [15:0] winout,
    input logic [15:0] dispcnt,
    output logic [4:0] mask,
    output logic [4:0] effects);
  
    logic [4:0] in_mask2;
    logic [4:0] in_mask3;
    logic [4:0] in_mask4;
    logic [4:0] in_mask5;

    assign effects = (winin[5] | win0) & (winin[13] | win1) & (winout[13] | obj)
                     & (~(win0 | win1) | winout[5]);

    pe_mux_4_to_1 #(5) mux2(.in0(5'h1F), .in1(winin[4:0]), .in2(5'b0), 
                    .in3(5'b0), .out(in_mask2), .select({~dispcnt[13],win0}));

    pe_mux_4_to_1 #(5) mux3(.in0(5'h1F), .in1(winin[12:8]), .in2(5'b0), 
                    .in3(5'b0), .out(in_mask3), .select({~dispcnt[14],win1}));

    pe_mux_4_to_1 #(5) mux4(.in0(5'h1F), .in1(winout[12:8]), .in2(5'b0), 
                    .in3(5'b0), .out(in_mask4), .select({~dispcnt[15],obj}));

    pe_mux_2_to_1 #(5) mux5(.in0(5'h1F), .in1(winout[4:0]), 
                    .out(in_mask5), .select(~(win0 | win1)));

    assign mask = dispcnt[12:8] & in_mask2 & in_mask3 & in_mask4 & in_mask5;
    
endmodule: pe_window_masker
