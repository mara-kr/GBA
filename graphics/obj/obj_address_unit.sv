`default_nettype none
module obj_address_unit (
    (* mark_debug="true" *) output logic [14:0] addr,
    (* mark_debug="true" *) input  logic  [9:0] objname,
    (* mark_debug="true" *) input  logic  [2:0] bgmode,
    (* mark_debug="true" *) input  logic        palettemode,
    (* mark_debug="true" *) input  logic        oam_mode,
    (* mark_debug="true" *) input  logic  [5:0] x, y,
    (* mark_debug="true" *) input  logic  [6:0] hsize);

    (* mark_debug="true" *) logic [14:0] x_addr, data_offset;
    (* mark_debug="true" *) logic [12:0] y_addr, y_offset, y_addr_one_dim, y_addr_two_dim;
    (* mark_debug="true" *) logic  [7:0] adj_size;
    (* mark_debug="true" *) logic  [5:0] adj_x;
    (* mark_debug="true" *) logic  [2:0] pri;

    obj_pri_encoder pri_enc (.pri, .val(adj_size));

    assign data_offset = {objname[9] | bgmode[2] | (bgmode[1] & bgmode[0]),
                          objname[8:1], objname[0] & (~palettemode | oam_mode),
                          5'b0};
    assign adj_x = (palettemode) ? {x[5:3], 3'b0, x[2:0]} : {1'b0, x[5:3], 3'b0, x[2:1]};
    assign x_addr = data_offset + adj_x;
    assign adj_size = (oam_mode) ? {1'b0, hsize} : 8'd128;
    assign y_offset = ({y[5:3], 3'b0} << pri) + {y[2:0], 3'b0};
    assign y_addr_one_dim = palettemode ? y_offset : {1'b0, y_offset[12:1]};
    assign y_addr_two_dim = palettemode ? y_offset : {y_offset[12:6], 1'b0, y_offset[5:1]};
    assign y_addr = oam_mode ? y_addr_one_dim : y_addr_two_dim;
    assign addr = x_addr + y_addr;

endmodule: obj_address_unit

module obj_pri_encoder (
    output logic [2:0] pri,
    input  logic [7:0] val);

    always_comb begin
        unique casex (val)
            8'b1xxx_xxxx: pri = 3'd7;//256
            8'bx1xx_xxxx: pri = 3'd6;//128
            8'bxx1x_xxxx: pri = 3'd5;//64
            8'bxxx1_xxxx: pri = 3'd4;//32
            8'bxxxx_1xxx: pri = 3'd3;//16
            8'bxxxx_x1xx: pri = 3'd2;//8
            8'bxxxx_xx1x: pri = 3'd1;//4
            8'bxxxx_xxx1: pri = 3'd0;//2
            default: pri = 3'd0;
        endcase
    end
endmodule: obj_pri_encoder

`default_nettype wire
