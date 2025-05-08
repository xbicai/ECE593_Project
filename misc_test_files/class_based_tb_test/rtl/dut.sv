module adder #(parameter WIDTH = 32) (
	input logic clk, rst, valid_in,
	input logic [WIDTH-1:0] a, b,
	output logic valid_out,
	output logic [WIDTH:0] result
);

	always_ff @(posedge clk) begin
		if (!rst) begin
			valid_out <= 0;
			result <= 0;
		end
		else begin
			valid_out <= valid_in;
			result <= a + b;		
		end
	end

endmodule : adder