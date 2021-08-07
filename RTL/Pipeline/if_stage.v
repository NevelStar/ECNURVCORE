//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.28

module if_stage(
	input	[`BUS_HOLD_CODE]	hold_code 		,
	input	[`BUS_DATA_INSTR]	instr_rd_i 		,
	input						instr_mask_i	,
	
	output	[`BUS_DATA_INSTR]	instr_rd_o 		,
	output						instr_rd_en_o
);

	
	assign instr_rd_en_o = (hold_code < `HOLD_CODE_IF) ? `INSTR_RD_EN : `INSTR_RD_DIS;
	assign instr_rd_o = (instr_mask_i == `MASK_EN) ? `ZERO_WORD : instr_rd_i;

endmodule