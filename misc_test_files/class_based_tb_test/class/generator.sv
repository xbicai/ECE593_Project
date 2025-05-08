class generator #(parameter WIDTH = 32);
	rand transaction #(.WIDTH(WIDTH)) tx;

	mailbox gen2driver;

	int tx_count;
	int i = 0;

	function new(mailbox gen2driver, int tx_count);
		this.gen2driver = gen2driver;
		this.tx_count = tx_count;
	endfunction	

	task main();
		$display($time, "\tGenerator Started, Tests = %3d", tx_count);
		fork
			repeat(tx_count) begin
				tx = new();
				assert(tx.randomize());
				// Wait until mailbox is not full?
				gen2driver.put(tx);
				// $display($time, "\tGenerator %d", i++);
			end
		join_any;
		$display($time, "\tGenerator Completed");
	endtask

endclass