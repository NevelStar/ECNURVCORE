//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//Edited in 2021.07.12
//Edited in 2021.07.14

module ctrl(

	input 	[31:0]		data_rs1	,
	input 	[31:0]		data_rs2	,
	input	[6:0]		operation	,


	input	[2:0]		funct3		,
	input	[6:0]		funct7		,


	output	[2:0]		load_code	,
	output	[1:0]		store_code	,
	output				wr_en		,

	output				jmp_en		,
	output				jmpr_en		,
	output				jmpb_en		,

	output				shift_ctrl	,
	output				sub_ctrl	

);
	wire	type_R;
	wire	type_S;
	wire	type_B;
	wire	type_I_cal;
	wire	type_I_load;
	wire	type_U_LUI;
	wire	type_U_AUIPC;

	wire	J_jal;
	wire	I_jalr;

	wire 	jmpb;


	assign type_R		= (operation==7'b0110011) ? 1'b1 : 1'b0;
	assign type_S		= (operation==7'b0100011) ? 1'b1 : 1'b0;
	assign type_B		= (operation==7'b1100011) ? 1'b1 : 1'b0;
	assign type_I_cal	= (operation==7'b0010011) ? 1'b1 : 1'b0;
	assign type_I_load	= (operation==7'b0000011) ? 1'b1 : 1'b0;
	assign type_U_LUI	= (operation==7'b0110111) ? 1'b1 : 1'b0;
	assign type_U_AUIPC	= (operation==7'b0010111) ? 1'b1 : 1'b0;
 
	assign J_jal		= (operation==7'b1101111) ? 1'b1 : 1'b0;
	assign I_jalr		= (operation==7'b1100111) ? 1'b1 : 1'b0;





	assign load_code = type_I_load ? funct3 : 3'b111 ;
	assign store_code = type_S ? funct3[1:0] : 2'b11 ;
	assign wr_en = type_R | type_I_cal | J_jal | I_jalr | type_I_load | type_U_LUI;


	assign jmp_en = J_jal;
	assign jmpr_en = I_jalr;
	assign jmpb_en = type_B & jmpb;

	assign sub_ctrl = (funct7 == 7'b0100000) & type_R;
	assign shift_ctrl = funct7[5];


	branch_ctrl brjmp_ctrl(
	
		.data_rs1(data_rs1)	,
		.data_rs2(data_rs2)	,
	
		.funct3	(funct3)	,
	
		.jmpb(jmpb)
	);

endmodule
