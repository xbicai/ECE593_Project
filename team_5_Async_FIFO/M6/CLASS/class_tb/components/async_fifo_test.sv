/* ECE 593 Team 5
 *
 * stimuli
 */
module test #(
    parameter DATA = 8, ADDR = 4
) (
    intf vif
);
    environment #(.DATA(DATA), .ADDR(ADDR)) env;

	initial begin
        env = new(vif);

        // setting amount of reads and writes
		env.gen.tx_count = 200;
		
        // starting environment
		env.run();
	end
endmodule : test