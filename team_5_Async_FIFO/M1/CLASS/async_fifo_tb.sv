module tb

	// Parameters
	parameter W_CYCLE = 100; 	// X time steps
	parameter R_CYCLE = 100;	// Initial testing will have R and W have the same clocks but shifted slightly
	parameter CLK_SHIFT = 25;
	parameter SIZE 	= 32;
	parameter DEPTH = 16;


	// DUT Inputs
	logic wclk, rclk, ainit;	// Clocks and reset
	logic wr_en, rd_en;			// Enable
	logic [SIZE-1:0] din;		// Data in

	// DUT Outputs
	logic full_f, empty_f;					// Required Flags
	logic almost_full_f, almost_empty_f;	// Optional Flags
	logic wr_ack, rd_ack, wr_err, rd_err;	// Optional Handshake
	logic [SIZE-1:0] wr_count, rd_count;	// Count Vectors
	logic [SIZE-1:0] dout;					// Data Out

	// Variables


	// DUT instantiation
	placeholder #(SIZE, DEPTH) iDUT (
		.*
	);


	// Generate Clocks
	initial begin
		wclk <= 0;
		rclk <= 0;
		forever #(W_CYCLE/2) wclk = ~wclk;
		#(CLK_SHIFT)
		forever #(R_CYCLE/2) rclk = ~rclk;	// rclk shifted 1/4 clk from wclk
	end

	// Testbench Initialization
	initial begin
		ainit 	= 1;
		wr_en 	= 0;
		wr_en 	= 0;
		din 	= 0;
	end

	// Testbench Outputs
	always @(full_f, almost_full_f)
		$display($time, "\tFull Flags:\tFull = %d\tAlmost FUll = %d", full_f, almost_full_f);

	always @(empty_f, almost_empty_f)
		$display($time, "\tEMPTY Flags:\tEmpty = %d\tAlmost Empty = %d", empty_f, almost_empty_f);

	always @(rd_err, wr_err)
		$display($time, "\tERR Flags:\twr_err = %d\t rd_err = %d", wr_err, rd_err);
	
	always @()
		$display($time, "\tData Out:\tdout = %d", dout);


	// Test Stimulus
	initial begin
		#(W_CYCLE/2 - CLK_SHIFT)	// Stimulus should fall on the falling edge of WCLK
		$display("Testbench Output Format: value = actual, expected")

		// Test AINT Fall + First WCLK (FULL Flags)   --->   Replace with Sequence Property
		$display("\n!!! Checking Flag Status after AINIT on first WCLK !!!");
		#(W_CYCLE) ainit = 0;
		$display("Full = %d, 1\tAlmost_Full = %d, 1\t", full_f, almost_full_f);
		#(W_CYCLE)
		$display("Full = %d, 0\tAlmost_Full = %d, 0\t", full_f, almost_full_f);

		// Test Initial Writes and EMPTY Flags   --->   Replace with Sequence Property
		$display("\n!!! Checking Flag Status after initial writes !!!");
		#(W_CYCLE*5);		// First Write
		$display("Empty = %d, 1\tAlmost_Empty = %d, 1\t", empty_f, almost_empty_f);
		din = $random();
		wr_en = 1;
		#(W_CYCLE);
		wr_en = 0;
		#(W_CYCLE);
		$display("Empty = %d, 0\tAlmost_Empty = %d, 1\t", empty_f, almost_empty_f);
		#(W_CYCLE*2);		// Second Write
		din = $random();
		wr_en = 1;
		#(W_CYCLE);
		wr_en = 0;
		#(W_CYCLE);
		$display("Empty = %d, 0\tAlmost_Empty = %d, 0\t", empty_f, almost_empty_f);

		// Write until full (Should be max_depth+2 writes) Flags should change, err signals should send with the final writes. 
		repeat(DEPTH)	begin
			#(W_CYCLE*2);		// 2 cycles between writes
			din = $random();
			wr_en = 1;
			#(W_CYCLE);
			wr_en = 0;
			#(W_CYCLE);
		end


		// Read until full (Should be max_depth+2 reads) Flags should change, err signals should send with the final reads. 
		#(CLK_SHIFT)	//Stimulus should fall on the falling edge of rclk
		repeat(DEPTH+2)	begin
			#(R_CYCLE*2);		// 2 cycles between reads
			rd_en = 1
			#(R_CYCLE);
			rd_en = 0;
			#(R_CYCLE);
		end

	end


endmodule : tb


module placeholder #(parameter width, depth) (
	// DUT Inputs
	input logic wclk, rclk, ainit,	// Clocks and reset
	input logic wr_en, rd_en,			// Enable
	input logic [SIZE-1:0] din,		// Data in

	// DUT Outputs
	output logic full_f, empty_f,					// Required Flags
	output logic almost_full_f, almost_empty_f,	// Optional Flags
	output logic wr_ack, rd_ack, wr_err, rd_err,	// Optional Handshake
	output logic [SIZE-1:0] wr_count, rd_count,	// Count Vectors
	output logic [SIZE-1:0] dout					// Data Out
);




endmodule : placeholder