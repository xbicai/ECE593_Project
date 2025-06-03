//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_drv extends uvm_driver #(async_fifo_pkt);
	`uvm_component_utils(async_fifo_drv)

	virtual async_fifo_intf #(.SIZE(`FIFO_WIDTH)) vif;
	async_fifo_pkt pkt;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_drv", uvm_component parent);
		super.new(name, parent);
	endfunction

	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("DRV_CLASS", "Inside Constructor!", UVM_HIGH)
		
		if (!uvm_config_db#(virtual async_fifo_intf #(.SIZE(`FIFO_WIDTH)))::get(this, "*", "v_intf", vif))
			`uvm_fatal("DRV", "Failed to get VIF from config DB");
	endfunction

	//----------------------------------------------------
	// UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("DRV_CLASS", "Inside Run Phase!", UVM_HIGH)

		forever begin
			pkt = async_fifo_pkt::type_id::create("pkt");
			seq_item_port.get_next_item(pkt);

			// Driver inputs
			fork
				begin : Reset
					vif.ainit 	<= pkt.ainit;
					//`uvm_info("DRIVE_RUN", $sformatf("DRIVING: rst=%d", pkt.ainit), UVM_LOW)
				end
				begin : Write
					@(negedge vif.clk_wr);
					vif.req_wr 	<= pkt.wr_en;
					vif.data_wr <= pkt.din;
					@(negedge vif.clk_wr);
					vif.req_wr 	<= 0;
				end
				begin : Read
					@(negedge vif.clk_rd);
					vif.req_rd 	<= pkt.rd_en;
					@(negedge vif.clk_rd);
					vif.req_rd 	<= 0;
				end
			join
	
			// `uvm_info("DRV_CLASS", $sformatf("ainit=%d, rd=%d, wr=%d, data=%d", vif.ainit, vif.req_rd, vif.req_wr, vif.data_wr), UVM_HIGH)
			seq_item_port.item_done();
		end
	endtask
endclass
