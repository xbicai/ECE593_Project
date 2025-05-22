// `include "transaction.sv"
// `include "async_fifo_interface.sv"

class async_fifo_mon extends uvm_monitor;
	`uvm_component_utils(async_fifo_mon)

	virtual async_fifo_intf v_intf;
	async_fifo_pkt pkt;

	uvm_analysis_port #(async_fifo_pkt) monitor_port;

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function new (string name = "async_fifo_mon", uvm_component parent);
		super.new(name, parent);
		`uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
	endfunction : new

	//------------------------------------------------------------
	// Build Phase
	//------------------------------------------------------------
	function void build_phsae(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)

		monitor_port = new("monitor_port", this);

		if (!(uvm_config_db #(virtual async_fifo_intf)::get(this, "*", "v_intf", v_intf))) begin
			`uvm_error("MONITOR_CLASS", "Failed to get v_intf from config DB!")
		end

	endfunction : build_phase

	//------------------------------------------------------------
	// Connect Phase
	//------------------------------------------------------------
	function void conenct_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)

	endfunction : connect_phase

	//------------------------------------------------------------
	// Run Phase
	//------------------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_HIGH)

		forever begin
			pkt = async_fifo_pkt::type_id::create("pkt");

			wait(!v_intf.ainit);

			// Sample Inputs
			@(posedge v_intf.wclk);
			// Data In
			pkt.din = v_intf.din;
			// Enables
			pkt.wr_en = v_intf.wr_en;
			pkt.rd_en = v_intf.rd_en;

			// Sample Outputs
			@(posedge v_intf.rclk);
			// Data Out
			pkt.dout = v_intf.dout;
			// Full Flags
			pkt.full_f = v_intf.full_f;
			pkt.a_full_f = v_intf.a_full_f;
			// Empty Flags
			pkt.empty_f = v_intf.empty_f;
			pkt.a_empty_f = v_intf.a_empty_f;


			// Send item to scoreboard
			monitor_port.write(pkt);
		end
		
	endtask : run_phase

endclass : async_fifo_mon