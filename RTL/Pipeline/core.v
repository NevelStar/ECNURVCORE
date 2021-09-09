//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.09.03

`include "define.v"

module core
(
	input						clk				,
	input						rst_n			,

	input						stall_if		,
	input						stall_mem		,

	input	[`BUS_DATA_INSTR] 	instr_i 		,
	input	[`BUS_ADDR_MEM] 	addr_instr_i 	,
	input	[`BUS_DATA_MEM]		data_mem_i		,



	output						mem_wr_en_o		,
	output						mem_rd_en_o		,
	output						instr_rd_en_o	,
	output	[`BUS_DATA_MEM]		data_mem_wr_o	,	
	output 	[`BUS_AXI_STRB]		strb_mem_wr_o	,
	output	[`BUS_ADDR_MEM]		addr_mem_wr_o	,	
	output	[`BUS_ADDR_MEM]		addr_mem_rd_o	,	
	output 	[`BUS_ADDR_MEM]		pc_o			
);
	
	wire fetch_except;
	wire decode_except;
	wire mem_except;
	wire [`BUS_EXCEPT_CAUSE] except_cause_if_o;
	wire [`BUS_EXCEPT_CAUSE] except_cause_id_o;
	wire [`BUS_EXCEPT_CAUSE] except_cause_ex_o;
	
	wire jmp_en_pc_i;
	wire [`BUS_ADDR_MEM] jmp_to_pc_i;

	wire instr_mask_if_i;
	wire [`BUS_ADDR_MEM] pc_if_i;
	wire [`BUS_DATA_INSTR] instr_rd_if_i; 	
	wire [`BUS_DATA_INSTR] instr_rd_if_o;
	wire instr_rd_en_if_o;

	wire [`BUS_DATA_REG] data_rs1_id_i;
	wire [`BUS_DATA_REG] data_rs2_id_i;
	wire [`BUS_DATA_REG] data_bypass_id_i;
	wire [`BUS_DATA_INSTR] instr_id_i;
	wire [`BUS_ADDR_MEM] addr_instr_id_i;
	wire [`BUS_DATA_REG] data_rs1_id_o;
	wire [`BUS_DATA_REG] data_rs2_id_o;
	wire [`BUS_DATA_REG] jmpb_rs1_id_o;
	wire [`BUS_DATA_REG] jmpb_rs2_id_o;
	wire [`BUS_ADDR_REG] addr_rs1_id_o;
	wire [`BUS_ADDR_REG] addr_rs2_id_o;
	wire [`BUS_ADDR_REG] addr_wr_id_o;
	wire [`BUS_ADDR_MEM] addr_instr_id_o;
	wire reg_wr_en_id_o;
	wire [`BUS_L_CODE] load_code_id_o;
	wire [`BUS_S_CODE] store_code_id_o;
	wire alu_add_sub_id_o;
	wire alu_shift_id_o;	
	wire word_intercept_id_o;
	wire [`BUS_ALU_OP] alu_operation_id_o;
	wire [`BUS_DATA_REG] alu_op_num1_id_o;
	wire [`BUS_DATA_REG] alu_op_num2_id_o;
	wire [`BUS_DATA_REG] jmp_op_num1_id_o;
	wire [`BUS_DATA_REG] jmp_op_num2_id_o;
	wire [`OPERATION_CODE] operation_code_id_o;
	wire [`BUS_ALU_OP] 	 csr_instr_id_o;
	wire [`BUS_CSR_IMM]	 csr_addr_id_o;
	wire [`BUS_JMP_FLAG] jmp_flag_id_o;	
	wire load_bypass_id_o;

