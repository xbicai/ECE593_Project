//----------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//----------------------------------------------------


//----------------------------------------------------
// BASIC TESTS
//----------------------------------------------------
// Standard write -> read
class seq1_1_1 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_1)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_1");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		int count = 1;
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.1 - standard write/read"), UVM_LOW)
		// starting with reset
		repeat(2) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 0; wr_en == 0; rd_en == 0; pkt.din == 1;});
			finish_item(pkt);
		end
		// Writing 1
		repeat(`FIFO_DEPTH/2) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 0;
			pkt.din = count;
			finish_item(pkt);
			count++;
		end

		// Read 1's out
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 0;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end
	endtask
endclass : seq1_1_1

// Write many random bursts of data in, then confirm FIFO correctly reads these bursts out.
class seq1_1_2 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_2)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_2");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.2 - bursts of random writes into bursts of random reads"), UVM_LOW)

		repeat(3) begin
			// Writing 
			repeat(5) begin
				start_item(pkt);
				void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
				finish_item(pkt);
			end

			// Reading
			repeat(5) begin
				start_item(pkt);
				void'(pkt.randomize() with {ainit == 1; wr_en == 0; rd_en == 1;});
				finish_item(pkt);
			end
		end
	endtask
endclass : seq1_1_2

// Filling the FIFO
class seq1_1_3 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_3)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_3");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.3 - Filling FIFO"), UVM_LOW)

		// writing to max depth
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
			finish_item(pkt);
		end
	endtask
endclass : seq1_1_3

// Write when full
class seq1_1_4 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_4)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_4");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.4 - Write when full"), UVM_LOW)

		repeat(2) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
			finish_item(pkt);
		end
	endtask
endclass : seq1_1_4

// Draining the FIFO
class seq1_1_5 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_5)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_5");
		super.new(name);
	endfunction

	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.5 - Draining FIFO"), UVM_LOW)

		// writing to max depth
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 0; rd_en == 1;});
			finish_item(pkt);
		end
	endtask
endclass : seq1_1_5

// read when empty
class seq1_1_6 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_6)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_6");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.6 - Read when empty"), UVM_LOW)

		repeat(2) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 0; rd_en == 1;});
			finish_item(pkt);
		end
	endtask
endclass : seq1_1_6

// reset tests
class seq1_1_7 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_1_7)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_1_7");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.1.7 - Reset when empty/half/full"), UVM_LOW)

		// reset when empty AND write/read when reset on
		start_item(pkt);
		void'(pkt.randomize() with {ainit == 0; wr_en == 1; rd_en == 1;});
		finish_item(pkt);

		// fill halfway
		repeat(`FIFO_DEPTH/2) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
			finish_item(pkt);
		end
		// reset when half full AND write when reset on
		start_item(pkt);
		void'(pkt.randomize() with {ainit == 0; wr_en == 1; rd_en == 0;});
		finish_item(pkt);

		// fill
		repeat(`FIFO_DEPTH/2) begin
			start_item(pkt);
			void'(pkt.randomize() with {ainit == 1; wr_en == 1; rd_en == 0;});
			finish_item(pkt);
		end
		// reset when full AND read when reset on
		start_item(pkt);
		void'(pkt.randomize() with {ainit == 0; wr_en == 0; rd_en == 1;});
		finish_item(pkt);
	endtask
endclass : seq1_1_7

//----------------------------------------------------
// COMPLEX TESTS
//----------------------------------------------------
/* Concurrent test 1
** Condition: fifo_full + rclk=wclk
*/
class seq1_2_1 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_2_1)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_2_1");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.2.1 - Concurrent test 1"), UVM_LOW)

		// fill with 1's
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 0;
			pkt.din = 1;
			finish_item(pkt);
		end

		// Read and write at same time (!!! clocks must match !!!)
		// SHOULD: block write, read 1
		repeat(1) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end
	endtask
endclass : seq1_2_1

/* Concurrent test 2
** Condition: fifo_empty + rclk=wclk
*/
class seq1_2_2 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_2_2)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_2_2");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.2.2 - Concurrent test 2"), UVM_LOW)

		// drain
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 0;
			pkt.rd_en = 1;
			pkt.din = 1;
			finish_item(pkt);
		end

		// Read and write at same time (!!! clocks must match !!!)
		// SHOULD: block read, write 
		repeat(1) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end
	endtask
endclass : seq1_2_2

/* Concurrent test 3
** Condition: fifo_empty and fifo_full + rclk=wclk
*/
class seq1_2_3 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_2_3)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_2_3");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.2.3 - Concurrent test 3"), UVM_LOW)

		// reset to raise flags
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 0;
			pkt.wr_en = 0;
			pkt.rd_en = 0;
			pkt.din = 1;
			finish_item(pkt);
		end

		// Read and write at same time (!!! clocks must match !!!)
		// SHOULD: block read and write
		repeat(1) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 1;
			pkt.din = 1;
			finish_item(pkt);
		end
	endtask
endclass : seq1_2_3

/* Concurrent test 4
** Condition: no flags asserted + rclk=wclk
*/
class seq1_2_4 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_2_4)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_2_4");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.2.4 - Concurrent test 4"), UVM_LOW)

		// Writing a single data 
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 0;
			pkt.din = 0;
			finish_item(pkt);
		end

		// Read and write at same time (!!! clocks must match !!!)
		// SHOULD: read a 0 and write a 1
		repeat(1) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 1;
			pkt.din = 1;
			finish_item(pkt);
		end
	endtask
endclass : seq1_2_4

//----------------------------------------------------
// CORNER TESTS
//----------------------------------------------------
/* WR WR WR
** Condition: fifo_empty
*/
class seq1_4_1 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_4_1)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_4_1");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.4.1 - WR WR WR WR"), UVM_LOW)

		// drain
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 0;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end

		// W->R multiple times, fifo_empty should toggle every wr and rd
		repeat(20) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 0;
			pkt.din = 1;
			finish_item(pkt);

			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 0;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end
	endtask
endclass : seq1_4_1

/* WWR WWR WWR
*/
class seq1_4_2 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_4_2)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_4_2");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.4.2 - WWR WWR WWR"), UVM_LOW)

		// W->R multiple times, fifo_empty should toggle every wr and rd
		repeat(`FIFO_DEPTH + 1) begin
			// write twice
			repeat(2) begin
				start_item(pkt);
				pkt.ainit = 1;
				pkt.wr_en = 1;
				pkt.rd_en = 0;
				pkt.din = 1;
				finish_item(pkt);
			end
			// read once
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 0;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end
	endtask
