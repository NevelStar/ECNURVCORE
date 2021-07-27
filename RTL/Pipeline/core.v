//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.07.25
//Edited in 2021.07.26

`include "define.v"

module core(
	input						clk				,
	input						rst_n			,

	input	[`BUS_DATA_MEM] 	instr_i 		,
	input	[`BUS_DATA_MEM] 	addr_instr_i 	,
	input	[`BUS_DATA_MEM]		data_mem_i		,



	output						mem_state_o		,
	output						instr_rd_en_o		,
	output	[`BUS_DATA_MEM]		data_mem_wr_o	,	
	output	[`BUS_DATA_MEM]		addr_mem_o		,
	output 	[`BUS_ADDR_MEM]		pc_o			
	

);
	
	
	wire jmp_en_pc_i;
	wire [`BUS_ADDR_MEM] jmp_to_pc_i;

	wire [`BUS_DATA_MEM] instr_if_i; 		
	wire [`BUS_DATA_MEM] addr_instr_if_i;
	wire [`BUS_DATA_MEM] instr_if_o;
	wire [`BUS_DATA_MEM] addr_instr_if_o;

	
	wire [`BUS_DATA_REG] data_rs1_id_i;
	wire [`BUS_DATA_REG] data_rs2_id_i;
	wire [`BUS_DATA_REG] data_bypass_id_i;
	wire [`BUS_DATA_MEM] instr_id_i;
	wire [`BUS_DATA_MEM] addr_instr_id_i;
	wire [`BUS_DATA_REG] data_rs1_id_o;
	wire [`BUS_DATA_REG] data_rs2_id_o;
	wire [`BUS_ADDR_REG] addr_rs1_id_o;
	wire [`BUS_ADDR_REG] addr_rs2_id_o;
	wire [`BUS_ADDR_REG] addr_wr_id_o;
	wire reg_wr_en_id_o;
	wire [`BUS_DATA_MEM] instr_id_o;
	wire [`BUS_L_CODE] load_code_id_o;
	wire [`BUS_S_CODE] store_code_id_o;
	wire alu_add_sub_id_o;
	wire alu_shift_id_o;	
	wire [`BUS_ALU_OP] alu_operation_id_o;
	wire [`BUS_DATA_REG] alu_op_num1_id_o;
	wire [`BUS_DATA_REG] alu_op_num2_id_o;
	wire [`BUS_DATA_REG] jmp_op_num1_id_o;
	wire [`BUS_DATA_REG] jmp_op_num2_id_o;
	wire [`BUS_JMP_FLAG] jmp_flag_id_o;	
	wire load_bypass_id_o;


	wire [`BUS_DATA_REG] data_rs1_ex_i;
	wire [`BUS_DATA_REG] data_rs2_ex_i;
	wire [`BUS_L_CODE] load_code_ex_i;
	wire [`BUS_S_CODE] store_code_ex_i;
	wire alu_add_sub_ex_i;
	wire alu_shift_ex_i;
	wire [`BUS_ALU_OP] alu_operation_ex_i;
	wire [`BUS_DATA_REG] alu_op_num1_ex_i;
	wire [`BUS_DATA_REG] alu_op_num2_ex_i;
	wire [`BUS_DATA_REG] jmp_op_num1_ex_i;
	wire [`BUS_DATA_REG] jmp_op_num2_ex_i;	
	wire [`BUS_JMP_FLAG] jmp_flag_ex_i;
	wire [`BUS_DATA_MEM] data_mem_ex_i;
	wire [`BUS_ADDR_REG] addr_wr_ex_i;
	wire reg_wr_en_ex_i;
	wire [`BUS_DATA_REG] alu_result_ex_o;
	wire [`BUS_DATA_MEM] data_mem_wr_ex_o;	
	wire [`BUS_ADDR_MEM] addr_mem_wr_ex_o;	
	wire [`BUS_ADDR_MEM] addr_mem_rd_ex_o;	
	wire mem_state_ex_o;
	wire jmp_en_ex_o;
	wire [`BUS_ADDR_MEM] jmp_to_ex_o;
	wire [`BUS_ADDR_REG] addr_wr_ex_o;
	wire [`BUS_DATA_REG] data_wr_ex_o;
	wire wr_en_ex_o;


	wire wr_en_reg_i;
	wire [`BUS_ADDR_REG] addr_wr_reg_i;
	wire [`BUS_ADDR_REG] addr_rd1_reg_i;
	wire [`BUS_ADDR_REG] addr_rd2_reg_i;
	wire [`BUS_DATA_REG] data_wr_reg_i;
	wire [`BUS_DATA_REG] data_rd1_reg_o;
	wire [`BUS_DATA_REG] data_rd2_reg_o;

	wire jmp_en_ctrl_i;
	wire [`BUS_ADDR_MEM] jmp_to_ctrl_i;
	wire load_bypass_ctrl_i;
	wire jmp_en_ctrl_o;
	wire [`BUS_ADDR_MEM] jmp_to_ctrl_o;
	wire [`BUS_HOLD_CODE] hold_code_ctrl_o;

	wire [`BUS_HOLD_CODE] hold_code;

	assign jmp_en_pc_i = jmp_en_ctrl_o;
	assign jmp_to_pc_i = jmp_to_ctrl_o;


	assign data_rs1_id_i = data_rd1_reg_o;
	assign data_rs2_id_i = data_rd2_reg_o;
	assign data_bypass_id_i = alu_result_ex_o;
	assign instr_id_i = instr_i;
	assign addr_instr_id_i = addr_instr_i;

	assign data_rs1_ex_i = data_rs1_id_o;
	assign data_rs2_ex_i = data_rs2_id_o;
	assign load_code_ex_i = load_code_id_o;	
	assign store_code_ex_i = store_code_id_o;
	assign alu_add_sub_ex_i = alu_add_sub_id_o;
	assign alu_shift_ex_i = alu_shift_id_o;
	assign alu_operation_ex_i = alu_operation_id_o;
	assign alu_op_num1_ex_i = alu_op_num1_id_o;
	assign alu_op_num2_ex_i = alu_op_num2_id_o;
	assign jmp_op_num1_ex_i = jmp_op_num1_id_o;
	assign jmp_op_num2_ex_i = jmp_op_num2_id_o;
	assign jmp_flag_ex_i = jmp_flag_id_o;
	assign data_mem_wr_o = data_mem_wr_ex_o;
	assign mem_state_o = mem_state_ex_o;
	assign addr_mem_o = (mem_state_o == `MEM_WR_EN) ? addr_mem_wr_ex_o : addr_mem_rd_ex_o;

	assign data_mem_ex_i = data_mem_i;
	assign addr_wr_ex_i = addr_wr_id_o;
	assign reg_wr_en_ex_i = reg_wr_en_id_o;

	assign wr_en_reg_i = wr_en_ex_o;
	assign addr_wr_reg_i = addr_wr_ex_o;
	assign addr_rd1_reg_i = addr_rs1_id_o;
	assign addr_rd2_reg_i = addr_rs2_id_o;
	assign data_wr_reg_i = data_wr_ex_o;

	assign jmp_en_ctrl_i = jmp_en_ex_o;
	assign jmp_to_ctrl_i = jmp_to_ex_o;
	assign load_bypass_ctrl_i = load_bypass_id_o;

	assign hold_code = hold_code_ctrl_o;
	assign instr_rd_en_o = hold_code < `HOLD_CODE_IF;


	pc core_pc(
		.clk		(clk),
		.rst_n		(rst_n),
		.hold_code 	(hold_code),
	
		.jmp_en		(jmp_en_pc_i),
		.jmp_to		(jmp_to_pc_i),
	
		.addr_instr	(pc_o)
	);





	id_stage core_id(
		.clk			(clk),
		.rst_n			(rst_n),

		.hold_code		(hold_code),

		.data_rs1_i		(data_rs1_id_i),
		.data_rs2_i		(data_rs2_id_i),
		.data_bypass_i 	(data_bypass_id_i),
		.instr_i		(instr_id_i),
		.addr_instr_i	(addr_instr_id_i),	

		.data_rs1_o		(data_rs1_id_o),
		.data_rs2_o		(data_rs2_id_o),
		.addr_rs1_o		(addr_rs1_id_o),
		.addr_rs2_o		(addr_rs2_id_o),		
		.addr_wr_o		(addr_wr_id_o),

		.reg_wr_en_o	(reg_wr_en_id_o),
		.instr_o		(instr_id_o),
		.load_code_o	(load_code_id_o),
		.store_code_o	(store_code_id_o),
		.alu_add_sub_o	(alu_add_sub_id_o),
		.alu_shift_o	(alu_shift_id_o),
		.alu_operation_o(alu_operation_id_o),
		.alu_op_num1_o	(alu_op_num1_id_o),
		.alu_op_num2_o	(alu_op_num2_id_o),
		.jmp_op_num1_o	(jmp_op_num1_id_o),
		.jmp_op_num2_o	(jmp_op_num2_id_o),	
		.jmp_flag_o		(jmp_flag_id_o),
		.load_bypass_o	(load_bypass_id_o)
	);

	ex_stage core_ex(

		.clk			(clk),
		.rst_n			(rst_n),
		.hold_code		(hold_code),

		.data_rs1_i		(data_rs1_ex_i),
		.data_rs2_i		(data_rs2_ex_i),

		.load_code_i		(load_code_ex_i),
		.store_code_i		(store_code_ex_i),
		.jmp_flag_i		(jmp_flag_ex_i),
		.alu_add_sub_i	(alu_add_sub_ex_i),
		.alu_shift_i		(alu_shift_ex_i),
		.alu_operation_i	(alu_operation_ex_i),
		.alu_op_num1_i	(alu_op_num1_ex_i),
		.alu_op_num2_i	(alu_op_num2_ex_i),
		.jmp_op_num1_i	(jmp_op_num1_ex_i),
		.jmp_op_num2_i	(jmp_op_num2_ex_i),

		.data_mem_i 	(data_mem_ex_i),
		.addr_reg_wr_i	(addr_wr_ex_i),
		.reg_wr_en_i	(reg_wr_en_ex_i),


		.alu_result_o		(alu_result_ex_o),
		.data_mem_wr_o	(data_mem_wr_ex_o),
		.addr_mem_wr_o	(addr_mem_wr_ex_o),
		.addr_mem_rd_o	(addr_mem_rd_ex_o),
		.mem_state_o		(mem_state_ex_o),
		.jmp_en_o			(jmp_en_ex_o),
		.jmp_to_o			(jmp_to_ex_o),

		.addr_reg_wr_o	(addr_wr_ex_o),
		.data_reg_wr_o 	(data_wr_ex_o),
		.reg_wr_en_o	(wr_en_ex_o)	
		
	);



	regs genral_regs(
		.clk		(clk),
		.rst_n		(rst_n),

		.wr_en		(wr_en_reg_i),
		.addr_wr	(addr_wr_reg_i),
		.addr_rd1	(addr_rd1_reg_i),
		.addr_rd2	(addr_rd2_reg_i),
		.data_wr	(data_wr_reg_i),


		.data_rd1	(data_rd1_reg_o),
		.data_rd2	(data_rd2_reg_o)

	);


	ctrl core_ctrl(
		.jmp_en_i 		(jmp_en_ctrl_i),
		.jmp_to_i		(jmp_to_ctrl_i),
		.load_bypass_i 	(load_bypass_ctrl_i),

		.jmp_en_o		(jmp_en_ctrl_o),		
		.jmp_to_o		(jmp_to_ctrl_o),
		.hold_code_o	(hold_code_ctrl_o)
	);

endmodule