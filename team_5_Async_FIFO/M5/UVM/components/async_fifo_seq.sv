//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_seq extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(async_fifo_seq)

	// Instantiate packet handle
	async_fifo_pkt pkt;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "async_fifo_seq");
		super.new(name);
	endfunction

	//----------------------------------------------------
	// Sequence
	//----------------------------------------------------
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		
		repeat(2) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 0;});
			finish_item(pkt);
			#10;
		end

		// Consecutive Writes
		repeat(5) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
			finish_item(pkt);
			#10;
		end

		// Consecutive Reads
		repeat(5) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 0; rd_en == 1;});
			finish_item(pkt);
			#10;
		end

	endtask
endclass
