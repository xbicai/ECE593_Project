
// `include "uvm_macros.svh"

// import uvm_pkg::*;

// all includes and imports 
import new_proj_pkg::*;

module custom_async_fifo_tb;
    parameter W_CYCLE = 15;
    parameter R_CYCLE = 10;
    parameter CLK_SHIFT = 5;
    parameter SIZE     = 8;
    parameter DEPTH    = 4;

    logic wclk, rclk, ainit;
    // interface instantiation
    async_fifo_intf #(SIZE) _intf (
        .clk_wr(wclk),
        .clk_rd(rclk),
        .ainit(ainit)
    );
    // DUT instantiation
    custom_async_fifo #(.DATASIZE(SIZE), .ADDRSIZE(DEPTH)) iDUT (
        .din               (_intf.data_wr),
        .dout              (_intf.data_rd),
        .fifo_full         (_intf.fifo_full),
        .fifo_empty        (_intf.fifo_empty),
        .fifo_almost_full  (_intf.fifo_almost_full),
        .fifo_almost_empty (_intf.fifo_almost_empty),
        .wen               (_intf.req_wr),
        .wclk_i            (wclk),
        .wrst_n_i          (ainit),
        .ren               (_intf.req_rd),
        .rclk_i            (rclk),
        .rrst_n_i          (ainit)
    );
    // starting test
    initial begin
        run_test("test");
    end
    // clock generation
    initial begin
        wclk = 0;
        forever #(W_CYCLE / 2) wclk = ~wclk;
    end
    initial begin
        rclk = 0;
        #(CLK_SHIFT);
        forever #(R_CYCLE / 2) rclk = ~rclk;
    end

endmodule
