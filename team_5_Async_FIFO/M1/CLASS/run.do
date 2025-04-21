vlib work

vlog fifomem.sv
vlog rptr_empty.sv
vlog sync_r2w.sv
vlog sync_w2r.sv
vlog wptr_full.sv
vlog async_fifo_tb.sv
vlog top.sv

vsim -c -gADDRSIZE=456 custom_async_fifo_tb
vsim work.custom_async_fifo_tb -c
#vsim -voptargs=+acc work.custom_async_fifo_tb

vsim -c -coverage custom_async_fifo_tb -voptargs="+acc +cover=bcesfx"
#vsim -c custom_async_fifo_tb -voptargs="+acc"

#add wave -r *
#add wave sim:/custom_async_fifo_tb/*

run -all

coverage report -details -code bcesft -output M1_report.rpt

exit