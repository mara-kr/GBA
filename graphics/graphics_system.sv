`include "../gba_core_defines.vh"
`include "../gba_mmio_defines.vh"
`default_nettype none

module graphics_system (
    output  logic [31:0] gfx_vram_A_addr, gfx_vram_B_addr, gfx_vram_C_addr,
    output  logic [31:0] gfx_oam_addr, gfx_palette_bg_addr, gfx_palette_obj_addr,
    output  logic [31:0] gfx_vram_A_addr2,
    input  logic [31:0] gfx_vram_A_data, gfx_vram_B_data, gfx_vram_C_data,
    input  logic [31:0] gfx_oam_data, gfx_palette_bg_data, gfx_palette_obj_data,
    input  logic [31:0] gfx_vram_A_data2,
    input  logic [31:0] IO_reg_datas [`NUM_IO_REGS-1:0],
    input  logic        graphics_clock, vga_clock,
    input  logic        reset,

    output logic [7:0] vcount,
    output logic [8:0] hcount,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    output logic        VGA_HS,
    output logic        VGA_VS
    );

    //module instantiations
    logic wen, toggle;
    logic [14:0] graphics_color, vga_color;
    logic [16:0] graphics_addr, vga_addr;
    logic [14:0] buffer0_dout, buffer1_dout;
    logic [16:0] buffer0_address, buffer1_address;
    logic [14:0] buffer0_din, buffer1_din;
    logic buffer0_ce, buffer1_ce;
    logic buffer0_we, buffer1_we;


    //dbl_buffer buffers

    dbl_buffer_bram0 buf0 (.clka(vga_clock), .addra(buffer0_address), .dina(buffer0_din), .douta(buffer0_dout),
                           .ena(buffer0_ce), .wea(buffer0_we));
    dbl_buffer_bram1 buf1 (.clka(vga_clock), .addra(buffer1_address), .dina(buffer1_din), .douta(buffer1_dout),
                           .ena(buffer1_ce), .wea(buffer1_we));

    //interface between graphics and dbl_buffer
    dblbuffer_driver driver(.toggle, .wen, .graphics_clock, .vcount, .hcount,
                            .graphics_addr, .clk(vga_clock), .rst_b(~reset));

    //double_buffer
    double_buffer video_buf(.ap_clk(vga_clock), .ap_rst_n(~reset), .graphics_addr, .graphics_color, .toggle, .vga_addr, .wen, .vga_color,
                            .buffer0_address, .buffer1_address,
                            .buffer0_din, .buffer1_din,
                            .buffer0_dout, .buffer1_dout,
                            .buffer0_ce, .buffer1_ce,
                            .buffer0_we, .buffer1_we);
    //vga
    vga_top video(.clock(vga_clock), .reset(reset), .data(vga_color), .addr(vga_addr), .VGA_R, .VGA_G, .VGA_B, .VGA_HS, .VGA_VS);

    //graphics
    graphics_top gfx(.clock(graphics_clock), .reset,
                 .gfx_vram_A_data, .gfx_vram_B_data, .gfx_vram_C_data,
                 .gfx_oam_data, .gfx_palette_bg_data, .gfx_palette_obj_data,
                 .gfx_vram_A_data2,
                 .gfx_vram_A_addr, .gfx_vram_B_addr, .gfx_vram_C_addr,
                 .gfx_oam_addr, .gfx_palette_bg_addr, .gfx_palette_obj_addr,
                 .gfx_vram_A_addr2,
                 .registers(IO_reg_datas),
                 .output_color(graphics_color));

endmodule: graphics_system

module dblbuffer_driver(
    output logic toggle,
    output logic wen,
    input logic graphics_clock,
    output logic [16:0] graphics_addr,
    output logic [7:0] vcount,
    output logic [8:0] hcount,
    input logic clk,
    input logic rst_b
    );

    assign vcount = row;
    assign hcount = col;

    dbdriver_counter #(20, 842687) toggler(.clk, .rst_b, .en(1'b1), .clear(1'b0), .last(toggle), .Q());

    logic [18:0] timer;
    logic [7:0] row;
    logic [8:0] col;

    logic step_row;
    logic next_frame;
    logic step;
    assign step = timer[1] & timer[0];
    dbdriver_counter #(19, 280895) sync(.clk(graphics_clock), .en(1'b1), .clear(1'b0), .rst_b, .last(next_frame), .Q(timer));
    dbdriver_counter #(16, 38399) addrs(.clk(graphics_clock), .en(wen & step), .clear(next_frame & step), .rst_b, .last(), .Q(graphics_addr));

    dbdriver_counter #(8, 227) rows(.clk(graphics_clock), .en(step_row & step), .clear(next_frame & step), .rst_b, .last(), .Q(row));
    dbdriver_counter #(9, 307) cols(.clk(graphics_clock), .en(step), .clear(next_frame & step), .rst_b, .last(step_row), .Q(col));

    assign wen = row < 8'd160 && col < 9'd240;

endmodule

module dbdriver_counter
    #(
    parameter WIDTH=18,
    parameter MAX = 210671
    )
    (
    input logic clk,
    input logic rst_b,
    input logic en,
    input logic clear,
    output logic [WIDTH-1:0] Q,
    output logic last
    );

    assign last = Q == MAX;

    logic [WIDTH-1:0] next;

    always_comb begin
        if(clear) begin
            next = 0;
        end
        else if(~en) begin
            next = Q;
        end
        else if(last) begin
            next = 0;
        end
        else begin
            next = Q + 1;
        end
    end

    always_ff @(posedge clk, negedge rst_b) begin
        if(~rst_b) begin
            Q <= 0;
        end
        else begin
            Q <= next;
        end
    end
endmodule

`default_nettype wire
