//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//Edited in 2021.07.12

module wb(
	input	[31:0]	data_out	,
	input	[31:0]	data_addr	,
	input	[31:0]	data_mem	,
	input	[6:0]	operation	,

	output	[31:0]	data_wr
);
	
	wire [31:0]	data_addr_next;

	assign data_addr_next = data_addr + 32'd4;

	assign data_wr = 	operation[4] ? 	data_out : (					//Type-I-caculate or Type-R
						operation[6] ?  data_addr_next : data_mem);		//Type-J/I:jalr or I-load 
endmodule