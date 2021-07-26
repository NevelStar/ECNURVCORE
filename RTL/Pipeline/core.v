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
	wire [`BUS_DATA_REG] alu_result_ex_o;
	wire [`BUS_DATA_MEM] data_mem_wr_ex_o;	
	wire [`BUS_ADDR_MEM] addr_mem_wr_ex_o;	
	wire [`BUS_ADDR_MEM] addr_mem_rd_ex_o;	
	wire mem_state_ex_o;
	wire jmp_en_ex_o;
	wire [`BUS_ADDR_MEM] jmp_to_ex_o;

	wire [`BUS_DATA_MEM] data_mem_wb_i;
	wire [`BUS_DATA_REG] alu_result_wb_i;
	wire [`BUS_ADDR_REG] addr_wr_wb_i;
	wire reg_wr_en_wb_i;
	wire [`BUS_L_CODE] load_code_wb_i;
	wire [`BUS_ADDR_REG] addr_wr_wb_o;
	wire [`BUS_DATA_REG] data_wr_wb_o;
	wire [`BUS_DATA_REG] data_bypass_wb_o;
	wire wr_en_wb_o;


	wire wr_en_reg_i;
	wire [`BUS_ADDR_REG] addr_wr_reg_i;
	wire [`BUS_ADDR_REG] addr_rd1_reg_i;
	wire [`BUS_ADDR_REG] addr_rd2_reg_i;
	wire [`BUS_DATA_REG] data_wr_reg_i;
	wire [`BUS_DATA_REG] data_rd1_reg_o;
	wire [`BUS_DATA_REG] data_rd2_reg_o;

	wire jmp_en_ctrl_i;
	wire [`BUS_ADDR_MEM] jmp_to_ctrl_i;
	wire jmp_en_ctrl_o;
	wire [`BUS_ADDR_MEM] jmp_to_ctrl_o;
	wire pipline_hold_n;


	assign jmp_en_pc_i = jmp_en_ctrl_o;
	assign jmp_to_pc_i = jmp_to_ctrl_o;

	assign instr_if_i = instr_i;
	assign addr_instr_if_i = addr_instr_i;

	assign data_rs1_id_i = data_rd1_reg_o;
	assign data_rs2_id_i = data_rd2_reg_o;
	assign data_bypass_id_i = data_bypass_wb_o;
	assign instr_id_i = instr_if_o;
	assign addr_instr_id_i = instr_if_o;

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

	assign data_mem_wb_i = data_mem_i;
	assign alu_result_wb_i = alu_result_ex_o;
	assign addr_wr_wb_i = addr_wr_id_o;
	assign reg_wr_en_wb_i = reg_wr_en_id_o;
	assign load_code_wb_i = load_code_id_o;

	assign wr_en_reg_i = wr_en_wb_o;
	assign addr_wr_reg_i = addr_wr_wb_o;
	assign addr_rd1_reg_i = addr_rs1_id_o;
	assign addr_rd2_reg_i = addr_rs2_id_o;
	assign data_wr_reg_i = data_wr_wb_o;
	assign jmp_en_ctrl_i = jmp_en_ex_o;
	assign jmp_to_ctrl_i = jmp_to_ex_o;


	pc core_pc(
		.clk		(clk),
		.rst_n		(rst_n),
		.hold_n 	(pipline_hold_n),
	
		.jmp_en		(jmp_en_pc_i),
		.jmp_to		(jmp_to_pc_i),
	
		.addr_instr	(pc_o)
	);


	if_id core_pipline_if_id(
		.clk			(clk),
		.rst_n			(rst_n),

		.addr_instr_i	(addr_instr_if_i),
		.instr_i		(instr_if_i),

		.hold_n			(pipline_hold_n),


		.addr_instr_o	(addr_instr_if_o),
		.instr_o		(instr_if_o)	
	);


	id_stage core_id(
		.clk			(clk),
		.rst_n			(rst_n),

		.hold_n			(pipline_hold_n),

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
		.jmp_flag_o		(jmp_flag_id_o)
	);

	ex core_ex(

		.data_rs1		(data_rs1_ex_i),
		.data_rs2		(data_rs2_ex_i),

		.load_code		(load_code_ex_i),
		.store_code		(store_code_ex_i),
		.jmp_flag		(jmp_flag_ex_i),
		.alu_add_sub	(alu_add_sub_ex_i),
		.alu_shift		(alu_shift_ex_i),
		.alu_operation	(alu_operation_ex_i),
		.alu_op_num1	(alu_op_num1_ex_i),
		.alu_op_num2	(alu_op_num2_ex_i),
		.jmp_op_num1	(jmp_op_num1_ex_i),
		.jmp_op_num2	(jmp_op_num2_ex_i),



		.alu_result		(alu_result_ex_o),
		.data_mem_wr	(data_mem_wr_ex_o),
		.addr_mem_wr	(addr_mem_wr_ex_o),
		.addr_mem_rd	(addr_mem_rd_ex_o),
		.mem_state		(mem_state_ex_o),
		.jmp_en			(jmp_en_ex_o),
		.jmp_to			(jmp_to_ex_o)
		
	);


	reg_wb core_wb(
		.clk			(clk),
		.rst_n			(rst_n),
		.hold_n			(pipline_hold_n),

		.data_mem_i 	(data_mem_wb_i),
		.data_alu_i	 	(alu_result_wb_i),
		.addr_reg_wr_i	(addr_wr_wb_i),
		.reg_wr_en_i	(reg_wr_en_wb_i),
		.load_code_i	(load_code_wb_i),


		.addr_reg_wr_o	(addr_wr_wb_o),
		.data_reg_wr_o 	(data_wr_wb_o),
		.data_bypass_o	(data_bypass_wb_o),
		.reg_wr_en_o	(wr_en_wb_o)	
	

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
		.jmp_en_i 	(jmp_en_ctrl_i),
		.jmp_to_i	(jmp_to_ctrl_i),

		.jmp_en_o	(jmp_en_ctrl_o),		
		.jmp_to_o	(jmp_to_ctrl_o),
		.hold_n		(pipline_hold_n)
	);

endmodule