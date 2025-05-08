class env #(parameter WIDTH = 32);

	generator 	#(.WIDTH(WIDTH)) 	gen;
	driver 		#(.WIDTH(WIDTH))	driver;
	monitor_in 	#(.WIDTH(WIDTH)) 	mon_in;
	monitor_out #(.WIDTH(WIDTH)) 	mon_out;
	scoreboard 	#(.WIDTH(WIDTH)) 	scb;

	mailbox gen2driver;
	mailbox mon_in2scb;
	mailbox mon_out2scb;

	virtual tb_intf #(.WIDTH(WIDTH)) v_intf;
	int tx_count = 0;

	function new(int tx_count);
		this.tx_count = tx_count;
		gen2driver 	= new();
		mon_in2scb 	= new();
		mon_out2scb = new();

		gen		= new(gen2driver, tx_count);
		driver	= new(gen2driver);
		mon_in	= new(mon_in2scb);
		mon_out	= new(mon_out2scb);
		scb		= new(mon_in2scb, mon_out2scb);
	endfunction

	task pre_test();
		// Setting the interfaces here because trying to 
		// include it into new() of the individual classes 
		// leads to a comiler error
		driver.v_intf 	= v_intf;
		mon_in.v_intf 	= v_intf;
		mon_out.v_intf 	= v_intf;
		driver.reset();
	endtask

	task test();
		fork
			gen.main();
			driver.main();
			mon_in.main();
			mon_out.main();
			scb.main();
		join_any
	endtask

	task post_test();
		// This does not work
		wait(gen.tx_count == driver.tx_count);
		$display("\n", $time, "\tGen Tx = %3d\tDrive Tx = %3d\n", gen.tx_count, driver.tx_count);
		wait(driver.valid_count == mon_out.tx_count);
		$display("\n", $time, "\tDrive Valid = %3d\tMon Tx = %3d\n", driver.valid_count, mon_out.tx_count);
		wait(mon_out.tx_count == scb.tx_count);
		$display("\n", $time, "\tMon Tx = %3d\tSCB Tx = %3d\n", mon_out.tx_count, scb.tx_count);

		#20 scb.print();
	endtask

	task main();
		pre_test();
		test();
		post_test();
	endtask
endclass