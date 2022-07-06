interface apb_interface(input pclk);
	logic [31:0]paddr;
	logic psel;
	logic penable;
	logic pwrite;
	logic [31:0]pwdata;
	logic pready;
	logic [31:0]prdata;
	
	clocking apb_ck@(posedge pclk);
		input paddr;
		input psel;
		input penable;
		input pwrite;
		input pwdata;
		output pready;
		output prdata;
	endclocking
	
	clocking mon_ck@(posedge pclk);
		input paddr;
		input psel;
		input penable;
		input pwrite;
		input pwdata;
		input pready;
		input prdata;
	endclocking
endinterface