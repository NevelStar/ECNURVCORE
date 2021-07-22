//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.08
//Edited in 2021.07.09
//Edited in 2021.07.12
//Edited in 2021.07.14




module pc(
	
	input 				clk			,
	input 				rst_n		,

	input				jmp_en		,
	input				jmpr_en		,
	input				jmpb_en		,

	input	[31:0]		jmp_to		,


	output reg [31:0]	addr
);



	always @(posedge clk or negedge rst_n)begin
		if(!rst_n) begin
			addr <= 32'h0;
		end
		else begin
			case({jmp_en,jmpr_en,jmpb_en})
				3'b100:		addr <= addr + jmp_to;
				3'b010:		addr <= jmp_to;
				3'b001:		addr <= addr + jmp_to;
				3'b000:		addr <= addr + 32'd4;
				default:	addr <= addr;
			endcase
		end
	end

endmodule

