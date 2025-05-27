
class async_fifo_scoreboard extends uvm_component;
  `uvm_component_utils(async_fifo_scoreboard)

  uvm_analysis_imp #(async_fifo_pkt, async_fifo_scoreboard) scoreboard_port;
//   queue [7:0] ref_model;
	bit [7:0] ref_model[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    scoreboard_port = new("scoreboard_port", this);
  endfunction

  virtual function void write(async_fifo_pkt pkt);
    if (pkt.wr_en && !pkt.fifo_full)
      ref_model.push_back(pkt.din);
    if (pkt.rd_en && !pkt.fifo_empty) begin
      if (ref_model.size() == 0) begin
        `uvm_error("SCOREBOARD", "Read attempted from empty reference queue!");
      end else begin
        logic [7:0] exp = ref_model.pop_front();
        if (pkt.dout !== exp) begin
          `uvm_error("SCOREBOARD", $sformatf("Mismatch: expected %0h, got %0h", exp, pkt.dout));
        end
      end
    end
  endfunction
endclass
