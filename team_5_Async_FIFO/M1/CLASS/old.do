vlib work

vlog fifomem.sv
vlog rptr_empty.sv
vlog sync_r2w.sv
vlog sync_w2r.sv
vlog wptr_full.sv
vlog testbench.sv
vlog top.sv

vsim -c -gADDRSIZE=456 custom_async_fifo_tb
vsim work.custom_async_fifo_tb
vsim -voptargs=+acc work.custom_async_fifo_tb

add wave -r *
add wave sim:/custom_async_fifo_tb/*

run -all
