//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.08
//Edited in 2021.07.09
//Edited in 2021.07.12




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
			if(jmp_en) begin
				addr <= addr + jmp_to;
			end
			else begin
				if(jmpr_en) begin
					addr <= jmp_to;
				end
				else begin
					if(jmpb_en) begin
						addr <= addr + jmp_to;
					end
					else begin
						addr <= addr + 32'd4;
					end
				end
			end
		end
	end

endmodule

