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

  //assign dout = mem_array[rd_addr];
  always_ff @(posedge rclk_i) begin
    if (ren & ~fifo_empty) begin
      dout <= mem_array[rd_addr];
    end
    else begin
      dout <= 1'bx;
    end
  end


  always_ff @(posedge wclk_i) begin
    if (wen & ~fifo_full)
      mem_array[wr_addr] <= din;
    else begin
      mem_array[wr_addr] <= mem_array[wr_addr];
    end
  end

endmodule
