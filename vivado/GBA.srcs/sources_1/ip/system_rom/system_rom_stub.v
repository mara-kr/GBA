// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Thu Nov  3 16:48:42 2016
// Host        : fuggle.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
// Command     : write_verilog -force -mode synth_stub
//               /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/system_rom/system_rom_stub.v
// Design      : system_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2015.2" *)
module system_rom(clka, rsta, addra, douta, clkb, rstb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,addra[31:0],douta[31:0],clkb,rstb,addrb[31:0],doutb[31:0]" */;
  input clka;
  input rsta;
  input [31:0]addra;
  output [31:0]douta;
  input clkb;
  input rstb;
  input [31:0]addrb;
  output [31:0]doutb;
endmodule
