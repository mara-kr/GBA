// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Thu Nov  3 16:48:47 2016
// Host        : fuggle.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
// Command     : write_verilog -force -mode synth_stub
//               /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_A/vram_A_stub.v
// Design      : vram_A
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2015.2" *)
module vram_A(clka, rsta, wea, addra, dina, douta, clkb, rstb, web, addrb, dinb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,wea[3:0],addra[31:0],dina[31:0],douta[31:0],clkb,rstb,web[3:0],addrb[31:0],dinb[31:0],doutb[31:0]" */;
  input clka;
  input rsta;
  input [3:0]wea;
  input [31:0]addra;
  input [31:0]dina;
  output [31:0]douta;
  input clkb;
  input rstb;
  input [3:0]web;
  input [31:0]addrb;
  input [31:0]dinb;
  output [31:0]doutb;
endmodule
