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
echo "xvlog -m64 --relax -prj audio_testbench_sv_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj audio_testbench_sv_vlog.prj 2>&1 | tee compile.log
echo "xvhdl -m64 --relax -prj audio_testbench_sv_vhdl.prj"
ExecStep $xv_path/bin/xvhdl -m64 --relax -prj audio_testbench_sv_vhdl.prj 2>&1 | tee -a compile.log
