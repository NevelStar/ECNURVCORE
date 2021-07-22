//ECNURVCORE
//Pipline CPU
//Created by Chesed
//2021.07.22


module register(
	input						clk			,
	input						rst_n		,

	input						wr_en		,
	input	[`BUS_ADDR_REG]		addr_wr		,
	input	[`BUS_ADDR_REG]		addr_rd1	,
	input	[`BUS_ADDR_REG]		addr_rd2	,
	input	[`BUS_DATA_REG]		data_wr		,


	output reg	[`BUS_DATA_REG]	data_rd1	,
	output reg	[`BUS_DATA_REG]	data_rd2


);

	integer i;
	
	reg [`BUS_DATA_REG] register_x[0:`REG_NUM-1]; //x0 is always 0

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			for(i=0;i<`REG_NUM;i=i+1)begin
				register_x[i] <= `ZERO_WORD;
			end
		end
		else begin
			if((addr_wr != `REG_ADDR_ZERO) & (wr_en == `REG_WR_EN)) begin
				register_x[addr_wr] <= data_wr;
			end
		end
	end

	always@(*) begin
		if(addr_rd1 == `REG_ADDR_ZERO) begin
			data_rd1 <= `ZERO_WORD;
		end
		else begin
			if((wr_en == `REG_WR_EN) & (addr_rd1 == addr_wr)) begin
				data_rd1 <= data_wr;
			end
			else begin
				data_rd1 <= register_x[addr_rd1];
			end
		end
	end

	always@(*) begin
		if(addr_rd2 == `REG_ADDR_ZERO) begin
			data_rd2 <= `ZERO_WORD;
		end
		else begin
			if((wr_en == `REG_WR_EN) & (addr_rd2 == addr_wr)) begin
				data_rd2 <= data_wr;
			end
			else begin
				data_rd2 <= register_x[addr_rd2];
			end
		end
	end

endmodule