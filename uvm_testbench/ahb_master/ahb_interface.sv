interface ahb_interface(input hclk, input hresetn);
	logic hsel;
	logic [31:0] haddr;
	logic hwrite;
	logic [2:0] hsize;
	logic [2:0]hburst;
	logic [1:0]htrans;
	logic hreadyin;
	logic [31:0]hwdata;
	
	logic hreadyout;
	logic [1:0]hresp;
	logic [31:0]hrdata;
	
	clocking ahb_ck@(posedge hclk);
		
		input hresetn;
		output hsel;
		output  haddr;
		output hwrite;
		output hsize;
		output hburst;
		output htrans;
		output hreadyin;
		output hwdata;
		input hreadyout;
		input hresp;
		input hrdata;
	endclocking
	clocking mon_ck@(posedge hclk);
		
		input hresetn;
		input hsel;
		input haddr;
		input hwrite;
		input hsize;
		input hburst;
		input htrans;
		input hreadyin;
		input hwdata;
		input hreadyout;
		input hresp;
		input hrdata;
	endclocking
endinterface