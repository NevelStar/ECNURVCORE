//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23
//Edited in 2021.07.26

`include "define.v"

module ctrl(
	input					jmp_en_i		,
	input [`BUS_ADDR_MEM]	jmp_to_i		,

	output					jmp_en_o		,		
	output [`BUS_ADDR_MEM]	jmp_to_o		,
	output					hold_n
	output					pc_hold_n
);

	assign jmp_en_o = jmp_en_i;
	assign jmp_to_o = jmp_to_i;
	assign hold_n = 1'b1;
	assign pc_hold_n = 1'b1;

endmodule