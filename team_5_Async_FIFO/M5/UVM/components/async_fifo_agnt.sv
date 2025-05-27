
class async_fifo_agnt extends uvm_agent;
  `uvm_component_utils(async_fifo_agnt)

  async_fifo_drv drv;
  async_fifo_mon mon;
  async_fifo_sqr sqr;

  function new(string name = "async_fifo_agnt", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = async_fifo_drv::type_id::create("drv", this);
    mon = async_fifo_mon::type_id::create("mon", this);
    sqr = async_fifo_sqr::type_id::create("sqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass
