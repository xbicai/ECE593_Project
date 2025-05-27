//--------------------------------------------------------
// async_fifo_tb.sv
// 	Top level testbench for async_fifo DUT
//	Uses UVM tb architecture
//
//--------------------------------------------------------

//--------------------------------------------------------
// Imports
//--------------------------------------------------------
// `include "uvm_macros.svh"
import uvm_pkg::*;
import new_proj_pkg::*;
`include "async_fifo_macros.svh"

//--------------------------------------------------------
// Testbench Top Module
//--------------------------------------------------------
module custom_async_fifo_tb;
    
	//----------------------------------------------------
	// Parameters
	//----------------------------------------------------
	parameter W_CYCLE = 15;
    parameter R_CYCLE = 10;
    parameter CLK_SHIFT = 5;
    // parameter SIZE     = 8;
    // parameter DEPTH    = 4;

    logic wclk, rclk;

    //----------------------------------------------------
	// Interface Instantiation
	//----------------------------------------------------
	async_fifo_intf #(.SIZE(`FIFO_WIDTH)) _intf (
        .clk_wr(wclk),
        .clk_rd(rclk)
    );

    //----------------------------------------------------
	// DUT Instantiation
	//----------------------------------------------------
	custom_async_fifo #(.DATASIZE(`FIFO_WIDTH), .ADDRSIZE(`FIFO_DEPTH)) iDUT (
        .din               (_intf.data_wr),
        .dout              (_intf.data_rd),
        .fifo_full         (_intf.fifo_full),
        .fifo_empty        (_intf.fifo_empty),
        .fifo_almost_full  (_intf.fifo_almost_full),
        .fifo_almost_empty (_intf.fifo_almost_empty),
        .wen               (_intf.req_wr),
        .wclk_i            (wclk),
        .wrst_n_i          (_intf.ainit),
        .ren               (_intf.req_rd),
        .rclk_i            (rclk),
        .rrst_n_i          (ainit)
    );

	//----------------------------------------------------
	// Interface Setting
	//----------------------------------------------------
	initial begin
		uvm_config_db #(virtual async_fifo_intf #(.SIZE(`FIFO_WIDTH)))::set(null, "*", "v_intf", _intf);
	end

    //----------------------------------------------------
	// Start the Test
	//----------------------------------------------------
	initial begin
        run_test("test");
    end

    //----------------------------------------------------
	// Clock Generation
	//----------------------------------------------------
	// Write Clock
	initial begin
        wclk = 0;
        forever #(W_CYCLE / 2) wclk = ~wclk;
    end

	// Read Clock
    initial begin
        rclk = 0;
        #(CLK_SHIFT);
        forever #(R_CYCLE / 2) rclk = ~rclk;
    end

	//----------------------------------------------------
	// Maximum Simulation Time
	//----------------------------------------------------
	initial begin
		#5000;
		$display("Sorry! Ran out of clock cycles!");
		$finish();
	end

endmodule
