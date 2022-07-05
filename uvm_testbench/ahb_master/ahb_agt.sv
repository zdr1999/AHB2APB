class ahb_agt extends uvm_agent;
	ahb_driver drv;
	ahb_sqr   sqr;
	ahb_monitor mon;
	uvm_analysis_port#(ahb_trans)ap;
	`uvm_component_utils(ahb_agt)
	virtual ahb_interface vif;
	function new(string name = "ahb_agt",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ahb_interface)::get(this,"","vif",vif))
		`uvm_fatal("ahb_agt", "Error in Getting interface")
		uvm_config_db#(virtual ahb_interface)::set(this,"drv","vif",vif);
		uvm_config_db#(virtual ahb_interface)::set(this,"mon","vif",vif);
		ap = new("ap",this);
		//this.ap = this.mon.ap;
		drv = ahb_driver::type_id::create("drv",this);
		sqr = ahb_sqr::type_id::create("sqr",this);
		mon = ahb_monitor::type_id::create("mon",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass