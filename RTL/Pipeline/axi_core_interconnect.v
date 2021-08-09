//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.08

`include "define.v"

module axi_core_interconnect(
	input						clk				,
	input						rst_n			,
	
	

	//with core

	//store/load
	input	[`BUS_ADDR_MEM]		addr_mem_wr		,	
	input	[`BUS_ADDR_MEM]		addr_mem_rd		,	
	input	[`BUS_DATA_MEM]		data_mem_wr		,	
	input						mem_wr_en		,	
	input						mem_rd_en		,					
	output	[`BUS_DATA_MEM]		data_mem_rd		,


	output 						core_stall		,


	//instruction fetch
	input	[`BUS_ADDR_MEM]		pc				,	
	input						instr_rd_en		,	

	output 	[`BUS_ADDR_MEM]		instr_addr		,
	output 	[`BUS_ADDR_MEM]		instr			,
	

	//with bus

	//address write

	//handshake
	input	      				awready			,
	output 	      				awvalid			,

	output						awid 			,
	output 	[`BUS_ADDR_MEM]		awaddr			,




	//data write

	//handshake
	input	      				wready			,
	output 	      				wvalid			,

	output 	[`BUS_DATA_MEM]		wdata			,
	output 	[`BUS_AXI_STRB] 	wstrb			,




	//write response
	input						bresp			,

	//handshake
	input						bvalid			,
	output						bready			,
			


	//address read

	//handshake
	input	      				arready			,
	output 	      				arvalid			,

	output 	[`BUS_ADDR_MEM]		araddr			,



	//data read
	input	[`BUS_DATA_MEM]		rdata			,
	input						rresp			,

	
	//handshake
	input						rvalid 			,
	output						rready




);

	//type-s
	assign awvalid = (mem_wr_en == `MEM_WR_EN) ? 1'b1 : 1'b0;
	assign awaddr = addr_mem_wr;
	assign wvalid = awvalid & awready;
	assign wdata = data_mem_wr;
	assign wstrb = `WR_STR_ALL;


	
	//type-l
	assign araddr = addr_mem_rd;
	assign arvalid = (mem_rd_en == `MEM_RD_EN) ? 1'b1 : 1'b0;;
	assign rready = 1'b1;
	assign data_mem_rd = rdata & rvalid;




endmodule