//	wire [`BUS_ADDR_MEM] pc_ex_i;
//	wire [`BUS_DATA_INSTR] instr_ex_i;
	wire [`BUS_DATA_REG] data_rs1_ex_i;
	wire [`BUS_DATA_REG] data_rs2_ex_i;
	wire [`BUS_ALU_OP]	csr_instr_ex_i;	
	wire [`BUS_CSR_IMM]	csr_addr_ex_i;	
	wire [`BUS_L_CODE] load_code_ex_i;
	wire [`BUS_S_CODE] store_code_ex_i;
	wire alu_add_sub_ex_i;
	wire alu_shift_ex_i;
	wire word_intercept_ex_i;
	wire [`BUS_ALU_OP] alu_operation_ex_i;
	wire [`BUS_DATA_REG] alu_op_num1_ex_i;
	wire [`BUS_DATA_REG] alu_op_num2_ex_i;
	wire [`BUS_DATA_MEM] data_mem_ex_i;
	wire [`BUS_ADDR_REG] addr_wr_ex_i;
	wire reg_wr_en_ex_i;
	wire [`BUS_DATA_REG] alu_result_ex_o;
	wire [`BUS_DATA_MEM] data_mem_wr_ex_o;	
	wire [`BUS_AXI_STRB] strb_mem_wr_ex_o;
	wire [`BUS_ADDR_MEM] addr_mem_wr_ex_o;	
	wire [`BUS_ADDR_MEM] addr_mem_rd_ex_o;	
	wire mem_wr_en_ex_o;
	wire mem_rd_en_ex_o;
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

	wire 				 stall_if_ctrl_i;
	wire 				 stall_mem_ctrl_i;
	wire				 irq_jmp_ctrl_i;
	wire [`BUS_ADDR_MEM] irq_jmp_to_ctrl_i;
	wire [`BUS_ADDR_MEM] jmp_num1_ctrl_i;
	wire [`BUS_ADDR_MEM] jmp_num2_ctrl_i;
	wire [`BUS_ADDR_MEM] pc_prediction_ctrl_i;
	wire [`BUS_ADDR_MEM] pc_jmp_ctrl_i;
	wire [`BUS_DATA_REG] data_rs1_ctrl_i;
	wire [`BUS_DATA_REG] data_rs2_ctrl_i;
	wire [`BUS_JMP_FLAG] jmp_flag_ctrl_i;
	wire load_bypass_ctrl_i;
	wire jmp_en_ctrl_o;
	wire [`BUS_ADDR_MEM] jmp_to_ctrl_o;
	wire instr_mask_ctrl_o;
	wire [`BUS_HOLD_CODE] hold_code_ctrl_o;

	wire [`BUS_HOLD_CODE] hold_code;
	
	wire				   		irq_assert_clint_o;
	wire 	[`BUS_ADDR_MEM] 	irq_addr_clint_o;
	wire						csr_we_ex_o;
	wire	[`BUS_CSR_IMM]		csr_addr_ex_o;
	wire	[`BUS_DATA_REG]		csr_data_id_i;
	wire	[`BUS_DATA_REG]		csr_data_id_o;
	wire	[`BUS_DATA_REG]		csr_data_ex_o;
	wire						csr_we_clint_o;
	wire	[`BUS_CSR_IMM]		csr_addr_clint_o;
	wire	[`BUS_DATA_REG]		csr_data_clint_i;
	wire	[`BUS_DATA_REG]		csr_data_clint_o;
	
	wire	[`BUS_DATA_REG]		mstatus_csr_reg_o;
	wire	[`BUS_DATA_REG]		mie_csr_reg_o;
	wire	[`BUS_DATA_REG]		mtvec_csr_reg_o;
	wire	[`BUS_DATA_REG]		mepc_csr_reg_o;
	


	assign jmp_en_pc_i = jmp_en_ctrl_o;
	assign jmp_to_pc_i = jmp_to_ctrl_o;

	assign instr_rd_if_i = instr_i;
	assign pc_if_i = pc_o;
	assign instr_mask_if_i = instr_mask_ctrl_o;

	assign data_rs1_id_i = data_rd1_reg_o;
	assign data_rs2_id_i = data_rd2_reg_o;
	assign data_bypass_id_i = alu_result_ex_o;
	assign instr_id_i = instr_rd_if_o;
	assign addr_instr_id_i = addr_instr_i;

//	assign pc_ex_i = pc_o;
//	assign instr_ex_i = instr_rd_if_o;
	assign data_rs1_ex_i = data_rs1_id_o;
	assign data_rs2_ex_i = data_rs2_id_o;
	assign csr_instr_ex_i = csr_instr_id_o;
	assign csr_addr_ex_i = csr_addr_id_o;
	assign load_code_ex_i = load_code_id_o;	
	assign store_code_ex_i = store_code_id_o;
	assign alu_add_sub_ex_i = alu_add_sub_id_o;
	assign alu_shift_ex_i = alu_shift_id_o;
	assign word_intercept_ex_i = word_intercept_id_o;
	assign alu_operation_ex_i = alu_operation_id_o;
	assign alu_op_num1_ex_i = alu_op_num1_id_o;
	assign alu_op_num2_ex_i = alu_op_num2_id_o;
	assign data_mem_wr_o = data_mem_wr_ex_o;
	assign strb_mem_wr_o = strb_mem_wr_ex_o;
	assign mem_wr_en_o = mem_wr_en_ex_o;
	assign mem_rd_en_o = mem_rd_en_ex_o;
	assign addr_mem_wr_o = addr_mem_wr_ex_o;
	assign addr_mem_rd_o = addr_mem_rd_ex_o;

	assign data_mem_ex_i = data_mem_i;
	assign addr_wr_ex_i = addr_wr_id_o;
	assign reg_wr_en_ex_i = reg_wr_en_id_o;

	assign wr_en_reg_i = wr_en_ex_o & (hold_code_ctrl_o < `HOLD_CODE_EX);
	//assign wr_en_reg_i = wr_en_ex_o;
	assign addr_wr_reg_i = addr_wr_ex_o;
	assign addr_rd1_reg_i = addr_rs1_id_o;
	assign addr_rd2_reg_i = addr_rs2_id_o;
	assign data_wr_reg_i = data_wr_ex_o;

	assign stall_if_ctrl_i = stall_if;
	assign stall_mem_ctrl_i = stall_mem;
	assign jmp_num1_ctrl_i = jmp_op_num1_id_o;
	assign jmp_num2_ctrl_i = jmp_op_num2_id_o;
	assign pc_prediction_ctrl_i = pc_o;
	assign pc_jmp_ctrl_i = addr_instr_i;
	assign data_rs1_ctrl_i = jmpb_rs1_id_o;
	assign data_rs2_ctrl_i = jmpb_rs2_id_o;
	assign jmp_flag_ctrl_i = jmp_flag_id_o;
	assign load_bypass_ctrl_i = load_bypass_id_o;

	assign hold_code = hold_code_ctrl_o;
	assign instr_rd_en_o = instr_rd_en_if_o;

	assign irq_jmp_ctrl_i = irq_assert_clint_o;
	assign irq_jmp_to_ctrl_i = irq_addr_clint_o;


	pc core_pc
	(
		.clk				(clk),
		.rst_n				(rst_n),
		.hold_code 			(hold_code),
			
		.jmp_en				(jmp_en_pc_i),
		.jmp_to				(jmp_to_pc_i),
			
		.addr_instr			(pc_o)
	);


	if_stage core_if
	(
		.hold_code 			(hold_code),
		.instr_rd_i 		(instr_rd_if_i),
		.instr_mask_i		(instr_mask_if_i),
		.pc_i 				(pc_if_i),
			
		.fetch_except_o		(fetch_except),
		.except_cause_o		(except_cause_if_o),
		.instr_rd_o 		(instr_rd_if_o),
		.instr_rd_en_o		(instr_rd_en_if_o)
	);


	id_stage core_id
	(
		.clk				(clk),
		.rst_n				(rst_n),
	
		.hold_code			(hold_code),
	
		.data_rs1_i			(data_rs1_id_i),
		.data_rs2_i			(data_rs2_id_i),
		.data_bypass_i 		(data_bypass_id_i),
		.instr_i			(instr_id_i),
		.addr_instr_i		(addr_instr_id_i),	
	
		.data_rs1_o			(data_rs1_id_o),
		.data_rs2_o			(data_rs2_id_o),
		.jmpb_rs1_o			(jmpb_rs1_id_o),
		.jmpb_rs2_o			(jmpb_rs2_id_o),
		.addr_rs1_o			(addr_rs1_id_o),
		.addr_rs2_o			(addr_rs2_id_o),		
		.addr_wr_o			(addr_wr_id_o),
		.addr_instr_o		(addr_instr_id_o),
	
		.reg_wr_en_o		(reg_wr_en_id_o),
		.load_code_o		(load_code_id_o),
		.store_code_o		(store_code_id_o),
		.op_code_o			(operation_code_id_o),
		.alu_add_sub_o		(alu_add_sub_id_o),
		.alu_shift_o		(alu_shift_id_o),
		.word_intercept_o	(word_intercept_id_o),
		.alu_operation_o	(alu_operation_id_o),
		.alu_op_num1_o		(alu_op_num1_id_o),
		.alu_op_num2_o		(alu_op_num2_id_o),
		.jmp_op_num1_o		(jmp_op_num1_id_o),
		.jmp_op_num2_o		(jmp_op_num2_id_o),
		
		.csr_instr_o		(csr_instr_id_o),
		.csr_addr_o			(csr_addr_id_o),
		.csr_data_i			(csr_data_id_i),
		.csr_data_o			(csr_data_id_o),
		
		.jmp_flag_o			(jmp_flag_id_o),
		.decode_except_o	(decode_except),
		.except_cause_o		(except_cause_id_o),
		.load_bypass_o		(load_bypass_id_o)
	);


	ex_stage core_ex
	(
		.clk				(clk),
		.rst_n				(rst_n),
		.hold_code			(hold_code),
	
//		.pc_i				(pc_ex_i),
//		.instr_i			(instr_ex_i),
		.data_rs1_i			(data_rs1_ex_i),
		.data_rs2_i			(data_rs2_ex_i),
		.csr_instr_i		(csr_instr_ex_i),
		.csr_addr_i			(csr_addr_ex_i),
	
		.load_code_i		(load_code_ex_i),
		.store_code_i		(store_code_ex_i),
		.op_code_i			(operation_code_id_o),
		.alu_add_sub_i		(alu_add_sub_ex_i),
		.alu_shift_i		(alu_shift_ex_i),
		.word_intercept_i	(word_intercept_ex_i),
		.alu_operation_i	(alu_operation_ex_i),
		.alu_op_num1_i		(alu_op_num1_ex_i),
		.alu_op_num2_i		(alu_op_num2_ex_i),
	
		.data_mem_i 		(data_mem_ex_i),
		.addr_reg_wr_i		(addr_wr_ex_i),
		.reg_wr_en_i		(reg_wr_en_ex_i),
	
		.alu_result_o		(alu_result_ex_o),
		.data_mem_wr_o		(data_mem_wr_ex_o),
		.strb_mem_wr_o		(strb_mem_wr_ex_o),
		.addr_mem_wr_o		(addr_mem_wr_ex_o),
		.addr_mem_rd_o		(addr_mem_rd_ex_o),
		.mem_wr_en_o		(mem_wr_en_ex_o),
		.mem_rd_en_o		(mem_rd_en_ex_o),
	
		.addr_reg_wr_o		(addr_wr_ex_o),
		.data_reg_wr_o 		(data_wr_ex_o),
		.reg_wr_en_o		(wr_en_ex_o),
		
		.csr_we_o			(csr_we_ex_o),
        .csr_addr_o			(csr_addr_ex_o),
        .csr_data_o			(csr_data_ex_o),
        .csr_data_i			(csr_data_id_o),
		
		.mem_except_o		(mem_except),
		.except_cause_o		(except_cause_ex_o)
	);


	regs genral_regs
	(
		.clk				(clk),
		.rst_n				(rst_n),
		
		.wr_en				(wr_en_reg_i),
		.addr_wr			(addr_wr_reg_i),
		.addr_rd1			(addr_rd1_reg_i),
		.addr_rd2			(addr_rd2_reg_i),
		.data_wr			(data_wr_reg_i),
		
		.data_rd1			(data_rd1_reg_o),
		.data_rd2			(data_rd2_reg_o)
	);
	

	reg_csr U_reg_csr
	(
        .clk				(clk),
        .rst_n				(rst_n),
		
        .ex_we_i			(csr_we_ex_o),
        .ex_waddr_i			(csr_addr_ex_o),
		.ex_raddr_i			(csr_addr_id_o),
        .ex_data_i			(csr_data_ex_o),
        .ex_data_o			(csr_data_id_i),
		
        .clt_we_i			(csr_we_clint_o),
        .clt_addr_i			(csr_addr_clint_o),
        .clt_data_i			(csr_data_clint_o),
        .clt_data_o			(csr_data_clint_i),
		
		.csr_mstatus		(mstatus_csr_reg_o),
		.csr_mie			(mie_csr_reg_o),
		.csr_mtvec			(mtvec_csr_reg_o),
		.csr_mepc			(mepc_csr_reg_o)
    );


	ctrl core_ctrl
	(
		.clk				(clk),
		.rst_n				(rst_n),
		.stall_if			(stall_if_ctrl_i),
		.stall_mem			(stall_mem_ctrl_i),
		.irq_jmp_i 			(irq_jmp_ctrl_i),
		.irq_jmp_to_i		(irq_jmp_to_ctrl_i),
		.jmp_num1_i			(jmp_num1_ctrl_i),
		.jmp_num2_i			(jmp_num2_ctrl_i),
		.pc_pred_i			(pc_prediction_ctrl_i),
		.pc_instr_i			(pc_jmp_ctrl_i),
		.data_rs1_i			(data_rs1_ctrl_i),
		.data_rs2_i			(data_rs2_ctrl_i),
		.jmp_flag_i			(jmp_flag_ctrl_i),
		.load_bypass_i		(load_bypass_ctrl_i),
	
		.jmp_en_o			(jmp_en_ctrl_o),		
		.jmp_to_o			(jmp_to_ctrl_o),
		.instr_mask_o		(instr_mask_ctrl_o),
		.hold_code_o		(hold_code_ctrl_o)
	);
	

	clint core_clint
	(
		.clk				(clk),
		.rst_n				(rst_n),
	
		.except_src_if		(fetch_except),
		.except_cus_if		(except_cause_if_o),
	
		.except_src_id		(decode_except),
		.except_cus_id		(except_cause_id_o),
		.instr_id_i			(instr_id_i),
		.addr_instr_id_i	(addr_instr_id_i),
		
		.except_src_ex		(mem_except),
		.except_cus_ex		(except_cause_ex_o),
		
		.irq_assert_o		(irq_assert_clint_o),
		.irq_addr_o			(irq_addr_clint_o),
		
		.csr_we_o			(csr_we_clint_o),
		.csr_addr_o			(csr_addr_clint_o),
		.csr_data_i			(csr_data_clint_i),
		.csr_data_o			(csr_data_clint_o),
		
		.csr_mstatus		(mstatus_csr_reg_o),
		.csr_mie			(mie_csr_reg_o),
		.csr_mtvec			(mtvec_csr_reg_o), 
		.csr_mepc			(mepc_csr_reg_o)
);



endmodule