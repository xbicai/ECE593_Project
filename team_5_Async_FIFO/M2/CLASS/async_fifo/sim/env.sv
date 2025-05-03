// `include "generator.sv"
// `include "driver.sv"
// `include "monitor.sv"
// `include "scoreboard.sv"
// `include "async_fifo_interface.sv"

class async_fifo_env;

	async_fifo_generator 	gen;
	async_fifo_driver 		drive;
	async_fifo_monitor		mon;
	async_fifo_scoreboard 	scb;

	mailbox	gen2drive_wr;
	mailbox	gen2drive_rd;
	mailbox mon2scb_wr;
	mailbox mon2scb_rd;

	virtual intf intf;
	int tx_count_wr;
	int tx_count_rd;

	function new();
		gen2drive_wr = new();
		gen2drive_rd = new();
		mon2scb_wr = new();
		mon2scb_rd = new();
		
		gen = new(gen2drive_wr, gen2drive_rd, tx_count_wr, tx_count_rd);
		drive = new(gen2drive_wr, gen2drive_rd, tx_count_rd, tx_count_wr);
		mon = new(mon2scb_rd, mon2scb_wr);
		scb = new(mon2scb_wr, mon2scb_rd);
	endfunction

	task pre_test();
		drive.vif_exec = intf;
		mon.vif_obs = intf;
		drive.reset();
	endtask

	task test();
		fork 
			gen.main();
			drive.run();
			mon.run();
			scb.main();
		join_any
	endtask

	task post_test();
		// wait(gen.ended.triggered);
		wait(gen.tx_count_wr == drive.tx_count_wr);
		wait(gen.tx_count_rd == drive.tx_count_rd);
	endtask

	task run();
		pre_test();
		test();
		post_test();
		do begin end while (0);
		// $finish;
	endtask

endclass : async_fifo_env