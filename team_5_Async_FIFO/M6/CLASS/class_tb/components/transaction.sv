/* ECE 593 Team 5
 *
 * aggregate classes for random varaible generation
 * separate read and writes since they have different clocks
 */
class transaction #(parameter DATA = 8);
    rand bit [DATA-1:0] data_wr;
    rand bit req_wr, req_rd;
    bit [DATA-1:0] data_rd;
    bit full_flag, empty_flag, almost_full_flag, almost_empty_flag;

    
    // 3:1 READ-biased
    constraint read_bias {
        req_wr dist {0:=3, 1:=1};
        req_rd dist {0:=1, 1:=3};
    }

    // 3:1 WRITE-biased
    constraint write_bias {
        req_wr dist {0:=1, 1:=3};
        req_rd dist {0:=3, 1:=1};
    }
    
    function void print();
        $display("Inputs wr = %0h req_wr = %0h\n", data_wr, req_wr);
    endfunction: print
endclass : transaction

