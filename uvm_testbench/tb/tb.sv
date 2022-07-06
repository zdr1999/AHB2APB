module tb;
	import testcase_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	reg hclk,hresetn;
	
	initial begin
		hclk = 0;
		hresetn = 0;
		#30;
		hresetn = 1;
	end
	
	always #2 hclk = ~hclk;
	
	ahb_interface ahb_if(hclk,hresetn);
	apb_interface apb_if(hclk);
	
	
	
	
	ahbtoapb2 uu(
	            .HSEL(ahb_if.hsel),
	            .HADDR(ahb_if.haddr),
	            .HWRITE(ahb_if.hwrite),
	            .HSIZE(ahb_if.hsize),
	            .HBURST(ahb_if.hburst),
	           
	            .HTRANS(ahb_if.htrans),
	          
	            .HREADYIN(ahb_if.hreadyin),
	            .HWDATA(ahb_if.hwdata),
	            .HRESETn(ahb_if.hresetn),
	            .HCLK(ahb_if.hclk),
	          
	            .HREADYOUT(ahb_if.hreadyout),
	            .HRESP(ahb_if.hresp),
	            .HRDATA(ahb_if.hrdata),
	         
	  
	            .PADDR(apb_if.paddr),
	            .PSEL(apb_if.psel),
	            .PENABLE(apb_if.penable),
	            .PWRITE(apb_if.pwrite),
	            .PWDATA(apb_if.pwdata),
	            .PREADY(apb_if.pready),
	            .PRDATA(apb_if.prdata)
	);
	
	
	
	
	initial begin
	uvm_config_db#(virtual ahb_interface)::set(null, "uvm_test_top.env1.ahb_agent", "vif", ahb_if);
	uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.env1.apb_agent", "vif", apb_if);
	
	run_test("");
end
	
	
	
	
	
	
	
	
	
	
	
	
	
endmodule