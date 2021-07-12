//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.12

module alu_mem(

	input 	[31:0]		data_reg	,
	input	[31:0]		offset		,


	output 	[31:0]		addr_mem

);


	assign addr_mem = data_rs1 + offset;

endmodule