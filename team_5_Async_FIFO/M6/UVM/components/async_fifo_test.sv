//--------------------------------------------------------
// async_fifo_drv.sv
// 	UVM Driver Class for async_fifo DUT
//
//--------------------------------------------------------
class test extends uvm_test;
	`uvm_component_utils(test)

	async_fifo_env env;
	int logfile;
	// basic tests
	seq1_1_1 seq111;
	seq1_1_2 seq112;
	seq1_1_3 seq113;
	seq1_1_4 seq114;
	seq1_1_5 seq115;
	seq1_1_6 seq116;
	seq1_1_7 seq117;
	// complex tests
	seq1_2_1 seq121;
	seq1_2_2 seq122;
	seq1_2_3 seq123;
	seq1_2_4 seq124;
	// corner tests
	seq1_4_1 seq141;
	seq1_4_2 seq142;
	seq1_4_3 seq143;

	//----------------------------------------------------
	// Standard UVM Constructor
	//----------------------------------------------------
	function new(string name = "test", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	//----------------------------------------------------
	// UVM Build Phase
	//----------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
		env = async_fifo_env::type_id::create("env", this);
	endfunction

	//----------------------------------------------------
	// UVM EOB Phase
	//----------------------------------------------------
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	
	//----------------------------------------------------
	// UVM Run Phase
	//----------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("TEST_CLASS", "Inside Run Phase!", UVM_HIGH)

		create_seqs();

		phase.raise_objection(this);

		start_seqs();

		phase.drop_objection(this);
	endtask

	// helper tasks
	task create_seqs();
		seq111 = seq1_1_1::type_id::create("seq111");
		// seq112 = seq1_1_2::type_id::create("seq112");
		// seq113 = seq1_1_3::type_id::create("seq113");
		// seq114 = seq1_1_4::type_id::create("seq114");
		// seq115 = seq1_1_5::type_id::create("seq115");
		// seq116 = seq1_1_6::type_id::create("seq116");
/*		seq117 = seq1_1_7::type_id::create("seq117");
/* 
		seq121 = seq1_2_1::type_id::create("seq121");
		seq122 = seq1_2_2::type_id::create("seq122");
		seq123 = seq1_2_3::type_id::create("seq123");
		seq124 = seq1_2_4::type_id::create("seq124");

		seq141 = seq1_4_1::type_id::create("seq141");
		seq142 = seq1_4_2::type_id::create("seq142");
		seq143 = seq1_4_3::type_id::create("seq143"); */
	endtask

	task start_seqs();
		repeat(2) begin
		seq111.start(env.agnt.sqr);
		#100;
		end
		// seq112.start(env.agnt.sqr);
		// `SEQ_DELAY_L;
		// seq113.start(env.agnt.sqr);
		// `SEQ_DELAY_L;
		// seq114.start(env.agnt.sqr);
		// `SEQ_DELAY_S;
		// seq115.start(env.agnt.sqr);
		// `SEQ_DELAY_L;
		// seq116.start(env.agnt.sqr);
		// `SEQ_DELAY_S;
/*		seq117.start(env.agnt.sqr);
		`SEQ_DELAY_L;
 
		seq121.start(env.agnt.sqr);
		`SEQ_DELAY_L;
		seq122.start(env.agnt.sqr);
		`SEQ_DELAY_L;
		seq123.start(env.agnt.sqr);
		`SEQ_DELAY_L;
		seq124.start(env.agnt.sqr);
		`SEQ_DELAY_L;

		seq141.start(env.agnt.sqr);
		`SEQ_DELAY_L;
		seq142.start(env.agnt.sqr);
		`SEQ_DELAY_L;
		seq143.start(env.agnt.sqr);
		`SEQ_DELAY_L; */
	endtask

	function void start_of_simulation_phase(uvm_phase phase);
		fifo_report_server server = new;
		super.start_of_simulation_phase(phase);
		`uvm_info("SCB CLASS", "Start of Simulation", UVM_NONE);
		logfile = $fopen("../docs/test_logfile.txt","w");

		if (logfile)  $display("File was opened successfully : %0d", logfile);
    	else     $display("File was NOT opened successfully : %0d", logfile);

		set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);
		set_report_severity_file_hier(UVM_INFO, logfile);
		set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
		set_report_severity_file_hier(UVM_ERROR, logfile);
		uvm_report_server::set_server( server );
	endfunction
endclass
