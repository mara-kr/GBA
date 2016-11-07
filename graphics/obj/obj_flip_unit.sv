module obj_flip_unit (
    output logic  [9:0] new_x, new_y,
    input  logic  [9:0] x, y,
    input  logic [10:0] hsize, vsize,
    input  logic        hflip, vflip);

    flip_unit h (.new_val(new_x), .size(hsize), .val(x), .flip(hflip));
    flip_unit v (.new_val(new_y), .size(vsize), .val(y), .flip(vflip));

endmodule: obj_flip_unit

module flip_unit (
    output logic  [9:0] new_val,
    input  logic [10:0] size,
    input  logic  [9:0] val,
    input  logic       flip);

    logic [10:0] flip_val;
    assign flip_val = (size - 1) - {1'b0, val};
    assign new_val = (flip) ? flip_val[9:0] : val;

endmodule: flip_unit
