class ahbtoapb_scb extends uvm_scoreboard;
	uvm_blocking_get_port #(apb_trans) 	apb_port;
	uvm_blocking_get_port #(ahb_trans)	ahb_port;
	
	apb_trans	apb_pkt;
	ahb_trans	ahb_pkt;
	int cntw,cntr,cnt;
	`uvm_component_utils(ahbtoapb_scb)
	function new(string name= "ahbtoapb_scb",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	apb_port = new("apb_port", this);
	ahb_port = new("ahb_port", this);
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		cntw =0;
		cntr=0;
		cnt=0;
		//ahb_port.get(ahb_pkt);
		forever begin
			 ahb_port.get(ahb_pkt);
		     apb_port.get(apb_pkt);
			 
			if((ahb_pkt.hwrite == apb_pkt.pwrite) && (ahb_pkt.hwrite == 1) &&(ahb_pkt.hwdata == apb_pkt.pwdata)&&(ahb_pkt.haddr==apb_pkt.paddr))
				begin
				cntw <= cntw+1;
					//ahb_pkt.print();
					//apb_pkt.print();
				`uvm_info("WRITE_TRANS",$sformatf("this is the %0d write trans and transmit success",cntw),UVM_LOW)
				end
			else if((ahb_pkt.hwrite == apb_pkt.pwrite) && (ahb_pkt.hwrite == 0) &&(ahb_pkt.hrdata == apb_pkt.prdata)&&(ahb_pkt.haddr==apb_pkt.paddr))
				begin
				cntr <= cntr+1;
					//ahb_pkt.print();
					//apb_pkt.print();
				`uvm_info("READ_TRANS",$sformatf("this is the %0d read trans and transmit success",cntr),UVM_LOW)
				end
			else begin
				cnt <=cnt+1;
				//ahb_pkt.print();
				//apb_pkt.print();
				`uvm_info("wrong_trans",$sformatf("%0d transmit failed",cnt),UVM_LOW)
				end
			end
	endtask
	
endclass