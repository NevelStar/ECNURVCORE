//ECNURVCORE
//AXI Bus master-slave
//Created by Chesed
//2021.08.12
//Edited in 2021.09.01

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
	input 	[`BUS_AXI_STRB]		strb_mem_wr		,			
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

	//output	[`BUS_AXI_CACHE]	awcache_mem		,
	//output						awprot_mem		,
	//output						awqos_mem		,
	//output						awregion_mem	,



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

	//output	[`BUS_AXI_CACHE]	arcache_mem		,
	//output						arprot_mem		,
	//output						arqos_mem		,
	//output						arregion_mem	,



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


	reg bvalid_t;
	reg rlast_t;
	reg mem_rd_wait;
	reg mem_rd_aligned;
	reg [2:0] mem_rd_addr_bias;
	reg mem_wr_wait;
	reg mem_wr_aligned;
	reg [2:0] mem_wr_addr_bias;

	reg data_wr_valid;
	reg data_act_page;//0~first 1~second

	reg [`BUS_DATA_MEM] data_wr_act_first;
	reg [`BUS_DATA_MEM] data_wr_act_second;
	reg [`BUS_AXI_STRB] strb_wr_act_first;
	reg [`BUS_AXI_STRB] strb_wr_act_second;


	reg [`BUS_DATA_MEM] data_rd_t;
	reg	[`BUS_DATA_MEM] data_mem_rd_act;
	reg [`BUS_DATA_MEM] data_mem_rd_t;

	reg [`BUS_DATA_MEM] data_wr;
	wire [`BUS_DATA_MEM] rdata_act;
	wire mem_awhandshake;

	wire mem_aligned_aw;
	wire mem_aligned_ar;

	//unaligned
	assign  mem_aligned_aw = (addr_mem_wr[2:0] == 3'b000) ? `AXI_ADDR_ALIGN : `AXI_ADDR_UNALIGN;
	assign  mem_aligned_ar = (addr_mem_rd[2:0] == 3'b000) ? `AXI_ADDR_ALIGN : `AXI_ADDR_UNALIGN;


    //id set
	assign awid_mem = `AXI_ID_MEM;
	assign arid_mem = `AXI_ID_MEM;
		
    
	//burst set
	assign awlen_mem = (mem_aligned_aw == `AXI_ADDR_ALIGN) ? `AXI_LEN_ZERO : `AXI_OVER_PAGE;
	//assign awlen_mem = `AXI_LEN_ZERO;
	assign awsize_mem = `AXI_SIZE_DOUBLE;
	assign awburst_mem = `AXI_BURST_INCR;

	assign arlen_mem = (mem_aligned_ar == `AXI_ADDR_ALIGN) ? `AXI_LEN_ZERO : `AXI_OVER_PAGE;
	//assign arlen_mem = `AXI_LEN_ZERO;
	assign arsize_mem = `AXI_SIZE_DOUBLE;
	assign arburst_mem = `AXI_BURST_INCR;


	//type-s
	assign awvalid_mem = mem_wr_en & (!bvalid_t);
	assign mem_awhandshake = awvalid_mem & awready_mem;

    assign wlast_mem = wvalid_mem & data_act_page;
    assign bready_mem = `AXI_READY_EN;
	assign stall_mem = mem_wr_wait | mem_rd_wait;


	assign awaddr_mem = {addr_mem_wr[63:3],3'b000} + `BASE_MEM;

	assign wvalid_mem = data_wr_valid;
	assign wdata_mem = data_act_page ? data_wr_act_second : data_wr_act_first ;
	assign wstrb_mem = data_act_page ? strb_wr_act_second : strb_wr_act_first ;
	
	//type-l

	assign araddr_mem = {addr_mem_rd[63:3],3'b000} + `BASE_MEM;
	assign arvalid_mem = mem_rd_en & (!rlast_t);
	assign rready_mem = mem_rd_wait;
	assign rdata_act = (rvalid_mem == `AXI_VALID_EN) ? rdata_mem : `ZERO_DOUBLE;

	assign data_mem_rd = mem_rd_wait ? data_mem_rd_act : data_mem_rd_t;

	always@(*) begin
		case(mem_rd_addr_bias)
			3'b000:		data_mem_rd_act = rdata_act;
			3'b001:		data_mem_rd_act = {rdata_act[7:0],data_rd_t[63:8]};
			3'b010:		data_mem_rd_act = {rdata_act[15:0],data_rd_t[63:16]};
			3'b011:		data_mem_rd_act = {rdata_act[23:0],data_rd_t[63:24]};
			3'b100:		data_mem_rd_act = {rdata_act[31:0],data_rd_t[63:32]};
			3'b101:		data_mem_rd_act = {rdata_act[39:0],data_rd_t[63:40]};
			3'b110:		data_mem_rd_act = {rdata_act[47:0],data_rd_t[63:48]};
			3'b111:		data_mem_rd_act = {rdata_act[55:0],data_rd_t[63:56]};
			default:	data_mem_rd_act = rdata_act;
		endcase	
	end
	always@(*) begin
		case(mem_wr_addr_bias)
			3'b000: begin	
				data_wr_act_first = data_wr;
				data_wr_act_second = `ZERO_DOUBLE;
				strb_wr_act_first = strb_mem_wr;
				strb_wr_act_second = `WR_STR_NONE;
			end
			3'b001: begin
				data_wr_act_first = {data_wr[55:0],8'h0};
				data_wr_act_second = {56'h0,data_wr[63:56]};
				strb_wr_act_first = strb_mem_wr << 1;
				strb_wr_act_second = {7'b0,strb_mem_wr[7]};
			end
			3'b010: begin
				data_wr_act_first = {data_wr[47:0],16'h0};
				data_wr_act_second = {48'h0,data_wr[63:48]};
				strb_wr_act_first = strb_mem_wr << 2;
				strb_wr_act_second = {6'b0,strb_mem_wr[7:6]};
			end
			3'b011: begin
				data_wr_act_first = {data_wr[39:0],24'h0};
				data_wr_act_second = {40'h0,data_wr[63:40]};
				strb_wr_act_first = strb_mem_wr << 3;
				strb_wr_act_second = {5'b0,strb_mem_wr[7:5]};
			end
			3'b100: begin
				data_wr_act_first = {data_wr[31:0],32'h0};
				data_wr_act_second = {32'h0,data_wr[63:32]};
				strb_wr_act_first = strb_mem_wr << 4;
				strb_wr_act_second = {4'b0,strb_mem_wr[7:4]};
			end
			3'b101: begin
				data_wr_act_first = {data_wr[23:0],40'h0};
				data_wr_act_second = {24'h0,data_wr[63:24]};
				strb_wr_act_first = strb_mem_wr << 5;
				strb_wr_act_second = {3'b0,strb_mem_wr[7:3]};
			end
			3'b110: begin
				data_wr_act_first = {data_wr[15:0],48'h0};
				data_wr_act_second = {16'h0,data_wr[63:16]};
				strb_wr_act_first = strb_mem_wr << 6;
				strb_wr_act_second = {2'b0,strb_mem_wr[7:2]};
			end
			3'b111: begin
				data_wr_act_first = {data_wr[7:0],56'h0};
				data_wr_act_second = {8'h0,data_wr[63:8]};
				strb_wr_act_first = strb_mem_wr << 7;
				strb_wr_act_second = {1'b0,strb_mem_wr[7:1]};
			end
			default: begin
				data_wr_act_first = data_wr;
				data_wr_act_second = `ZERO_DOUBLE;
				strb_wr_act_first = strb_mem_wr;
				strb_wr_act_second = `WR_STR_NONE;
			end
		endcase	
	end




	always@(posedge clk) begin
		if(!rst_n) begin
			bvalid_t <= `AXI_VALID_DIS;
			rlast_t <= `AXI_VALID_DIS;
			data_mem_rd_t <= `ZERO_DOUBLE;
		end
		else begin
			bvalid_t <= bvalid_mem;
			rlast_t <= rlast_mem;
			data_mem_rd_t <= data_mem_rd;
		end
	end	
	always@(posedge clk) begin
		if(!rst_n) begin
			mem_rd_wait <= 1'b0;
			mem_rd_aligned <= `AXI_ADDR_ALIGN;
			mem_rd_addr_bias <= 3'b000;
		end
		else begin
			if(mem_rd_wait == 1'b0) begin
				if(arready_mem&arvalid_mem) begin
				  	mem_rd_wait <= 1'b1;
					mem_rd_aligned <= mem_aligned_ar;
					mem_rd_addr_bias <= addr_mem_rd[2:0];
				end
				else begin
					mem_rd_wait <= mem_rd_wait;
					mem_rd_aligned <= mem_rd_aligned;
					mem_rd_addr_bias <= mem_rd_addr_bias;
				end
			end	
			else begin
				if(rlast_mem) begin
					mem_rd_wait <= 1'b0;
					mem_rd_aligned <= `AXI_ADDR_ALIGN;
					mem_rd_addr_bias <= 3'b000;
				end
				else begin
					mem_rd_wait <= mem_rd_wait;
					mem_rd_aligned <= mem_rd_aligned;
					mem_rd_addr_bias <= mem_rd_addr_bias;
				end
			end
		end
	end
	always@(posedge clk) begin
		if(!rst_n) begin
			mem_wr_wait <= 1'b0;
			mem_wr_aligned <= `AXI_ADDR_ALIGN;
			mem_wr_addr_bias <= 3'b000;
		end
		else begin
			if(mem_wr_wait == 1'b0) begin
				if(mem_awhandshake) begin
				  	mem_wr_wait <= 1'b1;
					mem_wr_aligned <= mem_aligned_aw;
					mem_wr_addr_bias <= addr_mem_wr[2:0];
				end
				else begin
					mem_wr_wait <= mem_wr_wait;
					mem_wr_aligned <= mem_wr_aligned;
					mem_wr_addr_bias <= mem_wr_addr_bias;
				end
			end	
			else begin
				if(bvalid_mem) begin
					mem_wr_wait <= 1'b0;
					mem_wr_aligned <= `AXI_ADDR_ALIGN;
					mem_wr_addr_bias <= 3'b000;
				end
				else begin
					mem_wr_wait <= mem_wr_wait;
					mem_wr_aligned <= mem_wr_aligned;
					mem_wr_addr_bias <= mem_wr_addr_bias;
				end
			end
		end
	end


	always@(posedge clk) begin
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
	always@(posedge clk) begin
		if(!rst_n) begin
			data_rd_t <= `ZERO_DOUBLE;
		end
		else begin
			if(mem_rd_wait & rvalid_mem) begin
				data_rd_t <= rdata_act;
			end
			else begin
				data_rd_t <= data_rd_t;
			end
		end
    end
	always@(posedge clk) begin
		if(!rst_n) begin
			data_wr_valid <= `AXI_VALID_DIS;
			data_act_page <= 1'b0;
		end
		else begin
			if(mem_wr_wait == 1'b0) begin
				data_wr_valid <= `AXI_VALID_DIS;
				data_act_page <= 1'b0;
			end
			else begin
				if(data_wr_valid == `AXI_VALID_EN) begin
					if(data_act_page==1'b0) begin
						data_act_page <= 1'b1;
						data_wr_valid <= `AXI_VALID_DIS;
					end
					else begin
						data_act_page <= data_act_page;
						data_wr_valid <= `AXI_VALID_DIS;
					end
				end
				else begin
					data_act_page <= data_act_page;
					data_wr_valid <= wready_mem ? `AXI_VALID_EN : `AXI_VALID_DIS;
				end
			end
		end
	end
	
endmodule