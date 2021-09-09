//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20
//Edited in 2021.08.07

`include "define.v"

module id_ex
(
	input						clk				,
	input						rst_n			,

	input	[`BUS_DATA_REG]		data_rs1_i		,
	input	[`BUS_DATA_REG]		data_rs2_i		,
	input	[`BUS_ADDR_REG]		addr_rd_i		,
	input						reg_wr_en_i		,
	input	[`BUS_ADDR_MEM]		addr_instr_i	,

	input 	[`BUS_L_CODE]		load_code_i		,
	input 	[`BUS_S_CODE]		store_code_i	,
	input	[`OPERATION_CODE]	op_code_i		,

	input		 				alu_add_sub_i	,
	input		 				alu_shift_i		,
	input						word_intercept_i,
	input	[`BUS_ALU_OP]		alu_operation_i	,
	input	[`BUS_DATA_REG]		alu_op_num1_i	,
	input	[`BUS_DATA_REG]		alu_op_num2_i	,
	input	[`BUS_ALU_OP]		csr_instr_i		,
	input	[`BUS_CSR_IMM]		csr_addr_i		,
	input	[`BUS_DATA_REG]		csr_data_i		,


	input						hold_n			,

	output	[`BUS_DATA_REG]		data_rs1_o		,
	output	[`BUS_DATA_REG]		data_rs2_o		,
	output	[`BUS_ADDR_REG]		addr_rd_o		,
	output						reg_wr_en_o		,
	output	[`BUS_ADDR_MEM]		addr_instr_o	,


	output 	[`BUS_L_CODE]		load_code_o		,
	output 	[`BUS_S_CODE]		store_code_o	,
	output	[`OPERATION_CODE]	op_code_o		,

	output		 				alu_add_sub_o	,
	output		 				alu_shift_o		,
	output						word_intercept_o,
	output	[`BUS_ALU_OP]		alu_operation_o	,
	output	[`BUS_DATA_REG]		alu_op_num1_o	,
	output	[`BUS_DATA_REG]		alu_op_num2_o	,
	output	[`BUS_ALU_OP]		csr_instr_o		,
	output	[`BUS_CSR_IMM]		csr_addr_o		,
	output	[`BUS_DATA_REG]		csr_data_o		
	
);
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_data_rs1(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(data_rs1_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(data_rs1_o)
	);

	gnrl_dff # (.DW(`DATA_WIDTH)) dff_data_rs2(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(data_rs2_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(data_rs2_o)
	);	

	gnrl_dff # (.DW(5)) dff_addr_rd(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(addr_rd_i),
		.data_r_ini	(`REG_ADDR_ZERO),

		.data_out	(addr_rd_o)
	);	
	gnrl_dff # (.DW(1)) dff_wr_en(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(reg_wr_en_i),
		.data_r_ini	(`REG_WR_DIS),

		.data_out	(reg_wr_en_o)
	);	


	gnrl_dff # (.DW(3)) dff_store_code(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(store_code_i),
		.data_r_ini	(`STORE_NOPE),

		.data_out	(store_code_o)
	);	
	gnrl_dff # (.DW(3)) dff_load_code(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(load_code_i),
		.data_r_ini	(`LOAD_NOPE),

		.data_out	(load_code_o)
	);	

	gnrl_dff # (.DW(1)) dff_add_sub(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_add_sub_i),
		.data_r_ini	(`ALU_ADD_EN),

		.data_out	(alu_add_sub_o)
	);	

	gnrl_dff # (.DW(1)) dff_shift_l_a(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_shift_i),
		.data_r_ini	(`ALU_SHIFT_L),

		.data_out	(alu_shift_o)
	);	
	gnrl_dff # (.DW(1)) dff_word_intercept(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(word_intercept_i),
		.data_r_ini	(`INTERCEPT_DIS),

		.data_out	(word_intercept_o)
	);	
	gnrl_dff # (.DW(3)) dff_alu_opcode(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_operation_i),
		.data_r_ini	(`ALU_ADD),

		.data_out	(alu_operation_o)
	);

	gnrl_dff # (.DW(`DATA_WIDTH)) dff_alu_num1(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_op_num1_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(alu_op_num1_o)
	);	

	gnrl_dff # (.DW(`DATA_WIDTH)) dff_alu_num2(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(alu_op_num2_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(alu_op_num2_o)
	);

	gnrl_dff # (.DW(3)) dff_csr_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(csr_instr_i),
		.data_r_ini	(`CSR_CODE_NOPE),

		.data_out	(csr_instr_o)
	);

	gnrl_dff # (.DW(12)) dff_csr_addr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(csr_addr_i),
		.data_r_ini	(`CSR_ADDR_ZERO),

		.data_out	(csr_addr_o)
	);


	gnrl_dff # (.DW(`DATA_WIDTH)) dff_addr_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(addr_instr_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(addr_instr_o)
	);
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_addr_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(csr_data_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(csr_data_o)
	);

	gnrl_dff # (.DW(7)) dff_addr_instr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(op_code_i),
		.data_r_ini	(`ZERO_DOUBLE),

		.data_out	(op_code_o)
	);


endmodule