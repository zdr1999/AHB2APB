package testcase_pkg;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import ahb_master_pkg::*;
	import apb_slave_pkg::*;
	`include "../env/ahbtoapb_scb.sv"
	`include "../env/env_pkg.sv"
	
class test_base extends uvm_test;
	 env env1;
	`uvm_component_utils(test_base)
	
	function new(string name= "test_base",uvm_component parent);
		super.new(name,parent);
	endfunction
	 
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env1= env::type_id::create("env1",this);
	endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction
	
	task run_phase(uvm_phase phase);
		//phase.phase_done.set_drain_time(this,1us);
	endtask
	
endclass

class write_test extends test_base;
	apb_write_sequence    p_w_s;
	ahb_write_sequence    h_w_s;
	`uvm_component_utils(write_test)
	
	function new(string name = "write_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		p_w_s = apb_write_sequence::type_id::create("p_w_s");
		h_w_s = ahb_write_sequence::type_id::create("h_w_s");
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		super.run_phase(phase);
		fork
		
			p_w_s.start(env1.apb_agent.sqr);
			h_w_s.start(env1.ahb_agent.sqr);
				
		join_any
		
		phase.drop_objection(this);
	endtask
endclass

class read_test extends test_base;
	apb_read_sequence    p_r_s;
	ahb_read_sequence    h_r_s;
	`uvm_component_utils(read_test)
	
	function new(string name = "read_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		p_r_s = apb_read_sequence::type_id::create("p_r_s");
		h_r_s = ahb_read_sequence::type_id::create("h_r_s");
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		super.run_phase(phase);
		fork
		
			p_r_s.start(env1.apb_agent.sqr);
			h_r_s.start(env1.ahb_agent.sqr);
				
		join_any
		
		phase.drop_objection(this);
	endtask
endclass

class read_write_test extends test_base;
	apb_read_write_sequence    p_rw_s;
	ahb_read_write_sequence    h_rw_s;
	`uvm_component_utils(read_write_test)
	
	function new(string name = "read_write_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		p_rw_s = apb_read_write_sequence::type_id::create("p_rw_s");
		h_rw_s = ahb_read_write_sequence::type_id::create("h_rw_s");
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		super.run_phase(phase);
		fork
		
			p_rw_s.start(env1.apb_agent.sqr);
			h_rw_s.start(env1.ahb_agent.sqr);
				
		join
		
		phase.drop_objection(this);
	endtask
endclass

endpackage