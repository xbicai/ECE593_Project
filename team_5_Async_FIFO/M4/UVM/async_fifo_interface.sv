
interface async_fifo_intf #(parameter SIZE = 8) (
    input logic clk_wr,
    input logic clk_rd,
    input logic ainit
);
    // inputs
    logic req_wr;
    logic req_rd;
    logic [SIZE-1:0] data_wr;
    // output + flags
    logic fifo_full;
    logic fifo_empty;
    logic fifo_almost_full;
    logic fifo_almost_empty;
    logic [SIZE-1:0] data_rd;
endinterface : async_fifo_intf
