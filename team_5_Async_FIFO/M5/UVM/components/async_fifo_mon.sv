//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_mon extends uvm_monitor;
	`uvm_component_utils(async_fifo_mon)

	async_fifo_pkt pkt;
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
	
		forever begin
			pkt = async_fifo_pkt::type_id::create("pkt");
			if (vif.ainit) begin
				pkt.ainit = vif.ainit;
			end else begin
				// Sample Input
				@(posedge vif.clk_rd);
				pkt.rd_en 				= vif.req_rd;
				pkt.wr_en 				= vif.req_wr;
				pkt.rd_en 				= vif.req_rd;
				pkt.ainit				= vif.ainit;

				// Sample Outputs
				pkt.dout 				= vif.data_rd;
				pkt.fifo_empty 			= vif.fifo_empty;
				pkt.fifo_full 			= vif.fifo_full;
				pkt.fifo_almost_empty 	= vif.fifo_almost_empty;
				pkt.fifo_almost_full  	= vif.fifo_almost_full;
			end
			
			monitor_port.write(pkt);
		end
	endtask
endclass
