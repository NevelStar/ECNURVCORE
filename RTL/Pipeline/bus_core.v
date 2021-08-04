//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.25
//Edited in 2021.08.04


`include "define.v"

module bus_core(
	input							clk				,

	input							mem_state_i		,
	input							instr_rd_en_i		,
	input		[`BUS_DATA_MEM]		data_mem_wr_i	,	
	input		[`BUS_DATA_MEM]		addr_mem_i		,
	input 		[`BUS_ADDR_MEM]		addr_instr_i	,		

	output	reg	[`BUS_DATA_MEM] 	data_instr_o	,
	output	reg	[`BUS_DATA_MEM] 	addr_instr_o 	,
	output	reg	[`BUS_DATA_MEM]		data_mem_rd_o		
	

);
	reg [`BUS_DATA_MEM] mem_data[`NUM_DATA_MEM];
	reg [`BUS_DATA_MEM] mem_instr[`NUM_INSTR_MEM];

	initial begin
		$readmemh("memory_data.dat",mem_data);
		$readmemh("memory_instr.dat",mem_instr);
		addr_instr_o <= `MEM_ADDR_ZERO;
		data_instr_o <= `ZERO_WORD;
		data_mem_rd_o <= `ZERO_WORD;
	end

	always@(posedge clk) begin
		if(mem_state_i == `MEM_WR_EN) begin
			mem_data[addr_mem_i>>2] <= data_mem_wr_i;
		end
		else begin
			data_mem_rd_o <= mem_data[addr_mem_i>>2];
		end
	end

	always@(posedge clk) begin
		if(instr_rd_en_i && (addr_instr_i[1:0] == 2'b00)) begin
			data_instr_o <= mem_instr[addr_instr_i>>2];
			addr_instr_o <= addr_instr_i;
		end
		else begin
			data_instr_o <= data_instr_o;
			addr_instr_o <= addr_instr_o;
		end
	end

endmodule