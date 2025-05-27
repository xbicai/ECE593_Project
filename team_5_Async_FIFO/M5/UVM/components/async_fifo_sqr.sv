//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_sqr extends uvm_sequencer #(async_fifo_pkt);
	`uvm_component_utils(async_fifo_sqr)

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_sqr", uvm_component parent);
		super.new(name, parent);
		`uvm_info("SQR_CLASS", "Inside Constructor!", UVM_HIGH)
	endfunction

	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SQR_CLASS", "Inside Build Phase!", UVM_HIGH)
	endfunction

	//----------------------------------------------------
	// UVM Conenct Phase
	//----------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SQR_CLASS", "Inside Connect Phase!", UVM_HIGH)
	endfunction
endclass
