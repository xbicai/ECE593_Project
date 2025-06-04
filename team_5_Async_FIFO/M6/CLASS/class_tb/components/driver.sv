/* ECE 593 Team 5
 *
 * Sends writes and read requests to DUT via interface
 * Important: does not update flags unless there's a reset call, need to keep track in scoreboard to see if FIFO flag outputs are correct
 */

class driver#(parameter DATA = 8, ADDR = 4);
    // sync for generator and monitors
    int tx_count, tx_count_rd, tx_count_wr;
    // interface and mailbox connection
    virtual intf vif;
    mailbox gen2drive;

    function new(virtual intf vif, mailbox gen2drive);
        this.vif = vif;
        this.gen2drive = gen2drive;
    endfunction

    // reset operation 
    task reset();
        wait(!vif.ainit);   // Reset when ainit is low
        $display($time, "\treset started");
        vif.req_wr  <= 0;
        vif.req_rd  <= 0;
        vif.full_flag <= 0;
        vif.empty_flag <= 1;
        vif.almost_full_flag <= 0;
        vif.almost_full_flag <= 1;
        vif.data_wr <= 101;
        wait(vif.ainit);    // Wait for ainit to be high to exit
        $display($time, "\treset ended");
    endtask

    // getting transaction from generator and then sending to DUT via interface
    task main();
        $display("driver started\n");
        tx_count = 0;
        tx_count_rd = 0;
        tx_count_wr = 0;
        forever begin
            transaction #(DATA) tx;
            gen2drive.get(tx);
            tx_count++;
            //$display("TIME=%0t\tDRV\tSending: DIN=%d, WREN=%d, RDEN=%d\n", $time, tx.data_wr, tx.req_wr, tx.req_rd);
            fork
                begin : write
                    @(negedge vif.clk_wr);
                    vif.req_wr <= tx.req_wr;
                    vif.data_wr <= tx.data_wr;
                    tx_count_wr++;
                end
                begin : read
                    @(negedge vif.clk_rd);
                    vif.req_rd <= tx.req_rd;
                    tx_count_rd++;
                end
            join
        end
    endtask

endclass : driver