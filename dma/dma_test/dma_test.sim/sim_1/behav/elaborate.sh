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
ExecStep $xv_path/bin/xelab -wto 64123f22486d4382a23f191126ced691 -m64 --debug typical --relax --mt 8 -L dist_mem_gen_v8_0 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot dma_tb_behav xil_defaultlib.dma_tb xil_defaultlib.glbl -log elaborate.log
