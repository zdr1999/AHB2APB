
class ahb_trans extends uvm_sequence_item;
	
	function new(string name = "ahb_trans");
		super.new(name);
	endfunction
	





	rand logic hsel;
	rand logic [31:0] haddr;
	rand logic hwrite;
	rand logic [2:0] hsize;
	rand logic [2:0] hburst;

 

	rand logic [1:0] htrans;
	rand logic  hreadyin;
	rand logic [31:0] hwdata;
	     logic [31:0] hrdata;
	
 
	`uvm_object_utils_begin(ahb_trans)
	 `uvm_field_int(haddr, UVM_ALL_ON)
	 `uvm_field_int(hwrite, UVM_ALL_ON | UVM_UNSIGNED)
	 `uvm_field_int(hwdata, UVM_ALL_ON)
	 `uvm_field_int(hrdata, UVM_ALL_ON)
 `uvm_object_utils_end
	
	
	constraint c_hsel {
		hsel == 1;
	}	
	
	constraint c_htrans {
		htrans[1] == 1;
	}
	
endclass