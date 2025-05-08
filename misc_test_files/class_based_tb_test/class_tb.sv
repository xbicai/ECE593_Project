`define DEBUG 		true
`define DEEP_DEBUG 	false;

import class_tb_pkg::*;

module tb;

	// Paramters
	parameter WIDTH = 8;
	parameter CYCLE = 10;
	parameter TEST_COUNT = 10;

	// Interface
	logic clk, rst;
	tb_intf #(.WIDTH(WIDTH)) intf (
		.clk	(clk),
		.rst	(rst)
	);

	tb_test #(.WIDTH(WIDTH)) test;

	adder #(.WIDTH(WIDTH)) iDUT (
		.clk		(clk),
		.rst		(rst),
		.valid_in	(intf.valid_in),
		.a			(intf.a),
		.b			(intf.b),
		.valid_out	(intf.valid_out),
		.result		(intf.result)
	);

	// always @(intf.result) begin
	// 	$display($time, "DUT Result: %d", intf.result);
	// end


	// Generate Clocks
	initial begin
		clk <= 0;
		forever #(CYCLE/10) clk = ~clk;
	end

	// Test Stimulus
	initial begin
		test = new(TEST_COUNT);
		test.env.v_intf = intf;
		rst = 0;
		
		#20;
		fork
			test.main();
			#20 rst = 1; 
		join_any


		#100 $finish;

	end

endmodule : tb