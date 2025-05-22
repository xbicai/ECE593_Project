/* ECE 593 Team 5
 *
 * Generates test values which are sent to driver
 */
class generator#(parameter SIZE = 8, DEPTH = 4);
    rand transaction_wr #(.SIZE(SIZE)) tx_wr;
    rand transaction_rd #(.SIZE(SIZE)) tx_rd;
    mailbox gen2drive_wr;
    mailbox gen2drive_rd;

    // amount of reads and writes, set in test.sv
    int tx_count;

    // event to let environment know that gen is done
    event ended;

    function new(mailbox gen2drive_wr, mailbox gen2drive_rd, event gen_ended);
        this.gen2drive_wr = gen2drive_wr;
        this.gen2drive_rd = gen2drive_rd;
        this.ended = ended;
    endfunction

    task main ();
        $display($time, "\tGenerator started");
        // test 1: simple repeated random input along with random requests
        repeat(tx_count) begin
            tx_wr = new();              // generating random input and random requests
            tx_rd = new();
            assert (tx_wr.randomize());    // check if successful
            assert (tx_rd.randomize());
            gen2drive_wr.put(tx_wr);    // sending new write and read requests to driver
            gen2drive_rd.put(tx_rd);
        end
        $display($time, "\tGenerator completed");
        -> ended;
    endtask

    

endclass : generator