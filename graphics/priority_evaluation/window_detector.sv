module pe_window_detector (
    input logic [1:0] objmode,
    input logic [7:0] X,
    input logic [7:0] Y,
    input logic [15:0] WIN0H,
    input logic [15:0] WIN1H,
    input logic [15:0] WIN0V,
    input logic [15:0] WIN1V,
    output logic obj,
    output logic WIN0,
    output logic WIN1);

    assign obj = objmode[1];
    assign WIN0 = ((WIN0H[15:8] <= X) & (X <= WIN0H[7:0])) &
                  ((WIN0V[15:8] <= Y) & (Y <= WIN0V[7:0]));
    
    assign WIN1 = ((WIN1H[15:8] <= X) & (X <= WIN1H[7:0])) &
                  ((WIN1V[15:8] <= Y) & (Y <= WIN1V[7:0]));
endmodule: pe_window_detector
