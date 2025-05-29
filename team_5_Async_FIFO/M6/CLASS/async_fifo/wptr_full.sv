module custom_wptr_full (
  wen, wclk_i, wrst_n_i,
  rptr_sync2_wrclk,
  fifo_full,
  fifo_almost_full,
  wr_addr,
  wptr_g
);

  parameter ADDRSIZE = 32;
  input  logic wen, wclk_i, wrst_n_i;
  input  logic [ADDRSIZE:0] rptr_sync2_wrclk;
  output logic fifo_full;
  output logic fifo_almost_full;
  output logic [ADDRSIZE-1:0] wr_addr;
  output logic [ADDRSIZE:0] wptr_g;

  logic [ADDRSIZE:0] wbin_reg;
  logic [ADDRSIZE:0] wgray_next, wbin_next;
  logic fifo_full_val;
  logic fifo_almost_full_val;

  always_ff @(posedge wclk_i or negedge wrst_n_i) begin
    if (~wrst_n_i)
      {wbin_reg, wptr_g} <= '0;
    else
      {wbin_reg, wptr_g} <= {wbin_next, wgray_next};
  end

  assign wr_addr     = wbin_reg[ADDRSIZE-1:0];
  assign wbin_next   = wbin_reg + (wen & ~fifo_full);
  assign wgray_next  = (wbin_next >> 1) ^ wbin_next;

  assign fifo_full_val = (wgray_next == {~rptr_sync2_wrclk[ADDRSIZE:ADDRSIZE-1], rptr_sync2_wrclk[ADDRSIZE-2:0]});
  assign fifo_almost_full_val = ((wgray_next-1 == {~rptr_sync2_wrclk[ADDRSIZE:ADDRSIZE-1], rptr_sync2_wrclk[ADDRSIZE-2:0]}) || fifo_full_val);

  always_ff @(posedge wclk_i or negedge wrst_n_i) begin
    if (~wrst_n_i) begin
      fifo_full <= 1'b1;
	    fifo_almost_full <= 1'b1;
	end else begin
      fifo_full <= (wgray_next == {~rptr_sync2_wrclk[ADDRSIZE:ADDRSIZE-1], rptr_sync2_wrclk[ADDRSIZE-2:0]});;
	    fifo_almost_full <= fifo_almost_full_val;
	end
  end

endmodule
