/* ECE 593 Team 5
 *
 * Receives DUT's inputs via interface
 */

class monitor_wr#(parameter DATA = 8, ADDR = 4);
    virtual intf vif;
    mailbox mon2scb_wr;
    int tx_count;

    function new(virtual intf vif, mailbox mon2scb_wr);
        this.vif = vif;
        this.mon2scb_wr = mon2scb_wr;
    endfunction

    task main();
        $display("monitor_wr started");
        forever begin
            transaction #(.DATA(DATA)) tx = new();
            // getting data from DUT via interface
            @(posedge vif.clk_wr);
            tx.data_wr = vif.data_wr;
            tx.req_wr = vif.req_wr;
            tx.full_flag = vif.full_flag;
            tx.almost_full_flag = vif.almost_full_flag;
            mon2scb_wr.put(tx);
            tx_count++;
        end
    endtask

endclass : monitor_wr
