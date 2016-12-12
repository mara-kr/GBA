`default_nettype none

module obj_top (
    input  logic        clock, reset,

    (* mark_debug="true" *) output logic [31:0] OAM_mem_addr,
    (* mark_debug="true" *) output logic [14:0] VRAM_mem_addr,
    (* mark_debug="true" *) output logic [19:0] obj_packet,
    (* mark_debug="true" *) input  logic [31:0] OAM_mem_data,
    (* mark_debug="true" *) input  logic [15:0] VRAM_mem_data,
    input  logic [15:0] dispcnt,
    input  logic [15:0] mosaic_mmio_reg,
    (* mark_debug="true" *) input  logic  [7:0] vcount, hcount, //vcount is current row being displayed, hcount is column being output by BG
    input  logic  [2:0] bgmode

    );

    (* mark_debug="true" *) logic [19:0] obj_wdata;
    logic [14:0] vram_addr;

    (* mark_debug="true" *) logic  [5:0] X, Y;
    (* mark_debug="true" *) logic  [5:0] mosaicX, mosaicY, flipX, flipY, rotX, rotY;
    logic  [3:0] hscale, vscale;
    logic  [7:0] row, pinfo;
    (* mark_debug="true" *) logic        visible, valid, transparent;

    logic [15:0] A, B, C, D;
    logic  [4:0] attrno;
    (* mark_debug="true" *) logic        readOAM, attr_done, lookupAttr;

    logic [10:0] timer;
    (* mark_debug="true" *) logic  [9:0] objname, OAMaddr_attr, OAMaddr_obj;
    (* mark_debug="true" *) logic  [8:0] objx, col, col_offset;
    (* mark_debug="true" *) logic  [7:0] objy, hsize, vsize;
    logic  [6:0] obj_hsize, obj_vsize;
    logic  [3:0] paletteno;
    (* mark_debug="true" *) logic  [1:0] objmode, pri;
    logic  [1:0] waitstate;
    (* mark_debug="true" *) logic        mosaic, rotation, dblsize, hflip, vflip, palettemode, oam_mode;
    (* mark_debug="true" *) logic        step, stepobj, startrow, wen;
    logic        rot_scale_transparent;
    logic        clear_timer;

    logic [14:0] vram_addr_PIPELINE;
    logic  [7:0] row_PIPELINE, col_PIPELINE;
    logic  [5:0] x_PIPELINE;
    logic  [3:0] paletteno_PIPELINE;
    logic  [1:0] objmode_PIPELINE, pri_PIPELINE;
    logic        palettemode_PIPELINE, transparent_PIPELINE, wen_PIPELINE;

    enum logic  [3:0] {RESET, STARTROW, GETOBJDATA, WAITOBJDATA, GETOBJATTR, WRITE} cs, ns;

    assign hsize = (dblsize) ? {obj_hsize[6:0], 1'b0} : obj_hsize;
    assign vsize = (dblsize) ? {obj_vsize[6:0], 1'b0} : obj_vsize;

    assign hscale = mosaic_mmio_reg[11:8];
    assign vscale = mosaic_mmio_reg[15:12];

    assign row = vcount + 1;
    //assign col = rotation ? objx - hsize[7:1] + col_offset : objx + col_offset;
    assign col = objx + col_offset;
    assign transparent = (col >= 9'd240) || (rot_scale_transparent && rotation) || ~valid || ~visible || objmode[1] || (dblsize && ~rotation);
    assign obj_wdata = {pri_PIPELINE, 3'd5, objmode_PIPELINE, 5'd1, pinfo};
    assign VRAM_mem_addr = vram_addr;
    assign startrow = (timer == 11'd1231) || clear_timer;
    assign oam_mode = dispcnt[6];

    assign X = rotation ? rotX : mosaicX;
    assign Y = rotation ? rotY : mosaicY;

    //control logic
    obj_counter #(9) col_cntr(.q(col_offset), .en(step), .clear(stepobj | startrow), .clock, .reset);
    obj_counter #(11) kitchen_timer(.q(timer), .en(1'b1), .clear(startrow), .clock, .reset); //ding every 1232 clock cycles
    obj_counter #(2) reset_timer(.q(waitstate), .en(1'b1), .clear(1'b0), .clock, .reset); //ding every 1232 clock cycles

    always_ff @(posedge clock, posedge reset) begin
        if(reset)
            cs <= RESET;
        else
            cs <= ns;
    end

    always_comb begin
        ns = GETOBJDATA;
        step = 1'b0;
        stepobj = 1'b0;
        wen = 1'b0;
        lookupAttr = 1'b0;
        clear_timer = 1'b0;
        case(cs)
            RESET: begin
                if(waitstate == 2'd2) begin
                    ns = GETOBJDATA;
                    stepobj = 1'b1;
                    clear_timer = 1'b1;
                end
            end
            STARTROW: begin
                ns = GETOBJDATA;
            end
            GETOBJDATA: begin
                if(~startrow)
                    ns = WAITOBJDATA;
                else
                    ns = STARTROW;
            end
            WAITOBJDATA: begin
                if(~startrow)
                    if(~visible) begin
                        ns = GETOBJDATA;
                        stepobj = 1'b1;
                    end
                    else if(rotation) begin
                        ns = GETOBJATTR;
                        lookupAttr = 1'b1;
                    end
                    else begin
                        ns = WRITE;
                        wen = 1'b1;
                        step = 1'b1;
                    end
                else
                    ns = STARTROW;
            end
            GETOBJATTR: begin
                if(~startrow)
                    if(~attr_done) begin
                        ns = GETOBJATTR;
                    end
                    else begin
                        ns = WRITE;
                        wen = 1'b1;
                        step = 1'b1;
                    end
                else
                    ns = STARTROW;
            end
            WRITE: begin
                if(~startrow)
                    if(col_offset < (hsize - 1)) begin
                        ns = WRITE;
                        step = 1'b1;
                        wen = 1'b1;
                    end
                    else begin
                        ns = GETOBJDATA;
                        stepobj = 1'b1;
                    end
                else
                    ns = STARTROW;
            end
        endcase
    end

    //datapath logic
    obj_lookup_unit olu (.clock, .reset, .objname,.objx, .objy,
                         .OAMaddr(OAMaddr_obj),
                         .hsize(obj_hsize), .vsize(obj_vsize),
                         .attrno, .paletteno, .objmode,
                         .pri, .mosaic, .rotation, .dblsize, .hflip, .vflip,
                         .palettemode, .step(stepobj), .startrow, .OAMdata(OAM_mem_data));

    attribute_lookup_unit alu (.clock, .reset, .A, .B, .C, .D,
                                .OAMaddr(OAMaddr_attr), .readOAM, .done(attr_done),
                                .attrno, .start(lookupAttr),
                                .OAMdata(OAM_mem_data));

    assign OAM_mem_addr = readOAM ? OAMaddr_attr : OAMaddr_obj;

    mosaic_processing_unit mpu(.hscale, .vscale, .mosaic, .row(row-objy), .col(col_offset), .x(mosaicX), .y(mosaicY));

    row_visible_unit rvu (.visible, .row, .objy, .vsize);

    within_preimage_checker wpc (.valid, .X, .Y, .hsize(obj_hsize),
                                 .vsize(obj_vsize));

    obj_address_unit oau (.addr(vram_addr), .objname, .bgmode, .palettemode,
                          .oam_mode, .hsize(obj_hsize), .x(X), .y(Y));

    obj_flip_unit ofu (.new_x(flipX), .new_y(flipY), .x(mosaicX), .y(mosaicY),
                       .hsize, .vsize, .hflip, .vflip);

    obj_row_double_buffer ordb (.rdata(obj_packet), .wdata(obj_wdata), .row,
                                .rcol(hcount), .clear(startrow), .palettemode(palettemode_PIPELINE),
                                .transparent(transparent_PIPELINE), .wcol(col_PIPELINE), .we(wen_PIPELINE),
                                .clock, .reset);

    obj_rot_scale_unit orsu (.a(A), .b(B), .c(C), .d(D), .objx, .objy, .hsize, .vsize,
                             .dblsize, .x(rotX), .y(rotY), .transparent(rot_scale_transparent),
                             .row, .col(col[7:0]));

    obj_data_unit odu (.palette_info(pinfo), .X(x_PIPELINE), .palettemode(palettemode_PIPELINE), .addr(vram_addr_PIPELINE),
                       .paletteno(paletteno_PIPELINE), .data({16'b0, VRAM_mem_data}));

    //pipeline registers
    obj_pipeline #(15) addr_reg(.q(vram_addr_PIPELINE), .d(vram_addr), .clock, .reset);
    obj_pipeline #(6) x_reg(.q(x_PIPELINE), .d(X), .clock, .reset);
    obj_pipeline #(1) palettemode_reg(.q(palettemode_PIPELINE), .d(palettemode), .clock, .reset);
    obj_pipeline #(4) paletteno_reg(.q(paletteno_PIPELINE), .d(paletteno), .clock, .reset);
    obj_pipeline #(8) row_reg(.q(row_PIPELINE), .d(row), .clock, .reset);
    obj_pipeline #(8) col_reg(.q(col_PIPELINE), .d(col[7:0]), .clock, .reset);
    obj_pipeline #(1) transparent_reg(.q(transparent_PIPELINE), .d(transparent), .clock, .reset);
    obj_pipeline #(1) wen_reg(.q(wen_PIPELINE), .d(wen), .clock, .reset);
    obj_pipeline #(2) objmode_reg(.q(objmode_PIPELINE), .d(objmode), .clock, .reset);
    obj_pipeline #(2) pri_reg(.q(pri_PIPELINE), .d(pri), .clock, .reset);

endmodule: obj_top

`default_nettype wire
