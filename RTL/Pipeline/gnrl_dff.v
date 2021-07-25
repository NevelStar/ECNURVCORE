//ECNURVCORE
//General D Filp-Flop
//Created by Chesed
//2021.07.20

module gnrl_dff # (
	parameter	DW = 32
)(
	input				clk			,
	input				rst_n		,
	input				wr_en		,
	input	[DW-1:0]	data_in		,
	input	[DW-1:0]	data_r_ini	,

	output	[DW-1:0]	data_out	

);

	reg [DW-1:0] data_r;
	
	assign data_out = data_r;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			data_r <= data_r_ini;
		end
		else begin
			if(wr_en) begin
				data_r <= data_in;
			end
			else begin
				data_r <= data_r;
			end
		end
	end

endmodule