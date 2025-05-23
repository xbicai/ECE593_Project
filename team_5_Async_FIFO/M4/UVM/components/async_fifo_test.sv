
class test extends uvm_test;
  `uvm_component_utils(test)

  async_fifo_env env;
  async_fifo_seq seq;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = async_fifo_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = async_fifo_seq::type_id::create("seq");
    seq.start(env.agnt.sqr);
    #500;
    phase.drop_objection(this);
  endtask
endclass
