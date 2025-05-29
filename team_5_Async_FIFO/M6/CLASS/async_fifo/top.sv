module custom_async_fifo (
  wen, wclk_i, wrst_n_i,
  ren, rclk_i, rrst_n_i,
  din,
  dout,
  fifo_full,
  fifo_empty,
  fifo_almost_full,
  fifo_almost_empty
);
  parameter DATASIZE = 8;
  parameter ADDRSIZE = 4;

  input  logic wen, wclk_i, wrst_n_i;
  input  logic ren, rclk_i, rrst_n_i;
  input  logic [DATASIZE-1:0] din;
  output logic [DATASIZE-1:0] dout;
  output logic fifo_full;
  output logic fifo_empty;
  output logic fifo_almost_full;
  output logic fifo_almost_empty;

  logic [ADDRSIZE-1:0] wr_addr, rd_addr;
  logic [ADDRSIZE:0] wptr_g, rptr_g, rptr_sync2_wrclk, wptr_sync2_rdclk;

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
