/* ECE 593 Team 5
 *
 * Milestone 3 class based test bench without UVM
 */

`define W_CYCLE   15  // X time steps
`define R_CYCLE   10  // Initial testing will have R and W have the same clocks but shifted slightly
`define CLK_SHIFT 5
`define SIZE 	  8
`define DEPTH 	  4

`include "./async_fifo/sim/async_fifo_interface.sv"
import new_proj_pkg::*;
`include "./async_fifo/sim/async_fifo_test.sv"

module custom_async_fifo_tb;
	// DUT Inputs
	logic wclk, rclk, ainit;	// Clocks and reset

	// clocks and reset
	initial begin
		ainit = 0;
		#5 ainit = 1;
    end

	initial begin
		wclk <= 0;
		// rclk <= 0;
		forever #(`W_CYCLE/2) wclk = ~wclk;
		// #(CLK_SHIFT)
		// forever #(R_CYCLE/2) rclk = ~rclk;	// rclk shifted 1/4 clk from wclk
	end

	initial begin
		rclk <= 0;
		#(`CLK_SHIFT)
		forever #(`R_CYCLE/2) rclk = ~rclk;	// rclk shifted 1/4 clk from wclk
	end

	// interface instantiation
	intf _intf(
		.clk_wr	(wclk),
		.clk_rd	(rclk),
		.ainit	(ainit)
	);

	// DUT instantiation
	custom_async_fifo #(.SIZE(`SIZE), .DEPTH(`DEPTH)) iDUT (		// Test that Parameters work (defaults are 8, 4)
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

	// test call
	test #(.SIZE(`SIZE), .DEPTH(`DEPTH)) test(_intf);

endmodule : custom_async_fifo_tb