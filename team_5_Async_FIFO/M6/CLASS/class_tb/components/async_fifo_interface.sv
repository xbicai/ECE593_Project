

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

	covergroup cg_wr @(posedge clk_wr);
		wr_en_cp: 		coverpoint req_wr {
			bins val[] = {[0:1]};
			bins consecutive = (1[*5]);
		}
		full_f_cp: 		coverpoint full_flag;
		data_in_cp: coverpoint data_wr {
			bins zero = {0};
			bins val = {[1:$]};
			bins ones = {'1};
		}
	endgroup

	covergroup cg_rd @(posedge clk_rd);
		rd_en_cp: 		coverpoint req_rd {
			bins val[] = {[0:1]};
			bins consecutive = (1[*5]);
		}
		empty_f_cp: 	coverpoint empty_flag;
		data_out_cp: coverpoint data_rd {
			bins zero = {0};
			bins val = {[1:$]};
			bins ones = {'1};
		}
	endgroup


	cg_wr my_cg_wr = new();
	cg_rd my_cg_rd = new();

endinterface : intf