endclass : seq1_4_2

/* RRW RRW RRW
*/
class seq1_4_3 extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seq1_4_3)
	// Instantiate packet handle
	async_fifo_pkt pkt;

	// Standard UVM Constructor
	function new(string name = "seq1_4_3");
		super.new(name);
	endfunction

	// body (the test)
	virtual task body();
		pkt = async_fifo_pkt::type_id::create("pkt");
		`uvm_info("SEQ_BODY", $sformatf("Starting test 1.4.3 - RRW RRW RRW"), UVM_LOW)

		// drain
		repeat(`FIFO_DEPTH) begin
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 0;
			pkt.rd_en = 1;
			pkt.din = 0;
			finish_item(pkt);
		end

		// RRW multiple times, 
		// first two reads will be blocked, then it will start allowing the first read and blocking the second, empty flag is asserted correctly
		repeat(`FIFO_DEPTH + 1) begin
			// read twice
			repeat(2) begin
				start_item(pkt);
				pkt.ainit = 1;
				pkt.wr_en = 0;
				pkt.rd_en = 1;
				pkt.din = 1;
				finish_item(pkt);
			end
			// write once
			start_item(pkt);
			pkt.ainit = 1;
			pkt.wr_en = 1;
			pkt.rd_en = 0;
			pkt.din = 1;
			finish_item(pkt);
		end
	endtask
endclass : seq1_4_3

//----------------------------------------------------
// REGRESSION TESTS
//----------------------------------------------------
// Just call all tests again on major changes


//----------------------------------------------------
// MISC TESTS
//----------------------------------------------------
// random burst of data test
class seqRANDOM extends uvm_sequence #(async_fifo_pkt);
	// UVM factory registration
	`uvm_object_utils(seqRANDOM)

	// Instantiate packet handle
	async_fifo_pkt pkt;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "seqRANDOM");
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
endclass : seqRANDOM
