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
	//input    	[`BUS_AXI_CACHE]	awcache_if		,
	//input    						awprot_if		,
	//input    						awqos_if		,
	//input    						awregion_if		,
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
	//input    	[`BUS_AXI_CACHE]	arcache_if		,
	//input    						arprot_if		,
	//input    						arqos_if		,
	//input    						arregion_if		,
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
	//input    	[`BUS_AXI_CACHE]	awcache_mem		,
	//input    						awprot_mem		,
	//input    						awqos_mem		,
	//input    						awregion_mem	,
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
	//input    	[`BUS_AXI_CACHE]	arcache_mem		,
	//input    						arprot_mem		,
	//input    						arqos_mem		,
	//input    						arregion_mem	,
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
	//output	reg	[`BUS_AXI_CACHE]	awcache_axi		,
	//output	reg						awprot_axi		,
	//output	reg						awqos_axi		,
	//output	reg						awregion_axi	,
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
	//output	reg	[`BUS_AXI_CACHE]	arcache_axi		,
	//output	reg						arprot_axi		,
	//output	reg						arqos_axi		,
	//output	reg						arregion_axi	,
	input	[`BUS_AXI_RID] 			rid_axi			,
	input	[`BUS_DATA_MEM]			rdata_axi		,
	input	[`BUS_AXI_RESP]			rresp_axi		,
	input	      					rlast_axi		,
	input							rvalid_axi 		,
	output	reg						rready_axi 		,
	
	input	      					awready_timer	,
	output	reg 	      			awvalid_timer	,
	output	reg	[`BUS_AXI_AWID]		awid_timer 		,
	output	reg	[`BUS_ADDR_MEM]		awaddr_timer	,
	output	reg	[`BUS_AXI_LEN] 		awlen_timer		,
	output	reg	[`BUS_AXI_SIZE] 	awsize_timer	,
	output	reg	[`BUS_AXI_BURST]	awburst_timer	,
	//output	reg	[`BUS_AXI_CACHE]	awcache_timer	,
	//output	reg						awprot_timer	,
	//output	reg						awqos_timer		,
	//output	reg						awregion_timer	,
	input	      					wready_timer	,
	output	reg	      				wvalid_timer	,
	output	reg	[`BUS_DATA_MEM]		wdata_timer		,
	output	reg	[`BUS_AXI_STRB] 	wstrb_timer		,
	output	reg	      				wlast_timer		,
	input	[`BUS_AXI_BID]			bid_timer		,
	input	[`BUS_AXI_RESP]			bresp_timer		,
	input							bvalid_timer	,
	output	reg						bready_timer	,
	input	      					arready_timer	,
	output	reg	      				arvalid_timer	,
	output	reg	[`BUS_AXI_ARID]		arid_timer		,
	output	reg	[`BUS_ADDR_MEM]		araddr_timer	,
	output	reg	[`BUS_AXI_LEN] 		arlen_timer		,
	output	reg	[`BUS_AXI_SIZE] 	arsize_timer	,
	output	reg	[`BUS_AXI_BURST]	arburst_timer	,
	//output	reg	[`BUS_AXI_CACHE]	arcache_timer	,
	//output	reg						arprot_timer	,
	//output	reg						arqos_timer		,
	//output	reg						arregion_timer	,
	input	[`BUS_AXI_RID] 			rid_timer		,
	input	[`BUS_DATA_MEM]			rdata_timer		,
	input	[`BUS_AXI_RESP]			rresp_timer		,
	input	      					rlast_timer		,
	input							rvalid_timer 	,
	output	reg						rready_timer 		

);

	reg axi_wbusy;
	reg axi_rbusy;

	wire timer_cs_ar;
	wire timer_cs_aw;
	reg timer_cs_r;
	reg timer_cs_w;

	assign timer_cs_ar = (araddr_mem >= `ADDR_TIMER_MIN) & (araddr_mem <= `ADDR_TIMER_MAX);
	assign timer_cs_aw = (awaddr_mem >= `ADDR_TIMER_MIN) & (awaddr_mem <= `ADDR_TIMER_MAX);

	reg [`BUS_DATA_MEM] rdata_if_t;
	reg [`BUS_DATA_MEM] rdata_mem_t;

	always@(posedge clk) begin
		if(!rst_n) begin
			rdata_if_t <= `ZERO_DOUBLE;
		end
		else begin
			rdata_if_t <= rdata_if;
		end
	end
	
	always@(posedge clk) begin
		if(!rst_n) begin
			rdata_mem_t <= `ZERO_DOUBLE;
		end
		else begin
			rdata_mem_t <= rdata_mem;
		end
	end	


	//write request
	always@(posedge clk) begin
		if(!rst_n) begin
			axi_wbusy <= `AXI_IDLE;
			timer_cs_w <= 1'b0;
		end
		else begin
			if(axi_wbusy == `AXI_IDLE) begin
				if((awvalid_mem == `AXI_VALID_EN) & (awready_axi == `AXI_READY_EN)) begin
					axi_wbusy <= `AXI_BUSY;
					timer_cs_w <= timer_cs_aw;
				end
				else begin
					axi_wbusy <= axi_wbusy;
					timer_cs_w <= timer_cs_w;
				end
			end
			else begin
				if(bvalid_axi == `AXI_VALID_EN) begin
					axi_wbusy <= `AXI_IDLE;
					timer_cs_w <= 1'b0;
				end
				else begin
					axi_wbusy <= axi_wbusy;
					timer_cs_w <= timer_cs_w;
				end
			end
		end
	end	


	//read request
	always@(posedge clk) begin
		if(!rst_n) begin
			axi_rbusy <= `AXI_IDLE;
			timer_cs_r <= 1'b0;
		end
		else begin
			if(axi_rbusy == `AXI_IDLE) begin
				if((arvalid_mem == `AXI_VALID_EN) | (arvalid_if == `AXI_VALID_EN)) begin
					axi_rbusy <= `AXI_BUSY;
					timer_cs_r <= timer_cs_ar;
				end
				else begin
					axi_rbusy <= axi_rbusy;
					timer_cs_r <= timer_cs_r;
				end
			end
			else begin
				if(rlast_axi == `AXI_VALID_EN) begin
					axi_rbusy <= `AXI_IDLE;
					timer_cs_r <= 1'b0;
				end
				else begin
					axi_rbusy <= axi_rbusy;
					timer_cs_r <= timer_cs_r;
				end
			end
		end
	end

	assign awready_if = `AXI_READY_DIS;
	assign wready_if = `AXI_READY_DIS;
	assign bid_if = `AXI_ID_ZERO;	
	assign bresp_if = {1'b0,`AXI_VALID_DIS};
	assign bvalid_if = `AXI_VALID_DIS;

	always@(*) begin
		if((awvalid_mem == `AXI_VALID_EN) & (axi_wbusy == `AXI_IDLE)) begin
			if(timer_cs_aw) begin
				awready_mem = rst_n ? `AXI_READY_EN : `AXI_READY_DIS;

				awvalid_axi = awvalid_mem;
				awid_axi = awid_mem;
				awaddr_axi = awaddr_mem;
				awlen_axi = awlen_mem;
				awsize_axi = awsize_mem;
				awburst_axi = awburst_mem;
				//awcache_axi = awcache_mem;
				//awprot_axi = awprot_mem;
				//awqos_axi = awqos_mem;
				//awregion_axi = awregion_mem;

				awvalid_timer = awvalid_mem;
				awid_timer = awid_mem;
				//awaddr_timer = awaddr_mem - `ADDR_TIMER_MIN;
				awaddr_timer = awaddr_mem;
				awlen_timer = awlen_mem;
				awsize_timer = awsize_mem;
				awburst_timer = awburst_mem;
				//awcache_timer = awcache_mem;
				//awprot_timer = awprot_mem;
				//awqos_timer = awqos_mem;
				//awregion_timer = awregion_mem;

				awvalid_axi = `AXI_VALID_DIS;
				awid_axi = `AXI_ID_ZERO;
				awaddr_axi = `MEM_ADDR_ZERO;
				awlen_axi = `AXI_LEN_ZERO;
				awsize_axi = `AXI_SIZE_DOUBLE;
				awburst_axi = `AXI_BURST_INCR;
				//awcache_axi = awcache_mem;
				//awprot_axi = awprot_mem;
				//awqos_axi = awqos_mem;
				//awregion_axi = awregion_mem;
			end
			else begin
			
				awready_mem = rst_n ? `AXI_READY_EN : `AXI_READY_DIS;

				awvalid_axi = awvalid_mem;
				awid_axi = awid_mem;
				awaddr_axi = awaddr_mem;
				awlen_axi = awlen_mem;
				awsize_axi = awsize_mem;
				awburst_axi = awburst_mem;
				//awcache_axi = awcache_mem;
				//awprot_axi = awprot_mem;
				//awqos_axi = awqos_mem;
				//awregion_axi = awregion_mem;

				awvalid_timer = `AXI_VALID_DIS;
				awid_timer = `AXI_ID_ZERO;
				awaddr_timer = `MEM_ADDR_ZERO;
				awlen_timer = `AXI_LEN_ZERO;
				awsize_timer = `AXI_SIZE_DOUBLE;
				awburst_timer = `AXI_BURST_INCR;
				//awcache_timer = awcache_mem;
				//awprot_timer = awprot_mem;
				//awqos_timer = awqos_mem;
				//awregion_timer = awregion_mem;
			end
		end
		else begin
			awready_mem = rst_n ? !axi_wbusy : `AXI_READY_DIS;

			awvalid_axi = `AXI_VALID_DIS;
			awid_axi = `AXI_ID_ZERO;
			awaddr_axi = `MEM_ADDR_ZERO;
			awlen_axi = `AXI_LEN_ZERO;
			awsize_axi = `AXI_SIZE_DOUBLE;
			awburst_axi = `AXI_BURST_INCR;
			//awcache_axi = awcache_mem;
			//awprot_axi = awprot_mem;
			//awqos_axi = awqos_mem;
			//awregion_axi = awregion_mem;

			awvalid_timer = `AXI_VALID_DIS;
			awid_timer = `AXI_ID_ZERO;
			awaddr_timer = `MEM_ADDR_ZERO;
			awlen_timer = `AXI_LEN_ZERO;
			awsize_timer = `AXI_SIZE_DOUBLE;
			awburst_timer = `AXI_BURST_INCR;
			//awcache_timer = awcache_mem;
			//awprot_timer = awprot_mem;
			//awqos_timer = awqos_mem;
			//awregion_timer = awregion_mem;
		end
	end


	always@(*) begin
		if(axi_wbusy == `AXI_BUSY) begin
			if(timer_cs_w) begin
				wready_mem = wready_timer;

				wvalid_timer = wvalid_mem;
				wdata_timer = wdata_mem;
				wstrb_timer = wstrb_mem;
				wlast_timer = wlast_mem;

				wvalid_axi = `AXI_VALID_DIS;
				wdata_axi = `ZERO_DOUBLE;
				wstrb_axi = `WR_STR_NONE;
				wlast_axi = `AXI_VALID_DIS;

				bid_mem = bid_timer;
				bresp_mem = bresp_timer;
				bvalid_mem = bvalid_timer;

				bready_timer = bready_mem;

				bready_axi = `AXI_READY_DIS;
			end
			else begin
				wready_mem = wready_axi;

				wvalid_axi = wvalid_mem;
				wdata_axi = wdata_mem;
				wstrb_axi = wstrb_mem;
				wlast_axi = wlast_mem;

				wvalid_timer = `AXI_VALID_DIS;
				wdata_timer = `ZERO_DOUBLE;
				wstrb_timer = `WR_STR_NONE;
				wlast_timer = `AXI_VALID_DIS;

				bid_mem = bid_axi;
				bresp_mem = bresp_axi;
				bvalid_mem = bvalid_axi;

				bready_axi = bready_mem;	

				bready_timer = `AXI_READY_DIS;		
			end
		end
		else begin
			wready_mem = `AXI_READY_DIS;

			wvalid_axi = `AXI_VALID_DIS;
			wdata_axi = `ZERO_DOUBLE;
			wstrb_axi = `WR_STR_NONE;
			wlast_axi = wlast_mem;

			wvalid_timer = `AXI_VALID_DIS;
			wdata_timer = `ZERO_DOUBLE;
			wstrb_timer = `WR_STR_NONE;
			wlast_timer = `AXI_VALID_DIS;

			bid_mem = `AXI_ID_ZERO;
			bresp_mem = {1'b0,`AXI_VALID_DIS};
			bvalid_mem = `AXI_VALID_DIS;

			bready_axi = `AXI_READY_DIS;
				
			bready_timer = `AXI_READY_DIS;	
		end
	end


	always@(*) begin
		if(axi_rbusy == `AXI_IDLE) begin
			if(arvalid_mem == `AXI_VALID_EN) begin
				if(timer_cs_ar) begin
					arready_mem =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;
					arready_if =  `AXI_READY_DIS;

					arvalid_axi = `AXI_VALID_DIS;
					arid_axi = `AXI_ID_ZERO;
					araddr_axi = `MEM_ADDR_ZERO;
					arlen_axi = `AXI_LEN_ZERO;
					arsize_axi = `AXI_SIZE_DOUBLE;
					arburst_axi = `AXI_BURST_INCR;
					//arcache_axi = arcache_if;
					//arprot_axi = arprot_if;
					//arqos_axi = arqos_if;
					//arregion_axi = arregion_if;

					arvalid_timer = arvalid_mem;
					arid_timer = arid_mem;
					araddr_timer = araddr_mem;
					arlen_timer = arlen_mem;
					arsize_timer = arsize_mem;
					arburst_timer = arburst_mem;
					//arcache_timer = arcache_mem;
					//arprot_timer = arprot_mem;
					//arqos_timer = arqos_mem;
					//arregion_timer = arregion_mem;
				end
				else begin
					arready_mem =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;
					arready_if =  `AXI_READY_DIS;

					arvalid_axi = arvalid_mem;
					arid_axi = arid_mem;
					araddr_axi = araddr_mem;
					arlen_axi = arlen_mem;
					arsize_axi = arsize_mem;
					arburst_axi = arburst_mem;
					//arcache_axi = arcache_mem;
					//arprot_axi = arprot_mem;
					//arqos_axi = arqos_mem;
					//arregion_axi = arregion_mem;

					arvalid_timer = `AXI_VALID_DIS;
					arid_timer = `AXI_ID_ZERO;
					araddr_timer = `MEM_ADDR_ZERO;
					arlen_timer = `AXI_LEN_ZERO;
					arsize_timer = `AXI_SIZE_DOUBLE;
					arburst_timer = `AXI_BURST_INCR;
					//arcache_timer = arcache_if;
					//arprot_timer = arprot_if;
					//arqos_timer = arqos_if;
					//arregion_timer = arregion_if;
				end
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
					//arcache_axi = arcache_if;
					//arprot_axi = arprot_if;
					//arqos_axi = arqos_if;
					//arregion_axi = arregion_if;

					arvalid_timer = `AXI_VALID_DIS;
					arid_timer = `AXI_ID_ZERO;
					araddr_timer = `MEM_ADDR_ZERO;
					arlen_timer = `AXI_LEN_ZERO;
					arsize_timer = `AXI_SIZE_DOUBLE;
					arburst_timer = `AXI_BURST_INCR;
					//arcache_timer = arcache_if;
					//arprot_timer = arprot_if;
					//arqos_timer = arqos_if;
					//arregion_timer = arregion_if;
				end
				else begin
					arready_if =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;
					arready_mem =  rst_n ? `AXI_READY_EN : `AXI_READY_DIS;

					arvalid_axi = `AXI_VALID_DIS;
					arid_axi = `AXI_ID_ZERO;
					araddr_axi = `MEM_ADDR_ZERO;
					arlen_axi = `AXI_LEN_ZERO;
					arsize_axi = `AXI_SIZE_DOUBLE;
					arburst_axi = `AXI_BURST_INCR;
					//arcache_axi = arcache_if;
					//arprot_axi = arprot_if;
					//arqos_axi = arqos_if;
					//arregion_axi = arregion_if;

					arvalid_timer = `AXI_VALID_DIS;
					arid_timer = `AXI_ID_ZERO;
					araddr_timer = `MEM_ADDR_ZERO;
					arlen_timer = `AXI_LEN_ZERO;
					arsize_timer = `AXI_SIZE_DOUBLE;
					arburst_timer = `AXI_BURST_INCR;
					//arcache_timer = arcache_if;
					//arprot_timer = arprot_if;
					//arqos_timer = arqos_if;
					//arregion_timer = arregion_if;
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
			//arcache_axi = arcache_if;
			//arprot_axi = arprot_if;
			//arqos_axi = arqos_if;
			//arregion_axi = arregion_if;

			arvalid_timer = `AXI_VALID_DIS;
			arid_timer = `AXI_ID_ZERO;
			araddr_timer = `MEM_ADDR_ZERO;
			arlen_timer = `AXI_LEN_ZERO;
			arsize_timer = `AXI_SIZE_DOUBLE;
			arburst_timer = `AXI_BURST_INCR;
			//arcache_timer = arcache_if;
			//arprot_timer = arprot_if;
			//arqos_timer = arqos_if;
			//arregion_timer = arregion_if;

			arvalid_timer = `AXI_VALID_DIS;
			arid_timer = `AXI_ID_ZERO;
			araddr_timer = `MEM_ADDR_ZERO;
			arlen_timer = `AXI_LEN_ZERO;
			arsize_timer = `AXI_SIZE_DOUBLE;
			arburst_timer = `AXI_BURST_INCR;
			//arcache_timer = arcache_if;
			//arprot_timer = arprot_if;
			//arqos_timer = arqos_if;
			//arregion_timer = arregion_if;
		end
	end


	always@(*) begin
		if(axi_rbusy == `AXI_BUSY) begin
			if(rready_mem == `AXI_VALID_EN) begin
				if(timer_cs_r) begin
					rid_mem = rid_timer;
					rdata_mem = rdata_timer;
					rresp_mem = rresp_timer;
					rlast_mem = rlast_timer;
					rvalid_mem = rvalid_timer;

					rid_if = `AXI_ID_ZERO;
					rdata_if = rdata_if_t;
					rresp_if = {1'b0,`AXI_VALID_DIS};
					rlast_if = `AXI_VALID_DIS;
					rvalid_if = `AXI_VALID_EN;

					rready_axi = `AXI_READY_DIS;
					rready_timer = rready_mem;
				end
				else begin
					rid_mem = rid_axi;
					rdata_mem = rdata_axi;
					rresp_mem = rresp_axi;
					rlast_mem = rlast_axi;
					rvalid_mem = rvalid_axi;

					rid_if = `AXI_ID_ZERO;
					rdata_if = rdata_if_t;
					rresp_if = {1'b0,`AXI_VALID_DIS};
					rlast_if = `AXI_VALID_DIS;
					rvalid_if = `AXI_VALID_EN;

					rready_axi = rready_mem;
					rready_timer = `AXI_READY_DIS;
				end
			end
			else begin
				if(rready_if == `AXI_VALID_EN) begin
					rid_mem = `AXI_ID_ZERO;
					rdata_mem = `ZERO_DOUBLE;
					rresp_mem = {1'b0,`AXI_VALID_DIS};
					rlast_mem = `AXI_VALID_DIS;
					rvalid_mem = `AXI_VALID_DIS;

					rid_if = rid_axi;
					rdata_if = rdata_axi;
					rresp_if = rresp_axi;
					rlast_if = rlast_axi;
					rvalid_if = rvalid_axi;

					rready_axi = rready_if;
					rready_timer = `AXI_READY_DIS;
				end
				else begin
					rid_mem = `AXI_ID_ZERO;
					rdata_mem = `ZERO_DOUBLE;
					rresp_mem = {1'b0,`AXI_VALID_DIS};
					rlast_mem = `AXI_VALID_DIS;
					rvalid_mem = `AXI_VALID_DIS;

					rid_if = `AXI_ID_ZERO;
					rdata_if = `ZERO_DOUBLE;
					rresp_if = {1'b0,`AXI_VALID_DIS};
					rlast_if = `AXI_VALID_DIS;
					rvalid_if = `AXI_VALID_DIS;

					rready_axi = `AXI_READY_DIS;
					rready_timer = `AXI_READY_DIS;
				end
			end
		end
		else begin
			rid_mem = `AXI_ID_ZERO;
			rdata_mem = rdata_mem_t;
			rresp_mem = {1'b0,`AXI_VALID_DIS};
			rlast_mem = `AXI_VALID_DIS;
			rvalid_mem = `AXI_VALID_EN;

			rid_if = `AXI_ID_ZERO;
			rdata_if = rdata_if_t;
			rresp_if = {1'b0,`AXI_VALID_DIS};
			rlast_if = `AXI_VALID_DIS;
			rvalid_if = `AXI_VALID_EN;

			rready_axi = `AXI_READY_DIS;
			rready_timer = `AXI_READY_DIS;
		end
	end


endmodule