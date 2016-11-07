`default_nettype none

module obj_register #(parameter WIDTH = 8) (
    input  logic clock, reset,
    output logic [WIDTH-1:0] q,
    input  logic [WIDTH-1:0] d,
    input  logic en, clear);

    always_ff @(posedge clock, negedge reset) begin
        if (reset) q <= {WIDTH{1'b0}};
        else if (clear) q <= {WIDTH{1'b0}};
        else if (en) q <= d;
    end
endmodule: obj_register

module obj_counter #(parameter WIDTH = 8) (
    input  logic clock, reset,
    output logic [WIDTH-1:0] q,
    input  logic en, clear);

    always_ff @(posedge clock, negedge reset) begin
        if (reset) q <= {WIDTH{1'b0}};
        else if (clear) q <= {WIDTH{1'b0}};
        else if (en) q <= q + 1;
    end
endmodule: obj_counter

module is_transparent (
    output logic        transparent,
    input  logic [15:0] data,
    input  logic        palette_mode);

    assign transparent = (palette_mode) ? |data[7:0] : |data[3:0];
endmodule: is_transparent

module within_preimage_checker (
    output logic        valid,
    input  logic [10:0] X, Y, hsize, vsize);

    assign valid = (X < hsize) & (Y < vsize);

endmodule: within_preimage_checker

module obj_data_unit (
    output logic  [7:0] palette_info,
    input  logic [15:0] data,
    input  logic [10:0] X,
    input  logic  [7:0] addr,
    input  logic  [3:0] palette_no,
    input  logic        palette_mode);

    logic [7:0] data8;
    assign data8 = (addr[0]) ? data[15:8] : data[7:0];

    assign palette_info = (palette_mode) ? data8 :
                    (X[0] ? {palette_no, data8[7:4]} : {palette_no, data[3:0]});

endmodule: obj_data_unit

module row_visible_unit (
    output logic       visible,
    input  logic [7:0] row, objy,
    input  logic [6:0] vsize);

    logic [7:0] adjust_objy;

    assign adjust_objy = objy + {1'b0, vsize};
    assign visible = (row < adjust_objy) & (objy[7] | (objy >= row));

endmodule: row_visible_unit
