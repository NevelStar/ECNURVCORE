//ECNURVCORE
//AXI Bus master-interconnect
//Created by Chesed
//2021.08.12

`include "define.v"

module axi_core_mem(
	input						clk				,
	input						rst_n			,
	
	output						stall_load 		,
	output						stall_store		,
	

	//with core

	//store/load
	input	[`BUS_ADDR_MEM]		addr_mem_wr		,	
	input	[`BUS_ADDR_MEM]		addr_mem_rd		,	
	input	[`BUS_DATA_MEM]		data_mem_wr		,	
	input						mem_wr_en		,	
	input						mem_rd_en		,					
	output	[`BUS_DATA_MEM]		data_mem_rd		,



	input	[`BUS_ADDR_MEM]		pc				,
	input						instr_rd_en		,
	output	[`BUS_DATA_INSTR]	instr 			,
	output	reg [`BUS_ADDR_MEM]	addr_instr		,



//with bus

	//address write

	//handshake
	input	      				awready			,
	output 	      				awvalid			,

	output	[`BUS_AXI_AWID]		awid 			,
	output 	[`BUS_ADDR_MEM]		awaddr			,

	//burst
	output 	[`BUS_AXI_LEN] 		awlen			,
	output 	[`BUS_AXI_SIZE] 	awsize			,
	output 	[`BUS_AXI_BURST]	awburst			,

	output	[`BUS_AXI_CACHE]	awcache			,
	output						awprot			,
	output						awqos			,
	output						awregion		,



	//data write

	//handshake
	input	      				wready			,
	output 	      				wvalid			,

	output 	[`BUS_DATA_MEM]		wdata			,
	output 	[`BUS_AXI_STRB] 	wstrb			,

	//burst
	output 	      				wlast			,



	//write response
	input	[`BUS_AXI_BID]		bid 			,
	input	[`BUS_AXI_RESP]		bresp			,

	//handshake
	input						bvalid			,
	output						bready			,
			


	//address read

	//handshake
	input	      				arready			,
	output 	      				arvalid			,

	output	[`BUS_AXI_ARID]		arid 			,
	output 	[`BUS_ADDR_MEM]		araddr			,

	//burst
	output 	[`BUS_AXI_LEN] 		arlen			,
	output 	[`BUS_AXI_SIZE] 	arsize			,
	output 	[`BUS_AXI_BURST]	arburst			,

	output	[`BUS_AXI_CACHE]	arcache			,
	output						arprot			,
	output						arqos			,
	output						arregion		,



	//data read
	input	[`BUS_AXI_RID] 		rid 			,
	input	[`BUS_DATA_MEM]		rdata			,
	input	[`BUS_AXI_RESP]		rresp			,

	//burst
	input	      				rlast			,
	
	//handshake
	input						rvalid 			,
	output						rready

);


	reg awhandshake_t;
	reg mem_rd_en_t;
	reg [`BUS_DATA_MEM] data_wr;
	reg [`BUS_DATA_INSTR] instr_t;
	wire [`BUS_DATA_MEM] rdata_act;
	wire awhandshake;


    //id set
    assign awid = `AXI_ID_ZERO;
    assign arid = `AXI_ID_ZERO;
    
    
	//burst set
	assign awlen = `AXI_LEN_ZERO;
	assign awsize = `AXI_SIZE_DOUBLE;
	assign awburst = `AXI_BURST_FIX;

	assign arlen = `AXI_LEN_ZERO;
	assign arsize = (mem_rd_en==`MEM_RD_EN) ? `AXI_SIZE_DOUBLE : `AXI_SIZE_WORD;
	assign arburst = `AXI_BURST_FIX;


	//type-s
	assign awvalid = mem_wr_en;
	assign awhandshake = awvalid & awready;

	assign wvalid = awhandshake_t;
    assign wlast = wvalid;
    assign bready = `AXI_READY_EN;
	assign stall_store = awvalid & (~awready);


	assign awaddr = addr_mem_wr + `BASE_MEM;
	assign wdata = data_wr;
	assign wstrb = `WR_STR_ALL;


	
	//type-l or if
	assign stall_load = (mem_rd_en_t==`MEM_RD_EN) ? 1'b1 : 1'b0;

	assign araddr = (mem_rd_en==`MEM_RD_EN) ? (addr_mem_rd + `BASE_MEM) : ({pc[63:3],3'b000} + `BASE_PC);
	assign arvalid = `AXI_VALID_EN;
	assign rready = `AXI_READY_EN;
	assign rdata_act = (rvalid == `AXI_VALID_EN) ? rdata : `ZERO_DOUBLE;

	assign data_mem_rd = (mem_rd_en_t==`MEM_RD_EN) ? rdata_act : `ZERO_DOUBLE;
	assign instr = (mem_rd_en_t==`MEM_RD_EN) ? instr_t : (pc[2] ? rdata_act[63:32] : rdata_act[31:0]);



	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			awhandshake_t <= `HANDSHAKE_DIS;
		end
		else begin
			awhandshake_t <= awhandshake;
		end
	end

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			addr_instr <= `BASE_PC;
			instr_t <= `ZERO_WORD;
		end
		else begin
			addr_instr <= pc;
			instr_t <= instr;
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
		  if(awready == `AXI_READY_EN) begin
		      data_wr <= data_mem_wr;
		  end
		  else begin
		      data_wr <= data_wr;
		  end
		end
    end

endmodule