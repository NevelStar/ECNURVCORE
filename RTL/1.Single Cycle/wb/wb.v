//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09

module wb(
	input	[31:0]	data_out	,
	input	[31:0]	data_addr	,
	input	[31:0]	data_mem	,
	input	[6:0]	operation	,

	output	[31:0]	data_wr
);

	assign data_wr = 	operation[4] ? 	data_out : (					//Type-I-caculate or Type-R
						operation[6] ? 	data_addr + 32d'4 : (			//J-jal or I-jalr
										data_mem));						//I-load
endmodule