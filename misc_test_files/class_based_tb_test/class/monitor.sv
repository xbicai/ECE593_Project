class monitor_in #(parameter WIDTH = 32);

	virtual tb_intf #(.WIDTH(WIDTH)) v_intf;
	mailbox mon_in2scb;

	int tx_count = 0;

	function new(mailbox mon_in2scb);
		this.v_intf = v_intf;			// <--- Leads to a NULL instance in compile time
		this.mon_in2scb = mon_in2scb;
	endfunction

	task main;
		$display($time,"\tMonitor In Started");
		forever begin
			transaction #(.WIDTH(WIDTH)) tx = new();
			@(posedge v_intf.clk);
			if (v_intf.valid_in) begin
				tx.a = v_intf.a;
				tx.b = v_intf.b;
				// Check if mailbox is full?
				mon_in2scb.put(tx);
				// `ifdef DEBUG
					$display($time,"\tMonitor In \t%3d, %3d, %3d, %3d", tx_count++, tx.a, tx.b, v_intf.valid_in);
				// `endif
			end
		end	
		$display($time, "\tMonitor In Finished");
	endtask


endclass : monitor_in


class monitor_out #(parameter WIDTH = 32);

	int tx_count = 0;
	virtual tb_intf #(.WIDTH(WIDTH)) v_intf;
	mailbox mon_out2scb;

	function new(mailbox mon_out2scb);
		// this.v_intf = v_intf; 			// <--- Leads to a NULL instance in compile time
		this.mon_out2scb = mon_out2scb;
	endfunction

	task main;
		$display($time, "\tMonitor Out Started");
		forever begin
			transaction #(.WIDTH(WIDTH)) tx = new();
			@(posedge v_intf.clk);
			wait(v_intf.valid_out)			// Wait until valid_out is 1
			tx.result = v_intf.result;
			// Check if Mailbox is full?
			mon_out2scb.put(tx);
			// `ifdef DEBUG
				$display($time,"\tMonitor Out \t%3d, %3d, %3d", tx_count, v_intf.result, v_intf.valid_out);
			// `endif
			tx_count++;

		end
		$display($time, "\tMonitor Out Finished");
	endtask

endclass : monitor_out
