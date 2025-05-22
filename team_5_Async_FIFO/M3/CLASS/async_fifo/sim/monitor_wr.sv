/* ECE 593 Team 5
 *
 * Receives DUT's inputs via interface
 */

class monitor_wr#(parameter SIZE = 8, DEPTH = 4);
    virtual intf vif;
    mailbox mon2scb_wr;
    int tx_count_wr;

    function new(virtual intf vif, mailbox mon2scb_wr);
        this.vif = vif;
        this.mon2scb_wr = mon2scb_wr;
    endfunction

    task main();
        $display("monitor_wr started");
        forever begin
            transaction_wr #(.SIZE(SIZE)) tx = new();
            // getting data from DUT via interface
            @(posedge vif.clk_wr);
            tx.data_wr = vif.data_wr;
            tx.req_wr = vif.req_wr;
            tx.full_flag = vif.full_flag;
            mon2scb_wr.put(tx);
            tx_count_wr++;
        end
    endtask

endclass : monitor_wr
