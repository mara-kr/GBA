# Makefile for CPU - compiles SV/VHDL code together in build/
# The synopsys_sim.setup makes SV/VHDL simulator time agree (to sec)

WORK_DIR=$(shell pwd)

#BIOS_FILE=$(WORK_DIR)/gba_bios.hex
BIOS_FILE=$(WORK_DIR)/roms/pixels.hex
ROM_FILE=$(WORK_DIR)/roms/main.hex
BUS_LOG_FILE=$(WORK_DIR)/BusLog.txt

VCS=vcs -debug -R
VLOGAN=vlogan -sverilog -q
FILES=$(WORK_DIR)/synopsys_sim.setup $(BIOS_FILE) $(ROM_FILE)
INIT=mkdir -p build && cp $(FILES) build/ && cd build
export GBA_CPU_BIOS_FILE=$(BIOS_FILE)
export GBA_CPU_ROM_FILE=$(ROM_FILE)
export GBA_CPU_BUS_LOG=$(BUS_LOG_FILE)

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
