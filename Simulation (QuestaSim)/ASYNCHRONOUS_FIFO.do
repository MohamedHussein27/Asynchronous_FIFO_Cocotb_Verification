vlib work
vlog ASYNCHRONOUS_FIFO.v DF_SYNC.v FIFO_MEM_CNTRL.v FIFO_RD.v FIFO_WR.v ASYNCHRONOUS_FIFO_TB.V
vsim -voptargs=+acc work.asynch_fifo_tb
do wave.do
run -all