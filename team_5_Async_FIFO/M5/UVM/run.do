if [file exists "work"] {vdel -all}

vlib work

## Compile async fifo dut
vlog -f async_fifo_dut.list

## Compile UVM?

## Compile Testbench
vlog async_fifo_interface.sv

vlog async_fifo_package.sv

vlog async_fifo_tb.sv

## Simulate Testbench
vsim -c -coverage custom_async_fifo_tb -voptargs="+acc +cover=bcesfx" -logfile ../docs/M3_tb_transcript +UVM_VERBOSITY=UVM_MEDIUM

onfinish stop

# Exclude from coverage
coverage exclude -src ./tb_UVM_top.sv
coverage exclude -src ./UVM/interface.sv
coverage exclude -src ./UVM/interface.sv
coverage exclude -src ./UVM/agent_config.sv
coverage exclude -src ./UVM/sequence_item.sv
coverage exclude -src ./UVM/sequence.sv
coverage exclude -src ./UVM/sequencer.sv
coverage exclude -src ./UVM/driver.sv
coverage exclude -src ./UVM/monitor.sv
coverage exclude -src ./UVM/agent.sv
coverage exclude -src ./UVM/scoreboard.sv
coverage exclude -src ./UVM/coverage_mon.sv
coverage exclude -src ./UVM/environment.sv
coverage exclude -src ./UVM/base_test.sv
coverage exclude -src ./UVM/test_one.sv

run -all

## Coverage
#coverage report -details -code bcesft -output ../docs/M3_coverage.rpt

exit