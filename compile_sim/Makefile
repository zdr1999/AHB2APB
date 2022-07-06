
vcs:
	vcs ../rtl/ahbtoapb2.v \
	        ../uvm_testbench/ahb_master/ahb_interface.sv \
	        ../uvm_testbench/ahb_master/ahb_master_pkg.sv \
	        ../uvm_testbench/apb_slave/apb_interface.sv \
	        ../uvm_testbench/apb_slave/apb_slave_pkg.sv \
	        ../uvm_testbench/tc/testcase_pkg.sv \
	        ../uvm_testbench/tb/tb.sv \
	        +incdir+../uvm_testbench/ahb_master/+../uvm_testbench/apb_slave/ \
	        -ntb_opts uvm \
	        -full64 -sverilog +vc +v2k

run:
	simv +UVM_TESTNAME=read_write_test
	
all: vcs run
