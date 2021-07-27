//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.26

`include "define.v"

module ex_stage(
	input						clk				,
	input						rst_n			,

	input	[`BUS_HOLD_CODE]	hold_code		,


	input	[`BUS_DATA_REG]		data_rs1_i		,
	input	[`BUS_DATA_REG]		data_rs2_i		,

	input 	[`BUS_L_CODE]		load_code_i		,
	input 	[`BUS_S_CODE]		store_code_i	,
	input 	[`BUS_JMP_FLAG]		jmp_flag_i		,

	input						alu_add_sub_i	,
	input						alu_shift_i		,
	input	[`BUS_ALU_OP]		alu_operation_i	,
	input	[`BUS_DATA_REG]		alu_op_num1_i	,
	input	[`BUS_DATA_REG]		alu_op_num2_i	,
	input	[`BUS_DATA_REG]		jmp_op_num1_i	,
	input	[`BUS_DATA_REG]		jmp_op_num2_i	,

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
	output 	[`BUS_ADDR_MEM] 	addr_mem_rd_o	,
	output 						jmp_en_o		,
	output 	[`BUS_ADDR_MEM] 	jmp_to_o

);


	wire [`BUS_DATA_REG] alu_result;	
	wire hold_n;

	assign hold_n = (hold_code >= `HOLD_CODE_EX) ? `HOLD_EN : `HOLD_DIS;
	assign alu_result_o = alu_result;

	ex ex_alu(
		.data_rs1		(data_rs1_i),
		.data_rs2		(data_rs2_i),
	
		.load_code		(load_code_i),
		.store_code		(store_code_i),
		.jmp_flag		(jmp_flag_i),
		.alu_add_sub	(alu_add_sub_i),
		.alu_shift		(alu_shift_i),
		.alu_operation	(alu_operation_i),
		.alu_op_num1	(alu_op_num1_i),
		.alu_op_num2	(alu_op_num2_i),
		.jmp_op_num1	(jmp_op_num1_i),
		.jmp_op_num2	(jmp_op_num2_i),

		.alu_result		(alu_result),
		.data_mem_wr	(data_mem_wr_o),
		.addr_mem_wr	(addr_mem_wr_o),
		.addr_mem_rd	(addr_mem_rd_o),
		.mem_state		(mem_state_o),
		.jmp_en			(jmp_en_o),
		.jmp_to			(jmp_to_o)
	);

	ex_mem core_pipline_ex_mem(
		.clk			(clk),
		.rst_n			(rst_n),
		.hold_n			(hold_n),

		.data_mem_i 	(data_mem_i),
		.data_alu_i	 	(alu_result),
		.addr_reg_wr_i	(addr_reg_wr_i),
		.reg_wr_en_i	(reg_wr_en_i),
		.load_code_i	(load_code_i),


		.addr_reg_wr_o	(addr_reg_wr_o),
		.data_reg_wr_o 	(data_reg_wr_o),
		.reg_wr_en_o	(reg_wr_en_o)	
	

	);


endmodule