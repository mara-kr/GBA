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
echo "xvlog -m64 --relax -prj dma_tb_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj dma_tb_vlog.prj 2>&1 | tee compile.log
