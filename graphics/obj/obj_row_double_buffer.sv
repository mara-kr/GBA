`default_nettype none
module obj_row_double_buffer (
    output logic [19:0] rdata,
    input  logic [15:0] wdata,
    input  logic  [7:0] wcol, rcol, row,
    input  logic        palettemode, clear, transparent,
    input  logic        we);

    logic [19:0] rdata_even, rdata_odd;

    obj_row_buffer odd (.wdata, .transparent, .palettemode,
                         .wcol, .rcol, .clear, .rdata(rdata_odd),
                         .en((clear | we) & row[0]));

    obj_row_buffer even  (.wdata, .transparent, .palettemode,
                         .wcol, .rcol, .clear, .rdata(rdata_even),
                         .en((clear | we) & ~row[0]));

    assign rdata = (row[0]) ? rdata_even : rdata_odd;
endmodule: obj_row_double_buffer

module obj_row_buffer (
    input  logic        clock, reset,
    output logic [19:0] rdata,
    input  logic [15:0] wdata,
    input  logic  [7:0] wcol, rcol,
    input  logic        palettemode, clear, transparent, en);

    logic [255:0] col_ones_hot, transparent_col;
    logic [19:0] reg_in [239:0];
    logic [19:0] reg_out [239:0];
    logic [19:0] rdata_bus;
    logic  [15:0] col_data;

    // 8:256 ones hot decoder
    always_comb begin
        col_ones_hot = 256'b0;
        col_ones_hot[wcol] = 1'b1;
    end
    assign col_data = (palettemode) ? 16'h0 : wdata;

    assign rdata = (rcol < 8'd240) ? rdata_bus : 20'b0;
    generate
        for (genvar i = 0; i < 239; i++) begin : REGS
            assign reg_in[i] = {4'd0, col_data} | (reg_out[i] & 20'h4000);
            is_transparent ist (.transparent(transparent_col[i]),
                                .data(reg_out[i][15:0]),
                                .palettemode);
            obj_register #(20) r
                (.clock, .reset, .q(reg_out[i]), .d(reg_in[i]),
                .clear(en & clear),
                .en(en & col_ones_hot[i] & transparent_col[i]));
            assign rdata_bus = (rcol == i) ? reg_out[i] : 20'bz;
        end
    endgenerate

endmodule: obj_row_buffer
`default_nettype wire
