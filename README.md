# GBA
### Directories
####audio
    audio_top.sv : top module for audio
    audio_testbench.sv : a testbench for 4 channel sound
    direct_sound/ : mixer and files for direct sound
    4channel/ : mixer and modules for each of the 4 channels
    
####coe_files
    mem_test.coe : Test for block RAMs
    mem_test_new.coe : Another test for block RAMs
    pixels.coe : COE file for ROM that puts 3 pixels on a screen
    pmt.coe : COE file for Mario & Luigi Pong ROM w/ sound (final)
    pong.coe : Basic pong ROM from DevKitARM demo
    pong_mario.coe : 1st iteration of Mario & Luigi pong
    pong_mario_txt.coe : 2nd interation of Mario & Luigi pong
    wstein.coe : ROM for WolfARMStein
    
    There'd normally be gba_bios.coe here, but we remvoed it for copyright reasons. 
    Go find it on the internet, then use the following commands:
    
    xxd -ps -c 1 gba_bios.rom > gba_bios.hex
    python endian_convert.py gba_bios.hex
    mv outfile.hex gba_bios.coe
    
    endian_convert.py is in mem/
    Then add the two lines at the top of COE files - see any other COE file for an example
    
####controller
    controller.sv : the source code fo the controller
    interface.txt : detail documentation on the controller interface
    CI.sv : chip interface for the controller
    
####cpu
    Multiplier/ : source code for the multiplier (the M in TDMI)
    file_lists/ : File lists to pass to the Makefile for simulation
    roms/ : test roms including the GBA bios
    test_files/ : Files for defunct testing infrastructure
    ThumbDecoder.vhd : decoder for thumb mode the (T in TDMI)
    ARM7TDMIS_TOP.vhd : the top module for the entire CPU
    cpu_top.sv : wrapper for ARM7TDMIS_TOP.vhd in system verilog
    ControlLogic.vhd : control logic for the instruction pipeline
    interrupt_controller.sv : Interrupt controller for system
    
    See project report for more details on CPU

####dma
    dma.sv : includes the datapath and fsm for dma, as well as the top module for all 4 dma's
    dma_fsm_tb.sv : an fsm that sets mmio registers for the tb
    dma_tb_sim.sv : a test bench in simulation, includes a simulated memory controller
    dma_tb.sv : a tb for the fpga
    test.coe : a sample coe file for testing
    
####doc
    Docs for each of the major systems, summary of the programming reference manual
    
####games
    Source for the Mario & Luigi pong game that we made for demo day
    
####graphics
    graphics_top.sv : A top module for all of graphics
    manual_testbench.sv : A manual testbench for individual parts of the pipeline
    bg_processing_circuit/ : everything for the bg_processing circuit 
    dbl_buffer_src/ : the double buffer for the vga output
    obj/ : everything for the object (sprite) processing circuit
    priority_evaluation/ : everything for priority evaluation, the inputs to this are the backgroudn and 
                            object circuits
    special_effects/ : everything for the special effects circuit, the input to this comes from the priority
                            circuit
                            
####mem
    endian_convert.py : A python script to convert from single-byte-per-line to 4-byte little endian for COE files
    pixels.coe : A sample coe file
    mem_top.sv : The memory controller
    
####timer
    timer_top.sv : the top module for al 4 timers
    timer.sv : one individual timer
    
####zedboard_audio-master:
    This directory was taken from https://github.com/ems-kl/zedboard_audio. The code in hdl/ outputs to 
    the audio chip
    hdl/ : the source code
    doku/ : documentation taken from the project repo
    constraints/ : a constraints file for the project (not needed for our project)
    bitstreams/ : sample bitstreams the project gave for tests (not needed for our project)


### Instructions to make Project
1. Unzip and open the GBA_archive.xpr.zip Vivado Project (get from Dropbox/AFS)
2. Make a COE file for the GBA BIOS
3. Create COE file out of game ROM you want to play, make sure to convert to Little Endian.
    Input COE file into Game Pack ROM 
