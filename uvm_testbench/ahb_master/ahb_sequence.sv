import uvm_pkg::*;
`include "uvm_macros.svh"
class ahb_sequence_base extends uvm_sequence#(ahb_trans);
	
	ahb_trans req;
	function new(string name = "ahb_sequence_base");
		super.new(name);
	endfunction
	
	`uvm_object_utils(ahb_sequence_base)
	
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

class ahb_write_sequence extends ahb_sequence_base;
	 `uvm_object_utils(ahb_write_sequence)
	 function new(string name = "ahb_write_sequence");
		 super.new(name);
	 endfunction
	 
	 task body();
		 repeat(10)begin
		 `uvm_do_with(req,{req.hwrite==1;req.hreadyin==1;})
		 end
	 endtask
	 
endclass

class ahb_read_sequence extends ahb_sequence_base;
	 `uvm_object_utils(ahb_read_sequence)
	 function new(string name = "ahb_read_sequence");
		 super.new(name);
	 endfunction
	 
	 task body();
		 repeat(5)begin
		 `uvm_do_with(req,{req.hwrite==0;req.hreadyin==1;})
		 end
	 endtask
	 
endclass

class ahb_read_write_sequence extends ahb_sequence_base;
	 `uvm_object_utils(ahb_read_write_sequence)
	 function new(string name = "ahb_read_write_sequence");
		 super.new(name);
	 endfunction
	 
	 task body();
		 `uvm_do_with(req,{req.hreadyin==1;req.hwrite==0;})
		 repeat(50)begin
		 `uvm_do_with(req,{req.hreadyin==1;})
		 end
		 
		 
	 endtask
	 
endclass