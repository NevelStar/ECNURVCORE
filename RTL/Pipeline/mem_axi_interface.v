//ECNURVCORE
//AXI Bus master-slave
//Created by Chesed
//2021.08.12
//Edited in 2021.08.30

`include "define.v"

module mem_axi_interface(
	input						clk				,
	input						rst_n			,
	
	output						stall_mem		,
	

	//with core

	//store/load
	input	[`BUS_ADDR_MEM]		addr_mem_wr		,	
	input	[`BUS_ADDR_MEM]		addr_mem_rd		,	
	input	[`BUS_DATA_MEM]		data_mem_wr		,	
	input						mem_wr_en		,	
	input						mem_rd_en		,
	input 						strb_mem_wr		,			
	output	[`BUS_DATA_MEM]		data_mem_rd		,





//with bus

	//address write

	//handshake
	input	      				awready_mem		,
	output 	      				awvalid_mem		,

	output	[`BUS_AXI_AWID]		awid_mem		,
	output 	[`BUS_ADDR_MEM]		awaddr_mem		,

	//burst
	output 	[`BUS_AXI_LEN] 		awlen_mem		,
	output 	[`BUS_AXI_SIZE] 	awsize_mem		,
	output 	[`BUS_AXI_BURST]	awburst_mem		,

	output	[`BUS_AXI_CACHE]	awcache_mem		,
	output						awprot_mem		,
	output						awqos_mem		,
	output						awregion_mem	,



	//data write

	//handshake
	input	      				wready_mem		,
	output 	      				wvalid_mem		,

	output 	[`BUS_DATA_MEM]		wdata_mem		,
	output 	[`BUS_AXI_STRB] 	wstrb_mem		,

	//burst
	output 	      				wlast_mem		,



	//write response
	input	[`BUS_AXI_BID]		bid_mem			,
	input	[`BUS_AXI_RESP]		bresp_mem		,

	//handshake
	input						bvalid_mem		,
	output						bready_mem		,
			


	//address read

	//handshake
	input	      				arready_mem		,
	output 	      				arvalid_mem		,

	output	[`BUS_AXI_ARID]		arid_mem		,
	output 	[`BUS_ADDR_MEM]		araddr_mem		,

	//burst
	output 	[`BUS_AXI_LEN] 		arlen_mem		,
	output 	[`BUS_AXI_SIZE] 	arsize_mem		,
	output 	[`BUS_AXI_BURST]	arburst_mem		,

	output	[`BUS_AXI_CACHE]	arcache_mem		,
	output						arprot_mem		,
	output						arqos_mem		,
	output						arregion_mem	,



	//data read
	input	[`BUS_AXI_RID] 		rid_mem			,
	input	[`BUS_DATA_MEM]		rdata_mem		,
	input	[`BUS_AXI_RESP]		rresp_mem		,

	//burst
	input	      				rlast_mem		,
	
	//handshake
	input						rvalid_mem 		,
	output						rready_mem
);


	reg mem_awhandshake_t;
	reg bvalid_t;
	reg rlast_t;
	reg mem_rd_en_t;


	reg [`BUS_DATA_MEM] data_wr;
	wire [`BUS_DATA_MEM] rdata_act;
	wire mem_awhandshake;


    //id set
    assign awid_mem = `AXI_ID_MEM;
    assign arid_mem = `AXI_ID_MEM;
    
    
	//burst set
	assign awlen_mem = `AXI_LEN_ZERO;
	assign awsize_mem = `AXI_SIZE_DOUBLE;
	assign awburst_mem = `AXI_BURST_FIX;

	assign arlen_mem = `AXI_LEN_ZERO;
	assign arsize_mem = `AXI_SIZE_DOUBLE;
	assign arburst_mem = `AXI_BURST_FIX;


	//type-s
	assign awvalid_mem = mem_wr_en & (!bvalid_t);
	assign mem_awhandshake = awvalid_mem & awready_mem;

	assign wvalid_mem = mem_awhandshake_t;
    assign wlast_mem = wvalid_mem;
    assign bready_mem = `AXI_READY_EN;
	assign stall_mem = (awvalid_mem & (~awready_mem)) | (arvalid_mem & (~arready_mem));


	assign awaddr_mem = addr_mem_wr + `BASE_MEM;
	assign wdata_mem = (mem_wr_en == `MEM_WR_EN) ? data_mem_wr : data_wr ;
	assign wstrb_mem = strb_mem_wr;


	
	//type-l

	assign araddr_mem = addr_mem_rd + `BASE_MEM;
	assign arvalid_mem = mem_rd_en & (!rlast_t);
	assign rready_mem = mem_rd_en_t;
	assign rdata_act = (rvalid_mem == `AXI_VALID_EN) ? rdata_mem : `ZERO_DOUBLE;

	assign data_mem_rd = rdata_act;



	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			mem_awhandshake_t <= `HANDSHAKE_DIS;
			bvalid_t <= `AXI_VALID_DIS;
			rlast_t <= `AXI_VALID_DIS;
		end
		else begin
			mem_awhandshake_t <= mem_awhandshake;	
			bvalid_t <= bvalid_mem;
			rlast_t <= rlast_mem;
		end
	end	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			mem_rd_en_t <= `MEM_RD_DIS;
		end
		else begin
			mem_rd_en_t <= mem_rd_en;	
		end
	end



	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
		  data_wr <= `ZERO_DOUBLE;
		end
		else begin
		  if(mem_wr_en == `MEM_WR_EN) begin
		      data_wr <= data_mem_wr;
		  end
		  else begin
		      data_wr <= data_wr;
		  end
		end
    end

endmodule