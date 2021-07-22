//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20

`include "define.v"

module id_ex(
	input						clk				,
	input						rst_n			,

	input	[`BUS_DATA_REG]		data_rs1_i		,
	input	[`BUS_DATA_REG]		data_rs2_i		,

	input	[`BUS_DATA_MEM]		instr_i			,
	input 	[`BUS_L_CODE]		load_code_i		,
	input 	[`BUS_S_CODE]		store_code_i	,

	input	[`BUS_ALU_OP]		alu_operation_i	,
	input	[`BUS_DATA_REG]		alu_op_num1_i	,
	input	[`BUS_DATA_REG]		alu_op_num2_i	,
	input	[`BUS_DATA_REG]		jmp_op_num1_i	,
	input	[`BUS_DATA_REG]		jmp_op_num2_i	,
	input						jmp_flag_i		,

	input						hold_n			,

	output	[`BUS_DATA_REG]		data_rs1_o		,
	output	[`BUS_DATA_REG]		data_rs2_o		,

	output	[`BUS_DATA_MEM]		instr_o			,
	output 	[`BUS_L_CODE]		load_code_o		,
	output 	[`BUS_S_CODE]		store_code_o	,

	output	[`BUS_ALU_OP]		alu_operation_o	,
	output	[`BUS_DATA_REG]		alu_op_num1_o	,
	output	[`BUS_DATA_REG]		alu_op_num2_o	,
	output	[`BUS_DATA_REG]		jmp_op_num1_o	,
	output	[`BUS_DATA_REG]		jmp_op_num2_o	,
	output						jmp_flag_o		
	
);
	gnrl_dff # (.DW(32)) dff_data_rs1(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(data_rs1_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(data_rs1_o),
	);

	gnrl_dff # (.DW(32)) dff_data_rs2(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(data_rs2_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(data_rs2_o),
	);	

	gnrl_dff # (.DW(32)) dff_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(instr_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(instr_o),
	);	


	gnrl_dff # (.DW(32)) dff_store_code(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(store_code_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(store_code_o),
	);	
	gnrl_dff # (.DW(32)) dff_load_code(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(load_code_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(load_code_o),
	);	
	gnrl_dff # (.DW(3)) dff_alu_opcode(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_operation_i),
		.data_r_ini	(`ALU_ADD),

		.data_out	(alu_operation_o),
	);

	gnrl_dff # (.DW(32)) dff_alu_num1(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_op_num1_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(alu_op_num1_o),
	);	

	gnrl_dff # (.DW(32)) dff_alu_num2(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_op_num2_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(alu_op_num2_o),
	);

	gnrl_dff # (.DW(32)) dff_jmp_num1(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(jmp_op_num1_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(jmp_op_num1_o),
	);	

	gnrl_dff # (.DW(32)) dff_jmp_num2(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(jmp_op_num2_i),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(jmp_op_num2_o),
	);

	gnrl_dff # (.DW(1)) dff_jmp_flag(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(jmp_flag),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(jmp_flag),
	);


endmodule