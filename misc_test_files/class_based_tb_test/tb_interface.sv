interface tb_intf #(parameter WIDTH = 32) (
	input clk, rst
);

	// DUT Inputs
	logic valid_in;
	logic [WIDTH-1:0] a, b;
	
	// DUT Outputs
	logic valid_out;
	logic [WIDTH:0] result;


endinterface
