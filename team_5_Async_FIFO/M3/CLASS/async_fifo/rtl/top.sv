module custom_async_fifo #(
  parameter SIZE = 8, DEPTH = 4
) (
  wen, wclk_i, wrst_n_i,
  ren, rclk_i, rrst_n_i,
  din,
  dout,
  fifo_full,
  fifo_empty,
  fifo_almost_full,
  fifo_almost_empty
);
  parameter DATASIZE = SIZE;
  parameter ADDRSIZE = DEPTH;

  input  wen, wclk_i, wrst_n_i;
  input  ren, rclk_i, rrst_n_i;
  input  [DATASIZE-1:0] din;
  output [DATASIZE-1:0] dout;
  output fifo_full;
  output fifo_empty;
  output fifo_almost_full;
  output fifo_almost_empty;

  wire [ADDRSIZE-1:0] wr_addr, rd_addr;
  wire [ADDRSIZE:0] wptr_g, rptr_g, rptr_sync2_wrclk, wptr_sync2_rdclk;

  custom_sync_r2w #(ADDRSIZE) u_sync_r2w (
    .*
  );

  custom_sync_w2r #(ADDRSIZE) u_sync_w2r (
    .*
  );

  custom_fifomem #(DATASIZE, ADDRSIZE) u_fifomem (
    .*
  );

  custom_rptr_empty #(ADDRSIZE) u_rptr_empty (
    .*
  );

  custom_wptr_full #(ADDRSIZE) u_wptr_full (
    .*
  );

endmodule
