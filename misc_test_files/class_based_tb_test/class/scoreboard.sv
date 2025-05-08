class scoreboard #(parameter WIDTH = 32);

	mailbox mon_in2scb;
	mailbox mon_out2scb;

	bit [WIDTH-1:0] a_fifo[$];
	bit [WIDTH-1:0] b_fifo[$];

	int bad_count 	= 0;
	int good_count 	= 0;
	int tx_count 	= 0;
	int in_count 	= 0;

	function new(mailbox mon_in2scb, mon_out2scb);
		this.mon_in2scb  = mon_in2scb;
		this.mon_out2scb = mon_out2scb;
	endfunction

	task main;
		$display($time,"\tScoreboard Started\n");
		fork
			get_input();
			get_output();
		join_none
	endtask

	task get_input();
		transaction #(.WIDTH(WIDTH)) tx;
		// $display($time,"\Scoreboard In Started");
		forever begin
			// Check for mailbox empty??

			
			mon_in2scb.get(tx);			// We are getting a fatal error --- Caused by Monitor tx not being set to the WIDTH Parameter
			a_fifo.push_back(tx.a);
			b_fifo.push_back(tx.b);

			// `ifdef DEBUG
			// 	$display($time, "Scoreboard In %d", in_count);
			// `endif
		end
	endtask

	task get_output();
		transaction #(.WIDTH(WIDTH)) tx;
		bit [WIDTH-1:0] a, b;
		// $display($time,"\tScoreboard Out Started");	
		forever begin
			mon_out2scb.get(tx);
			a = a_fifo.pop_front();
			b = b_fifo.pop_front();
			if ((a+b) != tx.result) begin
				$display("Addition Error");
				bad_count++;
				// Keep track of bad IO combinations
			end
			else begin
				good_count++;
			end
			
			// `ifdef DEBUG
				$display($time, "\tScoreboard out \t%3d, %3d, %3d, %3d\n", tx_count, a, b, tx.result);
			// `endif

			tx_count++;
		end
	endtask

	function void print();
		$display($time, "\tScoreboard (T, G, B): %d, %d, %d", tx_count, good_count, bad_count);
	endfunction

endclass : scoreboard