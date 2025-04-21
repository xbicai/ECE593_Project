module custom_fifomem (
  wen, fifo_full, wclk_i,
  wr_addr, rd_addr,
  din,
  dout
);
  parameter DATASIZE = 8;   // Memory data word width
  parameter ADDRSIZE = 32;  // Number of mem address bits
  localparam DEPTH = 2**ADDRSIZE;

  input  wen, fifo_full, wclk_i;
  input  [ADDRSIZE-1:0] wr_addr, rd_addr;
  input  [DATASIZE-1:0] din;
  output [DATASIZE-1:0] dout;

  logic [DATASIZE-1:0] mem_array [0:DEPTH-1];

  assign dout = mem_array[rd_addr];

  always_ff @(posedge wclk_i) begin
    if (wen & ~fifo_full)
      mem_array[wr_addr] <= din;
  end

endmodule
