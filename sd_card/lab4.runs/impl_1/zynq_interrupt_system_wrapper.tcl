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
  set_property webtalk.parent_dir /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.cache/wt [current_project]
  set_property parent.project_path /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.xpr [current_project]
  set_property ip_repo_paths {
  /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.cache/ip
  /afs/ece.cmu.edu/usr/ryanovsk/oled_embeddedcentric
} [current_project]
  set_property ip_output_repo /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.cache/ip [current_project]
  add_files -quiet /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.runs/synth_1/zynq_interrupt_system_wrapper.dcp
  read_xdc -ref zynq_interrupt_system_processing_system7_0_0 -cells inst /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_processing_system7_0_0/zynq_interrupt_system_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_processing_system7_0_0/zynq_interrupt_system_processing_system7_0_0.xdc]
  read_xdc -prop_thru_buffers -ref zynq_interrupt_system_axi_gpio_0_0 -cells U0 /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_axi_gpio_0_0/zynq_interrupt_system_axi_gpio_0_0_board.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_axi_gpio_0_0/zynq_interrupt_system_axi_gpio_0_0_board.xdc]
  read_xdc -ref zynq_interrupt_system_axi_gpio_0_0 -cells U0 /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_axi_gpio_0_0/zynq_interrupt_system_axi_gpio_0_0.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_axi_gpio_0_0/zynq_interrupt_system_axi_gpio_0_0.xdc]
  read_xdc -prop_thru_buffers -ref zynq_interrupt_system_rst_processing_system7_0_50M_0 /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_rst_processing_system7_0_50M_0/zynq_interrupt_system_rst_processing_system7_0_50M_0_board.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_rst_processing_system7_0_50M_0/zynq_interrupt_system_rst_processing_system7_0_50M_0_board.xdc]
  read_xdc -ref zynq_interrupt_system_rst_processing_system7_0_50M_0 /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_rst_processing_system7_0_50M_0/zynq_interrupt_system_rst_processing_system7_0_50M_0.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_rst_processing_system7_0_50M_0/zynq_interrupt_system_rst_processing_system7_0_50M_0.xdc]
  read_xdc -ref zynq_interrupt_system_axi_timer_0_0 /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_axi_timer_0_0/zynq_interrupt_system_axi_timer_0_0.xdc
  set_property processing_order EARLY [get_files /afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/sources_1/bd/zynq_interrupt_system/ip/zynq_interrupt_system_axi_timer_0_0/zynq_interrupt_system_axi_timer_0_0.xdc]
  read_xdc {{/afs/ece.cmu.edu/usr/ryanovsk/Downloads/lab7/lab4.srcs/constrs_1/imports/Source Code/oled_constraints.xdc}}
  link_design -top zynq_interrupt_system_wrapper -part xc7z020clg484-1
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
  write_checkpoint -force zynq_interrupt_system_wrapper_opt.dcp
  catch {report_drc -file zynq_interrupt_system_wrapper_drc_opted.rpt}
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
  catch {write_hwdef -file zynq_interrupt_system_wrapper.hwdef}
  place_design 
  write_checkpoint -force zynq_interrupt_system_wrapper_placed.dcp
  catch { report_io -file zynq_interrupt_system_wrapper_io_placed.rpt }
  catch { report_utilization -file zynq_interrupt_system_wrapper_utilization_placed.rpt -pb zynq_interrupt_system_wrapper_utilization_placed.pb }
  catch { report_control_sets -verbose -file zynq_interrupt_system_wrapper_control_sets_placed.rpt }
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
  write_checkpoint -force zynq_interrupt_system_wrapper_routed.dcp
  catch { report_drc -file zynq_interrupt_system_wrapper_drc_routed.rpt -pb zynq_interrupt_system_wrapper_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file zynq_interrupt_system_wrapper_timing_summary_routed.rpt -rpx zynq_interrupt_system_wrapper_timing_summary_routed.rpx }
  catch { report_power -file zynq_interrupt_system_wrapper_power_routed.rpt -pb zynq_interrupt_system_wrapper_power_summary_routed.pb }
  catch { report_route_status -file zynq_interrupt_system_wrapper_route_status.rpt -pb zynq_interrupt_system_wrapper_route_status.pb }
  catch { report_clock_utilization -file zynq_interrupt_system_wrapper_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force zynq_interrupt_system_wrapper.bit 
  catch { write_sysdef -hwdef zynq_interrupt_system_wrapper.hwdef -bitfile zynq_interrupt_system_wrapper.bit -meminfo zynq_interrupt_system_wrapper.mmi -ltxfile debug_nets.ltx -file zynq_interrupt_system_wrapper.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

