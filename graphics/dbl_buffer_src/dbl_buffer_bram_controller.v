//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Mon Oct 10 21:07:19 2016
//Host        : Sigma running 64-bit major release  (build 9200)
//Command     : generate_target double_buffer.bd
//Design      : double_buffer
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module double_buffer
   (ap_clk,
    ap_rst_n,
    graphics_addr,
    graphics_color,
    toggle,
    vga_addr,
    vga_color,
    wen,
    
    buffer0_address,
    buffer0_din,
    buffer0_dout,
    buffer0_ce,
    buffer0_we,
    
    buffer1_address,
    buffer1_din,
    buffer1_dout,
    buffer1_ce,
    buffer1_we
    );
    
  input ap_clk;
  input ap_rst_n;
  input [16:0]graphics_addr;
  input [14:0]graphics_color;
  input toggle;
  input [16:0]vga_addr;
  output [14:0]vga_color;
  input [0:0]wen;
  
  input [14:0] buffer0_dout;
  output [14:0] buffer0_din;
  output [16:0] buffer0_address;
  output buffer0_ce;
  output buffer0_we;
  
  input [14:0] buffer1_dout;
  output [14:0] buffer1_din;
  output [16:0] buffer1_address;
  output buffer1_ce;
  output buffer1_we;

  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [14:0]buffer0_dout;
  wire [14:0]buffer1_dout;
  wire [0:0]c_counter_binary_0_Q;
  wire [16:0]buffer1_address;
  wire buffer1_ce;
  wire [14:0]buffer1_din;
  wire buffer1_we;
  wire [16:0]buffer0_address;
  wire buffer0_ce;
  wire [14:0]buffer0_din;
  wire buffer0_we;
  wire [14:0]gba_double_buffer_0_vga_color;
  wire [16:0]graphics_addr_1;
  wire [14:0]graphics_color_1;
  wire toggle_1;
  wire [16:0]vga_addr_1;
  wire [0:0]wen_1;

  assign ap_clk_1 = ap_clk;
  assign ap_rst_n_1 = ap_rst_n;
  assign graphics_addr_1 = graphics_addr[16:0];
  assign graphics_color_1 = graphics_color[14:0];
  assign toggle_1 = toggle;
  assign vga_addr_1 = vga_addr[16:0];
  assign vga_color[14:0] = gba_double_buffer_0_vga_color;
  assign wen_1 = wen[0];
  /*
  double_buffer_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(buffer0_address),
        .clka(ap_clk_1),
        .dina(buffer0_din),
        .douta(buffer0_dout),
        .ena(buffer0_ce),
        .wea(buffer0_we));
  double_buffer_blk_mem_gen_0_1 blk_mem_gen_2
       (.addra(buffer1_address),
        .clka(ap_clk_1),
        .dina(buffer1_din),
        .douta(buffer1_dout),
        .ena(buffer1_ce),
        .wea(buffer1_we));
  */
  
  graphics_counter #(1) buffer_selecter
        (.q(c_counter_binary_0_Q), .d(1'b0), .clk(ap_clk_1), .enable(toggle_1), .clear(1'b0), .load(1'b0), .up(1'b1), .rst_b(ap_rst_n_1));
  /*
  double_buffer_c_counter_binary_0_0 c_counter_binary_0
       (.CE(toggle_1),
        .CLK(ap_clk_1),
        .Q(c_counter_binary_0_Q));
  */
  double_buffer_gba_double_buffer_0_0 gba_double_buffer_0
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .buf0_address0(buffer1_address),
        .buf0_ce0(buffer1_ce),
        .buf0_d0(buffer1_din),
        .buf0_q0(buffer1_dout),
        .buf0_we0(buffer1_we),
        .buf1_address0(buffer0_address),
        .buf1_ce0(buffer0_ce),
        .buf1_d0(buffer0_din),
        .buf1_q0(buffer0_dout),
        .buf1_we0(buffer0_we),
        .buf_select(c_counter_binary_0_Q),
        .graphics_addr(graphics_addr_1),
        .graphics_color(graphics_color_1),
        .vga_addr(vga_addr_1),
        .vga_color(gba_double_buffer_0_vga_color),
        .wen(wen_1));
endmodule
