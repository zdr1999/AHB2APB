class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)
	logic[31:0] haddr1=0,hwdata1=0;
	
	logic hwrite1=0;
	logic cnt=0;
	function new(string name = "ahb_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	ahb_trans ahb_mon_trans;
	uvm_analysis_port #(ahb_trans)	ap;
	virtual ahb_interface vif;
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ahb_mon_trans = ahb_trans::type_id::create("ahb_mon_trans");
		ap = new("ap", this);
		if(!uvm_config_db#(virtual ahb_interface)::get(this,"","vif",vif))
		`uvm_fatal("ahb_monitor", "Error in Getting interface")
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			@(vif.mon_ck);
			if((vif.mon_ck.hreadyin)==1 & (vif.mon_ck.hreadyout==1) & (vif.mon_ck.hresetn==1) & (vif.mon_ck.hsel==1) & (vif.mon_ck.htrans[1]==1))begin
				if(cnt ==0)begin
					cnt=cnt+1;
					haddr1 <= vif.mon_ck.haddr;
					hwrite1 <= vif.mon_ck.hwrite;
					
				end
				else begin
					haddr1 <= vif.mon_ck.haddr;
					hwrite1 <= vif.mon_ck.hwrite;
					ahb_mon_trans.haddr <= haddr1;
				    ahb_mon_trans.hwrite <= hwrite1;
				    ahb_mon_trans.hwdata <= vif.mon_ck.hwdata;
				    ahb_mon_trans.hrdata <= vif.mon_ck.hrdata;
					#1;//因为是非阻塞赋值，如果不延时的话则会相差一个数据的误差
					//ahb_mon_trans.print();
				    ap.write(ahb_mon_trans);
					
					
					
					end
				
			end
			else ;
			end
	endtask
endclass