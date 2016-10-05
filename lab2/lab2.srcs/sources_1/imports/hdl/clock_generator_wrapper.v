//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Mon Oct  3 12:01:05 2016
//Host        : magnum.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
//Command     : generate_target clock_generator_wrapper.bd
//Design      : clock_generator_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_generator_wrapper
   (clock_100);
  input clock_100;

  wire clock_100;

  clock_generator clock_generator_i
       (.clock_100(clock_100));
endmodule
