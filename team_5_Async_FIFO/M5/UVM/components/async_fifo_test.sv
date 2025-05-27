//--------------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//--------------------------------------------------------
class test extends uvm_test;
	`uvm_component_utils(test)

	
	async_fifo_env env;
	async_fifo_seq seq;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "test", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
		env = async_fifo_env::type_id::create("env", this);
	endfunction

	//----------------------------------------------------
	// UVM EOB Phase
	//----------------------------------------------------
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	
	//----------------------------------------------------
	// UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("TEST_CLASS", "Inside Run Phase!", UVM_HIGH)

		phase.raise_objection(this);
		seq = async_fifo_seq::type_id::create("seq");
		seq.start(env.agnt.sqr);
		#500;
		phase.drop_objection(this);
	endtask
endclass
