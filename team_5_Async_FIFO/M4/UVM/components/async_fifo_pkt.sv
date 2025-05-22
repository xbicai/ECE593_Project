class async_fifo_pkt extends uvm_sequence_item #(
	parameter dw = 32	// TODO - Does this Work?
);
	`uvm_object_utils(async_fifo_pkt)

	//------------------------------------------------------------
	// Instantiation
	//  - Create inputs & outputs
	//  - Apply rand(c) to inputs
	//------------------------------------------------------------
	
	// Randomized Inputs
	rand logic 			ainit;
	rand logic 			wr_en, rd_en;	//  TODO: Somewhat arbitrary names
	rand logic [dw-1:0]	din;

	// Outputs
	logic [dw-1:0]	dout;
	logic 			full_f, empty_f; 		// Max Flags
	logic 			a_full_f, a_empty_f;	// Almost Flags


	//------------------------------------------------------------
	// Default Constraints
	//  - Constrain input randomization
	//------------------------------------------------------------
	constraint input_c 		{din inside {[1:2**dw]};}	// TODO: Currently arbitrary constraints (Does 2**dw work?)
	constraint enable1_c 	{wr_en dist {1:=4, 0:=1};}	// TODO: Currently arbitrary constraints
	constraint enable2_c 	{rd_en dist {1:=3, 0:=1};}	// TODO: Currently arbitrary constraints
	constraint reset_c		{ainit dist {1:=2, 0:=1};}	// TODO: Currently arbitrary constraints

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function new (string name = "async_fifo_pkt");
		super.new(name);

	endfunction : new

endclass : async_fifo_pkt