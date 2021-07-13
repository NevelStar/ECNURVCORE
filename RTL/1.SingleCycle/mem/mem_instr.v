//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.08
//Edited in 2021.07.11




module mem_instr(

	input 		[31:0]		addr	,

	output reg 	[31:0]	instr_out
);

	reg [7:0] instr_mem[0:255];

	initial begin
		$readmemh("../../../../../../RTL/1.SingleCycle/mem/memory_instr.dat",instr_mem);
	end

	always@(addr) begin
		instr_out <= {instr_mem[addr],instr_mem[addr+1],instr_mem[addr+2],instr_mem[addr+3]};
	end
endmodule