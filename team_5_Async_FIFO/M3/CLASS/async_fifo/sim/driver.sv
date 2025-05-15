// `include "transaction.sv"
// `include "async_fifo_interface.sv"

class async_fifo_driver;

    int tx_count_rd;
    int tx_count_wr;

    virtual intf vif_exec;

    mailbox gen2exec_wr;
    mailbox gen2exec_rd;

    function new(mailbox gen2exec_wr, mailbox gen2exec_rd, int tx_count_rd, tx_count_wr);
        this.gen2exec_wr = gen2exec_wr;
        this.gen2exec_rd = gen2exec_rd;
        this.tx_count_rd = tx_count_rd;
        this.tx_count_wr = tx_count_wr;
    endfunction

    task reset();
        wait(!vif_exec.ainit);   // Reset when ainit is low
        $display($time, "\treset started");
        vif_exec.req_wr  <= 0;
        vif_exec.req_rd  <= 0;
        vif_exec.data_wr <= 0;
        wait(vif_exec.ainit);    // Wait for ainit to be high to start
        $display($time, "\treset ended");
    endtask

    task drive_write();
        tx_wr t_wr = new();
        gen2exec_wr.get(t_wr);
        vif_exec.req_wr = t_wr.req_wr;
        vif_exec.data_wr = t_wr.data_wr;
        @(posedge vif_exec.clk_wr);
        @(posedge vif_exec.clk_wr);
    endtask

    task drive_read();
        tx_rd t_rd = new();
        gen2exec_rd.get(t_rd);
        vif_exec.req_rd = t_rd.req_rd;
        @(posedge vif_exec.clk_rd);
        @(posedge vif_exec.clk_rd);
    endtask

    task run();
        fork
        begin
            repeat (10) @(posedge vif_exec.clk_wr);
            for (int i = 0; i < tx_count_wr; i++)
                drive_write();
            vif_exec.req_wr = 0;
            vif_exec.data_wr = 0;
        end

        begin
            repeat (10) @(posedge vif_exec.clk_rd);
            for (int j = 0; j < tx_count_rd; j++)
                drive_read();
            vif_exec.req_rd = 0;
        end
        join
    endtask

endclass : async_fifo_driver