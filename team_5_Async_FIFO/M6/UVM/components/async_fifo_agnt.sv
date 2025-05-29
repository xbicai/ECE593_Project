//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_agnt extends uvm_agent;
	`uvm_component_utils(async_fifo_agnt)

	async_fifo_drv drv;
	async_fifo_mon mon;
	async_fifo_sqr sqr;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_agnt", uvm_component parent);
		super.new(name, parent);
	endfunction

	//----------------------------------------------------
	// Agent - UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("AGNT_CLASS", "Inside Constructor!", UVM_HIGH)

		drv = async_fifo_drv::type_id::create("drv", this);
		mon = async_fifo_mon::type_id::create("mon", this);
		sqr = async_fifo_sqr::type_id::create("sqr", this);
	endfunction

	//----------------------------------------------------
	// Agent - UVM Conenct Phase
	//----------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("AGNT_CLASS", "Inside Connect Phase!", UVM_HIGH)

		// Connect sequencer to driver
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction

	//----------------------------------------------------
	// Agent - UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("AGNT_CLASS", "Inside Run Phase!", UVM_HIGH)

	endtask

endclass
