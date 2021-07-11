//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09

module data_pre(

	input	[6:0]		operation	,
	input 	[31:0]		data_rs1	,
	input 	[31:0]		data_rs2	,
	input	[31:0]		jmp 		,

	input	[11:0]		imm			,

	output  [31:0]		data_alu1	,
	output  [31:0]		data_alu2	,

	output	[31:0]		addr_mem	,

	output reg	[31:0]	jmp_to

);


	wire 	[31:0]	imm_ext;

	assign imm_ext = {{20{imm[11]}},imm[11:0]};

	assign data_alu1 = data_rs1;
	assign data_alu2 = operation[5] ? data_rs2 : imm_ext;

	assign addr_mem = data_rs2 + imm_ext;

	always@(*) begin
		case(operation[3:2])
			2'b11:		jmp_to <= jmp;					//J jal
			2'b01:		jmp_to <= data_rs1 + imm_ext;	//I jalr
			2'b00:		jmp_to <= imm_ext;				//Type-B
			default:	jmp_to <= 32'd0;
		endcase
	end


endmodule