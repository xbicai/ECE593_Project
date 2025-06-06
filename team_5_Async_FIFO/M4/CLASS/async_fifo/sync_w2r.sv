module custom_sync_w2r (
  rclk_i, rrst_n_i,
  wptr_g,
  wptr_sync2_rdclk
);

  parameter ADDRSIZE = 32;
  input   rclk_i, rrst_n_i;
  input   [ADDRSIZE:0] wptr_g;
  output  reg [ADDRSIZE:0] wptr_sync2_rdclk;

  reg [ADDRSIZE:0] wptr_sync1_rdclk;

  always_ff @(posedge rclk_i or negedge rrst_n_i) begin
    if (~rrst_n_i)
      {wptr_sync2_rdclk, wptr_sync1_rdclk} <= '0;
    else
      {wptr_sync2_rdclk, wptr_sync1_rdclk} <= {wptr_sync1_rdclk, wptr_g};
  end

endmodule
