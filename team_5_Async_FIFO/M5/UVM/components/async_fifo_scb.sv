//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------
class async_fifo_scoreboard extends uvm_component;
	`uvm_component_utils(async_fifo_scoreboard)

	uvm_analysis_imp #(async_fifo_pkt, async_fifo_scoreboard) scoreboard_port;
	//   queue [7:0] ref_model;
	async_fifo_pkt tx[$];
	bit [`FIFO_WIDTH-1:0] ref_model[$];

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
		`uvm_info("SCB_CLASS", "Packet Received!", UVM_HIGH)
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

		// if (pkt.wr_en && !pkt.fifo_full)
		// 	ref_model.push_back(pkt.din);
		// if (pkt.rd_en && !pkt.fifo_empty) begin
		// 	if (ref_model.size() == 0) begin
		// 		`uvm_error("SCOREBOARD", "Read attempted from empty reference queue!");
		// 	end else begin
		// 		logic [7:0] exp = ref_model.pop_front();
		// 		if (pkt.dout !== exp) begin
		// 		`uvm_error("SCOREBOARD", $sformatf("Mismatch: expected %0h, got %0h", exp, pkt.dout));
		// 		end
		// 	end
		// end
	endtask

	task compare(async_fifo_pkt	curr_tx);
		`uvm_info("SCB_CLASS", $sformatf("Packet Processed!, %d, %d", `FIFO_WIDTH, `FIFO_DEPTH), UVM_HIGH)

	endtask
endclass
