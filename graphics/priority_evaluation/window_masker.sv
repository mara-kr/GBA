 module pe_window_masker (
    input logic obj,
    input logic WIN0,
    input logic WIN1,
    input logic [15:0] WININ,
    input logic [15:0] WINOUT,
    input logic [15:0] DISPCNT,
    output logic [4:0] mask,
    output logic [4:0] effects);
  
    logic [4:0] in_mask2;
    logic [4:0] in_mask3;
    logic [4:0] in_mask4;
    logic [4:0] in_mask5;

    assign effects = (WININ[5] | WIN0) & (WININ[13] | WIN1) & (WINOUT[13] | obj)
                     & (~(WIN0 | WIN1) | WINOUT[5]);

    pe_mux_4_to_1 #(5) mux2(.in0(5'h1F), .in1(WININ[4:0]), .in2(5'b0), 
                    .in3(5'b0), .out(in_mask2), .select({DISPCNT[13],WIN0}));

    pe_mux_4_to_1 #(5) mux3(.in0(5'h1F), .in1(WININ[12:8]), .in2(5'b0), 
                    .in3(5'b0), .out(in_mask3), .select({DISPCNT[14],WIN1}));

    pe_mux_4_to_1 #(5) mux4(.in0(5'h1F), .in1(WINOUT[12:8]), .in2(5'b0), 
                    .in3(5'b0), .out(in_mask4), .select({DISPCNT[15],obj}));

    pe_mux_2_to_1 #(5) mux5(.in0(5'h1F), .in1(WINOUT[4:0]), 
                    .out(in_mask5), .select(~(WIN0 | WIN1)));

    assign mask = DISPCNT[12:8] & in_mask2 & in_mask3 & in_mask4 & in_mask5;
    
endmodule: pe_window_masker
