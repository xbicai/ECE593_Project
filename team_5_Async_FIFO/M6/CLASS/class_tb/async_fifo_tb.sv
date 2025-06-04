/* ECE 593 Team 5
 *
 * Milestone 3 class based test bench without UVM
 */

`include "class_macros.svh"

`include "./components/async_fifo_interface.sv"
import new_proj_pkg::*;
`include "./components/async_fifo_test.sv"

module custom_async_fifo_tb;
	// DUT Inputs
	logic wclk, rclk, ainit;	// Clocks and reset

	// clocks and reset
	initial begin
		ainit = 0;
		#5 ainit = 1;
		#5 ainit = 0;
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

/* 	initial begin
		forever begin
			@(negedge rclk) 
			$display("TIME=%0t\tTOP\tDATA=%d, WR_ADDR=%d, RD_ADDR=%d", $time, 
					iDUT.custom_async_fifo.u_fifomem.mem_array[iDUT.custom_async_fifo.u_fifomem.rd_addr], iDUT.custom_async_fifo.u_fifomem.wr_addr, iDUT.custom_async_fifo.u_fifomem.rd_addr);
		end
	end */

	// interface instantiation
	intf _intf(
		.clk_wr	(wclk),
		.clk_rd	(rclk),
		.ainit	(ainit)
	);

	// DUT instantiation
	custom_async_fifo #(.DATASIZE(`DATA), .ADDRSIZE(`ADDR)) iDUT (		// Test that Parameters work (defaults are 8, 4)
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
	test #(.DATA(`DATA), .ADDR(`ADDR)) test(_intf);

endmodule : custom_async_fifo_tb