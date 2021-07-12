//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.12

module alu_jmp(

	input	[6:0]		operation	,
	input 	[31:0]		data_reg	,
	input	[31:0]		jmp 		,

	input	[31:0]		imm_ext		,


	output reg	[31:0]	jmp_to

);



	always@(*) begin
		case(operation[3:2])
			2'b11:		jmp_to <= jmp;					//J jal
			2'b01:		jmp_to <= data_reg + imm_ext;	//I jalr
			2'b00:		jmp_to <= imm_ext;				//Type-B
			default:	jmp_to <= 32'd0;
		endcase
	end


endmodule