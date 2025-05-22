// `include "transaction.sv"

class async_fifo_sqr extends uvm_sequencer #(
	async_fifo_pkt
);
    `uvm_component_utils(async_fifo_sqr)

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function new(string name = "async_fifo_sqr", uvm_component parent);
		super.new(name, parent);
		`uvm_info("SEQR_CLASS", "Inside Constructor!", UVM_HIGH)
	endfunction : new


	//------------------------------------------------------------
	// Build Phase
	//------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SEQR_CLASS", "Build Phase!", UVM_HIGH)
	endfunction : build_phase

	//------------------------------------------------------------
	// Connect Phase
	//------------------------------------------------------------
	function void connect_phase(uvm_phse phase);
		super.connect_phase(phase);
		`uvm_info("SEQR_CLASS", "Connect Phase!", UVM_HIGH)

	endfunction : connect_phase
endclass : async_fifo_generator