//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20
//Edited in 2021.07.26


`include "define.v"



module pc(
	input						clk			,
	input						rst_n		,
	input	[`BUS_HOLD_CODE]	hold_code	,

	input						jmp_en		,
	input	[`BUS_ADDR_MEM]		jmp_to		,

	output reg [`BUS_ADDR_MEM]	addr_instr
);

	wire hold_n;

	assign hold_n = (hold_code >= `HOLD_CODE_PC) ? `HOLD_EN : `HOLD_DIS;

	always @(posedge clk or negedge rst_n)begin
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

