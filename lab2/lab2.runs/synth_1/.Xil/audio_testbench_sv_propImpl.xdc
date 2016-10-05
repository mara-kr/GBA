set_property SRC_FILE_INFO {cfile:/afs/ece.cmu.edu/usr/ryanovsk/Private/18545/GBA/lab2/lab2.srcs/sources_1/bd/clock_generator/ip/clock_generator_clk_wiz_0_0/clock_generator_clk_wiz_0_0.xdc rfile:../../../lab2.srcs/sources_1/bd/clock_generator/ip/clock_generator_clk_wiz_0_0/clock_generator_clk_wiz_0_0.xdc id:1 order:EARLY scoped_inst:clock_generator_i/clk_wiz_0/inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
