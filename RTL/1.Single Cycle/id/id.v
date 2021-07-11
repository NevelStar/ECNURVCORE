//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09


module id(
	input	[31:0]		instr_in	,

	output 	[6:0]		operation	,
	output 	[4:0]		rd			,
	output 	[2:0]		funct3		,	
	output 	[4:0]		rs1			,
	output 	[4:0]		rs2			,
	output 	[6:0]		funct7		,

	output  [11:0]		imm			,
	output	[31:0]		jmp			



);

	
	assign operation	= instr_in[6:0]		;
	assign rd			= instr_in[11:7]	;
	assign funct3		= instr_in[14:12]	;
	assign rs1			= instr_in[19:15]	;
	assign rs2			= instr_in[24:20]	;
	assign funct7		= instr_in[31:25]	;

	assign jmp			=  {{13{funct7[6]}},rs1,funct3,rs2[0],funct7[5:0],rs2[4:1]}	;								//type J imm

	//type U imm:{funct7,rs2,rs1,funct3}

	assign imm			= 	(operation == 7'b0110011) ? 12'h0									:	(				//type R
							(operation == 7'b0010011) ? {funct7,rs2}							:	(				//type I
							(operation == 7'b0100011) ? {funct7,rd}								:	(				//type S
							(operation == 7'b1100011) ? {funct7[6],rd[0],funct[5:0],rd[4:1]}	:   (				//type B
							(operation == 7'b1100111) ? {funct7,rs2}							:	(				//I jalr
							12'h0)))));
endmodule