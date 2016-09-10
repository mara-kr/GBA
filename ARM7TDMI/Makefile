VCS=vcs -q -debug -R
VLOGAN=vlogan -sverilog -q
WORK_DIR=$(shell pwd)

default: test_core

init:
	mkdir build
	cd build

test_alu: init
	vhdlan -f $(WORK_DIR)/file_lists/alu_files
	$(VLOGAN) $(WORK_DIR)/ALU/alu_tb.sv
	$(VCS) alu_sv_tb

test_core: init
	vhdlan -f $(WORK_DIR)/file_lists/core_files
	$(VLOGAN) $(WORK_DIR)/CoreSimTimer.sv
	$(VCS) CoreSimTimer

clean:
	rm -rf build
	rm -rf 64
	rm -rf ALU/64
	rm -rf AN.DB
	rm -rf csrc
	rm -rf DVEfiles
	rm -rf simv.daidir
	rm simv
	rm ucli.key
