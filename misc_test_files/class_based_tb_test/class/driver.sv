class driver #(parameter WIDTH = 32);

	int tx_count = 0;
	int valid_count = 0;;

	virtual tb_intf #(.WIDTH(WIDTH)) v_intf;

	mailbox gen2driver;

	function new(mailbox gen2driver);
		// this.v_intf = v_intf;		// <--- Leads to a NULL instance in compile time
		this.gen2driver = gen2driver;
	endfunction

	task reset;
		wait(!v_intf.rst);		// Wait for reset to go low
		$display($time, "\tReset Started");
		v_intf.a 		<= 0;
		v_intf.b 		<= 0;
		v_intf.valid_in <= 0;
		wait(v_intf.rst);		// Wait for reset to go high
		$display($time, "\tReset Ended");
	endtask

	task main;
		$display($time, "\tDriver Started");
		forever begin
			transaction #(.WIDTH(WIDTH)) tx;
			// Checl if Mailbox is empty??
			gen2driver.get(tx);
			@(posedge v_intf.clk);

			tx_count++;
			v_intf.a <= tx.a;
			v_intf.b <= tx.b;
			v_intf.valid_in <= tx.valid_in;
			// `ifdef DEBUG
			// $display($time, "\tDrive \t\t%3d, %3d, %3d, %3d", valid_count, v_intf.a, v_intf.b, v_intf.valid_in);
			// `endif
			if (v_intf.valid_in) 
				valid_count++;
		end
		$display($time, "\tDriver Completed");
	endtask


endclass