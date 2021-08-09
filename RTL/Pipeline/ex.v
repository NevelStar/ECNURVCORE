//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.21
//Edited in 2021.08.07

`include "define.v"

module ex(

	input	[`BUS_DATA_REG]		data_rs1		,
	input	[`BUS_DATA_REG]		data_rs2		,

	input 	[`BUS_L_CODE]		load_code		,
	input 	[`BUS_S_CODE]		store_code		,

	input						alu_add_sub		,
	input						alu_shift		,
	input						word_intercept	,
	input	[`BUS_ALU_OP]		alu_operation	,
	input	[`BUS_DATA_REG]		alu_op_num1		,
	input	[`BUS_DATA_REG]		alu_op_num2		,



	output reg 	[`BUS_DATA_REG]	alu_result		,
	output reg 	[`BUS_DATA_MEM]	data_mem_wr		,
	output reg 	[`BUS_ADDR_MEM]	addr_mem_wr		,
	output reg 	[`BUS_ADDR_MEM]	addr_mem_rd		,
	output reg 					mem_wr_en		,
	output reg 					mem_rd_en		
	
);
	
	wire [5:0] shamt;

	wire [`BUS_DATA_REG] sra_mask;
	wire [`BUS_DATA_REG] sra_sign;

	wire [`BUS_DATA_REG] alu_add;
	wire [`BUS_DATA_REG] alu_sub;
	wire [`BUS_DATA_REG] alu_sl;
	wire [`BUS_DATA_REG] alu_sllw;
	wire [`BUS_DATA_REG] alu_slt;
	wire [`BUS_DATA_REG] alu_sltu;
	wire [`BUS_DATA_REG] alu_xor;
	wire [`BUS_DATA_REG] alu_srl;
	wire [`BUS_DATA_REG] alu_sra;
	wire [`BUS_DATA_REG] alu_or;
	wire [`BUS_DATA_REG] alu_and;

	wire [`BUS_DATA_REG] op_num1_word;
	wire [`BUS_DATA_REG] op_num1_word_u;

	assign op_num1_word = {{32{alu_op_num1[31]}},alu_op_num1[31:0]};
	assign op_num1_word_u = {32'd0,alu_op_num1[31:0]};


	assign shamt = (word_intercept == `INTERCEPT_EN) ? {1'b0,alu_op_num2[4:0]} : alu_op_num2[5:0];

	assign sra_mask = ~(64'hffffffffffffffff >> shamt);
	assign sra_sign = sra_mask & {64{alu_op_num1[63]}};
	assign sraw_sign = sra_mask & {64{alu_op_num1[31]}};


	assign alu_add = alu_op_num1 + alu_op_num2;
	assign alu_sub = alu_op_num1 - alu_op_num2;
	assign alu_sl = alu_op_num1 << shamt;
	assign alu_slw = {{32{alu_sl[31]}},alu_sl[31:0]};
	assign alu_slt = (alu_op_num1[63] == alu_op_num2[63]) ? ((alu_op_num1 < alu_op_num2) ? 64'd1 : 64'd0 ) : {63'd0,alu_op_num1[63]};
	assign alu_sltu = (alu_op_num1 < alu_op_num2) ? 64'd1 : 64'd0;
	assign alu_xor = alu_op_num1 ^ alu_op_num2;
	assign alu_srl = alu_op_num1 >> shamt;
	assign alu_srlw = op_num1_word_u >> shamt;
	assign alu_sra = (alu_op_num1 >> shamt) + sra_sign;
	assign alu_sraw = (op_num1_word >> shamt) + sraw_sign;
	assign alu_or = alu_op_num1 | alu_op_num2;
	assign alu_and = alu_op_num1 & alu_op_num2;






	always@(*)begin
		case(alu_operation)
			`INSTR_ADD: begin
				case(alu_add_sub)
					`ALU_ADD_EN:	alu_result <= (word_intercept == `INTERCEPT_EN) ? {{32{alu_add[31]}},alu_add[31:0]} : alu_add;
					`ALU_SUB_EN:	alu_result <= (word_intercept == `INTERCEPT_EN) ? {{32{alu_sub[31]}},alu_sub[31:0]} : alu_sub;
					default:		alu_result <= `ZERO_DOUBLE;
				endcase
			end
			`INSTR_SL:		alu_result <= (word_intercept == `INTERCEPT_EN) ? alu_sllw : alu_sl;
			`INSTR_SLT:		alu_result <= alu_slt;
			`INSTR_SLTU:	alu_result <= alu_sltu;
			`INSTR_XOR:		alu_result <= alu_xor;
			`INSTR_SR: begin
				case(alu_shift)
					`ALU_SHIFT_L:	alu_result <= (word_intercept == `INTERCEPT_EN) ? alu_srlw : alu_srl;
					`ALU_SHIFT_A:	alu_result <= (word_intercept == `INTERCEPT_EN) ? alu_sraw : alu_sra;
					default:		alu_result <= `ZERO_DOUBLE;
				endcase
			end
			`INSTR_OR:		alu_result <= alu_or;
			`INSTR_AND:		alu_result <= alu_and;
			default:		alu_result <= `ZERO_DOUBLE;
		endcase
	end

	always@(*) begin
		case(load_code)
			`INSTR_LB,`INSTR_LH,`INSTR_LW,`INSTR_LD,`INSTR_LBU,`INSTR_LHU,`INSTR_LWU: begin
				addr_mem_rd <= alu_result;
				mem_rd_en <= `MEM_RD_EN;
			end
			default: begin
				addr_mem_rd <= `MEM_ADDR_ZERO;
				mem_rd_en <= `MEM_RD_DIS;
			end
		endcase
	end

	always@(*) begin
		case(store_code)
			`INSTR_SB: begin
				data_mem_wr <= {56'd0,data_rs2[7:0]};
				addr_mem_wr <= alu_result;
				mem_wr_en <= `MEM_WR_EN;
			end
			`INSTR_SH: begin
				data_mem_wr <= {48'd0,data_rs2[15:0]};
				addr_mem_wr <= alu_result;
				mem_wr_en <= `MEM_WR_EN;
			end
			`INSTR_SW: begin
				data_mem_wr <= {32'd0,data_rs2[31:0]};
				addr_mem_wr <= alu_result;
				mem_wr_en <= `MEM_WR_EN;
			end
			`INSTR_SD: begin
				data_mem_wr <= data_rs2;
				addr_mem_wr <= alu_result;
				mem_wr_en <= `MEM_WR_EN;
			end
			default: begin
				data_mem_wr <= `ZERO_WORD;
				addr_mem_wr <= `MEM_ADDR_ZERO;
				mem_wr_en <= `MEM_WR_DIS;
			end
		endcase
	end



endmodule


