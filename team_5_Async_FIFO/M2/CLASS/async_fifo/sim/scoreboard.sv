// `include "transaction.sv"

class async_fifo_scoreboard #(parameter SIZE = 32);
    mailbox mon2scb_wr;
    mailbox mon2scb_rd;

    bit [SIZE-1:0] wr_fifo[$];
    bit [SIZE-1:0] rd_fifo[$];

    int wr_count;
    int rd_count;

    function new(mailbox mon2scb_wr, mailbox mon2scb_rd);
        this.mon2scb_wr = mon2scb_wr;
        this.mon2scb_rd = mon2scb_rd;
        wr_count = 0;
        rd_count = 0;
    endfunction

    task main();
        tx_wr tx_w = new();
        tx_rd tx_r = new();
        fork
            get_wr();
            get_rd();
        join_none;
    endtask


    task get_wr();                   // How do we handle full_flag?
        tx_wr tx_w = new();
        forever begin
            if (mon2scb_wr.num() != 0) begin
                mon2scb_wr.get(tx_w);
                if (tx_w.req_wr) begin        // Store only if it is a valid write
                    wr_fifo.push_back(tx_w.data_wr);
                    wr_count++;
                    $display($time, "\tScoreboard - WR_Input - %d", tx_w.data_wr);
                end
            end
        end
    endtask

    task get_rd();
        tx_rd tx_r = new();
        bit [SIZE-1:0] data;
        forever begin
            if (mon2scb_wr.num() != 0) begin
                mon2scb_rd.get(tx_r);         // Monitor only sends valid reads
                data = wr_fifo.pop_front();
                rd_count++;    
                if (data != tx_r.data_rd)
                    $display($time, "\tFIFO Error");
                $display($time, "\tScoreboard - RD_Input - %d", tx_r.data_rd);
            end
        end
    endtask

endclass : async_fifo_scoreboard