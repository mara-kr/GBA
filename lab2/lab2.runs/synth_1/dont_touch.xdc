# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: /afs/ece.cmu.edu/usr/ryanovsk/Private/18545/GBA/zedboard_audio-master/constraints/zed_audio.xdc

# Block Designs: bd/clock_generator/clock_generator.bd
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==clock_generator || ORIG_REF_NAME==clock_generator}]

# IP: bd/clock_generator/ip/clock_generator_clk_wiz_0_0/clock_generator_clk_wiz_0_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==clock_generator_clk_wiz_0_0 || ORIG_REF_NAME==clock_generator_clk_wiz_0_0}]

# XDC: bd/clock_generator/ip/clock_generator_clk_wiz_0_0/clock_generator_clk_wiz_0_0_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clock_generator_clk_wiz_0_0 || ORIG_REF_NAME==clock_generator_clk_wiz_0_0}] {/inst }]/inst ]]

# XDC: bd/clock_generator/ip/clock_generator_clk_wiz_0_0/clock_generator_clk_wiz_0_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==clock_generator_clk_wiz_0_0 || ORIG_REF_NAME==clock_generator_clk_wiz_0_0}] {/inst }]/inst ]]

# XDC: bd/clock_generator/ip/clock_generator_clk_wiz_0_0/clock_generator_clk_wiz_0_0_ooc.xdc

# XDC: bd/clock_generator/clock_generator_ooc.xdc
