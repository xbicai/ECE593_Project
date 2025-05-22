/* ECE 593 Team 5
 *
 * stimuli
 */
module test #(
    parameter SIZE = 8, DEPTH = 4
) (
    intf vif
);
    environment #(.SIZE(SIZE), .DEPTH(DEPTH)) env;

	initial begin
        env = new(vif);

        // setting amount of reads and writes
		env.gen.tx_count = 100;
		
        // starting environment
		env.run();
	end
endmodule : test