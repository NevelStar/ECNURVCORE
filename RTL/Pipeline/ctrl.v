//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.07.26

`include "define.v"

module ctrl(
	input [`BUS_ADDR_MEM]	jmp_num1_i		,
	input [`BUS_ADDR_MEM]	jmp_num2_i		,
	input [`BUS_DATA_REG]	data_rs1_i		,
	input [`BUS_DATA_REG]	data_rs2_i		,
	input [`BUS_JMP_FLAG]	jmp_flag_i		,
	input					load_bypass_i	,

	output					jmp_en_o		,
	output [`BUS_ADDR_MEM]	jmp_to_o		,	
	output					id_flush		,	
	output					ex_flush		,
	output [`BUS_HOLD_CODE]	hold_code_o 			
);

	reg jmp_en;

	assign jmp_en_o = jmp_en;
	assign jmp_to_o = jmp_num1_i + jmp_num2_i;

	assign rs1_slt_rs2 = (data_rs1_i[31] == data_rs2_i[31]) ? ((data_rs1_i < data_rs2_i) ? 1'b1 : 1'b0 ) : data_rs1_i[31];
	assign rs1_sltu_rs2 = (data_rs1_i < data_rs2_i) ? 1'b1 : 1'b0;

	always@(*) begin
		case(jmp_flag_i)
			`INSTR_BEQ:		jmp_en <= (data_rs1_i == data_rs2_i) ? `JMP_EN : `JMP_DIS;
			`INSTR_BNE:		jmp_en <= (data_rs1_i != data_rs2_i) ? `JMP_EN : `JMP_DIS;
			`INSTR_BLT:		jmp_en <= rs1_slt_rs2 ? `JMP_EN : `JMP_DIS;
			`INSTR_BGE:		jmp_en <= rs1_slt_rs2 ? `JMP_DIS : `JMP_EN;
			`INSTR_BLTU:	jmp_en <= rs1_sltu_rs2 ? `JMP_EN : `JMP_DIS;
			`INSTR_BGEU:	jmp_en <= rs1_sltu_rs2 ? `JMP_DIS : `JMP_EN;
			`JMP_J: 		jmp_en <= `JMP_EN;
			default:		jmp_en <= `JMP_DIS;
		endcase
	end




	assign hold_code_o = (load_bypass_i==`LOAD_BYPASS_EN) ? `HOLD_CODE_ID : `HOLD_CODE_NOPE;

endmodule