//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.23

`include "define.v"

module reg_wb(
	input						clk				,
	input						rst_n			,
	input						hold_n			,

	input	[`BUS_DATA_MEM] 	data_mem_i 		,
	input	[`BUS_DATA_REG] 	data_alu_i	 	,
	input	[`BUS_ADDR_REG]		addr_reg_wr_i	,
	input						reg_wr_en_i		,
	input	[`BUS_L_CODE]		load_code_i		,


	output	[`BUS_ADDR_REG]		addr_reg_wr_o	,
	output	[`BUS_DATA_REG]		data_reg_wr_o 	,
	output	[`BUS_DATA_REG]		data_bypass_o 	,
	output						reg_wr_en_o		
	

);
	
	reg [`BUS_DATA_REG] data_reg_wr; 

	assign data_bypass_o = data_reg_wr;

	always@(*) begin
		case(load_code_i)
			`INSTR_LB: data_reg_wr <= {{24{data_mem_i[7]}},data_mem_i[7:0]};
			`INSTR_LH: data_reg_wr <= {{16{data_mem_i[15]}},data_mem_i[15:0]};
			`INSTR_LW: data_reg_wr <= data_mem_i;
			`INSTR_LBU: data_reg_wr <= {24'd0,data_mem_i[7:0]};
			`INSTR_LHU: data_reg_wr <= {16'd0,data_mem_i[15:0]};
			default: data_reg_wr <= data_alu_i;
		endcase
	end

	gnrl_dff # (.DW(5)) dff_addr_reg_wr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(addr_reg_wr_i),
		.data_r_ini	(`REG_ADDR_ZERO),

		.data_out	(addr_reg_wr_o)
	);

	gnrl_dff # (.DW(32)) dff_data_reg_wr(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(data_reg_wr),
		.data_r_ini	(`ZERO_WORD),

		.data_out	(data_reg_wr_o)
	);

	gnrl_dff # (.DW(1)) dff_reg_wr_en(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(hold_n),
		.data_in	(reg_wr_en_i),
		.data_r_ini	(`REG_WR_DIS),

		.data_out	(reg_wr_en_o)
	);


endmodule