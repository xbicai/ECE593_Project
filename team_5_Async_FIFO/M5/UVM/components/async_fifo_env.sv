
class async_fifo_env extends uvm_env;
  `uvm_component_utils(async_fifo_env)

  async_fifo_agnt agnt;
  async_fifo_scoreboard scb;
//   virtual async_fifo_intf v_intf;

  function new(string name = "async_fifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt = async_fifo_agnt::type_id::create("agnt", this);
    scb = async_fifo_scoreboard::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnt.mon.monitor_port.connect(scb.scoreboard_port);
  endfunction
endclass
