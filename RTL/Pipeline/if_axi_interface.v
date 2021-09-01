//ECNURVCORE
//AXI Bus master-interconnect
//Created by Chesed
//2021.09.01

`include "define.v"

module if_axi_interface(
	input						clk				,
	input						rst_n			,
	
	output						stall_if 		,
	

	//with core




	input	[`BUS_ADDR_MEM]		pc				,
	input						instr_rd_en		,
	output	[`BUS_DATA_INSTR]	instr 			,
	output	reg [`BUS_ADDR_MEM]	addr_instr		,
	output						axi_idle_if		,



	//with bus

	//address write

	//handshake
	input	      				awready_if	,
	output 	      				awvalid_if	,

	output	[`BUS_AXI_AWID]		awid_if 	,
	output 	[`BUS_ADDR_MEM]		awaddr_if	,

	//burst
	output 	[`BUS_AXI_LEN] 		awlen_if	,
	output 	[`BUS_AXI_SIZE] 	awsize_if	,
	output 	[`BUS_AXI_BURST]	awburst_if	,

	output	[`BUS_AXI_CACHE]	awcache_if	,
	output						awprot_if	,
	output						awqos_if	,
	output						awregion_if	,



	//data write

	//handshake
	input	      				wready_if	,
	output 	      				wvalid_if	,

	output 	[`BUS_DATA_MEM]		wdata_if	,
	output 	[`BUS_AXI_STRB] 	wstrb_if	,

	//burst
	output 	      				wlast_if	,



	//write response
	input	[`BUS_AXI_BID]		bid_if		,
	input	[`BUS_AXI_RESP]		bresp_if	,

	//handshake
	input						bvalid_if	,
	output						bready_if	,
			


	//address read

	//handshake
	input	      				arready_if	,
	output 	      				arvalid_if	,

	output	[`BUS_AXI_ARID]		arid_if		,
	output 	[`BUS_ADDR_MEM]		araddr_if	,

	//burst
	output 	[`BUS_AXI_LEN] 		arlen_if	,
	output 	[`BUS_AXI_SIZE] 	arsize_if	,
	output 	[`BUS_AXI_BURST]	arburst_if	,

	output	[`BUS_AXI_CACHE]	arcache_if	,
	output						arprot_if	,
	output						arqos_if	,
	output						arregion_if	,



	//data read
	input	[`BUS_AXI_RID] 		rid_if		,
	input	[`BUS_DATA_MEM]		rdata_if	,
	input	[`BUS_AXI_RESP]		rresp_if	,

	//burst
	input	      				rlast_if	,
	
	//handshake
	input						rvalid_if 	,
	output						rready_if 	






);


	reg [`BUS_DATA_INSTR] instr_t;
	wire [`BUS_DATA_MEM] rdata_act;
	reg [`BUS_ADDR_MEM] pc_t;
	reg [`BUS_DATA_MEM] rdata_act_t;
	reg if_wait;
	reg idle_t;

    //id set
    assign awid_if = `AXI_ID_IF;
    assign arid_if = `AXI_ID_IF;
    
    
	//burst set
	assign awlen_if = `AXI_LEN_ZERO;
	assign awsize_if = `AXI_SIZE_DOUBLE;
	assign awburst_if = `AXI_BURST_INCR;

	assign arlen_if = `AXI_LEN_ZERO;
	assign arsize_if = `AXI_SIZE_DOUBLE;
	assign arburst_if = `AXI_BURST_INCR;


	//read-only
	assign awvalid_if = `AXI_VALID_DIS;

    assign wlast_if = `AXI_VALID_DIS;
    assign bready_if = `AXI_READY_DIS;

	assign awaddr_if = `MEM_ADDR_ZERO;
	assign wdata_if = `ZERO_DOUBLE;
	assign wstrb_if = `WR_STR_NONE;

	assign axi_idle_if = idle_t;


	
	//instruction fetch 
	assign stall_if = (arready_if==`AXI_READY_DIS) ? 1'b1 : 1'b0;

	assign araddr_if = {pc[63:3],3'b000} + `BASE_PC;
	assign arvalid_if = instr_rd_en;
	assign rready_if = `AXI_READY_EN;
	assign rdata_act = (rvalid_if == `AXI_VALID_EN) ? rdata_if : `ZERO_DOUBLE;

	//assign instr = (arready_if==`AXI_READY_DIS) ? instr_t : (addr_instr[2] ? rdata_act[63:32] : rdata_act[31:0]);
	assign instr = (arready_if==`AXI_READY_DIS) ? (addr_instr[2] ? rdata_act_t[63:32] : rdata_act_t[31:0]) : (addr_instr[2] ? rdata_act[63:32] : rdata_act[31:0]);

	


	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pc_t <= `BASE_PC;
		end
		else begin
			if(instr_rd_en) begin
				pc_t <= pc;
			end
			else begin
				pc_t <= pc_t;
			end
		end
	end		

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			addr_instr <= `BASE_PC;
		end
		else begin
			if(rlast_if) begin
				addr_instr <= pc_t;
			end
			else begin
				addr_instr <= addr_instr;
			end
		end
	end	

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			instr_t <= `ZERO_WORD;
			idle_t <= 1'b0;
		end
		else begin
			instr_t <= instr;
			idle_t <= if_wait | arready_if;
		end
	end		

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			if_wait <= 1'b0;
		end
		else begin
			if(if_wait == 1'b0) begin
				if(arready_if&arvalid_if) begin
					if_wait <= 1'b1;
				end
				else begin
					if_wait <= if_wait;
				end
			end
			else begin
				if(rlast_if) begin
					if_wait <= 1'b0;
				end
				else begin
					if_wait <= if_wait;
				end
			end
		end
	end	


	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rdata_act_t <= `ZERO_DOUBLE;
		end
		else begin
			rdata_act_t <= rdata_act;
		end
	end	






endmodule