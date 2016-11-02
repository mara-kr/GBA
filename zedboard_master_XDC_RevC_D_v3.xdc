# ----------------------------------------------------------------------------
#     _____
#    / #   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/
# ----------------------------------------------------------------------------
#
#  Created With Avnet UCF Generator V0.4.0
#     Date: Saturday, June 30, 2012
#     Time: 12:18:55 AM
#
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#
#  Please direct any questions to:
#     ZedBoard.org Community Forums
#     http://www.zedboard.org
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2012 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Notes:
#
#  10 August 2012
#     IO standards based upon Bank 34 and Bank 35 Vcco supply options of 1.8V,
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.
#     By default, Vadj is expected to be set to 1.8V but if a different
#     voltage is used for a particular design, then the corresponding IO
#     standard within this UCF should also be updated to reflect the actual
#     Vadj jumper selection.
#
#  09 September 2012
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.
#     HDL net names are adjusted to contain no hyphen characters '-' but
#     rather use underscore '_' characters.  Comment net name with the hyphen
#     characters will remain in place since these are intended to match the
#     schematic net names in order to better enable schematic search.
#
#  17 April 2014
#     Pin constraint for toggle switch SW7 was corrected to M15 location.
#
#  16 April 2015
#     Corrected the way that entire banks are assigned to a particular IO
#     standard so that it works with more recent versions of Vivado Design
#     Suite and moved the IO standard constraints to the end of the file
#     along with some better organization and notes like we do with our SOMs.
#
#   6 June 2016
#     Corrected error in signal name for package pin N19 (FMC Expansion Connector)
#
#
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports GCLK]

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y11 [get_ports {JA1}];
set_property PACKAGE_PIN AA8  [get_ports {JA10}];  # "JA10"
set_property PACKAGE_PIN AA11 [get_ports {JA2}];
set_property PACKAGE_PIN Y10 [get_ports {JA3}];
set_property PACKAGE_PIN AA9  [get_ports {JA4}];  # "JA4"
set_property PACKAGE_PIN AB11 [get_ports {JA7}];  # "JA7"
set_property PACKAGE_PIN AB10 [get_ports {JA8}];  # "JA8"
set_property PACKAGE_PIN AB9  [get_ports {JA9}];  # "JA9"


# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN T22 [get_ports {LD[0]}]
set_property PACKAGE_PIN T21 [get_ports {LD[1]}]
set_property PACKAGE_PIN U22 [get_ports {LD[2]}]
set_property PACKAGE_PIN U21 [get_ports {LD[3]}]
set_property PACKAGE_PIN V22 [get_ports {LD[4]}]
set_property PACKAGE_PIN W22 [get_ports {LD[5]}]
set_property PACKAGE_PIN U19 [get_ports {LD[6]}]
set_property PACKAGE_PIN U14 [get_ports {LD[7]}]

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y21 [get_ports {VGA_B[0]}]
set_property PACKAGE_PIN Y20 [get_ports {VGA_B[1]}]
set_property PACKAGE_PIN AB20 [get_ports {VGA_B[2]}]
set_property PACKAGE_PIN AB19 [get_ports {VGA_B[3]}]
set_property PACKAGE_PIN AB22 [get_ports {VGA_G[0]}]
set_property PACKAGE_PIN AA22 [get_ports {VGA_G[1]}]
set_property PACKAGE_PIN AB21 [get_ports {VGA_G[2]}]
set_property PACKAGE_PIN AA21 [get_ports {VGA_G[3]}]
set_property PACKAGE_PIN AA19 [get_ports VGA_HS]
set_property PACKAGE_PIN V20 [get_ports {VGA_R[0]}]
set_property PACKAGE_PIN U20 [get_ports {VGA_R[1]}]
set_property PACKAGE_PIN V19 [get_ports {VGA_R[2]}]
set_property PACKAGE_PIN V18 [get_ports {VGA_R[3]}]
set_property PACKAGE_PIN Y19 [get_ports VGA_VS]

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN R16 [get_ports BTND]


