
interface async_fifo_intf #(parameter dw = 8) (
    input logic clk_wr,
    input logic clk_rd,
    input logic ainit
);
    logic req_wr;
    logic req_rd;
    logic [dw-1:0] data_wr;

    logic fifo_full;
    logic fifo_empty;
    logic fifo_almost_full;
    logic fifo_almost_empty;
    logic [dw-1:0] data_rd;
endinterface : async_fifo_intf
