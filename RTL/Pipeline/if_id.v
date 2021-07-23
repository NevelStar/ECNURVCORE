//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20

`include "define.v"

module if_id(
	input						clk				,
	input						rst_n			,

	input	[`BUS_ADDR_MEM]		addr_instr_i	,
	input	[`BUS_DATA_MEM]		instr_i			,

	input						hold_n			,


	output	[`BUS_ADDR_MEM]		addr_instr_o	,
	output	[`BUS_DATA_MEM]		instr_o			
);

	gnrl_dff # (.DW(32)) dff_addr_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(addr_instr_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(addr_instr_o),
	);

	gnrl_dff # (.DW(32)) dff_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(instr_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(instr_o),
	);


endmodule