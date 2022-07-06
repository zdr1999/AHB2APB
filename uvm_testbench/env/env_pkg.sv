//package env_pkg;
//import ahb_master_pkg::*;
//import apb_slave_pkg::*;
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class env extends uvm_env;
	apb_agt apb_agent;
	ahb_agt ahb_agent;
	ahbtoapb_scb scb;
	uvm_tlm_analysis_fifo #(ahb_trans)	ahb_fifo;
	uvm_tlm_analysis_fifo #(apb_trans)	apb_fifo;
	`uvm_component_utils(env);
	
	function new(string name = "env",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_agent = apb_agt::type_id::create("apb_agent",this);
		ahb_agent = ahb_agt::type_id::create("ahb_agent",this);
		scb = ahbtoapb_scb::type_id::create("scb",this);
		ahb_fifo	= new("ahb_fifo", this);
	    apb_fifo	= new("apb_fifo", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	ahb_agent.mon.ap.connect(ahb_fifo.analysis_export);
	apb_agent.mon.ap.connect(apb_fifo.analysis_export);
	
	scb.ahb_port.connect(ahb_fifo.blocking_get_export);
	scb.apb_port.connect(apb_fifo.blocking_get_export);
endfunction
endclass
//endpackage