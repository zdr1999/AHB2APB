import uvm_pkg::*;
`include "uvm_macros.svh"
class apb_driver extends uvm_driver#(apb_trans);
	`uvm_component_utils(apb_driver)
	
	function new(string name = "apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual apb_interface vif;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
		`uvm_fatal("my_driver", "Error in Getting interface")
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		vif.apb_ck.pready  <=1;
		forever begin
			@(vif.apb_ck);
			if(vif.apb_ck.psel & !vif.apb_ck.penable)begin
			seq_item_port.get_next_item(req);
			
			vif.apb_ck.pready <= req.pready;
			vif.apb_ck.prdata <= req.prdata;
				seq_item_port.item_done();
				end
			
			
			
		end
		
	endtask
endclass