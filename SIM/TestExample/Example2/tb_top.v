`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/11 16:00:50
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top(

    );
    reg clk;
    reg rst_n;
    wire rsta_busy;
    wire rstb_busy;


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
	wire [63:0] awaddr;
	wire [63:0] araddr;
	wire [63:0] wdata;
	wire [63:0] rdata;
	wire [7:0] wstrb;
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
    wire [1:0] s_axi_bresp;
    wire [1:0] s_axi_rresp;
    wire s_axi_rlast;
    wire s_axi_bvalid;
    
    initial begin
        rst_n <= 1'b0;
        clk <= 1'b0;
        #50 rst_n <= 1'b1;
    end
    always # 10 clk <= ~clk;    
    
    top top_u(
		.clk			(clk),
		.rst_n			(rst_n),

	//with bus

	//address write

	//handshake
		.awready_i		(awready),
		.awvalid_o		(awvalid),

		.awid_o 		(awid),
		.awaddr_o		(awaddr),

		.awlen_o		(awlen),
		.awsize_o		(awsize),
		.awburst_o		(awburst),

		.awcache_o		(),
		.awprot_o		(),
		.awqos_o		(),
		.awregion_o		(),



		.wready_i		(wready),
		.wvalid_o		(wvalid),

		.wdata_o		(wdata),
		.wstrb_o		(wstrb),

		.wlast_o		(wlast),



		.bid_i_o 		(),
		.bresp_i		(),


		.bvalid_i		(),
		.bready_o		(bready),


		.arready_i		(arready),
		.arvalid_o		(arvalid),

		.arid_o 		(),
		.araddr_o		(araddr),

		.arlen_o		(arlen),
		.arsize_o		(arsize),
		.arburst_o		(arburst),

		.arcache_o		(),
		.arprot_o		(),
		.arqos_o		(),
		.arregion_o		(),



		.rid_i 			(rid),
		.rdata_i		(rdata),
		.rresp_i		(),

		.rlast_i		(),
	
		.rvalid_i 		(rvalid),
		.rready_o		(rready)

);
     



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
    
    
