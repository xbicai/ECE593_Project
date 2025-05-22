/* ECE 593 Team 5
 *
 * Environment for class based test bench
 */

class environment#(parameter SIZE = 8, DEPTH = 42);
	// classes 
	generator 	#(.SIZE(SIZE), .DEPTH(DEPTH)) gen;
	driver 		#(.SIZE(SIZE), .DEPTH(DEPTH)) drive;
	monitor_wr	#(.SIZE(SIZE), .DEPTH(DEPTH)) mon_wr;
	monitor_rd	#(.SIZE(SIZE), .DEPTH(DEPTH)) mon_rd;
	scoreboard 	#(.SIZE(SIZE), .DEPTH(DEPTH)) scb;

	// mailboxes
	mailbox	gen2drive_wr;
	mailbox gen2drive_rd;
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
		gen2drive_wr = new();
		gen2drive_rd = new();
		mon2scb_wr = new();
		mon2scb_rd = new();
		
		// creating classes
		gen 	= new(gen2drive_wr, gen2drive_rd, gen_ended);
		drive 	= new(vif, gen2drive_wr, gen2drive_rd);
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
		wait((gen.tx_count <= drive.tx_count_wr) && (gen.tx_count <= drive.tx_count_rd));
		wait(drive.tx_count_wr <= mon_wr.tx_count_wr);
	endtask

	// the task for running all parts of the tests together
	task run();
		pre_test();
		test();
		post_test();
		$display("gen.tx_count: %d, drive.tx_count_wr: %d, drive.tx_count_rd: %d, mon.tx_count_wr:%d", gen.tx_count, drive.tx_count_wr, drive.tx_count_rd, mon_wr.tx_count_wr);
		$display("tests are finished\n");
		$stop;
	endtask

endclass : environment