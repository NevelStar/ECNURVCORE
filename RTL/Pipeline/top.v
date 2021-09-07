//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.09.03

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
	output 	[`BUS_AXI_ADDR]		awaddr_o		,
	output 	[`BUS_AXI_LEN] 		awlen_o			,
	output 	[`BUS_AXI_SIZE] 	awsize_o		,
	output 	[`BUS_AXI_BURST]	awburst_o		,
	input	      				wready_i		,
	output 	      				wvalid_o		,
	output 	[`BUS_DATA_MEM]		wdata_o			,
	output 	[`BUS_AXI_STRB] 	wstrb_o			,
	output 	      				wlast_o			,
	input	[`BUS_AXI_BID]		bid_i     		,
	input	[`BUS_AXI_RESP]		bresp_i			,
	input						bvalid_i		,
	output						bready_o		,
	input	      				arready_i		,
	output 	      				arvalid_o		,
	output	[`BUS_AXI_ARID]		arid_o 			,
	output 	[`BUS_AXI_ADDR]		araddr_o		,
	output 	[`BUS_AXI_LEN] 		arlen_o			,
	output 	[`BUS_AXI_SIZE] 	arsize_o		,
	output 	[`BUS_AXI_BURST]	arburst_o		,
	input	[`BUS_AXI_RID] 		rid_i 			,
	input	[`BUS_DATA_MEM]		rdata_i			,
	input	[`BUS_AXI_RESP]		rresp_i			,
	input	      				rlast_i			,
	input						rvalid_i 		,
	output						rready_o		,

	//axi dma slave port
	output		      				io_slave_awready	,
	input     	      				io_slave_awvalid	,
	input     	[`BUS_AXI_ADDR]		io_slave_awaddr		,
	input    	[`BUS_AXI_AWID]		io_slave_awid 		,
	input     	[`BUS_AXI_LEN] 		io_slave_awlen		,
	input     	[`BUS_AXI_SIZE] 	io_slave_awsize		,
	input     	[`BUS_AXI_BURST]	io_slave_awburst	,
	output 		      				io_slave_wready		,
	input     	      				io_slave_wvalid		,
	input     	[`BUS_DATA_MEM]		io_slave_wdata		,
	input     	[`BUS_AXI_STRB] 	io_slave_wstrb		,
	input     	      				io_slave_wlast		,
	input    						io_slave_bready		,
	output 							io_slave_bvalid		,
	output 		[`BUS_AXI_RESP]		io_slave_bresp		,
	output 		[`BUS_AXI_BID]		io_slave_bid		,
	output 		      				io_slave_arready	,
	input  		      				io_slave_arvalid	,
	input  		[`BUS_AXI_ADDR]		io_slave_araddr		,
	input  		[`BUS_AXI_ARID]		io_slave_arid		,
	input  		[`BUS_AXI_LEN] 		io_slave_arlen		,
	input  		[`BUS_AXI_SIZE] 	io_slave_arsize		,
	input  		[`BUS_AXI_BURST]	io_slave_arburst	,
	input    						io_slave_rready 	,
	output 							io_slave_rvalid 	,
	output 		      				io_slave_rlast		,
	output 		[`BUS_AXI_RESP]		io_slave_rresp		,
	output 		[`BUS_DATA_MEM]		io_slave_rdata		,
	output 		[`BUS_AXI_RID] 		io_slave_rid		

);

	wire		      			awready_if;
	wire	      				awvalid_if;
	wire	[`BUS_AXI_AWID]		awid_if;
	wire	[`BUS_ADDR_MEM]		awaddr_if;
	wire	[`BUS_AXI_LEN] 		awlen_if;
	wire	[`BUS_AXI_SIZE] 	awsize_if;
	wire	[`BUS_AXI_BURST]	awburst_if;
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
	wire	[`BUS_AXI_RID] 		rid_mem;
	wire	[`BUS_DATA_MEM]		rdata_mem;
	wire	[`BUS_AXI_RESP]		rresp_mem;
	wire	      				rlast_mem;
	wire						rvalid_mem;
	wire						rready_mem;



	wire 						stall_if;
	wire 						stall_mem;

	wire [`BUS_ADDR_MEM] araddr;
	wire [`BUS_ADDR_MEM] awaddr;
	
	assign awaddr_o = awaddr[31:0];
	assign araddr_o = araddr[31:0];




	core ecnurvcore(
		.clk			(clk),
		.rst_n			(rst_n),

		.stall_if		(stall_if),
		.stall_mem	(stall_mem),

		.instr_i 		(instr),
		.addr_instr_i 	(addr_instr),
		.data_mem_i		(data_mem_rd),



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

		.awready_if		(awready_if),
		.awvalid_if		(awvalid_if),
		.awid_if 		(awid_if),
		.awaddr_if		(awaddr_if),
		.awlen_if		(awlen_if),
		.awsize_if		(awsize_if),
		.awburst_if		(awburst_if),
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
		.addr_mem_rd	(addr_mem_rd),//to test the unaligned	
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

		//axi out
		.awready_axi		(awready_i),
		.awvalid_axi		(awvalid_o),
		.awid_axi 			(awid_o),
		.awaddr_axi			(awaddr),
		.awlen_axi			(awlen_o),
		.awsize_axi			(awsize_o),
		.awburst_axi		(awburst_o),
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
		.araddr_axi			(araddr),
		.arlen_axi			(arlen_o),
		.arsize_axi			(arsize_o),
		.arburst_axi		(arburst_o),
		.rid_axi			(rid_i),
		.rdata_axi			(rdata_i),
		.rresp_axi			(rresp_i),
		.rlast_axi			(rlast_i),
		.rvalid_axi 		(rvalid_i),
		.rready_axi 		(rready_o),

		//timer
		
		.awready_timer		(),
		.awvalid_timer		(),
		.awid_timer 		(),
		.awaddr_timer		(),
		.awlen_timer		(),
		.awsize_timer		(),
		.awburst_timer		(),
		.wready_timer		(),
		.wvalid_timer		(),
		.wdata_timer		(),
		.wstrb_timer		(),
		.wlast_timer		(),
		.bid_timer			(),
		.bresp_timer		(),
		.bvalid_timer		(),
		.bready_timer		(),
		.arready_timer		(),
		.arvalid_timer		(),
		.arid_timer			(),
		.araddr_timer		(),
		.arlen_timer		(),
		.arsize_timer		(),
		.arburst_timer		(),
		.rid_timer			(),
		.rdata_timer		(),
		.rresp_timer		(),
		.rlast_timer		(),
		.rvalid_timer 		(),
		.rready_timer 		()

);



endmodule