module custom_sync_r2w (
  wclk_i, wrst_n_i,
  rptr_g,
  rptr_sync2_wrclk
);

  parameter ADDRSIZE = 32;
  input   wclk_i, wrst_n_i;
  input   [ADDRSIZE:0] rptr_g;
  output  reg [ADDRSIZE:0] rptr_sync2_wrclk;

  reg [ADDRSIZE:0] rptr_sync1_wrclk;

  always_ff @(posedge wclk_i or negedge wrst_n_i) begin
    if (~wrst_n_i)
      {rptr_sync2_wrclk, rptr_sync1_wrclk} <= '0;
    else
      {rptr_sync2_wrclk, rptr_sync1_wrclk} <= {rptr_sync1_wrclk, rptr_g};
  end

endmodule
