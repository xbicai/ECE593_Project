//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_scoreboard extends uvm_component;
	`uvm_component_utils(async_fifo_scoreboard)

	//----------------------------------------------------
	// Instantiations
	//----------------------------------------------------
	uvm_analysis_imp #(async_fifo_pkt, async_fifo_scoreboard) scoreboard_port;
	// Transaction Buffer
	async_fifo_pkt tx[$];
	// Reference Model
	bit [`FIFO_WIDTH-1:0] ref_model[$];
	// Local Flags
	bit full_local, empty_local, a_full_local, a_empty_local;
	// Temp Values for read comparison
	logic [`FIFO_WIDTH-1:0] expected;
	logic [`FIFO_WIDTH-1:0] actual;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name, uvm_component parent);
		super.new(name, parent);
		`uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
	endfunction

	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SCB_CLASS", "Inside Build Phase!", UVM_HIGH)

		scoreboard_port = new("scoreboard_port", this);
	endfunction

	//----------------------------------------------------
	// Scoreboard Write Function
	//----------------------------------------------------
	function void write(async_fifo_pkt pkt);
		tx.push_back(pkt);
		// `uvm_info("SCB_CLASS", "Packet Received!", UVM_HIGH)
	endfunction

	//----------------------------------------------------
	// UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("SCB_CLASS", "Inside Run Phase!", UVM_HIGH)

		forever begin
			async_fifo_pkt curr_tx;
			wait((tx.size() != 0));
			curr_tx = tx.pop_front();
			compare(curr_tx);
		end

	endtask

	task compare(async_fifo_pkt	curr_tx);
		// `uvm_info("SCB_CLASS", $sformatf("Packet Processed!, %d, %d", `FIFO_WIDTH, `FIFO_DEPTH), UVM_HIGH)

		if (curr_tx.ainit == 0) begin
			ref_model.delete();			// Reset Model
			full_local 		= 0;
			empty_local 	= 1;
			a_full_local 	= 0;
			a_empty_local 	= 1;
		end else begin
			// `uvm_info("SCB_CLASS", $sformatf("ainit=%d, wr=%d, rd=%d, full=%d, empty=%d", curr_tx.ainit, curr_tx.wr_en, curr_tx.rd_en, curr_tx.fifo_full, curr_tx.fifo_empty), UVM_HIGH)	
			
			// Update Flags
			if (ref_model.size() >= `FIFO_DEPTH)	// Full
				full_local = 1;
			else 
				full_local = 0;
			if (ref_model.size() >= `FIFO_DEPTH-1)	// Almost Full
				a_full_local = 1;
			else 
				a_full_local = 0;

			if (ref_model.size() <= 0)				// Empty
				empty_local = 1;
			else 
				empty_local = 0;

			if (ref_model.size() <= 1)				// Almost Empty
				a_empty_local = 1;
			else 
				a_empty_local = 0;	

			// Track Write
			if (curr_tx.wr_en && !curr_tx.fifo_full) begin
				`uvm_info("COMPARE", $sformatf("Entered WRITE"), UVM_LOW)
				// Write to model
				if (!full_local) begin
					ref_model.push_back(curr_tx.din);
					`uvm_info("COMPARE", $sformatf("\tJust wrote %d", curr_tx.din), UVM_LOW)
				end
				`uvm_info("SCB_CLASS", $sformatf("Write! Fifo=%d", ref_model.size()), UVM_HIGH)
				// `uvm_info("SCB_CLASS", $sformatf("ainit=%d, wr=%d, data=%d, full=%d", curr_tx.ainit, curr_tx.wr_en, curr_tx.din, curr_tx.fifo_full), UVM_HIGH)
			end else if (curr_tx.wr_en) begin
				`uvm_info("COMPARE", $sformatf("\tFIFO Full! Ignored %d", curr_tx.din), UVM_LOW)
			end

			// Track Read
			if (curr_tx.rd_en && !curr_tx.fifo_empty) begin
				`uvm_info("COMPARE", $sformatf("Entered READ"), UVM_LOW)
				// Read from Model
				// `uvm_info("SCB_CLASS", $sformatf("ainit=%d, rd=%d, data=%d, full=%d", curr_tx.ainit, curr_tx.rd_en, curr_tx.dout, curr_tx.fifo_empty), UVM_HIGH)
				expected = ref_model.pop_front();
				`uvm_info("SCB_CLASS", $sformatf("Read! Fifo=%d", ref_model.size()), UVM_HIGH)
				actual = curr_tx.dout;
				`uvm_info("COMPARE", $sformatf("\tJust read %d", curr_tx.dout), UVM_LOW)

				// Compare model to DUT
				if (actual != expected)
					`uvm_error("COMPARE", $sformatf("Transction Failed! DUT=%d, Ref=%d", actual, expected))
				else
					`uvm_info("COMPARE", $sformatf("Transction Passed! DUT=%d, Ref=%d", actual, expected), UVM_LOW)
			end	else if (curr_tx.rd_en) begin
				`uvm_info("COMPARE", $sformatf("\tFIFO Empty!"), UVM_LOW)
			end

			// Compare Flags
			if (curr_tx.fifo_full != full_local)
				`uvm_error("COMPARE", $sformatf("Full Flag Mismatch! DUT=%d, Ref=%d", curr_tx.fifo_full, full_local))
			if (curr_tx.fifo_empty != empty_local)
				`uvm_error("COMPARE", $sformatf("Empty Flag Mismatch! DUT=%d, Ref=%d", curr_tx.fifo_empty, empty_local))
			if (curr_tx.fifo_almost_full != a_full_local)
				`uvm_error("COMPARE", $sformatf("Almost Full Flag Mismatch! DUT=%d, Ref=%d", curr_tx.fifo_almost_full, a_full_local))
			if (curr_tx.fifo_almost_empty != a_empty_local)
				`uvm_error("COMPARE", $sformatf("Almost Empty Flag Mismatch! DUT=%d, Ref=%d", curr_tx.fifo_almost_empty, a_empty_local))
		end

	endtask
endclass
