

interface intf #(parameter DATA = `DATA, ADDR = `ADDR) (
	input clk_wr, clk_rd, ainit
);
	// DUT Inputs
	logic req_wr, req_rd;
	logic [DATA-1:0] data_wr;

	// DUT Outputs
	logic full_flag, empty_flag;
	logic almost_full_flag, almost_empty_flag;
	logic [DATA-1:0] data_rd;

endinterface : intf