/* ECE 593 Team 5
 *
 * Sends writes and read requests to DUT via interface
 * Important: does not update flags unless there's a reset call, need to keep track in scoreboard to see if FIFO flag outputs are correct
 */

class driver#(parameter SIZE = 8, DEPTH = 4);
    // count for writes and reads
    int tx_count_wr; // sync for monitor_wr
    int tx_count_rd; // sync for monitor_rd
    // interface and mailbox connection
    virtual intf vif;
    mailbox gen2drive_wr;
    mailbox gen2drive_rd;

    function new(virtual intf vif, mailbox gen2drive_wr, mailbox gen2drive_rd);
        this.vif = vif;
        this.gen2drive_wr = gen2drive_wr;
        this.gen2drive_rd = gen2drive_rd;
    endfunction

    // reset operation 
    task reset();
        wait(!vif.ainit);   // Reset when ainit is low
        $display($time, "\treset started");
        vif.req_wr  <= 0;
        vif.req_rd  <= 0;
        vif.full_flag <= 0;
        vif.empty_flag <= 1;
        vif.data_wr <= 0;
        wait(vif.ainit);    // Wait for ainit to be high to exit
        $display($time, "\treset ended");
    endtask

    // getting transaction from generator and then sending to DUT via interface
    task main();
        $display("driver started\n");
        fork
            forever begin
                transaction_wr #(SIZE) tx_wr;
                gen2drive_wr.get(tx_wr);
                @(posedge vif.clk_wr);
                tx_count_wr++;
                vif.req_wr <= tx_wr.req_wr;
                vif.data_wr <= tx_wr.data_wr;
            end
            forever begin
                transaction_rd #(SIZE) tx_rd;
                gen2drive_rd.get(tx_rd);
                @(posedge vif.clk_rd);
                tx_count_rd++;
                vif.req_rd <= tx_rd.req_rd;
            end
        join
    endtask

endclass : driver