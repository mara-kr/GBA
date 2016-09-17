# Makefile for CPU - compiles SV/VHDL code together in build/
# The synopsys_sim.setup makes SV/VHDL simulator time agree (to sec)

VCS=vcs -debug -R
VLOGAN=vlogan -sverilog -q
WORK_DIR=$(shell pwd)
BIOS_FILE=../gba_bios.hex
INIT=mkdir -p build && cd build && cp ../synopsys_sim.setup . && cp $(BIOS_FILE) .

default: test_core

test_alu: clean
	$(INIT) && \
	vhdlan -f $(WORK_DIR)/file_lists/alu_files && \
	$(VLOGAN) $(WORK_DIR)/ALU/alu_tb.sv && \
	$(VCS) alu_sv_tb

test_core: clean
	$(INIT) && \
	vhdlan -f $(WORK_DIR)/file_lists/core_files && \
	$(VLOGAN) $(WORK_DIR)/core_tb_defines.vh $(WORK_DIR)/core_tb.sv && \
	$(VCS) core_tb

gui:
	cd build && ./simv -gui &
clean:
	rm -rf build
	rm -rf 64
	rm -rf AN.DB
	rm -rf csrc
	rm -rf BusLog.txt
