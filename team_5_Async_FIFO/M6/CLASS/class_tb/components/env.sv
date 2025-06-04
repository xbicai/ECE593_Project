/* ECE 593 Team 5
 *
 * Environment for class based test bench
 */

class environment#(parameter DATA = 8, ADDR = 42);
	// classes 
	generator 	#(.DATA(DATA), .ADDR(ADDR)) gen;
	driver 		#(.DATA(DATA), .ADDR(ADDR)) drive;
	monitor_wr	#(.DATA(DATA), .ADDR(ADDR)) mon_wr;
	monitor_rd	#(.DATA(DATA), .ADDR(ADDR)) mon_rd;
	scoreboard 	#(.DATA(DATA), .ADDR(ADDR)) scb;

	// mailboxes
	mailbox	gen2drive;
	mailbox mon2scb_wr;
	mailbox mon2scb_rd;

	// amount of reads and writes being tested, set in test.sv
	int tx_count;

	// event for synchronization, way for generator to tell environment it's done
	event gen_ended;

	virtual intf vif;
	function new(virtual intf vif);
		// connecting interface
		this.vif = vif;
		
		// creating mailboxes
		gen2drive = new();
		mon2scb_wr = new();
		mon2scb_rd = new();
		
		// creating classes
		gen 	= new(gen2drive, gen_ended);
		drive 	= new(vif, gen2drive);
		mon_wr 	= new(vif, mon2scb_wr);
		mon_rd 	= new(vif, mon2scb_rd);
		scb 	= new(mon2scb_wr, mon2scb_rd);
	endfunction

	// starting with a reset
	task pre_test();
		drive.reset();
	endtask

	// main test
	task test();
		fork 
			gen.main();
			drive.main();
			mon_wr.main();
			mon_rd.main();
			scb.main();
		join_any
	endtask

	// waiting for main test to finish
	task post_test();
		wait(gen.ended.triggered);
		wait((gen.tx_count <= drive.tx_count));
		wait(drive.tx_count_wr <= mon_wr.tx_count);
		wait(drive.tx_count_rd <= mon_rd.tx_count);
	endtask

	// the task for running all parts of the tests together
	task run();
		pre_test();
		test();
		post_test();
		$display("gen.tx_count: %d, drive.tx_count_wr: %d, drive.tx_count_rd: %d, mon.tx_count_wr:%d, mon.tx_count_rd",
		 			gen.tx_count, drive.tx_count_wr, drive.tx_count_rd, mon_wr.tx_count, mon_rd.tx_count);
		$display("tests are finished\n");
		$stop;
	endtask

endclass : environment