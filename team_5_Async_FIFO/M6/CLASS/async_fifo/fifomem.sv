// `define BUG

module custom_fifomem (
  wen, fifo_full, wclk_i,
  wr_addr, rd_addr,
  din,
  dout,
  fifo_empty, rclk_i, ren
);
  parameter DATASIZE = 8;   // Memory data word width
  parameter ADDRSIZE = 32;  // Number of mem address bits
  localparam DEPTH = 2**ADDRSIZE;

  input  logic wen, fifo_full, wclk_i;
  input  logic [ADDRSIZE-1:0] wr_addr, rd_addr;
  input  logic [DATASIZE-1:0] din;
  input  logic fifo_empty, rclk_i, ren;
  output logic [DATASIZE-1:0] dout;

  logic [DATASIZE-1:0] mem_array [0:DEPTH-1];

  `ifdef BUG
  assign dout = mem_array[rd_addr];
  `else
  always_ff @(posedge rclk_i) begin
    if (ren & ~fifo_empty) begin
      dout <= mem_array[rd_addr];
    end
  end
  `endif


  always_ff @(posedge wclk_i) begin
    if (wen & ~fifo_full)
      mem_array[wr_addr] <= din;
  end

endmodule
