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


	reg [31:0] addr_next;

	initial begin 
		addr_next <= 31'b0;
		addr <= 31'b0;
	end

	always @(posedge clk or negedge rst_n)begin
		if(!rst_n) begin
			addr_next <= 32'h0;
		end
		else begin
			if(jmp_en) begin
				addr_next <= addr + jmp_to;
			end
			else begin
				if(jmpr_en) begin
					addr_next <= jmp_to;
				end
				else begin
					if(jmpb_en) begin
						addr_next <= addr + jmp_to;
					end
					else begin
						addr_next <= addr + 32'd4;
					end
				end
			end
		end
	end

	always @(posedge clk or negedge rst_n)begin
		if(!rst_n) begin
			addr <= 32'h0;
		end
		else begin
			addr <= addr_next;
		end
	end

endmodule

