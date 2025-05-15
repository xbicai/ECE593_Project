// `include "transaction.sv"

class async_fifo_generator;
    rand tx_wr tx_wr;
    rand tx_rd tx_rd;
    
    mailbox gen2drive_wr;
    mailbox gen2drive_rd;

    int tx_count_rd;
    int tx_count_wr;

    function new(mailbox gen2drive_wr, mailbox gen2drive_rd, int tx_count_wr, int tx_count_rd);
        this.gen2drive_rd = gen2drive_rd;
        this.gen2drive_wr = gen2drive_wr;
        this.tx_count_wr = tx_count_wr;
        this.tx_count_rd = tx_count_rd;
    endfunction

    task main ();
        $display($time, "\tGenerator started");
        fork
            repeat(tx_count_wr) begin
                tx_wr = new();
                assert (tx_wr.randomize());
                gen2drive_wr.put(tx_wr);
            end
            repeat(tx_count_rd) begin
                tx_rd = new();
                assert (tx_rd.randomize());
                gen2drive_rd.put(tx_rd);
            end
        join_any;
        $display($time, "\tGenerator completed");
    endtask

    

endclass : async_fifo_generator