vlib work

## Compile async fifo dut
vlog -f async_fifo_dut.list

## Compile UVM?

## Compile Testbench
vlog async_fifo_interface.sv
vlog async_fifo_package.sv
vlog async_fifo_tb.sv

## Simulate Testbench
vsim -c -coverage custom_async_fifo_tb -voptargs="+acc +cover=bcesfx" -logfile ../docs/M3_tb_transcript

run -all

## Coverage
#coverage report -details -code bcesft -output ../docs/M3_coverage.rpt

exit