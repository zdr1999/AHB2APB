class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)
	
	function new(string name = "apb_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	apb_trans apb_mon_trans;
	uvm_analysis_port #(apb_trans)	ap;
	virtual apb_interface vif;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_mon_trans = apb_trans::type_id::create("apb_mon_trans");
		ap = new("ap", this);
		if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
		`uvm_fatal("apb_monitor", "Error in Getting interface")
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			@(vif.mon_ck);
			if(vif.mon_ck.penable & vif.mon_ck.psel)begin
				apb_mon_trans.paddr = vif.mon_ck.paddr;
				apb_mon_trans.pwrite = vif.mon_ck.pwrite;
				apb_mon_trans.prdata = vif.mon_ck.prdata;
				apb_mon_trans.pwdata = vif.mon_ck.pwdata;
				//apb_mon_trans.print();
				ap.write(apb_mon_trans);
			end
			else ;
			end
	endtask
endclass