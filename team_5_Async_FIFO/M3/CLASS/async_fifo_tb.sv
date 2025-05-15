import new_proj_pkg::*;


module custom_async_fifo_tb;
	// Parameters
	parameter W_CYCLE = 15; 	// X time steps
	parameter R_CYCLE = 10;		// Initial testing will have R and W have the same clocks but shifted slightly
	parameter CLK_SHIFT = 5;
	parameter SIZE 	= 32;
	parameter DEPTH = 4;

	// DUT Inputs
	logic wclk, rclk, ainit;	// Clocks and reset

	// Class Based Testbench
	intf _intf(
		.clk_wr	(wclk),
		.clk_rd	(rclk),
		.ainit	(ainit)
	);

	test test;

	// DUT instantiation
	custom_async_fifo #(SIZE, DEPTH) iDUT (		// Test that Parameters work (defaults are 8, 4)
		.din		(_intf.data_wr),
		.dout		(_intf.data_rd),
		.fifo_full	(_intf.full_flag),
		.fifo_empty	(_intf.empty_flag),
		.wen		(_intf.req_wr),
		.wclk_i		(wclk),
		.wrst_n_i	(ainit),
		.ren		(_intf.req_rd),
		.rclk_i		(rclk),
		.rrst_n_i	(ainit)
	);


	// Generate Clocks
	initial begin
		wclk <= 0;
		// rclk <= 0;
		forever #(W_CYCLE/2) wclk = ~wclk;
		// #(CLK_SHIFT)
		// forever #(R_CYCLE/2) rclk = ~rclk;	// rclk shifted 1/4 clk from wclk
	end

	initial begin
		rclk <= 0;
		#(CLK_SHIFT)
		forever #(R_CYCLE/2) rclk = ~rclk;	// rclk shifted 1/4 clk from wclk
	end

	// Testbench Initialization
	initial begin
		test = new;
		test.env.intf = _intf;
		test.env.tx_count_wr = 10;
		test.env.tx_count_rd = 10;
		ainit 		= 0;
		
		#20 		
		fork
			test.run();
			#20 ainit = 1;
		join_any;


		#2000 $finish;
	end


endmodule : custom_async_fifo_tb