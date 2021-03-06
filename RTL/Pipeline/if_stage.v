//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.13

module if_stage(
	input	[`BUS_HOLD_CODE]	hold_code 		,
	input	[`BUS_DATA_INSTR]	instr_rd_i 		,
	input						instr_mask_i	,
	input	[`BUS_ADDR_MEM]		pc_i			,
	
	output						fetch_except_o	,
	output	[`BUS_EXCEPT_CAUSE]	except_cause_o	,
	output	[`BUS_DATA_INSTR]	instr_rd_o 		,
	output						instr_rd_en_o
);
	
	assign fetch_except_o = ((pc_i < `BASE_PC)|(pc_i > `PC_MAX)|(pc_i[1:0] != 2'b00)) ? `EXCEPT_ACT : `EXCEPT_NOPE;


	assign except_cause_o = ((pc_i < `BASE_PC)|(pc_i > `PC_MAX)) ? `EXCEPT_PC_OVER : ((pc_i[1:0] != 2'b00) ? `EXCEPT_PC_ALIGN : `EXCEPT_NONE);
	
	assign instr_rd_en_o = (hold_code < `HOLD_CODE_IF) ? `INSTR_RD_EN : `INSTR_RD_DIS;
	assign instr_rd_o = ((instr_mask_i == `MASK_EN)) ? `ZERO_WORD : instr_rd_i;

endmodule