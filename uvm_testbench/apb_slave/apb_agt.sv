class apb_agt extends uvm_agent;
	apb_driver drv;
	apb_sqr   sqr;
	apb_monitor mon;
	uvm_analysis_port#(apb_trans)	ap;
	`uvm_component_utils(apb_agt)
	virtual apb_interface vif; 
	function new(string name = "apb_agt",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
		`uvm_fatal("apb_agt", "Error in Getting interface")
		uvm_config_db#(virtual apb_interface)::set(this,"drv","vif",vif);
		uvm_config_db#(virtual apb_interface)::set(this,"mon","vif",vif);
		ap = new("ap",this);
		//this.ap = this.mon.ap;
		drv = apb_driver::type_id::create("drv",this);
		sqr = apb_sqr::type_id::create("sqr",this);
		mon = apb_monitor::type_id::create("mon",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass