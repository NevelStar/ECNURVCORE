//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.08

`include "define.v"

module top(
	input						clk				,
	input						rst_n			,

//with bus

	//address write

	//handshake
	input	      				awready_i		,
	output 	      				awvalid_o		,

	output	[`BUS_AXI_AWID]		awid_o 			,
	output 	[`BUS_ADDR_MEM]		awaddr_o		,

	//burst
	output 	[`BUS_AXI_LEN] 		awlen_o			,
	output 	[`BUS_AXI_SIZE] 	awsize_o		,
	output 	[`BUS_AXI_BURST]	awburst_o		,

	output	[`BUS_AXI_CACHE]	awcache_o		,
	output						awprot_o		,
	output						awqos_o			,
	output						awregion_o		,



	//data write

	//handshake
	input	      				wready_i		,
	output 	      				wvalid_o		,

	output 	[`BUS_DATA_MEM]		wdata_o			,
	output 	[`BUS_AXI_STRB] 	wstrb_o			,

	//burst
	output 	      				wlast_o			,



	//write response
	input	[`BUS_AXI_BID]		bid_i_o 		,
	input	[`BUS_AXI_RESP]		bresp_i			,

	//handshake
	input						bvalid_i		,
	output						bready_o		,
			


	//address read

	//handshake
	input	      				arready_i		,
	output 	      				arvalid_o		,

	output	[`BUS_AXI_ARID]		arid_o 			,
	output 	[`BUS_ADDR_MEM]		araddr_o		,

	//burst
	output 	[`BUS_AXI_LEN] 		arlen_o			,
	output 	[`BUS_AXI_SIZE] 	arsize_o		,
	output 	[`BUS_AXI_BURST]	arburst_o		,

	output	[`BUS_AXI_CACHE]	arcache_o		,
	output						arprot_o		,
	output						arqos_o			,
	output						arregion_o		,



	//data read
	input	[`BUS_AXI_RID] 		rid_i 			,
	input	[`BUS_DATA_MEM]		rdata_i			,
	input	[`BUS_AXI_RESP]		rresp_i			,

	//burst
	input	      				rlast_i			,
	
	//handshake
	input						rvalid_i 		,
	output						rready_o

);
	wire [`BUS_DATA_MEM] data_mem_wr;
	wire [`BUS_DATA_MEM] data_mem_rd;
	wire [`BUS_ADDR_MEM] addr_mem_wr;
	wire [`BUS_ADDR_MEM] addr_mem_rd;
	wire mem_wr_en;
	wire mem_rd_en;
	wire stall_load;
    wire stall_store;


	wire [`BUS_DATA_INSTR] instr;
	wire [`BUS_ADDR_MEM] addr_instr;
	wire [`BUS_ADDR_MEM] pc;
	wire instr_rd_en;






	core ecnurvcore(
		.clk			(clk),
		.rst_n			(rst_n),

		.stall_load		(stall_load),
		.stall_store	(stall_store),

		.instr_i 		(instr),
		.addr_instr_i 	(addr_instr),
		.data_mem_i		(data_mem_rd),



		.mem_wr_en_o	(mem_wr_en),
		.mem_rd_en_o	(mem_rd_en),
		.instr_rd_en_o	(instr_rd_en),
		.data_mem_wr_o	(data_mem_wr),	
		.addr_mem_wr_o	(addr_mem_wr),	
		.addr_mem_rd_o	(addr_mem_rd),	
		.pc_o			(pc)
	

	);




	axi_core_mem core_mem(
		.clk			(clk),
		.rst_n			(rst_n),
		.stall_load		(stall_load),
		.stall_store	(stall_store),
	

		.addr_mem_wr	(addr_mem_wr),
		.addr_mem_rd	(addr_mem_rd),
		.data_mem_wr	(data_mem_wr),
		.mem_wr_en		(mem_wr_en),
		.mem_rd_en		(mem_rd_en),			
		.data_mem_rd	(data_mem_rd),
	    .pc				(pc),
	    .instr_rd_en	(instr_rd_en),
	    .instr 			(instr),
	    .addr_instr		(addr_instr),


		.awready		(awready_i),
		.awvalid		(awvalid_o),

		.awid 			(awid_o),
		.awaddr			(awaddr_o),


		.awlen			(awlen_o),
		.awsize			(awsize_o),
		.awburst		(awburst_o),

		.awcache		(awcache_o),
		.awprot			(awprot_o),
		.awqos			(awqos_o),
		.awregion		(awregion_o),

		.wready			(wready_i),
		.wvalid			(wvalid_o),

		.wdata			(wdata_o),
		.wstrb			(wstrb_o),

		.wlast			(wlast_o),

		.bid 			(bid_i_o),
		.bresp			(bresp_i),

		.bvalid			(bvalid_i),
		.bready			(bready_o),

		.arready		(arready_i),
		.arvalid		(arvalid_o),

		.arid 			(arid_o),
		.araddr			(araddr_o),

		.arlen			(arlen_o),
		.arsize			(arsize_o),
		.arburst		(arburst_o),

		.arcache		(arcache_o),
		.arprot			(arprot_o),
		.arqos			(arqos_o),
		.arregion		(arregion_o),


		.rid 			(rid_i),
		.rdata			(rdata_i),
		.rresp			(rresp_i),

		.rlast			(rlast_i),

		.rvalid 		(rvalid_i ),
		.rready 		(rready_o)

);



endmodule