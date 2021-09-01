//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.09.01

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
	input	[`BUS_AXI_BID]		bid_i     		,
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

	wire		      			awready_if;
	wire	      				awvalid_if;
	wire	[`BUS_AXI_AWID]		awid_if;
	wire	[`BUS_ADDR_MEM]		awaddr_if;
	wire	[`BUS_AXI_LEN] 		awlen_if;
	wire	[`BUS_AXI_SIZE] 	awsize_if;
	wire	[`BUS_AXI_BURST]	awburst_if;
	wire	[`BUS_AXI_CACHE]	awcache_if;
	wire						awprot_if;
	wire						awqos_if;
	wire						awregion_if;
	wire	      				wready_if;
	wire	      				wvalid_if;
	wire	[`BUS_DATA_MEM]		wdata_if;
	wire	[`BUS_AXI_STRB] 	wstrb_if;
	wire	      				wlast_if;
	wire	[`BUS_AXI_BID]		bid_if;
	wire	[`BUS_AXI_RESP]		bresp_if;
	wire						bvalid_if;
	wire						bready_if;
	wire	      				arready_if;
	wire	      				arvalid_if;
	wire	[`BUS_AXI_ARID]		arid_if;
	wire	[`BUS_ADDR_MEM]		araddr_if;
	wire	[`BUS_AXI_LEN] 		arlen_if;
	wire	[`BUS_AXI_SIZE] 	arsize_if;
	wire	[`BUS_AXI_BURST]	arburst_if;
	wire	[`BUS_AXI_CACHE]	arcache_if;
	wire						arprot_if;
	wire						arqos_if;
	wire						arregion_if;
	wire	[`BUS_AXI_RID] 		rid_if;
	wire	[`BUS_DATA_MEM]		rdata_if;
	wire	[`BUS_AXI_RESP]		rresp_if;
	wire	      				rlast_if;
	wire						rvalid_if;
	wire						rready_if;
	wire 	[`BUS_AXI_STRB]		strb_mem_wr;


	wire	[`BUS_ADDR_MEM]		pc;
	wire						instr_rd_en;
	wire	[`BUS_DATA_INSTR]	instr;
	wire	[`BUS_ADDR_MEM]		addr_instr;
	wire	[`BUS_ADDR_MEM]		addr_mem_wr;
	wire	[`BUS_ADDR_MEM]		addr_mem_rd;
	wire	[`BUS_DATA_MEM]		data_mem_wr;
	wire						mem_wr_en;
	wire						mem_rd_en;				
	wire	[`BUS_DATA_MEM]		data_mem_rd;


	wire	      				awready_mem;
	wire 	      				awvalid_mem;
	wire	[`BUS_AXI_AWID]		awid_mem;
	wire 	[`BUS_ADDR_MEM]		awaddr_mem;
	wire 	[`BUS_AXI_LEN] 		awlen_mem;
	wire 	[`BUS_AXI_SIZE] 	awsize_mem;
	wire 	[`BUS_AXI_BURST]	awburst_mem;
	wire	[`BUS_AXI_CACHE]	awcache_mem;
	wire						awprot_mem;
	wire						awqos_mem;
	wire						awregion_mem;
	wire	      				wready_mem;
	wire 	      				wvalid_mem;
	wire 	[`BUS_DATA_MEM]		wdata_mem;
	wire 	[`BUS_AXI_STRB] 	wstrb_mem;
	wire 	      				wlast_mem;
	wire	[`BUS_AXI_BID]		bid_mem;
	wire	[`BUS_AXI_RESP]		bresp_mem;
	wire						bvalid_mem;
	wire						bready_mem;
	wire	      				arready_mem;
	wire 	      				arvalid_mem;
	wire	[`BUS_AXI_ARID]		arid_mem;
	wire 	[`BUS_ADDR_MEM]		araddr_mem;
	wire 	[`BUS_AXI_LEN] 		arlen_mem;
	wire 	[`BUS_AXI_SIZE] 	arsize_mem;
	wire 	[`BUS_AXI_BURST]	arburst_mem;
	wire	[`BUS_AXI_CACHE]	arcache_mem;
	wire						arprot_mem;
	wire						arqos_mem;
	wire						arregion_mem;
	wire	[`BUS_AXI_RID] 		rid_mem;
	wire	[`BUS_DATA_MEM]		rdata_mem;
	wire	[`BUS_AXI_RESP]		rresp_mem;
	wire	      				rlast_mem;
	wire						rvalid_mem;
	wire						rready_mem;



	wire 						stall_if;
	wire 						stall_mem;
	wire 						axi_idle_if;




	core ecnurvcore(
		.clk			(clk),
		.rst_n			(rst_n),

		.stall_if		(stall_if),
		.stall_mem	(stall_mem),

		.instr_i 		(instr),
		.addr_instr_i 	(addr_instr),
		.data_mem_i		(data_mem_rd),
		.axi_idle_if_i	(axi_idle_if),



		.mem_wr_en_o	(mem_wr_en),
		.mem_rd_en_o	(mem_rd_en),
		.instr_rd_en_o	(instr_rd_en),
		.data_mem_wr_o	(data_mem_wr),	
		.strb_mem_wr_o	(strb_mem_wr),
		.addr_mem_wr_o	(addr_mem_wr),	
		.addr_mem_rd_o	(addr_mem_rd),	
		.pc_o			(pc)
	

	);

	if_axi_interface if_interface(
		.clk			(clk),
		.rst_n			(rst_n),
	
		.stall_if 		(stall_if),


		.pc				(pc),
		.instr_rd_en	(instr_rd_en),
		.instr 			(instr),
		.addr_instr		(addr_instr),
		.axi_idle_if	(axi_idle_if),

		.awready_if		(awready_if),
		.awvalid_if		(awvalid_if),
		.awid_if 		(awid_if),
		.awaddr_if		(awaddr_if),
		.awlen_if		(awlen_if),
		.awsize_if		(awsize_if),
		.awburst_if		(awburst_if),
		.awcache_if		(awcache_if),
		.awprot_if		(awprot_if),
		.awqos_if		(awqos_if),
		.awregion_if	(awregion_if),
		.wready_if		(wready_if),
		.wvalid_if		(wvalid_if),
		.wdata_if		(wdata_if),
		.wstrb_if		(wstrb_if),
		.wlast_if		(wlast_if),
		.bid_if			(bid_if),
		.bresp_if		(bresp_if),
		.bvalid_if		(bvalid_if),
		.bready_if		(bready_if),
		.arready_if		(arready_if),
		.arvalid_if		(arvalid_if),
		.arid_if		(arid_if),
		.araddr_if		(araddr_if),
		.arlen_if		(arlen_if),
		.arsize_if		(arsize_if),
		.arburst_if		(arburst_if),
		.arcache_if		(arcache_if),
		.arprot_if		(arprot_if),
		.arqos_if		(arqos_if),
		.arregion_if	(arregion_if),
		.rid_if			(rid_if),
		.rdata_if		(rdata_if),
		.rresp_if		(rresp_if),
		.rlast_if		(rlast_if),
		.rvalid_if 		(rvalid_if),
		.rready_if 		(rready_if)
	);


    mem_axi_interface mem_interface(
		.clk			(clk),
		.rst_n			(rst_n),
	
		.stall_mem		(stall_mem),
	

		//with core
		//store/load
		.addr_mem_wr	(addr_mem_wr),	
		.addr_mem_rd	(addr_mem_rd+64'd1),//to test the unaligned	
		.data_mem_wr	(data_mem_wr),	
		.strb_mem_wr	(strb_mem_wr),
		.mem_wr_en		(mem_wr_en),
		.mem_rd_en		(mem_rd_en),				
		.data_mem_rd	(data_mem_rd),


		.awready_mem	(awready_mem),
		.awvalid_mem	(awvalid_mem),
		.awid_mem		(awid_mem),
		.awaddr_mem		(awaddr_mem),
		.awlen_mem		(awlen_mem),
		.awsize_mem		(awsize_mem),
		.awburst_mem	(awburst_mem),
		.awcache_mem	(awcache_mem),
		.awprot_mem		(awprot_mem),
		.awqos_mem		(awqos_mem),
		.awregion_mem	(awregion_mem),
		.wready_mem		(wready_mem),
		.wvalid_mem		(wvalid_mem),
		.wdata_mem		(wdata_mem),
		.wstrb_mem		(wstrb_mem),
		.wlast_mem		(wlast_mem),
		.bid_mem		(bid_mem),
		.bresp_mem		(bresp_mem),
		.bvalid_mem		(bvalid_mem),
		.bready_mem		(bready_mem),
		.arready_mem	(arready_mem),
		.arvalid_mem	(arvalid_mem),
		.arid_mem		(arid_mem),
		.araddr_mem		(araddr_mem),
		.arlen_mem		(arlen_mem),
		.arsize_mem		(arsize_mem),
		.arburst_mem	(arburst_mem),
		.arcache_mem	(arcache_mem),
		.arprot_mem		(arprot_mem),
		.arqos_mem		(arqos_mem),
		.arregion_mem	(arregion_mem),
		.rid_mem		(rid_mem),
		.rdata_mem		(rdata_mem),
		.rresp_mem		(rresp_mem),
		.rlast_mem		(rlast_mem),
		.rvalid_mem 	(rvalid_mem),
		.rready_mem 	(rready_mem)

	);



	axi_interconnect interconnect(
		.clk			(clk),
		.rst_n			(rst_n),


		//if
		.awready_if		(awready_if),
		.awvalid_if		(awvalid_if),
		.awid_if 		(awid_if),
		.awaddr_if		(awaddr_if),
		.awlen_if		(awlen_if),
		.awsize_if		(awsize_if),
		.awburst_if		(awburst_if),
		.awcache_if		(awcache_if),
		.awprot_if		(awprot_if),
		.awqos_if		(awqos_if),
		.awregion_if	(awregion_if),
		.wready_if		(wready_if),
		.wvalid_if		(wvalid_if),
		.wdata_if		(wdata_if),
		.wstrb_if		(wstrb_if),
		.wlast_if		(wlast_if),
		.bid_if			(bid_if),
		.bresp_if		(bresp_if),
		.bvalid_if		(bvalid_if),
		.bready_if		(bready_if),
		.arready_if		(arready_if),
		.arvalid_if		(arvalid_if),
		.arid_if		(arid_if),
		.araddr_if		(araddr_if),
		.arlen_if		(arlen_if),
		.arsize_if		(arsize_if),
		.arburst_if		(arburst_if),
		.arcache_if		(arcache_if),
		.arprot_if		(arprot_if),
		.arqos_if		(arqos_if),
		.arregion_if	(arregion_if),
		.rid_if			(rid_if),
		.rdata_if		(rdata_if),
		.rresp_if		(rresp_if),
		.rlast_if		(rlast_if),
		.rvalid_if 		(rvalid_if),
		.rready_if 		(rready_if),
	
		//mem
		.awready_mem	(awready_mem),
		.awvalid_mem	(awvalid_mem),
		.awid_mem		(awid_mem),
		.awaddr_mem		(awaddr_mem),
		.awlen_mem		(awlen_mem),
		.awsize_mem		(awsize_mem),
		.awburst_mem	(awburst_mem),
		.awcache_mem	(awcache_mem),
		.awprot_mem		(awprot_mem),
		.awqos_mem		(awqos_mem),
		.awregion_mem	(awregion_mem),
		.wready_mem		(wready_mem),
		.wvalid_mem		(wvalid_mem),
		.wdata_mem		(wdata_mem),
		.wstrb_mem		(wstrb_mem),
		.wlast_mem		(wlast_mem),
		.bid_mem		(bid_mem),
		.bresp_mem		(bresp_mem),
		.bvalid_mem		(bvalid_mem),
		.bready_mem		(bready_mem),
		.arready_mem	(arready_mem),
		.arvalid_mem	(arvalid_mem),
		.arid_mem		(arid_mem),
		.araddr_mem		(araddr_mem),
		.arlen_mem		(arlen_mem),
		.arsize_mem		(arsize_mem),
		.arburst_mem	(arburst_mem),
		.arcache_mem	(arcache_mem),
		.arprot_mem		(arprot_mem),
		.arqos_mem		(arqos_mem),
		.arregion_mem	(arregion_mem),
		.rid_mem		(rid_mem),
		.rdata_mem		(rdata_mem),
		.rresp_mem		(rresp_mem),
		.rlast_mem		(rlast_mem),
		.rvalid_mem 	(rvalid_mem),
		.rready_mem 	(rready_mem),

         
         
		.awready_axi		(awready_i),
		.awvalid_axi		(awvalid_o),
         
		.awid_axi 			(awid_o),
		.awaddr_axi			(awaddr_o),
         
         
		.awlen_axi			(awlen_o),
		.awsize_axi			(awsize_o),
		.awburst_axi		(awburst_o),
         
		.awcache_axi		(awcache_o),
		.awprot_axi			(awprot_o),
		.awqos_axi			(awqos_o),
		.awregion_axi		(awregion_o),
         
		.wready_axi			(wready_i),
		.wvalid_axi			(wvalid_o),
         
		.wdata_axi			(wdata_o),
		.wstrb_axi			(wstrb_o),
         
		.wlast_axi			(wlast_o),
         
		.bid_axi			(bid_i),
		.bresp_axi			(bresp_i),
         
		.bvalid_axi			(bvalid_i),
		.bready_axi			(bready_o),
         
		.arready_axi		(arready_i),
		.arvalid_axi		(arvalid_o),
         
		.arid_axi			(arid_o),
		.araddr_axi			(araddr_o),
         
		.arlen_axi			(arlen_o),
		.arsize_axi			(arsize_o),
		.arburst_axi		(arburst_o),
         
		.arcache_axi		(arcache_o),
		.arprot_axi			(arprot_o),
		.arqos_axi			(arqos_o),
		.arregion_axi		(arregion_o),
         
         
		.rid_axi			(rid_i),
		.rdata_axi			(rdata_i),
		.rresp_axi			(rresp_i),
         
		.rlast_axi			(rlast_i),
         
		.rvalid_axi 		(rvalid_i),
		.rready_axi 		(rready_o)

);



endmodule