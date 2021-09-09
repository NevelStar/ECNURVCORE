//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.09.03

`include "define.v"

module top(
	input						clk				,
	input						rst_n			,
	input 						io_interrupt	,
//with bus

	//address write

	//handshake
	input	      					io_master_awready	,
	output 	      					io_master_awvalid	,
	output		[`BUS_AXI_AWID]		io_master_awid 		,
	output 		[`BUS_AXI_ADDR]		io_master_awaddr	,
	output 		[`BUS_AXI_LEN] 		io_master_awlen		,
	output 		[`BUS_AXI_SIZE] 	io_master_awsize	,
	output 		[`BUS_AXI_BURST]	io_master_awburst	,
	input		      				io_master_wready	,
	output 		      				io_master_wvalid	,
	output 		[`BUS_DATA_MEM]		io_master_wdata		,
	output 		[`BUS_AXI_STRB] 	io_master_wstrb		,
	output 		      				io_master_wlast		,
	input		[`BUS_AXI_BID]		io_master_bid     	,
	input		[`BUS_AXI_RESP]		io_master_bresp		,
	input							io_master_bvalid	,
	output							io_master_bready	,
	input		      				io_master_arready	,
	output 		      				io_master_arvalid	,
	output		[`BUS_AXI_ARID]		io_master_arid 		,
	output 		[`BUS_AXI_ADDR]		io_master_araddr	,
	output 		[`BUS_AXI_LEN] 		io_master_arlen		,
	output 		[`BUS_AXI_SIZE] 	io_master_arsize	,
	output 		[`BUS_AXI_BURST]	io_master_arburst	,
	input		[`BUS_AXI_RID] 		io_master_rid 		,
	input		[`BUS_DATA_MEM]		io_master_rdata		,
	input		[`BUS_AXI_RESP]		io_master_rresp		,
	input	      					io_master_rlast		,
	input							io_master_rvalid 	,
	output							io_master_rready	,

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
	
	//Timer AXI4-lite interface
	wire [`ADDR_WIDTH-1:0] timer_saxi_awaddr;
	wire timer_saxi_awvaild;
	wire timer_saxi_awready;

	wire [`ADDR_WIDTH-1:0] timer_saxi_araddr;
	wire timer_saxi_arvaild;
	wire timer_saxi_arready;

	wire timer_saxi_wvaild;
	wire timer_saxi_wready;
	wire [`DATA_WIDTH-1:0] timer_saxi_wdata;

	wire timer_saxi_rvaild;
	wire timer_saxi_rready;
	wire [`DATA_WIDTH-1:0] timer_saxi_rdata;

	wire timer_saxi_bvaild;
	wire timer_saxi_bready;
	wire time_irq_o;

	assign io_master_awaddr = awaddr[31:0];
	assign io_master_araddr = araddr[31:0];




	core ecnurvcore(
		.clk			(clk),
		.rst_n			(rst_n),

		.stall_if		(stall_if),
		.stall_mem	(stall_mem),

		.instr_i 		(instr),
		.addr_instr_i 	(addr_instr),
		.data_mem_i		(data_mem_rd),

		.tmr_irq_i		(time_irq_o),
		.ext_irq_i		(io_interrupt),

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

	timer u_timer(
		.clk          (clk          ),
		.rst          (rst          ),
		.saxi_awaddr  (timer_saxi_awaddr  ),
		.saxi_awvaild (timer_saxi_awvaild ),
		.saxi_awready (timer_saxi_awready ),
		.saxi_araddr  (timer_saxi_araddr  ),
		.saxi_arvaild (timer_saxi_arvaild ),
		.saxi_arready (timer_saxi_arready ),
		.saxi_wvaild  (timer_saxi_wvaild  ),
		.saxi_wready  (timer_saxi_wready  ),
		.saxi_wdata   (timer_saxi_wdata   ),
		.saxi_rvaild  (timer_saxi_rvaild  ),
		.saxi_rready  (timer_saxi_rready  ),
		.saxi_rdata   (timer_saxi_rdata   ),
		.saxi_bvaild  (timer_saxi_bvaild  ),
		.saxi_bready  (timer_saxi_bready  ),
		.time_irq_o   (time_irq_o   )
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
		//.arcache_if		(arcache_if),
		//.arprot_if		(arprot_if),
		//.arqos_if		(arqos_if),
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
		//.arcache_mem	(arcache_mem),
		//.arprot_mem		(arprot_mem),
		//.arqos_mem		(arqos_mem),
		//.arregion_mem	(arregion_mem),
		.rid_mem		(rid_mem),
		.rdata_mem		(rdata_mem),
		.rresp_mem		(rresp_mem),
		.rlast_mem		(rlast_mem),
		.rvalid_mem 	(rvalid_mem),
		.rready_mem 	(rready_mem),

		//axi out
		.awready_axi		(io_master_awready),
		.awvalid_axi		(io_master_awvalid),
		.awid_axi 			(io_master_awid),
		.awaddr_axi			(awaddr),
		.awlen_axi			(io_master_awlen),
		.awsize_axi			(io_master_awsize),
		.awburst_axi		(io_master_awburst),
		.wready_axi			(io_master_wready),
		.wvalid_axi			(io_master_wvalid),
		.wdata_axi			(io_master_wdata),
		.wstrb_axi			(io_master_wstrb),
		.wlast_axi			(io_master_wlast),
		.bid_axi			(io_master_bid),
		.bresp_axi			(io_master_bresp),
		.bvalid_axi			(io_master_bvalid),
		.bready_axi			(io_master_bready),
		.arready_axi		(io_master_arready),
		.arvalid_axi		(io_master_arvalid),
		.arid_axi			(io_master_arid),
		.araddr_axi			(araddr),
		.arlen_axi			(io_master_arlen),
		.arsize_axi			(io_master_arsize),
		.arburst_axi		(io_master_arburst),
		.rid_axi			(io_master_rid),
		.rdata_axi			(io_master_rdata),
		.rresp_axi			(io_master_rresp),
		.rlast_axi			(io_master_rlast),
		.rvalid_axi 		(io_master_rvalid),
		.rready_axi 		(io_master_rready),

		//timer
		
		.awready_timer		(timer_saxi_awready),
		.awvalid_timer		(timer_saxi_awvaild),
		.awid_timer 		(),
		.awaddr_timer		(timer_saxi_awaddr),
		.awlen_timer		(),
		.awsize_timer		(),
		.awburst_timer		(),
		.wready_timer		(timer_saxi_wready),
		.wvalid_timer		(timer_saxi_wvaild),
		.wdata_timer		(timer_saxi_wdata),
		.wstrb_timer		(),
		.wlast_timer		(),
		.bid_timer			(),
		.bresp_timer		(),
		.bvalid_timer		(timer_saxi_bvaild),
		.bready_timer		(timer_saxi_bready),
		.arready_timer		(timer_saxi_arready),
		.arvalid_timer		(timer_saxi_arvaild),
		.arid_timer			(),
		.araddr_timer		(timer_saxi_araddr),
		.arlen_timer		(),
		.arsize_timer		(),
		.arburst_timer		(),
		.rid_timer			(),
		.rdata_timer		(timer_saxi_rdata),
		.rresp_timer		(),
		.rlast_timer		(),
		.rvalid_timer 		(timer_saxi_rvaild),
		.rready_timer 		(timer_saxi_rready)

);



endmodule