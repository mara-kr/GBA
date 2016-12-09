`default_nettype none
module obj_lookup_unit (
    input  logic        clock, reset,
    output logic  [9:0] objname, OAMaddr,
    output logic  [8:0] objx,
    output logic  [8:0] objy,
    output logic  [6:0] hsize, vsize,
    output logic  [4:0] attrno,
    output logic  [3:0] paletteno,
    output logic  [1:0] objmode, pri,
    output logic        mosaic, rotation, dblsize, hflip, vflip,
    output logic        palettemode,
    input  logic [31:0] OAMdata,
    input  logic        step, startrow);

    logic [7:0] addr;
    logic [6:0] hsize_d, vsize_d, hsize_q, vsize_q;
    logic       en_low, en_high; // Upper or lower 32 bits
    logic       addr_lat1, step_lat1, startrow_lat1;

    //assign hsize = en_low ? hsize_d : hsize_q;
    //assign vsize = en_low ? vsize_d : vsize_q;

    obj_register #(1) lrow (.clock, .reset, .q(startrow_lat1), .d(startrow),
                            .en(1'b1), .clear(1'b0));
    obj_register #(1) lstep (.clock, .reset, .q(step_lat1), .d(step | startrow_lat1),
                             .en(1'b1), .clear(startrow));
    obj_register #(1) laddr
        (.clock, .reset, .q(addr_lat1), .d(OAMaddr[2]),
         .en(1'b1), .clear(1'b0));

    assign en_low = (step | startrow_lat1) & ~startrow;
    assign en_high = (step_lat1 & ~startrow);

    assign OAMaddr = (startrow) ? 10'b0 : ((en_low | en_high) ? {addr+8'b1, 2'b0} : {addr, 2'b0});

    obj_size_lookup osl (.hsize(hsize_d), .vsize(vsize_d),
                         .size(OAMdata[31:30]), .shape(OAMdata[15:14]));

    obj_counter #(8) adr
        (.clock, .reset, .q(addr), .en(en_low | en_high), .clear(startrow));

    obj_register #(2) om (.clock, .reset, .q(objmode), .d(OAMdata[11:10]),
                          .en(en_low), .clear(1'b0));

    obj_register #(1) pm (.clock, .reset, .q(palettemode), .d(OAMdata[13]),
                          .en(en_low), .clear(1'b0));

    obj_register #(9) ox (.clock, .reset, .q(objx), .d(OAMdata[24:16]),
                          .en(en_low), .clear(1'b0));

    obj_register #(8) oy (.clock, .reset, .q(objy), .d(OAMdata[7:0]),
                          .en(en_low), .clear(1'b0));

    obj_register #(7) hs (.clock, .reset, .q(hsize), .d(hsize_d),
                          .en(en_low), .clear(1'b0));

    obj_register #(7) vs (.clock, .reset, .q(vsize), .d(vsize_d),
                          .en(en_low), .clear(1'b0));

    obj_register #(1) mo (.clock, .reset, .q(mosaic), .d(OAMdata[12]),
                          .en(en_low), .clear(1'b0));

    obj_register #(1) ro (.clock, .reset, .q(rotation), .d(OAMdata[8]),
                          .en(en_low), .clear(1'b0));

    obj_register #(1) ds (.clock, .reset, .q(dblsize), .d(OAMdata[9]),
                          .en(en_low), .clear(1'b0));

    obj_register #(1) hf (.clock, .reset, .q(hflip), .d(OAMdata[28]),
                          .en(en_low), .clear(1'b0));

    obj_register #(1) vf (.clock, .reset, .q(vflip), .d(OAMdata[29]),
                          .en(en_low), .clear(1'b0));

    obj_register #(5) an (.clock, .reset, .q(attrno), .d(OAMdata[29:25]),
                          .en(en_low), .clear(1'b0));

    obj_register #(4) pn (.clock, .reset, .q(paletteno), .d(OAMdata[15:12]),
                          .en(en_high), .clear(1'b0));

    obj_register #(2) pr (.clock, .reset, .q(pri), .d(OAMdata[11:10]),
                          .en(en_high), .clear(1'b0));

    obj_register #(10) on (.clock, .reset, .q(objname), .d(OAMdata[9:0]),
                           .en(en_high), .clear(1'b0));

endmodule: obj_lookup_unit

module obj_size_lookup (
    output logic [6:0] hsize, vsize,
    input  logic [1:0] size, shape);

    always_comb begin
        case({shape, size})
            {2'd0, 2'd0}: {hsize, vsize} = {7'd8, 7'd8};
            {2'd0, 2'd1}: {hsize, vsize} = {7'd16, 7'd16};
            {2'd0, 2'd2}: {hsize, vsize} = {7'd32, 7'd32};
            {2'd0, 2'd3}: {hsize, vsize} = {7'd64, 7'd64};
            {2'd1, 2'd0}: {hsize, vsize} = {7'd16, 7'd8};
            {2'd1, 2'd1}: {hsize, vsize} = {7'd32, 7'd8};
            {2'd1, 2'd2}: {hsize, vsize} = {7'd32, 7'd16};
            {2'd1, 2'd3}: {hsize, vsize} = {7'd64, 7'd32};
            {2'd2, 2'd0}: {hsize, vsize} = {7'd8, 7'd16};
            {2'd2, 2'd1}: {hsize, vsize} = {7'd8, 7'd32};
            {2'd2, 2'd2}: {hsize, vsize} = {7'd16, 7'd32};
            {2'd2, 2'd3}: {hsize, vsize} = {7'd32, 7'd64};
            default: {hsize, vsize} = {7'd0, 7'd0};
        endcase
    end
endmodule: obj_size_lookup
`default_nettype wire
