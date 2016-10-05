#!/bin/sh -f
xv_path="/afs/ece/support/xilinx/xilinx.release/Vivado"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim audio_testbench_sv_behav -key {Behavioral:sim_1:Functional:audio_testbench_sv} -tclbatch audio_testbench_sv.tcl -view /afs/ece.cmu.edu/usr/ryanovsk/Private/18545/GBA/lab2/audio_testbench_sv_behav.wcfg -log simulate.log
