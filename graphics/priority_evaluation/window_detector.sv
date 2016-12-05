module pe_window_detector (
    input logic [1:0] objmode,
    input logic [7:0] X,
    input logic [7:0] Y,
    input logic [15:0] win0H,
    input logic [15:0] win1H,
    input logic [15:0] win0V,
    input logic [15:0] win1V,
    input logic [15:0] dispcnt,
    output logic obj,
    output logic win0,
    output logic win1);

    assign win0 = ((win0H[15:8] <= X) & (X <= win0H[7:0])) &
                  ((win0V[15:8] <= Y) & (Y <= win0V[7:0]));
    
    assign win1 = ((win1H[15:8] <= X) & (X <= win1H[7:0])) &
                  ((win1V[15:8] <= Y) & (Y <= win1V[7:0]));
    assign obj = objmode[1];
endmodule: pe_window_detector
