
package new_proj_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  `include "async_fifo_interface.sv"
  `include "./components/async_fifo_pkt.sv"
  `include "./components/async_fifo_seq.sv"
  `include "./components/async_fifo_sqr.sv"
  `include "./components/async_fifo_drv.sv"
  `include "./components/async_fifo_mon.sv"
  `include "./components/async_fifo_agnt.sv"
  `include "./components/async_fifo_scb.sv"
  `include "./components/async_fifo_env.sv"
  `include "./components/async_fifo_test.sv"
endpackage
