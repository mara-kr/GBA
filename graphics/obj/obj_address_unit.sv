`default_nettype none
module obj_address_unit (
    output logic [14:0] addr,
    input  logic  [9:0] objname,
    input  logic  [2:0] bgmode,
    input  logic        palettemode,
    input  logic        oam_mode,
    input  logic  [5:0] x, y,
    input  logic  [6:0] hsize);

    logic [14:0] x_addr, data_offset;
    logic [12:0] y_addr;
    logic  [7:0] adj_size;
    logic  [5:0] adj_x;
    logic  [2:0] pri;

    obj_pri_encoder pri_enc (.pri, .val(adj_size));

    assign data_offset = {objname[9] | bgmode | (bgmode[1] & bgmode[0]),
                          objname[8:1], objname[0] & (~palettemode | oam_mode),
                          5'b0};
    assign adj_x = (palettemode) ? x : {1'b0, x[5:1]};
    assign x_addr = data_offset + adj_x;
    assign adj_size = (oam_mode) ? {1'b0, hsize} : 8'd128;
    assign y_addr = y << pri;
    assign addr = x_addr + y_addr;

endmodule: obj_address_unit

module obj_pri_encoder (
    output logic [2:0] pri,
    input  logic [7:0] val);

    always_comb begin
        casex (val)
            8'b1xxx_xxxx: pri = 3'd7;
            8'bx1xx_xxxx: pri = 3'd6;
            8'bxx1x_xxxx: pri = 3'd5;
            8'bxxx1_xxxx: pri = 3'd4;
            8'bxxxx_1xxx: pri = 3'd3;
            8'bxxxx_x1xx: pri = 3'd2;
            8'bxxxx_xx1x: pri = 3'd1;
            8'bxxxx_xxx1: pri = 3'd0;
            default: pri = 3'd0;
        endcase
    end
endmodule: obj_pri_encoder

`default_nettype wire
