

interface intf #(parameter SIZE = `SIZE, DEPTH = `DEPTH) (
	input clk_wr, clk_rd, ainit
);
	// DUT Inputs
	logic req_wr, req_rd;
	logic [SIZE-1:0] data_wr;

	// DUT Outputs
	logic full_flag, empty_flag;
	logic [SIZE-1:0] data_rd;

endinterface : intf