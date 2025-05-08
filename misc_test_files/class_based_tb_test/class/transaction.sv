class transaction #(parameter WIDTH = 32);
	rand bit [WIDTH-1:0] a, b;
	rand bit valid_in;

	bit [WIDTH:0] result;
	bit valid_out;

	constraint c1 {valid_in dist {1 := 3, 0 := 1};}
	
	function void print();
		$display($time, "\tA = %d\tB = %d\tResult = %d", a, b, result);
	endfunction
endclass