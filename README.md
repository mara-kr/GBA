# GBA
### Directories
####audio
    audio_top.sv : top module for audio
    audio_testbench.sv : a testbench for 4 channel sound
    direct_sound/ : mixer and files for direct sound
    4channel/ : mixer and modules for each of the 4 channels
####controller
    controller.sv : the source code fo the controller
    interface.txt : detail documentation on the controller interface
    CI.sv : chip interface for the controller
####cpu
    roms/ : test roms including the GBA bios
    ALU/ : the source code for the ALU
    Multiplier : source code for the multiplier (the M in TDMI)
    ThumbDecoder.vhd : decoder for thumb mode the (T in TDMI)
    Shifter : source code fo the barrel shifter
    ARM7TDMIS_TOP.vhd : the top module for the entire CU
    cpu_top.sv : wrapper for ARM7TDMIS_TOP.vhd in system verilog
    ControlLogic.vhd : control logic for the instruction pipeline

####dma
    dma.sv : includes the datapath and fsm for dma, as well as the top module for all 4 dma's
    dma_fsm_tb.sv : an fsm that sets mmio registers for the tb
    dma_tb_sim.sv : a test bench in simulation, includes a simulated memory controller
    dma_tb.sv : a tb for the fpga
    test.coe : a sample coe file for testing
####doc
    Docs for each of the major systems, summary of the programming reference manual
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
    endian_convert.py : A python script to convert the endianness of a coe file
    pixels.coe : A sample coe file
    mem_top.sv : The memory controller
####timer
    timer_top.sv : the top module for al 4 timers
    timer.sv : one individual timer
####zedboard_audio-master:
    This directory was taken from https://github.com/ems-kl/zedboard_audio. The code in hdl/ outputs to the audio chip
    hdl/ : the source code
    doku/ : documentation taken from the project repo
    constraints/ : a constraints file for the project (not needed for our project)
    bitstreams/ : sample bitstreams the project gave for tests (not needed for our project)


### Instructions to make Project
1. Unzip and open the GBA_archive.xpr.zip Vivado Project
2. Create COE file out of game ROM you want to play, make sure to convert to Little Endian.
    Input COE file into Game Pack ROM 
