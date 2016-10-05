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
ExecStep $xv_path/bin/xelab -wto 965cdd21ee2d49cda2cb1e13c679d9eb -m64 --debug typical --relax --mt 8 --maxdelay -L xil_defaultlib -L simprims_ver -L secureip --snapshot audio_testbench_sv_time_impl -transport_int_delays -pulse_r 0 -pulse_int_r 0 xil_defaultlib.audio_testbench_sv xil_defaultlib.glbl -log elaborate.log
