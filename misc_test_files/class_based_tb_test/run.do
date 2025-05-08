vlib work

# Compile DUT (Parameterized Adder)
vlog ./rtl/dut.sv

# Compile Environment / Testbench
vlog ./tb_interface.sv
vlog ./tb_package.sv
vlog ./class_tb.sv

vsim -c tb -voptargs="+acc" -logfile ./docs/class_tb_nocov_transcript
#vsim -c -coverage tb - voptargs="+acc +cover=bcesfx" -logfile ./docs/class_tb_cov_transcript

run -all

#coverage report -details -code bcesft -output ./docs/class_tb_coverage.rpt

exit