/******************************************
** File: async_fifo_drv.sv
** 
** Description:
** Driver Class extended from UVM Driver
**
** Revision History:
** - Initial - 
** Setting up the Core structure of the UVM Component
******************************************/

class async_fifo_drv extends uvm_driver #(
	async_fifo_pkt
);
	`uvm_component_utils(async_fifo_drv)

	//------------------------------------------------------------
	// Instantiation
	//------------------------------------------------------------
	virtual async_fifo_intf v_intf;
	async_fifo_pkt pkt;

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function new(string name = "async_fifo_drv", uvm_component parent);
		super.new(name, parent);
		`uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
	endfunction : new

	//------------------------------------------------------------
	// UVM Build Phase
	//------------------------------------------------------------
	function void build_phase(uvm_phase uvm_phase);
		super.build_phase(phase);
		`uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)

		if (!(uvm_config_db #(virtual async_fifo_intf)::get(this, "*", "v_intf", v_intf))) begin
			`uvm_error("DRIVER_CLASS", "Failed to get v_intf from config DB!")
		end
	endfunction : build_phase

endclass : async_fifo_drv