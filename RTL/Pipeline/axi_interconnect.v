//ECNURVCORE
//AXI Bus master-slave
//Created by Chesed
//2021.08.12
//Edited in 2021.08.19

`include "define.v"

module axi_interconnect(
	input							clk				,
	input							rst_n			,
	
	//if
	output		      				awready_if		,
	input     	      				awvalid_if		,
	input    	[`BUS_AXI_AWID]		awid_if 		,
	input     	[`BUS_ADDR_MEM]		awaddr_if		,
	input     	[`BUS_AXI_LEN] 		awlen_if		,
	input     	[`BUS_AXI_SIZE] 	awsize_if		,
	input     	[`BUS_AXI_BURST]	awburst_if		,
	input    	[`BUS_AXI_CACHE]	awcache_if		,
	input    						awprot_if		,
	input    						awqos_if		,
	input    						awregion_if		,
	output 		      				wready_if		,
	input     	      				wvalid_if		,
	input     	[`BUS_DATA_MEM]		wdata_if		,
	input     	[`BUS_AXI_STRB] 	wstrb_if		,
	input     	      				wlast_if		,
	output 		[`BUS_AXI_BID]		bid_if			,
	output 		[`BUS_AXI_RESP]		bresp_if		,
	output 							bvalid_if		,
	input    						bready_if		,
	output reg	      				arready_if		,
	input     	      				arvalid_if		,
	input    	[`BUS_AXI_ARID]		arid_if			,
	input     	[`BUS_ADDR_MEM]		araddr_if		,
	input     	[`BUS_AXI_LEN] 		arlen_if		,
	input     	[`BUS_AXI_SIZE] 	arsize_if		,
	input     	[`BUS_AXI_BURST]	arburst_if		,
	input    	[`BUS_AXI_CACHE]	arcache_if		,
	input    						arprot_if		,
	input    						arqos_if		,
	input    						arregion_if		,
	output reg	[`BUS_AXI_RID] 		rid_if			,
	output reg	[`BUS_DATA_MEM]		rdata_if		,
	output reg	[`BUS_AXI_RESP]		rresp_if		,
	output reg	      				rlast_if		,
	output reg						rvalid_if 		,
	input    						rready_if 		,
	
	//mem
	output reg	      				awready_mem		,
	input     	      				awvalid_mem		,
	input    	[`BUS_AXI_AWID]		awid_mem		,
	input     	[`BUS_ADDR_MEM]		awaddr_mem		,
	input     	[`BUS_AXI_LEN] 		awlen_mem		,
	input     	[`BUS_AXI_SIZE] 	awsize_mem		,
	input     	[`BUS_AXI_BURST]	awburst_mem		,
	input    	[`BUS_AXI_CACHE]	awcache_mem		,
	input    						awprot_mem		,
	input    						awqos_mem		,
	input    						awregion_mem	,
	output reg	      				wready_mem		,
	input     	      				wvalid_mem		,
	input     	[`BUS_DATA_MEM]		wdata_mem		,
	input     	[`BUS_AXI_STRB] 	wstrb_mem		,
	input     	      				wlast_mem		,
	output reg	[`BUS_AXI_BID]		bid_mem			,
	output reg	[`BUS_AXI_RESP]		bresp_mem		,
	output reg						bvalid_mem		,
	input    						bready_mem		,
	output reg	      				arready_mem		,
	input     	      				arvalid_mem		,
	input    	[`BUS_AXI_ARID]		arid_mem		,
	input     	[`BUS_ADDR_MEM]		araddr_mem		,
	input     	[`BUS_AXI_LEN] 		arlen_mem		,
	input     	[`BUS_AXI_SIZE] 	arsize_mem		,
	input     	[`BUS_AXI_BURST]	arburst_mem		,
	input    	[`BUS_AXI_CACHE]	arcache_mem		,
	input    						arprot_mem		,
	input    						arqos_mem		,
	input    						arregion_mem	,
	output reg	[`BUS_AXI_RID] 		rid_mem			,
	output reg	[`BUS_DATA_MEM]		rdata_mem		,
	output reg	[`BUS_AXI_RESP]		rresp_mem		,
	output reg	      				rlast_mem		,
	output reg						rvalid_mem 		,
	input    						rready_mem 		,





	//axi out
	input	      					awready_axi		,
	output	reg 	      			awvalid_axi		,
	output	reg	[`BUS_AXI_AWID]		awid_axi 		,
	output	reg	[`BUS_ADDR_MEM]		awaddr_axi		,
	output	reg	[`BUS_AXI_LEN] 		awlen_axi		,
	output	reg	[`BUS_AXI_SIZE] 	awsize_axi		,
	output	reg	[`BUS_AXI_BURST]	awburst_axi		,
	output	reg	[`BUS_AXI_CACHE]	awcache_axi		,
	output	reg						awprot_axi		,
	output	reg						awqos_axi		,
	output	reg						awregion_axi	,
	input	      					wready_axi		,
	output	reg	      				wvalid_axi		,
	output	reg	[`BUS_DATA_MEM]		wdata_axi		,
	output	reg	[`BUS_AXI_STRB] 	wstrb_axi		,
	output	reg	      				wlast_axi		,
	input	[`BUS_AXI_BID]			bid_axi			,
	input	[`BUS_AXI_RESP]			bresp_axi		,
	input							bvalid_axi		,
	output	reg						bready_axi		,
	input	      					arready_axi		,
	output	reg	      				arvalid_axi		,
	output	reg	[`BUS_AXI_ARID]		arid_axi		,
	output	reg	[`BUS_ADDR_MEM]		araddr_axi		,
	output	reg	[`BUS_AXI_LEN] 		arlen_axi		,
	output	reg	[`BUS_AXI_SIZE] 	arsize_axi		,
	output	reg	[`BUS_AXI_BURST]	arburst_axi		,
	output	reg	[`BUS_AXI_CACHE]	arcache_axi		,
	output	reg						arprot_axi		,
	output	reg						arqos_axi		,
	output	reg						arregion_axi	,
	input	[`BUS_AXI_RID] 			rid_axi			,
	input	[`BUS_DATA_MEM]			rdata_axi		,
	input	[`BUS_AXI_RESP]			rresp_axi		,
	input	      					rlast_axi		,
	input							rvalid_axi 		,
	output	reg						rready_axi 		,
	
	input	      					awready_clint	,
	output	reg 	      			awvalid_clint	,
	output	reg	[`BUS_AXI_AWID]		awid_clint 		,
	output	reg	[`BUS_ADDR_MEM]		awaddr_clint	,
	output	reg	[`BUS_AXI_LEN] 		awlen_clint		,
	output	reg	[`BUS_AXI_SIZE] 	awsize_clint	,
	output	reg	[`BUS_AXI_BURST]	awburst_clint	,
	output	reg	[`BUS_AXI_CACHE]	awcache_clint	,
	output	reg						awprot_clint	,
	output	reg						awqos_clint		,
	output	reg						awregion_clint	,
	input	      					wready_clint	,
	output	reg	      				wvalid_clint	,
	output	reg	[`BUS_DATA_MEM]		wdata_clint		,
	output	reg	[`BUS_AXI_STRB] 	wstrb_clint		,
	output	reg	      				wlast_clint		,
	input	[`BUS_AXI_BID]			bid_clint		,
	input	[`BUS_AXI_RESP]			bresp_clint		,
	input							bvalid_clint	,
	output	reg						bready_clint	,
	input	      					arready_clint	,
	output	reg	      				arvalid_clint	,
	output	reg	[`BUS_AXI_ARID]		arid_clint		,
	output	reg	[`BUS_ADDR_MEM]		araddr_clint	,
	output	reg	[`BUS_AXI_LEN] 		arlen_clint		,
	output	reg	[`BUS_AXI_SIZE] 	arsize_clint	,
	output	reg	[`BUS_AXI_BURST]	arburst_clint	,
	output	reg	[`BUS_AXI_CACHE]	arcache_clint	,
	output	reg						arprot_clint	,
	output	reg						arqos_clint		,
	output	reg						arregion_clint	,
	input	[`BUS_AXI_RID] 			rid_clint		,
	input	[`BUS_DATA_MEM]			rdata_clint		,
	input	[`BUS_AXI_RESP]			rresp_clint		,
	input	      					rlast_clint		,
	input							rvalid_clint 	,
	output	reg						rready_clint 		

);

	reg axi_wbusy;
	reg axi_rbusy;


	reg [`BUS_DATA_MEM] rdata_if_t;
	reg [`BUS_DATA_MEM] rdata_mem_t;

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rdata_if_t <= `ZERO_DOUBLE;
		end
		else begin
			rdata_if_t <= rdata_if;
		end
	end		
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rdata_mem_t <= `ZERO_DOUBLE;
		end
		else begin
			rdata_mem_t <= rdata_mem;
		end
	end	


	//write request
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			axi_wbusy <= `AXI_IDLE;
		end
		else begin
			if(axi_wbusy == `AXI_IDLE) begin
				if((awvalid_mem == `AXI_VALID_EN) & (awready_axi == `AXI_READY_EN)) begin
					axi_wbusy <= `AXI_BUSY;
				end
				else begin
					axi_wbusy <= axi_wbusy;
				end
			end
			else begin
				if(bvalid_axi == `AXI_VALID_EN) begin
					axi_wbusy <= `AXI_IDLE;
				end
				else begin
					axi_wbusy <= axi_wbusy;
				end
			end
		end
	end	


	//read request
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			axi_rbusy <= `AXI_IDLE;
		end
		else begin
			if(axi_rbusy == `AXI_IDLE) begin
				if((arvalid_mem == `AXI_VALID_EN) | (arvalid_if == `AXI_VALID_EN)) begin
					axi_rbusy <= `AXI_BUSY;
				end
				else begin
					axi_rbusy <= axi_rbusy;
				end
			end
			else begin
				if(rlast_axi == `AXI_VALID_EN) begin
					axi_rbusy <= `AXI_IDLE;
				end
				else begin
					axi_rbusy <= axi_rbusy;
				end
			end
		end
	end

	assign awready_if = `AXI_READY_DIS;
	assign wready_if = `AXI_READY_DIS;
	assign bid_if = `AXI_ID_ZERO;	
	assign bresp_if = `AXI_VALID_DIS;
	assign bvalid_if = `AXI_VALID_DIS;

	always@(*) begin
		if((awvalid_mem == `AXI_VALID_EN) & (axi_wbusy == `AXI_IDLE)) begin
			awready_mem = rst_n ? `AXI_READY_EN : `AXI_READY_DIS;

			awvalid_axi = awvalid_mem;
			awid_axi = awid_mem;
			awaddr_axi = awaddr_mem;
			awlen_axi = awlen_mem;
			awsize_axi = awsize_mem;
			awburst_axi = awburst_mem;
			awcache_axi = awcache_mem;
			awprot_axi = awprot_mem;
			awqos_axi = awqos_mem;
			awregion_axi = awregion_mem;
		end
		else begin
			awready_mem = rst_n ? !axi_wbusy : `AXI_READY_DIS;

			awvalid_axi = `AXI_VALID_DIS;
			awid_axi = `AXI_ID_ZERO;
			awaddr_axi = `MEM_ADDR_ZERO;
			awlen_axi = awlen_mem;
			awsize_axi = awsize_mem;
			awburst_axi = awburst_mem;
			awcache_axi = awcache_mem;
			awprot_axi = awprot_mem;
			awqos_axi = awqos_mem;
			awregion_axi = awregion_mem;
		end
	end


	always@(*) begin
		if(axi_wbusy == `AXI_BUSY) begin
			wready_mem = wready_axi;

			wvalid_axi = wvalid_mem;
			wdata_axi = wdata_mem;
			wstrb_axi = wstrb_mem;
			wlast_axi = wlast_mem;

			bid_mem = bid_axi;
			bresp_mem = bresp_axi;
			bvalid_mem = bvalid_axi;
			bready_axi = bready_mem;
		end
		else begin
			wready_mem = `AXI_READY_DIS;

			wvalid_axi = `AXI_VALID_DIS;
			wdata_axi = `ZERO_DOUBLE;
			wstrb_axi = `WR_STR_NONE;
			wlast_axi = wlast_mem;

			bid_mem = `AXI_ID_ZERO;
			bresp_mem = `AXI_VALID_DIS;
			bvalid_mem = `AXI_VALID_DIS;
			bready_axi = `AXI_READY_DIS;
		end
	end


	always@(*) begin
		if(axi_rbusy == `AXI_IDLE) begin
			if(arvalid_mem == `AXI_VALID_EN) begin
				arready_mem =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;
				arready_if =  `AXI_READY_DIS;

				arvalid_axi = arvalid_mem;
				arid_axi = arid_mem;
				araddr_axi = araddr_mem;
				arlen_axi = arlen_mem;
				arsize_axi = arsize_mem;
				arburst_axi = arburst_mem;
				arcache_axi = arcache_mem;
				arprot_axi = arprot_mem;
				arqos_axi = arqos_mem;
				arregion_axi = arregion_mem;
			end
			else begin
				if(arvalid_if == `AXI_VALID_EN) begin
					arready_if =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;
					arready_mem =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;

					arvalid_axi = arvalid_if;
					arid_axi = arid_if;
					araddr_axi = araddr_if;
					arlen_axi = arlen_if;
					arsize_axi = arsize_if;
					arburst_axi = arburst_if;
					arcache_axi = arcache_if;
					arprot_axi = arprot_if;
					arqos_axi = arqos_if;
					arregion_axi = arregion_if;
				end
				else begin
					arready_if =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;
					arready_mem =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;

					arvalid_axi = `AXI_VALID_DIS;
					arid_axi = `AXI_ID_ZERO;
					araddr_axi = `MEM_ADDR_ZERO;
					arlen_axi = `AXI_LEN_ZERO;
					arsize_axi = `AXI_SIZE_DOUBLE;
					arburst_axi = `AXI_BURST_FIX;
					arcache_axi = arcache_if;
					arprot_axi = arprot_if;
					arqos_axi = arqos_if;
					arregion_axi = arregion_if;
				end
			end
		end
		else begin
			arready_if = `AXI_READY_DIS;
			arready_mem = `AXI_READY_DIS;

			arvalid_axi = `AXI_VALID_DIS;
			arid_axi = `AXI_ID_ZERO;
			araddr_axi = `MEM_ADDR_ZERO;
			arlen_axi = `AXI_LEN_ZERO;
			arsize_axi = `AXI_SIZE_DOUBLE;
			arburst_axi = `AXI_BURST_FIX;
			arcache_axi = arcache_if;
			arprot_axi = arprot_if;
			arqos_axi = arqos_if;
			arregion_axi = arregion_if;
		end
	end


	always@(*) begin
		if(axi_rbusy == `AXI_BUSY) begin
			if(rready_mem == `AXI_VALID_EN) begin
				rid_mem = rid_axi;
				rdata_mem = rdata_axi;
				rresp_mem = rresp_axi;
				rlast_mem = rlast_axi;
				rvalid_mem = rvalid_axi;

				rid_if = `AXI_ID_ZERO;
				rdata_if = rdata_if_t;
				rresp_if = `AXI_VALID_DIS;
				rlast_if = `AXI_VALID_DIS;
				rvalid_if = `AXI_VALID_EN;

				rready_axi = rready_mem;
			end
			else begin
				if(rready_if == `AXI_VALID_EN) begin
					rid_mem = `AXI_ID_ZERO;
					rdata_mem = `ZERO_DOUBLE;
					rresp_mem = `AXI_VALID_DIS;
					rlast_mem = `AXI_VALID_DIS;
					rvalid_mem = `AXI_VALID_DIS;

					rid_if = rid_axi;
					rdata_if = rdata_axi;
					rresp_if = rresp_axi;
					rlast_if = rlast_axi;
					rvalid_if = rvalid_axi;

					rready_axi = rready_if;
				end
				else begin
					rid_mem = `AXI_ID_ZERO;
					rdata_mem = `ZERO_DOUBLE;
					rresp_mem = `AXI_VALID_DIS;
					rlast_mem = `AXI_VALID_DIS;
					rvalid_mem = `AXI_VALID_DIS;

					rid_if = `AXI_ID_ZERO;
					rdata_if = `ZERO_DOUBLE;
					rresp_if = `AXI_VALID_DIS;
					rlast_if = `AXI_VALID_DIS;
					rvalid_if = `AXI_VALID_DIS;

					rready_axi = `AXI_READY_DIS;
				end
			end
		end
		else begin
			rid_mem = `AXI_ID_ZERO;
			rdata_mem = rdata_mem_t;
			rresp_mem = `AXI_VALID_DIS;
			rlast_mem = `AXI_VALID_DIS;
			rvalid_mem = `AXI_VALID_EN;

			rid_if = `AXI_ID_ZERO;
			rdata_if = rdata_if_t;
			rresp_if = `AXI_VALID_DIS;
			rlast_if = `AXI_VALID_DIS;
			rvalid_if = `AXI_VALID_EN;

			rready_axi = `AXI_READY_DIS;
		end
	end









































endmodule