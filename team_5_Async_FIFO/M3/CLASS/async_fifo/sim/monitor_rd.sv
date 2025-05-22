/* ECE 593 Team 5
 *
 * Monitors output
 */

class monitor_rd#(parameter SIZE = 8, DEPTH = 4);
    virtual intf vif;
    mailbox mon2scb_rd;
    int tx_count_rd = 0;

    function new(virtual intf vif, mailbox mon2scb_rd);
        this.vif = vif;
        this.mon2scb_rd = mon2scb_rd;
    endfunction

    task main();
        $display("monitor_rd started");
        forever begin
            transaction_rd #(.SIZE(SIZE)) tx = new();
            // getting data from DUT via interface
            @(posedge vif.clk_rd);
            tx.data_rd = vif.data_rd;
            tx.req_rd = vif.req_rd;
            tx.empty_flag = vif.empty_flag;
            mon2scb_rd.put(tx);
            tx_count_rd++;      // Once this matches driver's, all reads have been observed
        end
    endtask

endclass : monitor_rd