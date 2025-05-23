
class async_fifo_drv extends uvm_driver #(async_fifo_pkt);
  `uvm_component_utils(async_fifo_drv)

  virtual async_fifo_intf vif;

  function new(string name = "async_fifo_drv", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual async_fifo_intf)::get(this, "*", "v_intf", vif))
      `uvm_fatal("DRV", "Failed to get VIF from config DB");
  endfunction

  task run_phase(uvm_phase phase);
    async_fifo_pkt pkt;
    forever begin
      seq_item_port.get_next_item(pkt);
      if (pkt.wr_en && !vif.fifo_full) begin
        @(posedge vif.clk_wr);
        vif.req_wr <= 1;
        vif.data_wr <= pkt.din;
      end else begin
        vif.req_wr <= 0;
      end
      if (pkt.rd_en && !vif.fifo_empty) begin
        @(posedge vif.clk_rd);
        vif.req_rd <= 1;
      end else begin
        vif.req_rd <= 0;
      end
      @(posedge vif.clk_wr);
      vif.req_wr <= 0;
      @(posedge vif.clk_rd);
      vif.req_rd <= 0;
      seq_item_port.item_done();
    end
  endtask
endclass
