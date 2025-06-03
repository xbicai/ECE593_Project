if [file exists "work"] {vdel -all}

vlib work


vlog async_fifo_package.sv

## Compile async fifo dut
vlog -f async_fifo_dut.list

## Compile UVM?

## Compile Testbench
vlog async_fifo_interface.sv

#vlog async_fifo_package.sv

vlog async_fifo_tb.sv

## Simulate Testbench
vsim -c -coverage custom_async_fifo_tb -voptargs="+acc +cover=bcesfx" -logfile ../docs/M5_transcript +UVM_VERBOSITY=UVM_LOW

# This is needed to correctly output coverage when UVM tb completes
onfinish stop

# Exclude from coverage
coverage exclude -src ./async_fifo_tb.sv -code bcdefst
coverage exclude -src ./async_fifo_interface.sv
coverage exclude -src ./components/async_fifo_test.sv
coverage exclude -src ./components/async_fifo_env.sv
coverage exclude -src ./components/async_fifo_agnt.sv
coverage exclude -src ./components/async_fifo_drv.sv
coverage exclude -src ./components/async_fifo_mon.sv
coverage exclude -src ./components/async_fifo_sqr.sv
coverage exclude -src ./components/async_fifo_seq.sv
coverage exclude -src ./components/async_fifo_pkt.sv
coverage exclude -src ./components/async_fifo_scb.sv
coverage exclude -src ./components/async_fifo_cov.sv

# Run UVM testbench
run -all

## Coverage
coverage report -cvg -code bcesft -output ../docs/M5_code_coverage.rpt
coverage report -details -cvg -assert -output ../docs/M5_func_coverage.rpt

exit