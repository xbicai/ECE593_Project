class async_fifo_cov extends uvm_subscriber #(async_fifo_pkt);
	`uvm_component_utils(async_fifo_cov)

	async_fifo_pkt pkt;

	real cov;

	covergroup cg;
		wr_en_cp: 		coverpoint pkt.wr_en;
		rd_en_cp: 		coverpoint pkt.rd_en;
		full_f_cp: 		coverpoint pkt.fifo_full;
		empty_f_cp: 	coverpoint pkt.fifo_empty;
		a_full_f_cp: 	coverpoint pkt.fifo_almost_full;
		a_empty_f_cp: 	coverpoint pkt.fifo_almost_empty;
		ainit_cp: 		coverpoint pkt.rd_en {
			bins t_0to1 = (0=>1);
			bins t_1to0 = (1=>0);
		}
		// data_in_cp: coverpoint pkt.data_wr {}
		// data_out_cp: coverpoint pkt.data_wr {}
	endgroup

	function new(input string name = "async_fifo_cov", uvm_component parent = null);
		super.new(name, parent);

		pkt = async_fifo_pkt::type_id::create("pkt");

		cg = new();
	endfunction

	virtual function void write (input async_fifo_pkt t);
		`uvm_info(get_type_name(), "Reading data from monitor for coverage", UVM_NONE)
		t.print();

		pkt = t;

		cg.sample();
		cov = cg.get_coverage();

		`uvm_info(get_full_name(), $sformatf("Coverage is %d", cov), UVM_NONE);
	endfunction

endclass