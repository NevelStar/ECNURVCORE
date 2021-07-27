//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.07.26

`include "define.v"

module ctrl(
	input					jmp_en_i		,
	input [`BUS_ADDR_MEM]	jmp_to_i		,
	input					load_bypass_i	,

	output					jmp_en_o		,		
	output [`BUS_ADDR_MEM]	jmp_to_o		,
	output [`BUS_HOLD_CODE]	hold_code_o 			
);

	assign jmp_en_o = jmp_en_i;
	assign jmp_to_o = jmp_to_i;
	assign hold_code_o = (load_bypass_i==`LOAD_BYPASS_EN) ? `HOLD_CODE_ID : `HOLD_CODE_NOPE;
endmodule