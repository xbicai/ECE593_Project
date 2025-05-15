class tx_wr #(parameter SIZE = 32);
    rand bit [SIZE-1:0] data_wr;
    rand bit req_wr;
    bit full_flag;
endclass

class tx_rd #(parameter SIZE = 32);
    rand bit req_rd;
    logic [SIZE-1:0] data_rd;
    bit empty_flag;
endclass