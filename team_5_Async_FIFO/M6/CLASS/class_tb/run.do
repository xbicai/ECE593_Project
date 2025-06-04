if [file exists "work"] {vdel -all}

vlib work

# Compile async_fifo
vlog -f ./async_fifo.list

# Compile Environment
#vlog -f env.list


# Compile Testbench
#vlog async_fifo_tb.sv

#vsim -c -gADDRDATA=456 custom_async_fifo_tb
#vsim work.custom_async_fifo_tb -c
#vsim -voptargs=+acc work.custom_async_fifo_tb

vsim -c -coverage custom_async_fifo_tb -voptargs="+acc +cover=bcesft" -logfile ../../docs/CLASS_docs/CLASS_tb_transcript.txt
#vsim -c custom_async_fifo_tb -voptargs="+acc"

#add wave -r *
#add wave sim:/custom_async_fifo_tb/*

# Exclude from coverage
coverage exclude -src ./async_fifo_tb.sv -code bcdefst
coverage exclude -src ./components/async_fifo_interface.sv
coverage exclude -src ./components/async_fifo_test.sv
coverage exclude -src ./components/env.sv
coverage exclude -src ./components/generator.sv
coverage exclude -src ./components/driver.sv
coverage exclude -src ./components/monitor_rd.sv
coverage exclude -src ./components/monitor_wr.sv
coverage exclude -src ./components/package.sv
coverage exclude -src ./components/scoreboard.sv
coverage exclude -src ./components/transaction.sv

run -all

coverage report -cvg -code bcesft -output ../../docs/CLASS_docs/CLASS_coverage.rpt
coverage report -details -cvg -assert -output ../../docs/CLASS_docs/CLASS_functional.rpt

exit