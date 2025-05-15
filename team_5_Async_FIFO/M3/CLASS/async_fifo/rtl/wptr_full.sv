module custom_wptr_full (
  wen, wclk_i, wrst_n_i,
  rptr_sync2_wrclk,
  fifo_full,
  wr_addr,
  wptr_g
);

  parameter ADDRSIZE = 32;
  input  wen, wclk_i, wrst_n_i;
  input  [ADDRSIZE:0] rptr_sync2_wrclk;
  output reg fifo_full;
  output [ADDRSIZE-1:0] wr_addr;
  output reg [ADDRSIZE:0] wptr_g;

  reg [ADDRSIZE:0] wbin_reg;
  wire [ADDRSIZE:0] wgray_next, wbin_next;
  wire fifo_full_val;

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

  always_ff @(posedge wclk_i or negedge wrst_n_i) begin
    if (~wrst_n_i)
      fifo_full <= 1'b0;
    else
      fifo_full <= fifo_full_val;
  end

endmodule
