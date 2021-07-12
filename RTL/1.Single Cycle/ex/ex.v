//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09

module ex(
	
	input	[6:0]		operation	,
	input 	[31:0]		data_rs1	,
	input 	[31:0]		data_rs2	,
	input 	[31:0]		jmp			,

	input	[11:0]		imm			,

	input	[2:0]		funct3		,
	input				shift_ctrl	,
	input				sub_ctrl	,

	output  [31:0]		data_out	,
	output  [31:0]		addr_mem	,
	output  [31:0]		jmp_to

);

	wire [31:0] data_in1;
	wire [31:0] data_in2;
	wire [31:0] imm_ext;

	alu ex_alu(

		.data_in1	(data_in1),
		.data_in2	(data_in2),

		.funct3		(funct3),
		.shift_ctrl	(shift_ctrl),
		.sub_ctrl	(sub_ctrl),

		.data_out(data_out)
	);
	
	data_pre ex_data_pre(

		.operation	(operation),
		.data_rs1	(data_rs1),
		.data_rs2	(data_rs2),
		.imm		(imm),

		.data_alu1	(data_in1),
		.data_alu2	(data_in2),
		.imm_ext	(imm_ext)

	);

	alu_jmp ex_alu_jmp(

		.data_reg	(data_rs1),
		.jmp 		(jmp),

		.imm_ext	(imm_ext),


		.jmp_to 	(jmp_to)

	);

	alu_mem ex_alu_mem(
	
		.data_reg	(data_rs1),
		.offset		(imm_ext),

		.addr_mem	(addr_mem)

	);

endmodule