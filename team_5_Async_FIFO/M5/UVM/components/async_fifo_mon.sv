
class async_fifo_mon extends uvm_monitor;
  `uvm_component_utils(async_fifo_mon)

  virtual async_fifo_intf vif;
  uvm_analysis_port #(async_fifo_pkt) monitor_port;

  function new(string name = "async_fifo_mon", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual async_fifo_intf)::get(this, "*", "v_intf", vif))
      `uvm_fatal("MON", "Failed to get VIF from config DB");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk_rd);
      if (vif.req_rd && !vif.fifo_empty) begin
        async_fifo_pkt pkt = async_fifo_pkt::type_id::create("pkt");
        pkt.dout = vif.data_rd;
        pkt.fifo_empty = vif.fifo_empty;
        pkt.fifo_full = vif.fifo_full;
        pkt.fifo_almost_empty = vif.fifo_almost_empty;
        pkt.fifo_almost_full  = vif.fifo_almost_full;
        monitor_port.write(pkt);
      end
    end
  endtask
endclass
