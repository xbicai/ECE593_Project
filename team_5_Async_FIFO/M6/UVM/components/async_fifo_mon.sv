//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_mon extends uvm_monitor;
	`uvm_component_utils(async_fifo_mon)

	async_fifo_pkt w_pkt;
	async_fifo_pkt r_pkt;
	virtual async_fifo_intf #(.SIZE(`FIFO_WIDTH)) vif;
	uvm_analysis_port #(async_fifo_pkt) monitor_port;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_mon", uvm_component parent);
		super.new(name, parent);
	endfunction

	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("MON_CLASS", "Inside Build Phase!", UVM_HIGH)

		monitor_port = new("monitor_port", this);

		if (!uvm_config_db#(virtual async_fifo_intf #(.SIZE(`FIFO_WIDTH)))::get(this, "*", "v_intf", vif))
			`uvm_fatal("MON", "Failed to get VIF from config DB");	
	endfunction

	//----------------------------------------------------
	// UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("MON_CLASS", "Inside Run Phase!", UVM_HIGH)
	
		fork
			forever begin
				w_pkt = async_fifo_pkt::type_id::create("w_pkt");
				w_pkt.w_pkt_f = 1;
				
				w_pkt.ainit 				= vif.ainit;
				@(negedge vif.clk_wr);
				w_pkt.wr_en 			= vif.req_wr;
				w_pkt.din 				= vif.data_wr;
				w_pkt.fifo_full 		= vif.fifo_full;
				w_pkt.fifo_almost_full  = vif.fifo_almost_full;
				// w_pkt.rd_en 			= 0;
				// w_pkt.dout 				= 0;
				r_pkt.rd_en 			= vif.req_rd;
				r_pkt.dout 				= vif.data_rd;
				w_pkt.fifo_empty 		= vif.fifo_empty;
				w_pkt.fifo_almost_empty = vif.fifo_almost_empty;
				
				// `uvm_info("MON_CLASS", $sformatf("ainit=%d, rd=%d, wr=%d, data_wr=%d, data_rd=%d", pkt.ainit, pkt.rd_en, pkt.wr_en, pkt.din, pkt.dout), UVM_HIGH)
				monitor_port.write(w_pkt);
			end
			forever begin
				r_pkt = async_fifo_pkt::type_id::create("r_pkt");
				r_pkt.r_pkt_f = 1;
				
				@(negedge vif.clk_rd);
				r_pkt.ainit 			= vif.ainit;
				// w_pkt.wr_en 			= 0;
				// w_pkt.din 				= 0;
				w_pkt.wr_en 			= vif.req_wr;
				w_pkt.din 				= vif.data_wr;
				w_pkt.fifo_full 		= vif.fifo_full;
				w_pkt.fifo_almost_full  = vif.fifo_almost_full;
				r_pkt.rd_en 			= vif.req_rd;
				r_pkt.dout 				= vif.data_rd;
				r_pkt.fifo_empty 		= vif.fifo_empty;
				r_pkt.fifo_almost_empty = vif.fifo_almost_empty;
				
				// `uvm_info("MON_CLASS", $sformatf("ainit=%d, rd=%d, wr=%d, data_wr=%d, data_rd=%d", pkt.ainit, pkt.rd_en, pkt.wr_en, pkt.din, pkt.dout), UVM_HIGH)
				monitor_port.write(r_pkt);
			end
		join_none
	endtask
endclass
