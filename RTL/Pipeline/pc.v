//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20


`include "define.v"



module pc(
	input						clk			,
	input						rst_n		,
	input						hold_n		,

	input						jmp_en		,
	input	[`BUS_ADDR_MEM]		jmp_to		,

	output reg [`BUS_ADDR_MEM]	addr_next
);



	always @(posedge clk)begin
		if(!rst_n) begin
			addr_instr <= `INSTR_ADDR_INI;
		end
		else begin
			if(!hold_n) begin
				addr_instr <= addr_instr;
			end
			else begin
				if(jmp_en) begin
					addr_instr <= jmp_to;
				end
				else begin
					addr_instr <= addr_instr + 32'd4;
				end
			end
		end
	end

endmodule

