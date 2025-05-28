//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_env extends uvm_env;
	`uvm_component_utils(async_fifo_env)

	async_fifo_agnt agnt;
	async_fifo_scoreboard scb;
	async_fifo_cov cov;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_env", uvm_component parent);
		super.new(name, parent);
	endfunction

	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("ENV_CLASS", "Inside Constructor!", UVM_HIGH)

		agnt = async_fifo_agnt::type_id::create("agnt", this);
		scb = async_fifo_scoreboard::type_id::create("scb", this);
		cov = async_fifo_cov::type_id::create("cov", this);
	endfunction

	//----------------------------------------------------
	// UVM Connect Phase
	//----------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("ENV_CLASS", "Inside Connect Phase!", UVM_HIGH)

		agnt.mon.monitor_port.connect(scb.scoreboard_port);
		agnt.mon.monitor_port.connect(cov.analysis_export);
	endfunction

	//----------------------------------------------------
	// UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("ENV_CLASS", "Inside Run Phase!", UVM_HIGH)

	endtask
endclass
