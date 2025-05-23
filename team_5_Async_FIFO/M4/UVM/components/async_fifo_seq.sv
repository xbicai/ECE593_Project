
class async_fifo_seq extends uvm_sequence #(async_fifo_pkt);
  `uvm_object_utils(async_fifo_seq)

  function new(string name = "async_fifo_seq");
    super.new(name);
  endfunction

  virtual task body();
    async_fifo_pkt pkt;
    repeat (20) begin
      pkt = async_fifo_pkt::type_id::create("pkt");
      start_item(pkt);
      assert(pkt.randomize());
      finish_item(pkt);
    end
  endtask
endclass
