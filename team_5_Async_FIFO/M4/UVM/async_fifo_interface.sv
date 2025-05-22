interface async_fifo_intf #(parameter dw = 32) (
	input logic clk_wr, clk_rd, ainit
);
	// DUT Inputs
	logic req_wr, req_rd;
	logic [dw-1:0] data_wr;

	// DUT Outputs
	logic full_flag, empty_flag;
	logic [dw-1:0] data_rd;


endinterface : async_fifo_intf