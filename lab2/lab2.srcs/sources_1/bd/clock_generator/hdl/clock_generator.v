//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Wed Oct  5 17:00:06 2016
//Host        : hypnos.andrew.local.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
//Command     : generate_target clock_generator.bd
//Design      : clock_generator
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "clock_generator,IP_Integrator,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=clock_generator,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "clock_generator.hwdef" *) 
module clock_generator
   (clk_100_input,
    clk_100_output,
    clk_256,
    clk_8,
    reset);
  input clk_100_input;
  output clk_100_output;
  output clk_256;
  output clk_8;
  input reset;

  wire clk_100_input_1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire reset_1;

  assign clk_100_input_1 = clk_100_input;
  assign clk_100_output = clk_wiz_0_clk_out3;
  assign clk_256 = clk_wiz_0_clk_out1;
  assign clk_8 = clk_wiz_0_clk_out2;
  assign reset_1 = reset;
  clock_generator_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_100_input_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3),
        .reset(reset_1));
endmodule
