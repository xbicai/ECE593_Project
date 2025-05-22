vlib work

# Compile async_fifo
vlog -f ./async_fifo.list

# Compile Environment
#vlog -f env.list


# Compile Testbench
#vlog async_fifo_tb.sv

#vsim -c -gADDRSIZE=456 custom_async_fifo_tb
#vsim work.custom_async_fifo_tb -c
#vsim -voptargs=+acc work.custom_async_fifo_tb

vsim -c -coverage custom_async_fifo_tb -voptargs="+acc +cover=bcesfx" -logfile ../docs/M3_tb_transcript
#vsim -c custom_async_fifo_tb -voptargs="+acc"

#add wave -r *
#add wave sim:/custom_async_fifo_tb/*

run -all

coverage report -details -code bcesft -output ../docs/M3_coverage.rpt

exit