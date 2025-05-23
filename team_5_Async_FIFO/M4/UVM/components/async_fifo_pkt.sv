
class async_fifo_pkt extends uvm_sequence_item;
  `uvm_object_utils(async_fifo_pkt);

  rand logic        wr_en;
  rand logic        rd_en;
  rand logic [7:0]  din;
       logic [7:0]  dout;
       logic        fifo_full;
       logic        fifo_empty;
       logic        fifo_almost_full;
       logic        fifo_almost_empty;

  constraint wr_enable { wr_en dist {0 := 3, 1 := 7}; }
  constraint rd_enable { rd_en dist {0 := 3, 1 := 7}; }

  function new(string name = "async_fifo_pkt");
    super.new(name);
  endfunction
endclass
