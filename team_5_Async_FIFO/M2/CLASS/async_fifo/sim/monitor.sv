// `include "transaction.sv"
// `include "async_fifo_interface.sv"

class async_fifo_monitor;

    int wr_count;
    int tx_count_wr;
    int tx_count_rd;
    int rd_count;

    virtual intf vif_obs;
    mailbox obs2sb_wr;
    mailbox obs2sb_rd;

    function new(mailbox obs2sb_rd, mailbox obs2sb_wr);
        // this.vif_obs = vif_obs;
        this.obs2sb_rd = obs2sb_rd;
        this.obs2sb_wr = obs2sb_wr;
    endfunction

    task observe_write();    
        tx_wr t_wr = new();         
        t_wr.req_wr = vif_obs.req_wr;
        t_wr.data_wr = vif_obs.data_wr;
        if (vif_obs.req_wr == 1) begin
            obs2sb_wr.put(t_wr);
            wr_count++;
        end
    endtask

    task observe_read();
        tx_rd t_rd = new();     
        @(posedge vif_obs.clk_rd);
        t_rd.req_rd = vif_obs.req_rd;
        t_rd.data_rd = vif_obs.data_rd;
        t_rd.empty_flag = vif_obs.empty_flag; 
        if (vif_obs.req_rd == 1) begin
            obs2sb_rd.put(t_rd);
            rd_count++;
        end
    endtask

    task run();
        bit wr_done = 0;
        tx_rd t_rd = new();
        tx_wr t_wr = new();

        fork
            begin : wr_obs_block
                forever @(posedge vif_obs.clk_wr) begin
                    @(posedge vif_obs.clk_wr)
                    observe_write();
                end
            end

            begin : wr_complete
                @(posedge vif_obs.clk_wr)
                wait (wr_count == tx_count_wr);
                disable wr_obs_block;
                wr_done = 1;
            end
        join_any

        if (wr_done == 1) begin
            fork
                begin : rd_obs_block
                    forever @(posedge vif_obs.clk_rd) begin 
                        observe_read();
                    end
                end

                begin : rd_complete
                    @(posedge vif_obs.clk_rd)
                    wait (rd_count == tx_count_rd);
                    disable rd_obs_block;
                end  
            join_any
        end

        @(posedge vif_obs.clk_rd);
        t_rd.empty_flag = vif_obs.empty_flag;
        obs2sb_rd.put(t_rd.empty_flag);

        @(posedge vif_obs.clk_wr);
        t_wr.full_flag = vif_obs.full_flag;
        obs2sb_wr.put(t_wr.full_flag);
    endtask

endclass : async_fifo_monitor