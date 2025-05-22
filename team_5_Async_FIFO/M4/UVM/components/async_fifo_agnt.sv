class async_fifo_agnt extends uvm_agent;

	//------------------------------------------------------------
	// Factory registration
	//------------------------------------------------------------
	`uvm_components_utils(async_fifo_agnt)

	//------------------------------------------------------------
	// Sub-component Instantiation
	//------------------------------------------------------------
	async_fifo_drv drv;
	async_fifo_mon mon;
	async_fifo_sqr sqr;

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function new (string name = "async_fifo_agnt", uvm_component parent);
		super.new(name, parent);
		`uvm_info("AGENT_CLASS", "Inside COnstructor!", UVM_HIGH)
	endfunction : new	

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH)

		drv = async_fifo_drv::type_id::create("drv", this);
		mon = async_fifo_mon::type_id::create("mon", this);
		sqr = async_fifo_sqr::type_id::create("sqr", this);
	endfunction : build_phase

	//------------------------------------------------------------
	// Connect Phase
	//------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH)

		drv.seq_item_port.connect(sqr.seq_item_export);

	endfunction : connect_phase

	//------------------------------------------------------------
	// Run Phase
	//------------------------------------------------------------
	task run_phase (uvm_phase);
		super.run_phase(phase);
	endtask : run_phase


endclass : async_fifo_agnt