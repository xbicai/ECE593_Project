module custom_async_fifo_tb;

  parameter DATADDRSIZE = 8;
  parameter ADDRSIZE = 4;

  wire [DATADDRSIZE-1:0] dout;
  wire fifo_full;
  wire fifo_empty;
  reg [DATADDRSIZE-1:0] din;
  reg wen, wclk, wrst_n_i;
  reg ren, rclk, rrst_n_i;

  reg [DATADDRSIZE-1:0] verif_data_q[$];
  reg [DATADDRSIZE-1:0] verif_wdata;

  custom_async_fifo #(DATADDRSIZE, ADDRSIZE) dut (
    .din(din),
    .dout(dout),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .wen(wen),
    .wclk_i(wclk),
    .wrst_n_i(wrst_n_i),
    .ren(ren),
    .rclk_i(rclk),
    .rrst_n_i(rrst_n_i)
  );

  initial begin
    wclk = 1'b0;
    rclk = 1'b0;

    fork
      forever #33.33ns wclk = ~wclk;
      forever #50ns rclk = ~rclk;
    join
  end

  initial begin
    wen = 1'b0;
    din = '0;
    wrst_n_i = 1'b0;
    repeat(5) @(posedge wclk);
    wrst_n_i = 1'b1;

    for (int iter = 0; iter < 2; iter++) begin
      for (int i = 0; i < 460; i++) begin
        @(posedge wclk iff !fifo_full);
        wen = (i % 2 == 0) ? 1'b1 : 1'b0;
        if (wen) begin
          din = $urandom;
          verif_data_q.push_front(din);
        end
      end
      #1us;
    end
  end

  initial begin
    ren = 1'b0;
    rrst_n_i = 1'b0;
    repeat(5) @(posedge rclk);
    rrst_n_i = 1'b1;

    for (int iter = 0; iter < 2; iter++) begin
      for (int i = 0; i < 460; i++) begin
        @(posedge rclk iff !fifo_empty);
        ren = (i % 2 == 0) ? 1'b1 : 1'b0;
        if (ren) begin
          verif_wdata = verif_data_q.pop_back();
          $display("Checking dout: expected din = %h, dout = %h", verif_wdata, dout);
          assert(dout === verif_wdata)
            else $error("Check failed: expected din = %h, dout = %h", verif_wdata, dout);
        end
      end
    end

    $finish;
  end

endmodule
