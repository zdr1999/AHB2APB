class ahb_driver extends uvm_driver#(ahb_trans);
	`uvm_component_utils(ahb_driver)
	
	function new(string name = "ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual ahb_interface vif;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ahb_interface)::get(this,"","vif",vif))
		`uvm_fatal("my_driver", "Error in Getting interface")
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			@(vif.ahb_ck);
			if(!vif.ahb_ck.hresetn)begin
				vif.ahb_ck.hsel <= 'bx;
				vif.ahb_ck.haddr <= 'bx;
				vif.ahb_ck.hwrite <= 'bx;
				vif.ahb_ck.hsize <= 'bx;
				vif.ahb_ck.hburst <= 'bx;
				vif.ahb_ck.hreadyin <= 'bx;
				vif.ahb_ck.hwdata <= 'bx;
				vif.ahb_ck.htrans <= 'bx;
				@(vif.ahb_ck);
			end
			else begin
				
				 if(vif.ahb_ck.hreadyout)begin
				seq_item_port.get_next_item(req);
				vif.ahb_ck.hsel <= req.hsel;
				vif.ahb_ck.haddr <= req.haddr;
				vif.ahb_ck.hwrite <= req.hwrite;
				vif.ahb_ck.hsize <= req.hsize;
				vif.ahb_ck.hburst <= req.hburst;
				vif.ahb_ck.hreadyin <= req.hreadyin;
				vif.ahb_ck.hwdata <= req.hwdata;
				vif.ahb_ck.htrans <= req.htrans;
				
				seq_item_port.item_done();
				end
				
					
				end
			end
		
		
	endtask
endclass