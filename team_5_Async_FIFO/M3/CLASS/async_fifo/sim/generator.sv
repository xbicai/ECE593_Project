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
        
        
        // test repeat: simple repeated random input along with random requests
        repeat(tx_count) begin
            tx_wr = new();              // generating random input and random requests
            tx_rd = new();
            tx_wr.constraint_mode(0);
            tx_rd.constraint_mode(0);
            assert (tx_wr.randomize());    // check if successful
            assert (tx_rd.randomize());
            gen2drive_wr.put(tx_wr);    // sending new write and read requests to driver
            gen2drive_rd.put(tx_rd);
        end
        $display($time, "\tGenerator completed");
        -> ended;
    endtask

/*     // simple write -> read
    task test1();
        $display($time, "\tTest 1: Standard write followed by read");
        create_transaction(tx_wr, tx_rd);
        tx_wr.data_wr = 1'b1;
        tx_wr.req_wr = 1'b1;
        send_transaction(tx_wr, tx_rd);
    endtask
    // filling FIFO to max depth
    task test2();
        $display($time, "\tTest 2: Fill");
        create_transaction(tx_wr, tx_rd);
        tx_wr.constraint_select("max");
        tx_rd.constraint_select("zero");

    endtask
    task test3();

    endtask
    task test4();

    endtask
    task test5();

    endtask
    task create_transaction(output transaction_wr tx_wr, output transaction_rd tx_rd);
        tx_wr = new();
        tx_rd = new();
    endtask
    task send_transaction(transaction_wr tx_wr, transaction_rd tx_rd);
        gen2drive_wr.put(tx_wr);
        gen2drive_rd.put(tx_rd);
    endtask */

endclass : generator