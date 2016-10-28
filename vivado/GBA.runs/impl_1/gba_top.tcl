proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  debug::add_scope template.lib 1
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.cache/wt [current_project]
  set_property parent.project_path /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.xpr [current_project]
  set_property ip_repo_paths /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.cache/ip [current_project]
  set_property ip_output_repo /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.cache/ip [current_project]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/synth_1/gba_top.dcp
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/system_rom_synth_1/system_rom.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/system_rom_synth_1/system_rom.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/InternRAM_synth_1/InternRAM.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/InternRAM_synth_1/InternRAM.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/vram_A_synth_1/vram_A.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/vram_A_synth_1/vram_A.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/vram_B_synth_1/vram_B.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/vram_B_synth_1/vram_B.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/vram_C_synth_1/vram_C.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/vram_C_synth_1/vram_C.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/palette_bg_ram_synth_1/palette_bg_ram.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/palette_bg_ram_synth_1/palette_bg_ram.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/palette_obj_ram_synth_1/palette_obj_ram.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/palette_obj_ram_synth_1/palette_obj_ram.dcp]
  add_files -quiet /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/OAM_synth_1/OAM.dcp
  set_property netlist_only true [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.runs/OAM_synth_1/OAM.dcp]
  read_xdc -mode out_of_context -ref system_rom -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/system_rom/system_rom_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/system_rom/system_rom_ooc.xdc]
  read_xdc -mode out_of_context -ref InternRAM -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/InternRAM/InternRAM_ooc.xdc]
  read_xdc -mode out_of_context -ref vram_A -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_A/vram_A_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_A/vram_A_ooc.xdc]
  read_xdc -mode out_of_context -ref vram_B -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_B/vram_B_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_B/vram_B_ooc.xdc]
  read_xdc -mode out_of_context -ref vram_C -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_C/vram_C_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/vram_C/vram_C_ooc.xdc]
  read_xdc -mode out_of_context -ref palette_bg_ram -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/palette_bg_ram/palette_bg_ram_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/palette_bg_ram/palette_bg_ram_ooc.xdc]
  read_xdc -mode out_of_context -ref palette_obj_ram -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/palette_obj_ram/palette_obj_ram_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/palette_obj_ram/palette_obj_ram_ooc.xdc]
  read_xdc -mode out_of_context -ref OAM -cells U0 /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/OAM/OAM_ooc.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/vivado/GBA.srcs/sources_1/ip/OAM/OAM_ooc.xdc]
  read_xdc /afs/ece.cmu.edu/usr/nryan/Private/545/GBA/zedboard_master_XDC_RevC_D_v3.xdc
  link_design -top gba_top -part xc7z020clg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force gba_top_opt.dcp
  catch {report_drc -file gba_top_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file gba_top.hwdef}
  place_design 
  write_checkpoint -force gba_top_placed.dcp
  catch { report_io -file gba_top_io_placed.rpt }
  catch { report_utilization -file gba_top_utilization_placed.rpt -pb gba_top_utilization_placed.pb }
  catch { report_control_sets -verbose -file gba_top_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force gba_top_routed.dcp
  catch { report_drc -file gba_top_drc_routed.rpt -pb gba_top_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file gba_top_timing_summary_routed.rpt -rpx gba_top_timing_summary_routed.rpx }
  catch { report_power -file gba_top_power_routed.rpt -pb gba_top_power_summary_routed.pb }
  catch { report_route_status -file gba_top_route_status.rpt -pb gba_top_route_status.pb }
  catch { report_clock_utilization -file gba_top_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

