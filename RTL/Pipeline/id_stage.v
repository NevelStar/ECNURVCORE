//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.08.16

`include "define.v"

module id_stage(
	input						clk				,
	input						rst_n			,

	input	[`BUS_HOLD_CODE]	hold_code		,

	input	[`BUS_DATA_REG]		data_rs1_i		,
	input	[`BUS_DATA_REG]		data_rs2_i		,
	input	[`BUS_DATA_REG]		data_bypass_i	,
	input	[`BUS_DATA_INSTR]	instr_i			,
	input	[`BUS_ADDR_MEM]		addr_instr_i	,	

	output	[`BUS_DATA_REG]		data_rs1_o		,
	output	[`BUS_DATA_REG]		data_rs2_o		,
	output	[`BUS_DATA_REG]		jmpb_rs1_o		,
	output	[`BUS_DATA_REG]		jmpb_rs2_o		,
	output	[`BUS_ADDR_REG]		addr_rs1_o		,
	output	[`BUS_ADDR_REG]		addr_rs2_o		,
	output	[`BUS_ADDR_REG]		addr_wr_o		,
	output	[`BUS_ADDR_MEM]		addr_instr_o	,

	output						reg_wr_en_o		,
	output 	[`BUS_L_CODE] 		load_code_o		,
	output 	[`BUS_S_CODE] 		store_code_o	,
	output	[`OPERATION_CODE]	op_code_o		,
	output						alu_add_sub_o	,
	output						alu_shift_o		,
	output						word_intercept_o,
	output 	[`BUS_ALU_OP] 		alu_operation_o	,
	output	[`BUS_DATA_REG]		alu_op_num1_o	,
	output	[`BUS_DATA_REG]		alu_op_num2_o	,
	output	[`BUS_DATA_REG]		jmp_op_num1_o	,
	output	[`BUS_DATA_REG]		jmp_op_num2_o	,	
	output	[`BUS_JMP_FLAG] 	jmp_flag_o		,

	output						decode_except_o	,
	output	[`BUS_EXCEPT_CAUSE] except_cause_o	,
	output	[`BUS_ALU_OP]		csr_instr_o		,
	output	[`BUS_CSR_IMM]		csr_addr_o		,
	input	[`BUS_DATA_REG]		csr_data_i		,
	output	[`BUS_DATA_REG]		csr_data_o		,
	output						load_bypass_o
);
	wire [`BUS_ALU_OP] alu_operation;
	wire [`BUS_DATA_REG] alu_op_num1;
	wire [`BUS_DATA_REG] alu_op_num2;
	wire [`BUS_DATA_REG] jmp_op_num1;
	wire [`BUS_DATA_REG] jmp_op_num2;
	wire [`BUS_DATA_REG] data_rs1;
	wire [`BUS_DATA_REG] data_rs2;
	wire [`BUS_JMP_FLAG] jmp_flag;
	wire [`BUS_L_CODE] load_code;
	wire [`BUS_S_CODE] store_code;
	wire [`OPERATION_CODE] operation_code;
//	wire [`BUS_ALU_OP] funct3;
	wire [`BUS_ADDR_REG] reg_wr_addr;
	wire reg_wr_en;
	wire alu_add_sub;
	wire alu_shift;
	wire word_intercept;

	wire [`BUS_ALU_OP] csr_instr;
	wire [`BUS_CSR_IMM] csr_addr;	

	wire hold_n;

	assign hold_n = (hold_code >= `HOLD_CODE_ID) ? `HOLD_EN : `HOLD_DIS;

	assign jmp_op_num1_o = jmp_op_num1;
	assign jmp_op_num2_o = jmp_op_num2;
	assign jmp_flag_o = jmp_flag;
	assign jmpb_rs1_o = data_rs1;
	assign jmpb_rs2_o = data_rs2;


	decoder id_decoder
	(
		.data_rs1_reg		(data_rs1_i),
		.data_rs2_reg		(data_rs2_i),
		.reg_rd_addr_t		(addr_wr_o),
		.data_bypass 		(data_bypass_i),
		.instr				(instr_i),
		.addr_instr			(addr_instr_i),
		.load_code_t		(load_code_o),
		.reg_wr_en_t		(reg_wr_en_o),
		
		.data_rs1			(data_rs1),
		.data_rs2			(data_rs2),
		.alu_add_sub		(alu_add_sub),
		.alu_shift			(alu_shift),
		.word_intercept		(word_intercept),
		.alu_operation		(alu_operation),
		.alu_op_num1		(alu_op_num1),
		.alu_op_num2		(alu_op_num2),
		.jmp_op_num1		(jmp_op_num1),
		.jmp_op_num2		(jmp_op_num2),
		.jmp_flag			(jmp_flag),
		
		.load_code			(load_code),
		.store_code			(store_code),
		.operation_code		(operation_code),
//		.funct3				(funct3),
		
		.reg_rs1_addr		(addr_rs1_o),
		.reg_rs2_addr		(addr_rs2_o),
		.reg_wr_addr		(reg_wr_addr),
		.reg_wr_en			(reg_wr_en),
		.decode_except		(decode_except_o),
		.except_cause		(except_cause_o),
		.csr_instr			(csr_instr),
		.csr_addr			(csr_addr_o),
		.csr_data_i			(csr_data_i),
		.load_bypass		(load_bypass_o)

	);


	id_ex pipeline_id_ex
	(
		.clk				(clk),
		.rst_n				(rst_n),
	
		.data_rs1_i			(data_rs1),
		.data_rs2_i			(data_rs2),
		.addr_rd_i			(reg_wr_addr),
		.reg_wr_en_i		(reg_wr_en),
		.addr_instr_i		(addr_instr_i),
	
		.load_code_i		(load_code),
		.store_code_i		(store_code),
		.op_code_i			(operation_code),
//		.funct3_i			(funct3),
	
		.alu_add_sub_i		(alu_add_sub),
		.alu_shift_i		(alu_shift),
		.word_intercept_i	(word_intercept),
		.alu_operation_i	(alu_operation),
		.alu_op_num1_i		(alu_op_num1),
		.alu_op_num2_i		(alu_op_num2),
		.csr_instr_i		(csr_instr),
//		.csr_addr_i			(csr_addr),
		.csr_data_i			(csr_data_i),
	
		.hold_n				(hold_n),
	
		.data_rs1_o			(data_rs1_o),
		.data_rs2_o			(data_rs2_o),
		.addr_rd_o			(addr_wr_o),
		.reg_wr_en_o		(reg_wr_en_o),
		.addr_instr_o		(addr_instr_o),
	
		.load_code_o		(load_code_o),
		.store_code_o		(store_code_o),
		.op_code_o			(op_code_o),
//		.funct3_o			(funct3_o),
	
		.alu_add_sub_o		(alu_add_sub_o),
		.alu_shift_o		(alu_shift_o),
		.word_intercept_o	(word_intercept_o),
		.alu_operation_o	(alu_operation_o),
		.alu_op_num1_o		(alu_op_num1_o),
		.alu_op_num2_o		(alu_op_num2_o),
		.csr_instr_o		(csr_instr_o),
//		.csr_addr_o			(csr_addr_o),
		.csr_data_o			(csr_data_o)
	);

endmodule