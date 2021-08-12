//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.26
//Edited in 2021.08.01

`include "define.v"

module ex_stage(
	input						clk				,
	input						rst_n			,

	input	[`BUS_HOLD_CODE]	hold_code		,


	input	[`BUS_DATA_REG]		data_rs1_i		,
//	input	[`BUS_DATA_REG]		data_rs2_i		,


	input						alu_add_sub_i	,
	input						alu_shift_i		,
	input	[`BUS_ALU_OP]		alu_operation_i	,
	input	[`BUS_DATA_REG]		alu_op_num1_i	,
	input	[`BUS_DATA_REG]		alu_op_num2_i	,

	input	[`BUS_DATA_MEM] 	data_mem_i 		,
	input	[`BUS_ADDR_REG]		addr_reg_wr_i	,
	input						reg_wr_en_i		,

	output	[`BUS_DATA_REG] 	alu_result_o	,
	output	[`BUS_ADDR_REG]		addr_reg_wr_o	,
	output	[`BUS_DATA_REG]		data_reg_wr_o 	,
	output						reg_wr_en_o		,

	output						mem_state_o		,
	output 	[`BUS_DATA_MEM] 	data_mem_wr_o	,	
	output 	[`BUS_ADDR_MEM] 	addr_mem_wr_o	,	
	output 	[`BUS_ADDR_MEM] 	addr_mem_rd_o	

);


module ex_csr(
	input						clk				,
	input						rst_n			,

	input	[`BUS_DATA_REG]		data_rs1_i		,
	input	[`BUS_DATA_REG]		data_rs2_i		,

	input 	[`BUS_L_CODE]		load_code_i		,
	input 	[`BUS_S_CODE]		store_code_i	,

	input						alu_add_sub_i	,
	input						alu_shift_i		,
	input	[`BUS_ALU_OP]		alu_operation_i	,
	input	[`BUS_DATA_REG]		alu_op_num1_i	,
	input	[`BUS_DATA_REG]		alu_op_num2_i	,

	input	[`BUS_DATA_MEM] 	data_mem_i 		,
	input	[`BUS_ADDR_REG]		addr_reg_wr_i	,
	input						reg_wr_en_i		,

	output	[`BUS_DATA_REG] 	alu_result_o	,
	output	[`BUS_ADDR_REG]		addr_reg_wr_o	,
	output	[`BUS_DATA_REG]		data_reg_wr_o 	,
	output						reg_wr_en_o		,

	output						mem_state_o		,
	output 	[`BUS_DATA_MEM] 	data_mem_wr_o	,	
	output 	[`BUS_ADDR_MEM] 	addr_mem_wr_o	,	
	output 	[`BUS_ADDR_MEM] 	addr_mem_rd_o	

);

endmodule