# ----------------------------------------------------------------------------
# User DIP Switches - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN F22 [get_ports {SW[0]}]
set_property PACKAGE_PIN G22 [get_ports {SW[1]}]
set_property PACKAGE_PIN H22 [get_ports {SW[2]}]
set_property PACKAGE_PIN F21 [get_ports {SW[3]}]
set_property PACKAGE_PIN H19 [get_ports {SW[4]}]
set_property PACKAGE_PIN H18 [get_ports {SW[5]}]
set_property PACKAGE_PIN H17 [get_ports {SW[6]}]
set_property PACKAGE_PIN M15 [get_ports {SW[7]}]

# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are
# evaluated prior to other PACKAGE_PIN constraints being applied, then
# the IOSTANDARD specified will likely not be applied properly to those
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed
# within the XDC file in a location that is evaluated AFTER all
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ----------------------------------------------------------------------------

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]]

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]]

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]]









connect_debug_port u_ila_0_0/probe1 [get_nets [list {bus_wdata[0]} {bus_wdata[1]} {bus_wdata[2]} {bus_wdata[3]} {bus_wdata[4]} {bus_wdata[5]} {bus_wdata[6]} {bus_wdata[7]} {bus_wdata[8]} {bus_wdata[9]} {bus_wdata[10]} {bus_wdata[11]} {bus_wdata[12]} {bus_wdata[13]} {bus_wdata[14]} {bus_wdata[15]} {bus_wdata[16]} {bus_wdata[17]} {bus_wdata[20]} {bus_wdata[21]} {bus_wdata[23]} {bus_wdata[24]} {bus_wdata[25]} {bus_wdata[26]} {bus_wdata[27]} {bus_wdata[28]} {bus_wdata[29]} {bus_wdata[30]} {bus_wdata[31]}]]
connect_debug_port u_ila_0_0/probe3 [get_nets [list {bus_addr[0]} {bus_addr[1]} {bus_addr[2]} {bus_addr[3]} {bus_addr[4]} {bus_addr[5]} {bus_addr[6]} {bus_addr[9]} {bus_addr[10]} {bus_addr[11]} {bus_addr[12]} {bus_addr[13]} {bus_addr[14]} {bus_addr[15]} {bus_addr[16]} {bus_addr[17]} {bus_addr[18]} {bus_addr[19]} {bus_addr[20]} {bus_addr[21]} {bus_addr[22]} {bus_addr[23]} {bus_addr[24]} {bus_addr[25]} {bus_addr[26]} {bus_addr[27]} {bus_addr[28]} {bus_addr[29]} {bus_addr[30]} {bus_addr[31]}]]

















connect_debug_port u_ila_0_0/clk [get_nets [list GCLK_IBUF_BUFG]]
connect_debug_port dbg_hub/clk [get_nets GCLK_IBUF_BUFG]






