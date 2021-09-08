//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.26
//Edited in 2021.08.31

`include "define.v"

module ex_stage(
	input						clk				,
	input						rst_n			,

	input	[`BUS_HOLD_CODE]	hold_code		,

	input	[`BUS_ADDR_MEM]		pc_i			,
	input	[`BUS_DATA_INSTR]	instr_i			,
	input	[`BUS_DATA_REG]		data_rs1_i		,
	input	[`BUS_DATA_REG]		data_rs2_i		,
	input	[`BUS_ALU_OP]		csr_instr_i		,
	input	[`BUS_CSR_IMM]		csr_addr_i		,

	input 	[`BUS_L_CODE]		load_code_i		,
	input 	[`BUS_S_CODE]		store_code_i	,

	input						alu_add_sub_i	,
	input						alu_shift_i		,
	input						word_intercept_i,
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

	output						mem_wr_en_o		,
	output						mem_rd_en_o		,
	output 	[`BUS_DATA_MEM] 	data_mem_wr_o	,	
	output 	[`BUS_AXI_STRB]		strb_mem_wr_o	,
	output 	[`BUS_ADDR_MEM] 	addr_mem_wr_o	,	
	output 	[`BUS_ADDR_MEM] 	addr_mem_rd_o	,
	
	output						csr_we_o		,
	output	[`BUS_CSR_IMM]		csr_addr_o		,
	input	[`BUS_DATA_REG]		csr_data_i		,
	output	[`BUS_DATA_REG] 	csr_data_o		,
	
	output						mem_except_o	,
	output	[`BUS_EXCEPT_CAUSE]	except_cause_o	

);

	wire [`BUS_DATA_REG] alu_result;	
	wire hold_n;

	assign hold_n = (hold_code >= `HOLD_CODE_EX) ? `HOLD_EN : `HOLD_DIS;

	ex ex_alu(
		.data_rs1		(data_rs1_i),
		.data_rs2		(data_rs2_i),
	
		.load_code		(load_code_i),
		.store_code		(store_code_i),
		.alu_add_sub	(alu_add_sub_i),
		.alu_shift		(alu_shift_i),
		.word_intercept (word_intercept_i),
		.alu_operation	(alu_operation_i),
		.alu_op_num1	(alu_op_num1_i),
		.alu_op_num2	(alu_op_num2_i),

		.alu_result		(alu_result),
		.data_mem_wr	(data_mem_wr_o),
		.strb_mem_wr	(strb_mem_wr_o),
		.addr_mem_wr	(addr_mem_wr_o),
		.addr_mem_rd	(addr_mem_rd_o),
		.mem_wr_en		(mem_wr_en_o),
		.mem_rd_en		(mem_rd_en_o),
		.mem_except		(mem_except_o),
		.except_cause	(except_cause_o)
	);

	ex_mem core_pipeline_ex_mem(
		.clk			(clk),
		.rst_n			(rst_n),
		.hold_n			(hold_n),

		.data_mem_i 	(data_mem_i),
		.data_alu_i	 	(alu_result),
		.addr_reg_wr_i	(addr_reg_wr_i),
		.reg_wr_en_i	(reg_wr_en_i),
		.load_code_i	(load_code_i),

		.alu_reg_wr_o	(alu_result_o),
		.addr_reg_wr_o	(addr_reg_wr_o),
		.data_reg_wr_o 	(data_reg_wr_o),
		.reg_wr_en_o	(reg_wr_en_o)	
	);

	ex_csr U_ex_csr
	(
		.clk			(clk),
		.rst_n			(rst_n),
		
		.pc_i			(pc_i),
		.instr_i		(instr_i),
		.data_rs1_i		(data_rs1_i),
		.addr_reg_wr_i	(addr_reg_wr_i),
		
		.csr_instr_i	(csr_instr_i),
		.csr_addr_i		(csr_addr_i),
		.csr_imm_i		(),

		.wr_csr_nxt_o	(),
		.rd_wen_o		(),
		.wb_rd_idx_o	(),
		.wb_data_o		()
	);


endmodule