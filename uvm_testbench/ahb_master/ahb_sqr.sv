//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/04/2020
// Filename: 		ahbl_mst_sqr.svh
// class Name: 		ahbl_mst_sqr
// Project Name: 	ahb2apb_bridge


class ahb_sqr extends uvm_sequencer#(ahb_trans);
	
	
	`uvm_component_utils(ahb_sqr)
		
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahb_sqr", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	


endclass

//Constructor
function ahb_sqr::new(string name = "ahb_sqr", uvm_component parent);
	super.new(name, parent);
endfunction

function void ahb_sqr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

