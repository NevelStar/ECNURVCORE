//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//Edited in 2021.07.12
//Edited in 2021.07.14

module wb(
	input	[31:0]	data_out	,
	input	[31:0]	data_addr	,
	input	[31:0]	data_mem	,

	input	[19:0]	data_imm_u	,
	input	[6:0]	operation	,

	output	[31:0]	reg data_wr
);
	
	wire [31:0]	data_addr_next;

	assign data_addr_next = data_addr + 32'd4;


	always@(*)begin
		case({operation[6],operation[4],operation[2]})
			3'b000:		data_wr <= data_mem;				//I-load
			3'b010:		data_wr <= data_out;				//type R or I-caculate
			3'b011:		data_wr <= {data_imm_u,12'd0};		//U-lui
			3'b101:		data_wr <= data_addr_next;			//J-jal or I-jalr
			default:	data_wr <= 32'd0;
		endcase
	end

endmodule