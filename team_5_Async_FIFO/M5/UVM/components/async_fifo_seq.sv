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
			void'(pkt.randomize() with {ainit == 0; wr_en == 1;});
			`uvm_info("SEQ_BODY", $sformatf("Sending: wren=%d, rden=%d, din=%d, rst=%d", pkt.wr_en, pkt.rd_en, pkt.din, pkt.ainit), UVM_LOW)
			finish_item(pkt);
		end

		// Consecutive Writes
		repeat(5) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
			`uvm_info("SEQ_BODY", $sformatf("Sending: wren=%d, rden=%d, din=%d", pkt.wr_en, pkt.rd_en, pkt.din), UVM_LOW)
			finish_item(pkt);
		end

		// Consecutive Reads
		repeat(5) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 0; rd_en == 1;});
			`uvm_info("SEQ_BODY", $sformatf("Sending: wren=%d, rden=%d, din=%d", pkt.wr_en, pkt.rd_en, pkt.din), UVM_LOW)
			finish_item(pkt);
		end

	endtask
endclass
