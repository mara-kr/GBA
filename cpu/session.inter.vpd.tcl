# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Sat Nov 12 21:06:38 2016
# Designs open: 1
#   Sim: simv
# Toplevel windows open: 2
# 	TopLevel.2
# 	TopLevel.3
#   Wave.1: 31 signals
#   Group count = 4
#   Group Group1 signal count = 6
#   Group Group2 signal count = 13
#   Group Group3 signal count = 7
#   Group Group4 signal count = 5
# End_DVE_Session_Save_Info

# DVE version: J-2014.12-SP3-1_Full64
# DVE build date: Aug 27 2015 23:51:53


#<Session mode="Full" path="/afs/ece.cmu.edu/usr/nryan/Private/545/GBA/cpu/session.inter.vpd.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state maximized -rect {{1 183} {1600 1281}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.2} -dock_state left -dock_on_new_line true -dock_extent 198]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 198
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value 250
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 197} {height 999} {dock_state left} {dock_on_new_line true} {child_hier_colhier 934} {child_hier_coltype 661} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set DLPane.1 [gui_create_window -type {DLPane}  -parent ${TopLevel.2}]
if {[gui_get_shared_view -id ${DLPane.1} -type Data] == {}} {
        set Data.1 [gui_share_window -id ${DLPane.1} -type Data]
} else {
        set Data.1  [gui_get_shared_view -id ${DLPane.1} -type Data]
}

gui_show_window -window ${DLPane.1} -show_state maximized
gui_update_layout -id ${DLPane.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 675} {child_data_colvalue 340} {child_data_coltype 381} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}

# End MDI window settings


# Create and position top-level window: TopLevel.3

if {![gui_exist_window -window TopLevel.3]} {
    set TopLevel.3 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.3 TopLevel.3
}
gui_show_window -window ${TopLevel.3} -show_state maximized -rect {{533 106} {2132 1204}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.3} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.3}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 464} {child_wave_right 1130} {child_wave_colname 257} {child_wave_colvalue 203} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) none
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) none
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.2}
gui_update_statusbar_target_frame ${TopLevel.3}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{-ucligui -nc}}
gui_set_env SIMSETUP::SIMEXE {simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {simv}] } {
gui_sim_run Ucli -exe simv -args {-ucligui -nc} -dir ../build -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1s
gui_set_time_units 1s
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {core_tb}
gui_load_child_values {core_tb.DUT.IPDR_INST}
gui_load_child_values {core_tb.DUT.PSR_INST}
gui_load_child_values {core_tb.DUT.CONTROLLOGIC_INST}


set _session_group_1 Group1
gui_sg_create "$_session_group_1"
set Group1 "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { core_tb.clk core_tb.addr core_tb.wdata core_tb.size core_tb.write core_tb.rdata }

set _session_group_2 Group2
gui_sg_create "$_session_group_2"
set Group2 "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { core_tb.DUT.REGFILE_INST.UMREGISTERFILE(0) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(1) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(2) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(3) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(4) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(5) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(6) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(7) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(12) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(13) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(14) core_tb.DUT.REGFILE_INST.UMREGISTERFILE(15) core_tb.DUT.PSR_INST.CPSR }

set _session_group_3 Group3
gui_sg_create "$_session_group_3"
set Group3 "$_session_group_3"

gui_sg_addsignal -group "$_session_group_3" { core_tb.DUT.REGFILE_INST.SVCMREGISTERFILE(13) core_tb.DUT.REGFILE_INST.SVCMREGISTERFILE(14) core_tb.DUT.REGFILE_INST.IRQMREGISTERFILE(13) core_tb.DUT.REGFILE_INST.IRQMREGISTERFILE(14) core_tb.DUT.REGFILE_INST.USERMODE core_tb.DUT.REGFILE_INST.IRQMODE core_tb.DUT.REGFILE_INST.SVCMODE }

set _session_group_4 Group4
gui_sg_create "$_session_group_4"
set Group4 "$_session_group_4"

gui_sg_addsignal -group "$_session_group_4" { core_tb.DUT.IPDR_INST.FETCHEDINSTRUCTIONIN core_tb.DUT.THUMBDECODER_INST.HALFWORDFORDECODE core_tb.DUT.IPDR_INST.INSTFORDECODE core_tb.DUT.CONTROLLOGIC_INST.INSTFORDECODELATCHED core_tb.DUT.THUMBDECODER_INST.THUMBDECODEREN }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 0



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design Sim
catch {gui_list_expand -id ${Hier.1} core_tb}
catch {gui_list_expand -id ${Hier.1} core_tb.DUT}
catch {gui_list_select -id ${Hier.1} {core_tb.DUT.THUMBDECODER_INST}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {core_tb.DUT.THUMBDECODER_INST}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {core_tb.DUT.THUMBDECODER_INST.THUMBDECODEREN }}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 38
gui_list_add_group -id ${Wave.1} -after {New Group} {Group1}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group2}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group3}
gui_list_add_group -id ${Wave.1} -after {New Group} {Group4}
gui_list_select -id ${Wave.1} {core_tb.DUT.THUMBDECODER_INST.THUMBDECODEREN }
gui_seek_criteria -id ${Wave.1} {Any Edge}

gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(0) -add USER_R0 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(1) -add USER_R1 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(2) -add USER_R2 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(3) -add USER_R3 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(4) -add USER_R4 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(5) -add USER_R5 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(6) -add USER_R6 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(7) -add USER_R7 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(12) -add USER_R12 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(13) -add USER_R13 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(14) -add USER_R14 
gui_list_alias -id ${Wave.1} -group ${Group2} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.UMREGISTERFILE(15) -add USER_R15 
gui_list_alias -id ${Wave.1} -group ${Group3} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.SVCMREGISTERFILE(13) -add SVCM_R13 
gui_list_alias -id ${Wave.1} -group ${Group3} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.SVCMREGISTERFILE(14) -add SVCM_R14 
gui_list_alias -id ${Wave.1} -group ${Group3} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.IRQMREGISTERFILE(13) -add IRQM_R13 
gui_list_alias -id ${Wave.1} -group ${Group3} -index 0 -signal Sim:core_tb.DUT.REGFILE_INST.IRQMREGISTERFILE(14) -add IRQM_R14 
gui_list_alias -id ${Wave.1} -group ${Group4} -index 0 -signal Sim:core_tb.DUT.IPDR_INST.FETCHEDINSTRUCTIONIN -add IF_INST 
gui_list_alias -id ${Wave.1} -group ${Group4} -index 0 -signal Sim:core_tb.DUT.THUMBDECODER_INST.HALFWORDFORDECODE -add ID_INST_TH 
gui_list_alias -id ${Wave.1} -group ${Group4} -index 0 -signal Sim:core_tb.DUT.IPDR_INST.INSTFORDECODE -add ID_INST 
gui_list_alias -id ${Wave.1} -group ${Group4} -index 0 -signal Sim:core_tb.DUT.CONTROLLOGIC_INST.INSTFORDECODELATCHED -add EX_INST 
gui_list_alias -id ${Wave.1} -group ${Group4} -index 0 -signal Sim:core_tb.DUT.THUMBDECODER_INST.THUMBDECODEREN -add THUMB 


gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group Group4  -item core_tb.DUT.THUMBDECODER_INST.THUMBDECODEREN -position below

gui_marker_move -id ${Wave.1} {C1} 0
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${DLPane.1}
}
if {[gui_exist_window -window ${TopLevel.3}]} {
	gui_set_active_window -window ${TopLevel.3}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

