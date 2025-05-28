module custom_rptr_empty (
  ren, rclk_i, rrst_n_i,
  wptr_sync2_rdclk,
  fifo_empty,
  fifo_almost_empty,
  rd_addr,
  rptr_g
);
  parameter ADDRSIZE = 32;
  input  ren, rclk_i, rrst_n_i;
  input  [ADDRSIZE:0] wptr_sync2_rdclk;
  output reg fifo_empty;
  output reg fifo_almost_empty;
  output [ADDRSIZE-1:0] rd_addr;
  output reg [ADDRSIZE:0] rptr_g;

  reg [ADDRSIZE:0] rbin_reg;
  wire [ADDRSIZE:0] rgray_next, rbin_next;
  wire fifo_empty_val;
  wire fifo_almost_empty_val;

  always_ff @(posedge rclk_i or negedge rrst_n_i) begin
    if (~rrst_n_i)
      {rbin_reg, rptr_g} <= '0;
    else
      {rbin_reg, rptr_g} <= {rbin_next, rgray_next};
  end

  assign rd_addr = rbin_reg[ADDRSIZE-1:0];
  assign rbin_next = rbin_reg + (ren & ~fifo_empty);
  assign rgray_next = (rbin_next >> 1) ^ rbin_next;

  assign fifo_empty_val = (rgray_next == wptr_sync2_rdclk);
//   assign fifo_empty_val = (rgray_next == {1'b0, wptr_sync2_rdclk[ADDRSIZE-1:0]});
  assign fifo_almost_empty_val = ((rgray_next>>1 == wptr_sync2_rdclk) || fifo_empty_val);


  always_ff @(posedge rclk_i or negedge rrst_n_i) begin
    if (~rrst_n_i) begin
      fifo_empty <= 1'b0;
	  fifo_almost_empty <= 1'b0;
	end else begin
      fifo_empty <= fifo_empty_val;
	  fifo_almost_empty <= fifo_almost_empty_val;
	end
  end

endmodule
