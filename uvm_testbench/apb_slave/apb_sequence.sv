import uvm_pkg::*;
`include "uvm_macros.svh"
class apb_sequence_base extends uvm_sequence#(apb_trans);
	apb_trans req;
	
	function new(string name = "apb_sequence_base");
		super.new(name);
	endfunction
	
	`uvm_object_utils(apb_sequence_base)
	
	virtual task pre_body();
		if(starting_phase != null) begin
			starting_phase.raise_objection(this);
		end
	endtask
	
	virtual task post_body();
		if(starting_phase != null) begin
			starting_phase.drop_objection(this);
		end
	endtask
endclass

class apb_write_sequence extends apb_sequence_base;
	`uvm_object_utils(apb_write_sequence)
	 function new(string name = "apb_write_sequence");
		 super.new(name);
	 endfunction
	 
	 task body();
		 forever begin
		 `uvm_do_with(req,{req.prdata==0;req.pready==1;})
		 end
	 endtask
endclass
	 
class apb_read_sequence extends apb_sequence_base;
	`uvm_object_utils(apb_read_sequence)
	 function new(string name = "apb_read_sequence");
		 super.new(name);
	 endfunction
	 
	 task body();
		repeat(15) begin
		 `uvm_do_with(req,{req.pready==1;})
		 end
	 endtask
endclass
class apb_read_write_sequence extends apb_sequence_base;
	`uvm_object_utils(apb_read_write_sequence)
	 function new(string name = "apb_read_write_sequence");
		 super.new(name);
	 endfunction
	 
	 task body();
		repeat(50) begin
		 `uvm_do_with(req,{req.pready==1;})
		 end
	 endtask
endclass