import uvm_pkg::*;
`include "uvm_macros.svh"
class apb_trans extends uvm_sequence_item;
	

 

	
	function new(string name = "apb_trans");
		super.new(name);
	endfunction
	
	rand logic pready;
	rand logic [31:0]prdata;
	     logic pwrite;
	     logic [31:0]pwdata;
	     logic [31:0]paddr;
	

 `uvm_object_utils_begin(apb_trans)
	 `uvm_field_int(paddr, UVM_ALL_ON)
	  `uvm_field_int(pwrite, UVM_ALL_ON | UVM_UNSIGNED)
	  `uvm_field_int(pwdata, UVM_ALL_ON)
	 `uvm_field_int(prdata, UVM_ALL_ON)
	
	 
	 
 `uvm_object_utils_end

	
endclass