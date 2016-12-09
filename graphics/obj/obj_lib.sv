`default_nettype none

module obj_register #(parameter WIDTH = 8) (
    input  logic clock, reset,
    output logic [WIDTH-1:0] q,
    input  logic [WIDTH-1:0] d,
    input  logic en, clear);

    always_ff @(posedge clock, posedge reset) begin
        if (reset) q <= {WIDTH{1'b0}};
        else if (clear) q <= {WIDTH{1'b0}};
        else if (en) q <= d;
    end
endmodule: obj_register

module obj_counter #(parameter WIDTH = 8) (
    input  logic clock, reset,
    output logic [WIDTH-1:0] q,
    input  logic en, clear);

    always_ff @(posedge clock, posedge reset) begin
        if (reset) q <= {WIDTH{1'b0}};
        else if (clear) q <= {WIDTH{1'b0}};
        else if (en) q <= q + 1;
    end
endmodule: obj_counter

module obj_pipeline #(parameter WIDTH = 1) (
    input  logic clock, reset,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q);

    always_ff @(posedge clock, posedge reset)
        if(reset)
            q <= 0;
        else
            q <= d;

endmodule: obj_pipeline

module obj_mux_2_to_1 #(parameter WIDTH = 6) (
    input  logic [WIDTH-1:0] i0, i1,
    input  logic s,
    output logic [WIDTH-1:0] y);

    assign y = s ? i1 : i0;

endmodule: obj_mux_2_to_1

module is_transparent (
    output logic        transparent,
    input  logic [15:0] data,
    input  logic        palettemode);

    assign transparent = ~((palettemode) ? |data[7:0] : |data[3:0]);
endmodule: is_transparent

module within_preimage_checker (
    output logic        valid,
    input  logic [5:0] X, Y,
    input  logic [6:0] hsize, vsize);

    assign valid = ({1'b0, X} < hsize) & ({1'b0, Y} < vsize);

endmodule: within_preimage_checker

module obj_data_unit (
    output logic  [7:0] palette_info,
    input  logic [31:0] data,
    input  logic [5:0] X,
    input  logic  [14:0] addr,
    input  logic  [3:0] paletteno,
    input  logic        palettemode);

    logic [7:0] data8;
    assign data8 = addr[0] ? data[15:8] : data[7:0];

    assign palette_info = (palettemode) ? data8 :
                    (X[0] ? {paletteno, data8[7:4]} : {paletteno, data8[3:0]});

endmodule: obj_data_unit

module row_visible_unit (
    output logic       visible,
    input  logic [7:0] row, objy,
    input  logic [7:0] vsize);

    logic [7:0] lowerbound, upperbound;
    logic [7:0] adjust_objy;

    //assign lowerbound = rotation ? objy - vsize[7:1] : objy;
    assign lowerbound = objy;
    assign upperbound = lowerbound + vsize;
    assign visible = (row < upperbound) & ((objy[7] & ~upperbound[7]) | (lowerbound <= row));

endmodule: row_visible_unit
