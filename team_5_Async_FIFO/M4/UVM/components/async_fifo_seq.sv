class async_fifo_seq extends uvm_sequence #(
	parameter dw = 32
);
	//------------------------------------------------------------
	// UVM Factory Registration
	//------------------------------------------------------------
	`uvm_object_utils(async_fifo_seq)

	//------------------------------------------------------------
	// Instantiate Packet Handle
	//------------------------------------------------------------
	async_fifo_pkt pkt;

	//------------------------------------------------------------
	// Standard UVM Constructor
	//------------------------------------------------------------
	function new (string name = "async_fifo_seq");
		super.new(name);
		`uvm_info("PKT_SEQ", "Inside Constructor!", UVM_HIGH)
	endfunction

	
	//------------------------------------------------------------
	// Sequence Tasks
	//------------------------------------------------------------
	task body ();
		// Create the UVM Factory object
		pkt = async_fifo_pkt::type_id::create("async_fifo_pkt");

		repeat (2) begin
			start_item(pkt);
			void'(pkt.randomize() with {reset == 1;});
			finish_item(pkt);
		end

		repeat (5) begin
			start_item(pkt);
			void'(pkt.randomize() with {reset == 0;});
			finish_item(pkt);
		end
	endtask
endclass : async_fifo_seq