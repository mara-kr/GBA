 module pe_top( 
    input logic clock, reset,
    input logic [19:0] BG, OBJ,
    input logic [15:0] winin,
    input logic [15:0] winout,
    input logic [15:0] dispcnt,
    input logic [15:0] win0H,
    input logic [15:0] win1H,
    input logic [15:0] win0V,
    input logic [15:0] win1V,
    input logic [7:0] vcount,
    input logic [31:0] gfx_palette_bg_data,
    input logic [31:0] gfx_palette_obj_data,
    output logic [31:0] gfx_palette_bg_addr,
    output logic [31:0] gfx_palette_obj_addr,
    output logic [14:0] pe_color0,
    output logic [14:0] pe_color1,
    output logic [19:0] pe_layer0,
    output logic [19:0] pe_layer1,
    output logic [4:0] pe_effects);
    
    logic pe_clear;
    logic [8:0] pe_col;
    logic pe_send_address_1;
    logic pe_send_address_2;
    logic pe_read_data_1;
    logic pe_read_data_2;
    logic addr_is_obj;


    (* mark_debug = "true" *) logic [7:0] pe_row;
    logic [31:0] pe_data;
    logic [31:0] pe_addr;

    assign pe_row = (vcount == 8'd227) ? 8'd0 : vcount + 1;
    assign pe_data = (addr_is_obj) ? gfx_palette_obj_data : gfx_palette_bg_data;
    assign gfx_palette_bg_addr = pe_addr;
    assign gfx_palette_obj_addr = pe_addr;
    //our row is one ahead of vcount
    priority_eval datapath(.BG, .OBJ, .data(pe_data), 
        .clk(clock), .clear(pe_clear), 
        .winin, .winout, 
        .dispcnt, .vcount(pe_row),
        .win0H, .win1H, 
        .win0V, .win1V, 
        .col(pe_col[7:0]), .send_address_1(pe_send_address_1),
        .send_address_2(pe_send_address_2), 
        .read_data_1(pe_read_data_1), .read_data_2(pe_read_data_2), 
        .address(pe_addr),
        .addr_is_obj,
        .color0(pe_color0), .color1(pe_color1), 
        .layer0(pe_layer0), .layer1(pe_layer1), 
        .effects(pe_effects));
    
    pe_fsm fsm(.clock, .reset, .clear(pe_clear), 
        .col(pe_col), .send_address_1(pe_send_address_1),
        .send_address_2(pe_send_address_2), 
        .read_data_1(pe_read_data_1), .read_data_2(pe_read_data_2));
endmodule: pe_top


