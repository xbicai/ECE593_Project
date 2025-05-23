
class async_fifo_sqr extends uvm_sequencer #(async_fifo_pkt);
  `uvm_component_utils(async_fifo_sqr)

  function new(string name = "async_fifo_sqr", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
