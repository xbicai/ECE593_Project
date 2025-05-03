// `include "env.sv"

class test;
    async_fifo_env env;


    function new();
        env = new(); 
    endfunction

    task run();
        env.run();
    endtask

endclass