create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz/inst/clk_out1]]
set_property port_width 30 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {bus_addr[0]} {bus_addr[1]} {bus_addr[2]} {bus_addr[3]} {bus_addr[4]} {bus_addr[5]} {bus_addr[6]} {bus_addr[9]} {bus_addr[10]} {bus_addr[11]} {bus_addr[12]} {bus_addr[13]} {bus_addr[14]} {bus_addr[15]} {bus_addr[16]} {bus_addr[17]} {bus_addr[18]} {bus_addr[19]} {bus_addr[20]} {bus_addr[21]} {bus_addr[22]} {bus_addr[23]} {bus_addr[24]} {bus_addr[25]} {bus_addr[26]} {bus_addr[27]} {bus_addr[28]} {bus_addr[29]} {bus_addr[30]} {bus_addr[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {bus_rdata[0]} {bus_rdata[1]} {bus_rdata[2]} {bus_rdata[3]} {bus_rdata[4]} {bus_rdata[5]} {bus_rdata[6]} {bus_rdata[7]} {bus_rdata[8]} {bus_rdata[9]} {bus_rdata[10]} {bus_rdata[11]} {bus_rdata[12]} {bus_rdata[13]} {bus_rdata[14]} {bus_rdata[15]} {bus_rdata[16]} {bus_rdata[17]} {bus_rdata[18]} {bus_rdata[19]} {bus_rdata[20]} {bus_rdata[21]} {bus_rdata[22]} {bus_rdata[23]} {bus_rdata[24]} {bus_rdata[25]} {bus_rdata[26]} {bus_rdata[27]} {bus_rdata[28]} {bus_rdata[29]} {bus_rdata[30]} {bus_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {bus_size[0]} {bus_size[1]}]]
create_debug_port u_ila_0 probe
set_property port_width 29 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {bus_wdata[0]} {bus_wdata[1]} {bus_wdata[2]} {bus_wdata[3]} {bus_wdata[4]} {bus_wdata[5]} {bus_wdata[6]} {bus_wdata[7]} {bus_wdata[8]} {bus_wdata[9]} {bus_wdata[10]} {bus_wdata[11]} {bus_wdata[12]} {bus_wdata[13]} {bus_wdata[14]} {bus_wdata[15]} {bus_wdata[16]} {bus_wdata[17]} {bus_wdata[20]} {bus_wdata[21]} {bus_wdata[23]} {bus_wdata[24]} {bus_wdata[25]} {bus_wdata[26]} {bus_wdata[27]} {bus_wdata[28]} {bus_wdata[29]} {bus_wdata[30]} {bus_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 5 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {count[0]} {count[1]} {count[2]} {count[3]} {count[4]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {mem/bus_addr_lat1[0]} {mem/bus_addr_lat1[1]} {mem/bus_addr_lat1[2]} {mem/bus_addr_lat1[3]} {mem/bus_addr_lat1[4]} {mem/bus_addr_lat1[5]} {mem/bus_addr_lat1[6]} {mem/bus_addr_lat1[7]} {mem/bus_addr_lat1[8]} {mem/bus_addr_lat1[9]} {mem/bus_addr_lat1[10]} {mem/bus_addr_lat1[11]} {mem/bus_addr_lat1[12]} {mem/bus_addr_lat1[13]} {mem/bus_addr_lat1[14]} {mem/bus_addr_lat1[15]} {mem/bus_addr_lat1[16]} {mem/bus_addr_lat1[17]} {mem/bus_addr_lat1[18]} {mem/bus_addr_lat1[19]} {mem/bus_addr_lat1[20]} {mem/bus_addr_lat1[21]} {mem/bus_addr_lat1[22]} {mem/bus_addr_lat1[23]} {mem/bus_addr_lat1[24]} {mem/bus_addr_lat1[25]} {mem/bus_addr_lat1[26]} {mem/bus_addr_lat1[27]} {mem/bus_addr_lat1[28]} {mem/bus_addr_lat1[29]} {mem/bus_addr_lat1[30]} {mem/bus_addr_lat1[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {mem/bus_addr[0]} {mem/bus_addr[1]} {mem/bus_addr[2]} {mem/bus_addr[3]} {mem/bus_addr[4]} {mem/bus_addr[5]} {mem/bus_addr[6]} {mem/bus_addr[7]} {mem/bus_addr[8]} {mem/bus_addr[9]} {mem/bus_addr[10]} {mem/bus_addr[11]} {mem/bus_addr[12]} {mem/bus_addr[13]} {mem/bus_addr[14]} {mem/bus_addr[15]} {mem/bus_addr[16]} {mem/bus_addr[17]} {mem/bus_addr[18]} {mem/bus_addr[19]} {mem/bus_addr[20]} {mem/bus_addr[21]} {mem/bus_addr[22]} {mem/bus_addr[23]} {mem/bus_addr[24]} {mem/bus_addr[25]} {mem/bus_addr[26]} {mem/bus_addr[27]} {mem/bus_addr[28]} {mem/bus_addr[29]} {mem/bus_addr[30]} {mem/bus_addr[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {mem/bus_io_reg_rdata[0]} {mem/bus_io_reg_rdata[1]} {mem/bus_io_reg_rdata[2]} {mem/bus_io_reg_rdata[3]} {mem/bus_io_reg_rdata[4]} {mem/bus_io_reg_rdata[5]} {mem/bus_io_reg_rdata[6]} {mem/bus_io_reg_rdata[7]} {mem/bus_io_reg_rdata[8]} {mem/bus_io_reg_rdata[9]} {mem/bus_io_reg_rdata[10]} {mem/bus_io_reg_rdata[11]} {mem/bus_io_reg_rdata[12]} {mem/bus_io_reg_rdata[13]} {mem/bus_io_reg_rdata[14]} {mem/bus_io_reg_rdata[15]} {mem/bus_io_reg_rdata[16]} {mem/bus_io_reg_rdata[17]} {mem/bus_io_reg_rdata[18]} {mem/bus_io_reg_rdata[19]} {mem/bus_io_reg_rdata[20]} {mem/bus_io_reg_rdata[21]} {mem/bus_io_reg_rdata[22]} {mem/bus_io_reg_rdata[23]} {mem/bus_io_reg_rdata[24]} {mem/bus_io_reg_rdata[25]} {mem/bus_io_reg_rdata[26]} {mem/bus_io_reg_rdata[27]} {mem/bus_io_reg_rdata[28]} {mem/bus_io_reg_rdata[29]} {mem/bus_io_reg_rdata[30]} {mem/bus_io_reg_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {mem/bus_rdata[0]} {mem/bus_rdata[1]} {mem/bus_rdata[2]} {mem/bus_rdata[3]} {mem/bus_rdata[4]} {mem/bus_rdata[5]} {mem/bus_rdata[6]} {mem/bus_rdata[7]} {mem/bus_rdata[8]} {mem/bus_rdata[9]} {mem/bus_rdata[10]} {mem/bus_rdata[11]} {mem/bus_rdata[12]} {mem/bus_rdata[13]} {mem/bus_rdata[14]} {mem/bus_rdata[15]} {mem/bus_rdata[16]} {mem/bus_rdata[17]} {mem/bus_rdata[18]} {mem/bus_rdata[19]} {mem/bus_rdata[20]} {mem/bus_rdata[21]} {mem/bus_rdata[22]} {mem/bus_rdata[23]} {mem/bus_rdata[24]} {mem/bus_rdata[25]} {mem/bus_rdata[26]} {mem/bus_rdata[27]} {mem/bus_rdata[28]} {mem/bus_rdata[29]} {mem/bus_rdata[30]} {mem/bus_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {mem/bus_wdata[0]} {mem/bus_wdata[1]} {mem/bus_wdata[2]} {mem/bus_wdata[3]} {mem/bus_wdata[4]} {mem/bus_wdata[5]} {mem/bus_wdata[6]} {mem/bus_wdata[7]} {mem/bus_wdata[8]} {mem/bus_wdata[9]} {mem/bus_wdata[10]} {mem/bus_wdata[11]} {mem/bus_wdata[12]} {mem/bus_wdata[13]} {mem/bus_wdata[14]} {mem/bus_wdata[15]} {mem/bus_wdata[16]} {mem/bus_wdata[17]} {mem/bus_wdata[18]} {mem/bus_wdata[19]} {mem/bus_wdata[20]} {mem/bus_wdata[21]} {mem/bus_wdata[22]} {mem/bus_wdata[23]} {mem/bus_wdata[24]} {mem/bus_wdata[25]} {mem/bus_wdata[26]} {mem/bus_wdata[27]} {mem/bus_wdata[28]} {mem/bus_wdata[29]} {mem/bus_wdata[30]} {mem/bus_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {mem/bus_we[0]} {mem/bus_we[1]} {mem/bus_we[2]} {mem/bus_we[3]}]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list BTND_IBUF]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list mem/bus_intern_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list mem/bus_intern_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list mem/bus_io_reg_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list mem/bus_oam_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list mem/bus_oam_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list mem/bus_palette_bg_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list mem/bus_palette_bg_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list mem/bus_palette_obj_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list mem/bus_palette_obj_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list bus_pause]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list mem/bus_system_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list mem/bus_vram_A_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list mem/bus_vram_A_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list mem/bus_vram_B_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list mem/bus_vram_B_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list mem/bus_vram_C_read]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list mem/bus_vram_C_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list bus_write]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list clr]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list en]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list fail]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list good_bot]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list good_top]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list top_half]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clock]
