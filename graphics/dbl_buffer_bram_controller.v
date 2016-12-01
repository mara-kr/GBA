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

(* CORE_GENERATION_INFO = "double_buffer,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=double_buffer,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=1,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "double_buffer.hwdef" *) 
module double_buffer
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
  input [16:0] graphics_addr;
  input [14:0] graphics_color;
  input toggle;
  input [16:0]vga_addr;
  output [14:0]vga_color;
  input [0:0]wen;

  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [14:0]blk_mem_gen_0_douta;
  wire [14:0]blk_mem_gen_2_douta;
  wire [0:0]c_counter_binary_0_Q;
  wire [16:0]gba_double_buffer_0_buf0_address0;
  wire gba_double_buffer_0_buf0_ce0;
  wire [14:0]gba_double_buffer_0_buf0_d0;
  wire gba_double_buffer_0_buf0_we0;
  wire [16:0]gba_double_buffer_0_buf1_address0;
  wire gba_double_buffer_0_buf1_ce0;
  wire [14:0]gba_double_buffer_0_buf1_d0;
  wire gba_double_buffer_0_buf1_we0;
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
  double_buffer_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(gba_double_buffer_0_buf1_address0),
        .clka(ap_clk_1),
        .dina(gba_double_buffer_0_buf1_d0),
        .douta(blk_mem_gen_0_douta),
        .ena(gba_double_buffer_0_buf1_ce0),
        .wea(gba_double_buffer_0_buf1_we0));
  double_buffer_blk_mem_gen_0_1 blk_mem_gen_2
       (.addra(gba_double_buffer_0_buf0_address0),
        .clka(ap_clk_1),
        .dina(gba_double_buffer_0_buf0_d0),
        .douta(blk_mem_gen_2_douta),
        .ena(gba_double_buffer_0_buf0_ce0),
        .wea(gba_double_buffer_0_buf0_we0));
  double_buffer_c_counter_binary_0_0 c_counter_binary_0
       (.CE(toggle_1),
        .CLK(ap_clk_1),
        .Q(c_counter_binary_0_Q));
  double_buffer_gba_double_buffer_0_0 gba_double_buffer_0
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .buf0_address0(gba_double_buffer_0_buf0_address0),
        .buf0_ce0(gba_double_buffer_0_buf0_ce0),
        .buf0_d0(gba_double_buffer_0_buf0_d0),
        .buf0_q0(blk_mem_gen_2_douta),
        .buf0_we0(gba_double_buffer_0_buf0_we0),
        .buf1_address0(gba_double_buffer_0_buf1_address0),
        .buf1_ce0(gba_double_buffer_0_buf1_ce0),
        .buf1_d0(gba_double_buffer_0_buf1_d0),
        .buf1_q0(blk_mem_gen_0_douta),
        .buf1_we0(gba_double_buffer_0_buf1_we0),
        .buf_select(c_counter_binary_0_Q),
        .graphics_addr(graphics_addr_1),
        .graphics_color(graphics_color_1),
        .vga_addr(vga_addr_1),
        .vga_color(gba_double_buffer_0_vga_color),
        .wen(wen_1));
endmodule
