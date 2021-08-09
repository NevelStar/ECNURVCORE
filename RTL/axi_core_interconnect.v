//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.05

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

	//burst
	output 	[7:0] 				awlen			,
	output 	[2:0] 				awsize			,
	output 	[1:0] 				awburst			,

	output	[`BUS_AXI_CACHE]	awcache			,
	output						awprot			,
	output						awqos			,
	output						awregion		,



	//data write

	//handshake
	input	      				wready			,
	output 	      				wvalid			,

	output 	[`BUS_DATA_MEM]		wdata			,
	output 	[`BUS_AXI_STRB] 	wstrb			,

	//burst
	output 	      				wlast			,



	//write response
	input						bid 			,
	input						bresp			,

	//handshake
	input						bvalid			,
	output						bready			,
			


	//address read

	//handshake
	input	      				arready			,
	output 	      				arvalid			,

	output						arid 			,
	output 	[`BUS_ADDR_MEM]		araddr			,

	//burst
	output 	[7:0] 				arlen			,
	output 	[2:0] 				arsize			,
	output 	[1:0] 				arburst			,

	output	[`BUS_AXI_CACHE]	arcache			,
	output						arprot			,
	output						arqos			,
	output						arregion		,



	//data read
	input	      				rid 			,
	input	[`BUS_DATA_MEM]		rdata			,
	input						rresp			,

	//burst
	input	      				rlast			,
	
	//handshake
	input						rvalid 			,
	output						rready




);


	assign araddr = pc;

	assign instr = rdata[`BUS_DATA_INSTR] & rvalid;



endmodule