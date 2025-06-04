/* ECE 593 Team 5
 *
 * Obtain observed input and outputs from monitors, and checks correctness of flags/values
 */
class scoreboard #(parameter DATA = 8, ADDR = 4);
    mailbox mon2scb_wr;
    mailbox mon2scb_rd;

    bit [DATA-1:0] fifo[$];
    bit [DATA-1:0] data_temp;   // used in get_rd to temporally hold fifo popped data

    bit full_local, empty_local;
    bit full_sync1, empty_sync1;    // since the DUT has a 2FF synchronizer, scoreboard will simulate that for timing purposes
    bit full_sync2, empty_sync2;

    int depth = 2**ADDR;
    // semaphore for updating local flag
    semaphore lock;

    function new(mailbox mon2scb_wr, mailbox mon2scb_rd);
        this.mon2scb_wr = mon2scb_wr;
        this.mon2scb_rd = mon2scb_rd;

        // initialize
        full_local = 1'b0;   // these are assuming driver.reset() is never called again beyond pre_rest()!!!
        full_sync1 = 1'b0;
        full_sync2 = 1'b0;
        empty_local = 1'b1;
        empty_sync1 = 1'b1;
        empty_sync2 = 1'b1;
        lock = new(1);
    endfunction

    task main();
        $display("SCOREBOARD DATA:%d, ADDR:%d\n",DATA, ADDR);
        fork
            get_wr();
            get_rd();
        join_none
    endtask

    task get_wr();                 
        transaction #(.DATA(DATA)) tx_wr = new();
        forever begin
            mon2scb_wr.get(tx_wr);

            // Valid write when req high and full low
            if (tx_wr.req_wr && !tx_wr.full_flag) begin
                // check full flag
                if (tx_wr.full_flag != full_local) begin
                    $display("TIME=%0t\tSCB\tERROR: full_flag mismatch, SCB full_flag=%d, DUT full_flag=%d\n", $time, full_local, tx_wr.full_flag);
                end
                if (fifo.size() >= depth) begin
                    $display("TIME=%0t\tSCB\tERROR: local FIFO is full but DUT full flag is not raised\n", $time);
                end
                else begin
                    lock.get();
                    fifo.push_back(tx_wr.data_wr);
                    $display("TIME=%0t\tSCB\tWRITE=%d", $time, tx_wr.data_wr);
                    // update flags
                    if (fifo.size() >= 0) begin // always from a write
                        empty_local <= 1'b0;
                    end
                    if (fifo.size() >= depth) begin
                        full_sync1 <= 1'b1;
                        full_sync2 <= full_sync1;
                        full_local <= full_sync2;
                    end
                    lock.put();
                end
            end
            else if (tx_wr.req_wr && tx_wr.full_flag) begin
                $display("TIME=%0t\tSCB\tFIFO is full, can't write", $time);
            end
        end
    endtask

    task get_rd();
        transaction #(.DATA(DATA)) tx_rd = new();
        forever begin
            mon2scb_rd.get(tx_rd);   

            // Valid read when req high and empty low
            if (tx_rd.req_rd && !tx_rd.empty_flag) begin
                // check empty flag
                if (tx_rd.empty_flag != empty_local) begin
                    $display("TIME=%0t\tSCB\tERROR: empty_flag mismatch, SCB empty_flag=%d, DUT empty_flag=%d, sync1=%d, sync2=%d", $time, empty_local, tx_rd.empty_flag, empty_sync1, empty_sync2);
                end
                if (fifo.size() <= 0) begin
                    $display("TIME=%0t\tSCB\tERROR: local FIFO is empty but DUT empty flag is not raised\n", $time);
                end
                else begin
                    lock.get();
                    data_temp = fifo.pop_front();
                    if (data_temp != tx_rd.data_rd) begin
                        $display("TIME=%0t\tSCB\tread output mismatch: SCB read data=%d, DUT read data=%d\n", $time, data_temp, tx_rd.data_rd);
                    end
                    $display("TIME=%0t\tSCB\tREAD=%d", $time, tx_rd.data_rd);
                    // update local flag
                    if (fifo.size() <= 0) begin 
                        empty_sync1 <= 1'b1;
                        empty_sync2 <= empty_sync1;
                        empty_local <= empty_sync2;
                    end
                    if (fifo.size() <= depth) begin // always
                        full_local <= 1'b0;
                    end
                    lock.put();
                end
            end
            else if (tx_rd.req_rd && tx_rd.empty_flag) begin
                $display("TIME=%0t\tSCB\tFIFO is empty, can't read", $time);
            end
        end
    endtask

endclass : scoreboard