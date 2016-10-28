# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.cache/wt [current_project]
set_property parent.project_path /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
read_ip /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM.xci
set_property is_locked true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM.xci]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
synth_design -top InternRAM -part xc7z020clg484-1 -mode out_of_context
rename_ref -prefix_all InternRAM_
write_checkpoint -noxdef InternRAM.dcp
catch { report_utilization -file InternRAM_utilization_synth.rpt -pb InternRAM_utilization_synth.pb }
if { [catch {
  file copy -force /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/InternRAM_synth_1/InternRAM.dcp /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM.dcp
} _RESULT ] } { 
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}
if { [catch {
  write_verilog -force -mode synth_stub /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode synth_stub /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_verilog -force -mode funcsim /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM_funcsim.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode funcsim /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM_funcsim.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
