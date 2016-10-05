//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Wed Oct  5 17:00:06 2016
//Host        : hypnos.andrew.local.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
//Command     : generate_target clock_generator_wrapper.bd
//Design      : clock_generator_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_generator_wrapper
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

  wire clk_100_input;
  wire clk_100_output;
  wire clk_256;
  wire clk_8;
  wire reset;

  clock_generator clock_generator_i
       (.clk_100_input(clk_100_input),
        .clk_100_output(clk_100_output),
        .clk_256(clk_256),
        .clk_8(clk_8),
        .reset(reset));
endmodule
