//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.25


`include "define.v"

module bus_core(
	input							clk				,

	input							mem_state_i		,
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
	end

	always@(posedge clk) begin
		if(mem_state_i == `MEM_WR_EN) begin
			mem_data[addr_mem_i] <= data_mem_wr_i;
		end
		else begin
			data_mem_rd_o <= mem_data[addr_mem_i];
		end
	end

	always@(posedge clk) begin
		data_instr_o <= mem_instr[addr_instr_i];
		addr_instr_o <= addr_instr_i;
	end

endmodule