`default_nettype none
module obj_row_double_buffer (
    output logic [19:0] rdata,
    input  logic [19:0] wdata,
    (* mark_debug="true" *) input  logic  [7:0] wcol, rcol, row,
    input  logic        palettemode, clear, transparent,
    input  logic        we,
    input  logic        clock, reset);

    (* mark_debug="true" *) logic [19:0] rdata_even, rdata_odd;

    obj_row_buffer odd (.wdata, .transparent, .palettemode,
                         .wcol, .rcol, .clear, .rdata(rdata_odd),
                         .en((clear | we) & ~row[0]), .clock, .reset);

    obj_row_buffer even  (.wdata, .transparent, .palettemode,
                         .wcol, .rcol, .clear, .rdata(rdata_even),
                         .en((clear | we) & row[0]), .clock, .reset);

    assign rdata = (row[0]) ? rdata_even : rdata_odd;
endmodule: obj_row_double_buffer

module obj_row_buffer (
    input  logic        clock, reset,
    output logic [19:0] rdata,
    input  logic [19:0] wdata,
    input  logic  [7:0] wcol, rcol,
    input  logic        palettemode, clear, transparent, en);

    (* mark_debug="true" *) logic [255:0] col_ones_hot, transparent_col;
    logic [19:0] reg_in [239:0];
    logic [19:0] reg_out [239:0];
    logic [19:0] rdata_bus;
    (* mark_debug="true" *) logic  [19:0] col_data;

    // 8:256 ones hot decoder
    always_comb begin
        col_ones_hot = 256'b0;
        col_ones_hot[wcol] = 1'b1;
    end
    assign col_data = (transparent) ? 20'h0 : wdata;

    assign rdata = (rcol < 8'd240) ? rdata_bus : 20'b0;
    generate
        for (genvar i = 0; i < 240; i++) begin : REGS
            assign reg_in[i] = col_data | (reg_out[i] & 20'h4000);
            is_transparent ist (.transparent(transparent_col[i]),
                                .data(reg_out[i][15:0]),
                                .palettemode);
            obj_register #(20) r
                (.clock, .reset, .q(reg_out[i]), .d(reg_in[i]),
                .clear(en & clear),
                .en(en & col_ones_hot[i] & transparent_col[i]));
            //assign rdata_bus = (rcol == i) ? reg_out[i] : 20'bz;
        end
    endgenerate

    always_comb begin
        if(rcol < 8'd240)
            rdata_bus = reg_out[rcol];
        else
            rdata_bus = 20'hF_FFFF;
    end

endmodule: obj_row_buffer
`default_nettype wire
