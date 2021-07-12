//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.12

module alu_mem(

	input 	[6:0]		operation	,
	input 	[31:0]		data_rs1	,
	input 	[31:0]		data_rs2	,
	input	[31:0]		offset		,


	output 	[31:0]		addr_mem

);


	assign addr_mem = operation[5] ? (data_rs2 + offset) : (data_rs1 + offset);

endmodule