/* ECE 593 Team 5
 *
 * Generates test values which are sent to driver
 */
class generator#(parameter DATA = 8, ADDR = 4);
    rand transaction #(.DATA(DATA)) tx;
    mailbox gen2drive;

    // amount of reads and writes, set in test.sv
    int tx_count;
    int split;
    // event to let environment know that gen is done
    event ended;

    function new(mailbox gen2drive, event gen_ended);
        this.gen2drive = gen2drive;
        this.ended = ended;
    endfunction

    task main ();
        $display($time, "\tGenerator started");
        split = 0;
        // test repeat: simple repeated random input along with random requests
        repeat(tx_count) begin
            tx = new();                     // generating random input and random requests
            // writes 3 to 1
            if (split < tx_count/4) begin
                tx.write_bias.constraint_mode(1);
                tx.read_bias.constraint_mode(0);
                assert(tx.randomize());
            end
            // reads 3 to 1
            else if ((tx_count/4 < split) && (split < tx_count/2)) begin
                tx.write_bias.constraint_mode(0);
                tx.read_bias.constraint_mode(1);
                assert(tx.randomize());
            end
            // completely random for last half
            else begin
                tx.constraint_mode(0);
                assert(tx.randomize());
            end
            gen2drive.put(tx);              // sending new write and read requests to driver
            split++;
        end
        // pre determined test
/*         repeat(tx_count/2) begin
            tx = new();                     // generating random input and random requests
            void'(tx.randomize() with {req_wr == 1; req_rd == 0;});
            gen2drive.put(tx);              // sending new write and read requests to driver
        end
        repeat(tx_count/2) begin
            tx = new();                     
            void'(tx.randomize() with {req_wr == 0; req_rd == 1;});
            gen2drive.put(tx);             
        end */
        $display($time, "\tGenerator completed");
        -> ended;
    endtask

endclass : generator