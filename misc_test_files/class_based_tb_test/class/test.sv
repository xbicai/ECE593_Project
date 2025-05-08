class tb_test #(parameter WIDTH = 32);
	env #(.WIDTH(WIDTH)) env;

	function new(int test_count);
		env = new(test_count);
	endfunction

	task main();
		env.main();
	endtask
endclass