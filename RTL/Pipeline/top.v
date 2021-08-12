//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.08

`include "define.v"

module top(
	input	clk		,
	input	rst_n	
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



	wire wready;
	wire wvalid;
	wire awready;
	wire awvalid;
	wire arready;
	wire arvalid;
	wire rvalid;
	wire rready;
	wire bready;
	wire wlast;
	wire [`BUS_ADDR_MEM] awaddr;
	wire [`BUS_ADDR_MEM] araddr;
	wire [`BUS_DATA_MEM] wdata;
	wire [`BUS_DATA_MEM] rdata;
	wire [`BUS_AXI_STRB] wstrb;
	wire [3:0] awid;
	wire [3:0] arid;
	wire [3:0] bid;
	wire [3:0] rid;
	
	wire [7:0] awlen;
	wire [2:0] awsize;
	wire [1:0] awburst;
	wire [7:0] arlen;
	wire [2:0] arsize;
	wire [1:0] arburst;




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


		.awready		(awready),
		.awvalid		(awvalid),

		.awid 			(awid),
		.awaddr			(awaddr),


		.awlen			(awlen),
		.awsize			(awsize),
		.awburst		(awburst),

		.awcache		(),
		.awprot			(),
		.awqos			(),
		.awregion		(),

		.wready			(wready),
		.wvalid			(wvalid),

		.wdata			(wdata),
		.wstrb			(wstrb),

		.wlast			(wlast),

		.bid 			(bid),
		.bresp			(),

		.bvalid			(),
		.bready			(bready),

		.arready		(arready),
		.arvalid		(arvalid),

		.arid 			(arid),
		.araddr			(araddr),

		.arlen			(arlen),
		.arsize			(arsize),
		.arburst		(arburst),

		.arcache		(),
		.arprot			(),
		.arqos			(),
		.arregion		(),


		.rid 			(rid),
		.rdata			(rdata),
		.rresp			(),

		.rlast			(),

		.rvalid 		(rvalid),
		.rready 		(rready)

);

wire rsta_busy;
wire rstb_busy;

wire [1:0] s_axi_bresp;
wire [1:0] s_axi_rresp;
wire s_axi_rlast;
wire s_axi_bvalid;



blk_mem_gen_0 blk_mem_gen_0_u(
    .rsta_busy(rsta_busy),
    .rstb_busy(rstb_busy),
    .s_aclk(clk),
    .s_aresetn(rst_n),
    .s_axi_awid(awid),
    .s_axi_awaddr(awaddr),
    .s_axi_awlen(awlen),
    .s_axi_awsize(awsize),
    .s_axi_awburst(awburst),
    .s_axi_awvalid(awvalid),
    .s_axi_awready(awready),
    .s_axi_wdata(wdata),
    .s_axi_wstrb(wstrb),
    .s_axi_wlast(wlast),
    .s_axi_wvalid(wvalid),
    .s_axi_wready(wready),
    .s_axi_bid(bid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(bready),
    .s_axi_arid(arid),
    .s_axi_araddr(araddr),
    .s_axi_arlen (arlen),
    .s_axi_arsize(arsize),
    .s_axi_arburst(arburst),
    .s_axi_arvalid(arvalid),
    .s_axi_arready(arready),
    .s_axi_rid(rid),
    .s_axi_rdata (rdata),
    .s_axi_rresp (s_axi_rresp),
    .s_axi_rlast (s_axi_rlast),
    .s_axi_rvalid(rvalid),
    .s_axi_rready(rready)
  );


endmodule