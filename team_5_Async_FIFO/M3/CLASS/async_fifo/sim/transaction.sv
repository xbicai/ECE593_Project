/* ECE 593 Team 5
 *
 * aggregate classes for random varaible generation
 * separate read and writes since they have different clocks
 * TODO: add contraints for specific tests
 */
class transaction_wr #(parameter SIZE = 8);
    rand bit [SIZE-1:0] data_wr;
    rand bit req_wr;
    bit full_flag;

    function void print();
        $display("Inputs wr = %0h req_wr = %0h\n", data_wr, req_wr);
    endfunction: print
endclass : transaction_wr

class transaction_rd #(parameter SIZE = 32);
    bit [SIZE-1:0] data_rd;
    rand bit req_rd;
    bit empty_flag;

    function void print();
        $display("Input read request = %0h\n", req_rd);
    endfunction: print
endclass : transaction_rd
