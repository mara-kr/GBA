module obj_top (
    input  logic        clock, reset,

    output logic [31:0] OAM_mem_addr, VRAM_mem_addr,
    input  logic [31:0] OAM_mem_data, VRAM_mem_data,
    input  logic  [7:0] vcount, hcount,
    input  logic  [3:0] bgmode,
    input  logic        oam_mode

    );

    logic [19:0] obj_packet;
    logic [15:0] obj_wdata;
    logic [14:0] vram_addr;

    logic  [5:0] X, Y;
    logic  [5:0] mosaicX, mosaicY, flipX, flipY;
    logic  [7:0] row, pinfo;
    logic        visible, valid, transparent;

    logic [15:0] A, B, C, D;
    logic  [4:0] attr_no;
    logic        readOAM, done, loadAttrNo, start;

    logic  [9:0] objname;
    logic  [8:0] objx;
    logic  [7:0] objy, OAMaddr_obj, hsize, vsize, OAMaddr_attr;
    logic  [7:0] obj_hsize, obj_vsize;
    logic  [4:0] attrno;
    logic  [3:0] paletteno;
    logic  [1:0] objmode, pri;
    logic        mosaic, rotation, dblsize, hflip, vflip, palettemode;
    logic        step, startrow;

    assign hsize = (dblsize) ? {obj_hsize[6:0], 1'b0} : obj_hsize;
    assign vsize = (dblsize) ? {obj_vsize[6:0], 1'b0} : obj_vsize;

    assign row = vcount + 1;
    assign transparent = ~valid;
    assign obj_wdata = {pri, 3'd5, objmode, 5'd1, pinfo};

    obj_lookup_unit olu (.clock, .reset, .objname,.objx, .objy,
                         .OAMaddr(OAMaddr_obj),
                         .hsize(obj_hsize), .vsize(obj_vsize),
                         .attrno, .paletteno, .objmode,
                         .pri, .mosaic, .rotation, .dblsize, .hflip, .vflip,
                         .palettemode, .step, .startrow);

    attribute_lookup_unit alu (.clock, .reset, .A, .B, .C, .D,
                                .OAMaddr(OAMaddr_attr), .readOAM, .done,
                                .attrno, loadAttrNo, .start,
                                .OAMdata(OAM_memdata));

    row_visible_unit rvu (.visible, .row, .objy, .vsize);

    within_preimage_checker wpc (.valid, .X, Y, .hsize(obj_hsize),
                                 .vsize(obj_vsize));

    obj_address_unit oau (.addr(vram_addr), .objname, .bg_mode, .palettemode,
                          .oam_mode, .hsize, .x(X), .y(Y));

    obj_flip_unit ofu (.new_x(flipX), .new_y(flipY), .x(mosaicX), .y(mosaicY),
                       .hsize, .vsize, .hflip, .vflip);

    obj_row_double_buffer ordb (.rdata(obj_packet), .wdata(obj_wdata), .row,
                                .rcol(hcount), .clear(startrow), .palettemode,
                                .transparent, .wcol(), rcol(), .we());

    obj_rot_scale_unit orsu (.a(A), .b(B), .c(C), .d(D), .objx, .objy, .hsize, .vsize,
                             .dblsize, .x(X), .y(Y));

    obj_data_unit odu (.paletteinfo(pinfo), .X, .palettemode, .addr(vram_addr),
                       .paletteno, .palettemode, .data(pinfo));

endmodule: obj_top
