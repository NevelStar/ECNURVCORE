//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.12
//Edited in 2021.07.13

module alu_mem(

	input 	[31:0]		data_reg	,
	input	[31:0]		offset		,


	output 	[31:0]		addr_mem

);
	wire [31:0] offset_addr;
	assign offset_addr = offset << 2;
	assign addr_mem = data_reg + offset_addr;

endmodule