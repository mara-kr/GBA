# Makefile for CPU - compiles SV/VHDL code together in build/
# The synopsys_sim.setup makes SV/VHDL simulator time agree (to sec)

WORK_DIR=$(shell pwd)
BUILD_DIR=$(WORK_DIR)/build

VCS_REG_FILE=$(BUILD_DIR)/vcs_reg_out.txt

BIOS_FILE=$(WORK_DIR)/gba_bios.hex
#BIOS_FILE=$(WORK_DIR)/roms/pixels.hex
#BIOS_FILE=$(WORK_DIR)/roms/mem_test.hex
ROM_FILE=$(WORK_DIR)/roms/pixels.hex
#ROM_FILE=$(WORK_DIR)/roms/loz_minish.hex
#QEMU_REG_FILE=$(WORK_DIR)/test_files/pixels.regs
QEMU_REG_FILE=$(WORK_DIR)/test_files/bios.regs
BUS_LOG_FILE=$(WORK_DIR)/BusLog.txt

VCS=vcs -debug -q
VLOGAN=vlogan -sverilog -q
FILES=$(WORK_DIR)/synopsys_sim.setup $(BIOS_FILE) $(ROM_FILE)
INIT=mkdir -p $(BUILD_DIR) && cp $(FILES) $(BUILD_DIR)/ && cd $(BUILD_DIR)
export GBA_CPU_BIOS_FILE=$(BIOS_FILE)
export GBA_CPU_ROM_FILE=$(ROM_FILE)
export GBA_CPU_BUS_LOG=$(BUS_LOG_FILE)
export GBA_PAK_INIT_1_FILE=$(WORK_DIR)/roms/pak_init_1.hex

default: core

# Build the CPU for testing
core:
	$(INIT) && \
	vhdlan -f $(WORK_DIR)/file_lists/core_files && \
	$(VLOGAN) $(WORK_DIR)/core_tb_defines.vh $(WORK_DIR)/core_tb.sv && \
	$(VCS) core_tb

# Build and test the CPU.
# NOTE: testing infrastructure is outdated with modifications to the memory
# subsystem. It would be prudent to have the memory controller re-written
# to work in synthesis or simulation (like the P18240)
test_core:
	$(INIT) && \
	vhdlan -f $(WORK_DIR)/file_lists/core_files && \
	$(VLOGAN) $(WORK_DIR)/core_tb_defines.vh $(WORK_DIR)/core_tb.sv && \
	$(VCS) -R core_tb > $(VCS_REG_FILE) && \
	python $(WORK_DIR)/test_files/reg_diff.py --vcs $(VCS_REG_FILE) --qemu $(QEMU_REG_FILE) --dir $(BUILD_DIR)/

# Run the VCS waveform viewer, since VCS is weird about using build directories
gui:
	cd build && ./simv -gui &

simv:
	cd build && ./simv

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(BUS_LOG_FILE)
