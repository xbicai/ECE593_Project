/* ECE 593 Team 5
 *
 * aggregate classes for random varaible generation
 * separate read and writes since they have different clocks
 */
class transaction_wr #(parameter SIZE = 8);
    rand bit [SIZE-1:0] data_wr;
    rand bit req_wr;
    bit full_flag;

    constraint req_zero {
        req_wr == 0;
    }
    constraint req_one {
        req_wr == 1;
    }
    constraint data_large { // upper half values
        data_wr > (1 << (SIZE-1));
    }
    constraint data_small { // lower half values
        data_wr < (1 << (SIZE-1));
    }
    constraint data_min {
        data_wr == '0;
    }
    constraint data_max {
        data_wr == {SIZE{1'b1}};
    }
    // assuming req_one since specifying data
    function void constraint_select (string name);
        this.constraint_mode(0);
        this.req_one.constraint_mode(1);
        case (name)
            "large": this.data_large.constraint_mode(1);
            "small": this.data_small.constraint_mode(1);
            "min"  : this.data_min.constraint_mode(1);
            "max"  : this.data_max.constraint_mode(1);
        endcase
    endfunction

    function void print();
        $display("Inputs wr = %0h req_wr = %0h\n", data_wr, req_wr);
    endfunction: print
endclass : transaction_wr

class transaction_rd #(parameter SIZE = 32);
    bit [SIZE-1:0] data_rd;
    rand bit req_rd;
    bit empty_flag;

    constraint req_zero {
        req_rd == 0;
    }
    constraint req_one {
        req_rd == 1;
    }
    constraint three_quarters {
        req_rd dist {1:=3, 0:=1};
    }

    function void constraint_select (string name);
        this.constraint_mode(0);
        case (name)
            "zero": this.req_zero.constraint_mode(1);
            "one": this.req_one.constraint_mode(1);
            "3/4"  : this.three_quarters.constraint_mode(1);
        endcase
    endfunction
    
    function void print();
        $display("Input read request = %0h\n", req_rd);
    endfunction: print
endclass : transaction_rd
