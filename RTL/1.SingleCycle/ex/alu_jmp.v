//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.12
//Edited in 2021.07.14

module alu_jmp(

	input	[6:0]		operation	,
	input 	[31:0]		data_reg	,
	input	[31:0]		jmp 		,

	input	[31:0]		imm_ext		,
	input	[31:0]		imm_u_ext	,


	output reg	[31:0]	jmp_to

);



	always@(*) begin
		case(operation[4:2])
			3'b101:		jmp_to <= imm_u_ext;				//U auipc
			3'b011:		jmp_to <= jmp;						//J jal 
			3'b001:		jmp_to <= data_reg + imm_ext;		//I jalr
			3'b000:		jmp_to <= imm_ext << 1;				//Type-B
			default:	jmp_to <= 32'd0;
		endcase
	end


endmodule