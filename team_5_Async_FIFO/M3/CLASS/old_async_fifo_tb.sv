module custom_async_fifo_tb;

	// Parameters
	parameter W_CYCLE = 100; 	// X time steps
	parameter R_CYCLE = 75;		// Initial testing will have R and W have the same clocks but shifted slightly
	parameter CLK_SHIFT = 25;
	parameter SIZE 	= 32;
	parameter DEPTH = 4;


	// DUT Inputs
	logic wclk, rclk, ainit;	// Clocks and reset
	logic wr_en, rd_en;			// Enable
	logic [SIZE-1:0] din;		// Data in

	// DUT Outputs
	logic full_f, empty_f;					// Required Flags
	logic almost_full_f, almost_empty_f;	// Optional Flags		- Unused
	logic wr_ack, rd_ack, wr_err, rd_err;	// Optional Handshake	- Unused
	logic [SIZE-1:0] wr_count, rd_count;	// Count Vectors		- Unused
	logic [SIZE-1:0] dout;					// Data Out

	// Variables


	// DUT instantiation
	custom_async_fifo #(SIZE, DEPTH) iDUT (		// Test that Parameters work (defaults are 8, 4)
		.din(din),
		.dout(dout),
		.fifo_full(full_f),
		.fifo_empty(empty_f),
		.wen(wr_en),
		.wclk_i(wclk),
		.wrst_n_i(ainit),
		.ren(rd_en),
		.rclk_i(rclk),
		.rrst_n_i(ainit),
		.fifo_almost_empty(almost_empty_f),
		.fifo_almost_full(almost_full_f)
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
		ainit 	= 0;
		wr_en 	= 0;
		rd_en 	= 0;
		din 	= 0;
	end

	// Testbench Outputs
	// always @(full_f, almost_full_f)
	// 	$display($time, "\tFull Flags:\tFull = %d\tAlmost FUll = %d", full_f, almost_full_f);

	// always @(empty_f, almost_empty_f)
	// 	$display($time, "\tEMPTY Flags:\tEmpty = %d\tAlmost Empty = %d", empty_f, almost_empty_f);

	// always @(rd_err, wr_err)
	// 	$display($time, "\tERR Flags:\twr_err = %d\t rd_err = %d", wr_err, rd_err);
	
	// always @(dout)
	// 	$display($time, "\tData Out:\tdout = %d", dout);


	// Test Stimulus
	initial begin
		$display("Testbench Output Format: value = actual, expected");

		// Test AINT Fall + First WCLK (FULL Flags)   --->   Replace with Sequence Property
		$display("\n!!! Checking Flag Status after AINIT on first WCLK !!!");
		repeat(5) @(negedge wclk);
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
		ainit = 1;
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
		@(negedge wclk);
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);

		// Test Initial Writes and EMPTY Flags   --->   Replace with Sequence Property
		$display("\n!!! Checking Flag Status after initial writes !!!");
		repeat(5) @(negedge wclk);		// First Write
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
		din = 1;
		wr_en = 1;
		@(negedge wclk);
		wr_en = 0;
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
		@(negedge wclk);
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
		repeat(2) @(negedge wclk);		// Second Write
		din = 2;
		wr_en = 1;
		@(negedge wclk);
		wr_en = 0;
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
		@(negedge wclk);
		$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);

		// Write until full (Should be max_depth+2 writes) Flags should change, err signals should send with the final writes. 
		$display("\n!!! Fill the Fifo !!!");
		repeat(16) begin
			repeat(2) @(negedge wclk);		// 2 cycles between writes
			din = $random();
			wr_en = 1;
			// $display($time, "\tFlags:\tFull = %d\tEmpty = %d\t din = %d\tdout = %d", full_f, empty_f, din, dout);
			@(negedge wclk);
			wr_en = 0;
			$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
			@(negedge wclk);
		end


		// Read until empty (Should be max_depth+2 reads) Flags should change, err signals should send with the final reads. 
		$display("\n!!! Empty the Fifo !!!");
		repeat(2) @(negedge wclk);	//Stimulus should fall on the falling edge of rclk
		din = 0;
		repeat(18)	begin
			repeat(2) @(negedge rclk);		// 2 cycles between reads
			rd_en = 1;
			// $display($time, "\tFlags:\tFull = %d\tEmpty = %d\t din = %d\tdout = %d", full_f, empty_f, din, dout);
			@(negedge rclk);
			rd_en = 0;
			$display($time, "\tFlags:\tF = %d\tE = %d\tAF = %d\tAE = %d\tdin = %d\tdout = %d", full_f, empty_f, almost_full_f, almost_empty_f, din, dout);
			@(negedge rclk);
		end

		repeat(2) @(negedge wclk);
		$stop;
	end


endmodule : custom_async_fifo_tb