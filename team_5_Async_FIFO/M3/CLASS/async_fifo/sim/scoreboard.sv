/* ECE 593 Team 5
 *
 * Obtain observed input and outputs from monitors, and checks correctness of flags/values
 * TODO: Add more specific checks for things such as corner cases
 */
class scoreboard #(parameter SIZE = 8, DEPTH = 4);
    mailbox mon2scb_wr;
    mailbox mon2scb_rd;

    bit [SIZE-1:0] fifo[$];
    bit [SIZE-1:0] data_temp;   // used in get_rd to temporally hold fifo popped data

    bit full_local, empty_local;

    // semaphore for updating local flag
    semaphore lock;

    function new(mailbox mon2scb_wr, mailbox mon2scb_rd);
        this.mon2scb_wr = mon2scb_wr;
        this.mon2scb_rd = mon2scb_rd;

        // initialize
        full_local = 1'b0;   // these are assuming driver.reset() is never called again beyond pre_rest()!!!
        empty_local = 1'b1;
        lock = new(1);
    endfunction

    task main();
        $display("SCOREBOARD SIZE:%d, DEPTH:%d\n",SIZE, DEPTH);
        fork
            get_wr();
            get_rd();
        join_none
    endtask

    task get_wr();                 
        transaction_wr #(.SIZE(SIZE)) tx_wr = new();
        forever begin
            mon2scb_wr.get(tx_wr);

            // check full flag
            if (tx_wr.full_flag != full_local) begin
                $display("ERROR full_flag mismatch, scoreboard full_flag: %d, DUT full_flag: %d\n", full_local, tx_wr.full_flag);
            end

            // Valid write when req high and full low
            if (tx_wr.req_wr && !tx_wr.full_flag) begin
                lock.get();
                fifo.push_back(tx_wr.data_wr);
                $display($time, "\tScoreboard - WR_Input - %d", tx_wr.data_wr);

                // update local flag 
                empty_local = 1'b0;
                if (fifo.size() == DEPTH) full_local = 1'b1;
                lock.put();
            end
        end

    endtask

    task get_rd();
        transaction_rd #(.SIZE(SIZE)) tx_rd = new();
        forever begin
            mon2scb_rd.get(tx_rd);   

            // check empty flag
            if (tx_rd.empty_flag != empty_local) begin
                $display("ERROR: empty_flag mismatch, scoreboard empty_flag: %d, DUT empty_flag: %d\n", empty_local, tx_rd.empty_flag);
            end
            
            // Valid read when req high and empty low
            if (tx_rd.req_rd && !tx_rd.empty_flag) begin
                if (fifo.size() <= 0) begin
                    $display("ERROR: local FIFO is empty but DUT empty flag is not raised\n");
                end
                else begin
                    lock.get();
                    data_temp = fifo.pop_front();
                    if (data_temp != tx_rd.data_rd) begin
                        $display($time, "\tread output mismatch: scoreboard read data: %0h, DUT read data: %0h\n", data_temp, tx_rd.data_rd);
                    end
                    $display($time, "\tScoreboard - RD_Input - %d", tx_rd.data_rd);
                    // update local flag
                    full_local = 1'b0;
                    if (fifo.size() == 0) empty_local = 1'b1;
                    lock.put();
                end
            end
        end
    endtask

endclass : scoreboard