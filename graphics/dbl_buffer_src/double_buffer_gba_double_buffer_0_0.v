// (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:hls:gba_double_buffer:1.0
// IP Revision: 1610102049

(* X_CORE_INFO = "gba_double_buffer,Vivado 2016.2" *)
(* CHECK_LICENSE_TYPE = "double_buffer_gba_double_buffer_0_0,gba_double_buffer,{}" *)
(* CORE_GENERATION_INFO = "double_buffer_gba_double_buffer_0_0,gba_double_buffer,{x_ipProduct=Vivado 2016.2,x_ipVendor=xilinx.com,x_ipLibrary=hls,x_ipName=gba_double_buffer,x_ipVersion=1.0,x_ipCoreRevision=1610102049,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module double_buffer_gba_double_buffer_0_0 (
  buf0_ce0,
  buf0_we0,
  buf1_ce0,
  buf1_we0,
  ap_clk,
  ap_rst_n,
  graphics_color,
  vga_color,
  graphics_addr,
  vga_addr,
  buf0_address0,
  buf0_d0,
  buf0_q0,
  buf1_address0,
  buf1_d0,
  buf1_q0,
  wen,
  buf_select
);

output wire buf0_ce0;
output wire buf0_we0;
output wire buf1_ce0;
output wire buf1_we0;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *)
input wire ap_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *)
input wire ap_rst_n;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 graphics_color DATA" *)
input wire [14 : 0] graphics_color;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 vga_color DATA" *)
output wire [14 : 0] vga_color;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 graphics_addr DATA" *)
input wire [16 : 0] graphics_addr;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 vga_addr DATA" *)
input wire [16 : 0] vga_addr;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf0_address0 DATA" *)
output wire [16 : 0] buf0_address0;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf0_d0 DATA" *)
output wire [14 : 0] buf0_d0;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf0_q0 DATA" *)
input wire [14 : 0] buf0_q0;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf1_address0 DATA" *)
output wire [16 : 0] buf1_address0;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf1_d0 DATA" *)
output wire [14 : 0] buf1_d0;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf1_q0 DATA" *)
input wire [14 : 0] buf1_q0;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 wen DATA" *)
input wire [0 : 0] wen;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 buf_select DATA" *)
input wire [0 : 0] buf_select;

  gba_double_buffer inst (
    .buf0_ce0(buf0_ce0),
    .buf0_we0(buf0_we0),
    .buf1_ce0(buf1_ce0),
    .buf1_we0(buf1_we0),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .graphics_color(graphics_color),
    .vga_color(vga_color),
    .graphics_addr(graphics_addr),
    .vga_addr(vga_addr),
    .buf0_address0(buf0_address0),
    .buf0_d0(buf0_d0),
    .buf0_q0(buf0_q0),
    .buf1_address0(buf1_address0),
    .buf1_d0(buf1_d0),
    .buf1_q0(buf1_q0),
    .wen(wen),
    .buf_select(buf_select)
  );
endmodule
