//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.08

`include "define.v"

module top(
	input	clk		,
	input	rst_n	,
);

	wire [`BUS_DATA_MEM] data_mem_wr;
	wire [`BUS_DATA_MEM] data_mem_rd;
	wire [`BUS_ADDR_MEM] addr_mem_wr;
	wire [`BUS_ADDR_MEM] addr_mem_rd;
	wire mem_wr_en;
	wire mem_rd_en;


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
	wire [`BUS_ADDR_MEM] awaddr;
	wire [`BUS_ADDR_MEM] araddr;
	wire [`BUS_DATA_MEM] wdata;
	wire [`BUS_DATA_MEM] rdata;
	wire [`BUS_AXI_STRB] wstrb;

	core ecnurvcore(
		.clk			(clk),
		.rst_n			(rst_n),

		.stall			(1'b0),

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

	bus_core bus(
		.clk			(clk),
	
		.mem_wr_en_i	(1'b0),
		.mem_rd_en_i	(1'b0),
		.instr_rd_en_i	(instr_rd_en),
		.data_mem_wr_i	(64'd0),	
		.addr_mem_wr_i	(64'd0),
		.addr_mem_rd_i	(64'd0),
		.addr_instr_i	(pc),		
	
		.data_instr_o	(instr),
		.addr_instr_o 	(addr_instr),
		.data_mem_rd_o	()
		
	
	);


	axi_core_mem core_mem(
		.clk			(clk),
		.rst_n			(rst_n),
	

		.addr_mem_wr	(addr_mem_wr),	
		.addr_mem_rd	(addr_mem_rd),	
		.data_mem_wr	(data_mem_wr),	
		.mem_wr_en		(mem_wr_en),	
		.mem_rd_en		(mem_rd_en),					
		.data_mem_rd	(data_mem_rd),


		.awready		(awready),
		.awvalid		(awvalid),

		.awid 			(),
		.awaddr			(awaddr),


		.awlen			(),
		.awsize			(),
		.awburst		(),

		.awcache		(),
		.awprot			(),
		.awqos			(),
		.awregion		(),

		.wready			(wready),
		.wvalid			(wvalid),

		.wdata			(wdata),
		.wstrb			(wstrb),

		.wlast			(),

		.bid 			(),
		.bresp			(),

		.bvalid			(),
		.bready			(),

		.arready		(arready),
		.arvalid		(arvalid),

		.arid 			(),
		.araddr			(araddr),

		.arlen			(),
		.arsize			(),
		.arburst		(),

		.arcache		(),
		.arprot			(),
		.arqos			(),
		.arregion		(),


		.rid 			(),
		.rdata			(rdata),
		.rresp			(),

		.rlast			(),

		.rvalid 		(rvalid),
		.rready 		()

);


	module AXI4RAM(
		.clock			(clk),
		.reset			(!rst_n),
		.io_in_awready	(awready),
		.io_in_awvalid	(awvalid),
		.io_in_awaddr	(awaddr),
		.io_in_wready	(wready),
		.io_in_wvalid	(wvalid),
		.io_in_wdata	(wdata),
		.io_in_wstrb	(wstrb),
		.io_in_wlast	(1'b1),
		.io_in_bvalid	(),
		.io_in_arready	(arready),
		.io_in_arvalid	(arvalid),
		.io_in_araddr	(araddr),
		.io_in_arlen	(),
		.io_in_arsize	(),
		.io_in_arburst	(),
		.io_in_rvalid	(rvalid),
		.io_in_rdata	(rdata),
		.io_in_rlast	()
	);



endmodule