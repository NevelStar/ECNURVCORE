//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.08.22

`include "define.v"

module ctrl(
	input					clk				,
	input					rst_n			,
	input					stall_if		,
	input					stall_mem		,
	input					irq_jmp_i		,
	input [`BUS_ADDR_MEM]	irq_jmp_to_i	,
	input [`BUS_ADDR_MEM]	jmp_num1_i		,
	input [`BUS_ADDR_MEM]	jmp_num2_i		,
	input [`BUS_ADDR_MEM]	pc_pred_i		,
	input [`BUS_ADDR_MEM]	pc_instr_i		,
	input [`BUS_DATA_REG]	data_rs1_i		,
	input [`BUS_DATA_REG]	data_rs2_i		,
	input [`BUS_JMP_FLAG]	jmp_flag_i		,
	input					load_bypass_i	,

	output					jmp_en_o		,
	output [`BUS_ADDR_MEM]	jmp_to_o		,	
	output					instr_mask_o	,	
	output [`BUS_HOLD_CODE]	hold_code_o 			
);

	reg jmp_en_pre;
	wire jmp_en;
	wire [`BUS_ADDR_MEM] jmp_to;

    wire rs1_slt_rs2;
    wire rs1_sltu_rs2;
	wire prediction_result;
	wire prediction_result_t;
	wire jmp_en_prediction;
	wire [`BUS_ADDR_MEM] jmp_to_prediction;
	wire hold_n;
	
	assign jmp_en = (load_bypass_i==`LOAD_BYPASS_EN) ? `JMP_DIS : jmp_en_pre ;
	assign jmp_to = (jmp_en == `JMP_EN) ? (jmp_num1_i + jmp_num2_i) : `MEM_ADDR_ZERO;



	assign rs1_slt_rs2 = (data_rs1_i[31] == data_rs2_i[31]) ? ((data_rs1_i < data_rs2_i) ? 1'b1 : 1'b0 ) : data_rs1_i[31];
	assign rs1_sltu_rs2 = (data_rs1_i < data_rs2_i) ? 1'b1 : 1'b0;

	always@(*) begin
		case(jmp_flag_i)
			`INSTR_BEQ:		jmp_en_pre = (data_rs1_i == data_rs2_i) ? `JMP_EN : `JMP_DIS;
			`INSTR_BNE:		jmp_en_pre = (data_rs1_i != data_rs2_i) ? `JMP_EN : `JMP_DIS;
			`INSTR_BLT:		jmp_en_pre = rs1_slt_rs2 ? `JMP_EN : `JMP_DIS;
			`INSTR_BGE:		jmp_en_pre = rs1_slt_rs2 ? `JMP_DIS : `JMP_EN;
			`INSTR_BLTU:	jmp_en_pre = rs1_sltu_rs2 ? `JMP_EN : `JMP_DIS;
			`INSTR_BGEU:	jmp_en_pre = rs1_sltu_rs2 ? `JMP_DIS : `JMP_EN;
			`JMP_J: 		jmp_en_pre = `JMP_EN;
			default:		jmp_en_pre = `JMP_DIS;
		endcase
	end

	assign jmp_en_o = (irq_jmp_i == `JMP_EN) ? `JMP_EN : ((prediction_result == `JMP_RIGHT) ? jmp_en_prediction : `JMP_EN);
	assign jmp_to_o = (irq_jmp_i == `JMP_EN) ? irq_jmp_to_i : (
					  (prediction_result == `JMP_RIGHT) ? jmp_to_prediction : (
					  (jmp_en == `JMP_EN) ? jmp_to : pc_instr_i + 32'd4));

	assign instr_mask_o = prediction_result_t;

	assign hold_code_o = (stall_mem == `STALL_EN) ? `HOLD_CODE_EX : ((stall_if == `STALL_EN) ? `HOLD_CODE_EX : `HOLD_CODE_NOPE);

	assign hold_n = (hold_code_o == `HOLD_CODE_NOPE) ? `HOLD_DIS : `HOLD_EN;

	gnrl_dff # (.DW(1)) dff_addr_reg_wr(
			.clk		(clk),
			.rst_n		(rst_n),
			.wr_en		(hold_n),
			.data_in	(prediction_result),
			.data_r_ini	(`JMP_RIGHT),
	
			.data_out	(prediction_result_t)
		);



	btb_ctrl ctrl_prediction(
		.clk				(clk),
		.rst_n				(rst_n),
		.hold_code 			(hold_code_o),
		
		.pc_i				(pc_pred_i),
		.pc_jmp_i			(pc_instr_i),
		.target_pc_i		(jmp_to),
		.jmp_en_i			(jmp_en),
		
		
		.jmp_prediction_o	(jmp_en_prediction),
		.target_pc_o		(jmp_to_prediction),
		.prediction_error_o	(prediction_result)
	);
endmodule