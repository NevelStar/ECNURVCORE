//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.08

`include "define.v"

module axi_core_if(
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

	//type-s
	assign awvalid = mem_wr_en;
	assign awaddr = addr_mem_wr;
	assign wvalid = awvalid & awready;
	assign wdata = data_mem_wr;
	assign wstrb = `WR_STR_ALL;


	
	//type-l
	assign araddr = addr_mem_rd;
	assign arvalid = mem_rd_en;
	assign rready = mem_rd_en;
	assign data_mem_rd = rdata & rvalid;




endmodule