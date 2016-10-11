//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Mon Oct 10 21:07:19 2016
//Host        : Sigma running 64-bit major release  (build 9200)
//Command     : generate_target double_buffer_wrapper.bd
//Design      : double_buffer_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module double_buffer_wrapper
   (ap_clk,
    ap_rst_n,
    graphics_addr,
    graphics_color,
    toggle,
    vga_addr,
    vga_color,
    wen);
  input ap_clk;
  input ap_rst_n;
  input [16:0]graphics_addr;
  input [14:0]graphics_color;
  input toggle;
  input [16:0]vga_addr;
  output [14:0]vga_color;
  input [0:0]wen;

  wire ap_clk;
  wire ap_rst_n;
  wire [16:0]graphics_addr;
  wire [14:0]graphics_color;
  wire toggle;
  wire [16:0]vga_addr;
  wire [14:0]vga_color;
  wire [0:0]wen;

  double_buffer double_buffer_i
       (.ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .graphics_addr(graphics_addr),
        .graphics_color(graphics_color),
        .toggle(toggle),
        .vga_addr(vga_addr),
        .vga_color(vga_color),
        .wen(wen));
endmodule
