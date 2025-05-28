//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_pkt extends uvm_sequence_item;
	// `uvm_object_utils(async_fifo_pkt);

	//----------------------------------------------------
	// Instantiation
	//----------------------------------------------------
	// Inputs
	rand logic        	wr_en;
	rand logic        	rd_en;
	rand logic 		  	ainit;
	rand logic [`FIFO_WIDTH-1:0]	din;

	// Outputs
	logic [`FIFO_WIDTH-1:0] 	dout;
	logic 			fifo_full;
	logic 			fifo_empty;
	logic 			fifo_almost_full;
	logic 			fifo_almost_empty;

	`uvm_object_utils_begin(async_fifo_pkt)
		`uvm_field_int(wr_en, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(rd_en, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(ainit, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(din, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(dout, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(fifo_full, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(fifo_empty, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(fifo_almost_full, UVM_DEFAULT + UVM_DEC)
		`uvm_field_int(fifo_almost_empty, UVM_DEFAULT + UVM_DEC)
	`uvm_object_utils_end

	//----------------------------------------------------
	// Default Constraints
	//----------------------------------------------------
	constraint wr_enable { wr_en dist {0 := 3, 1 := 7}; }
	constraint rd_enable { rd_en dist {0 := 3, 1 := 7}; }


	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_pkt");
		super.new(name);
	endfunction
endclass
