//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.21
//Edited in 2021.07.23

`include "define.v"

module ex(

	input	[`BUS_DATA_REG]		data_rs1		,
	input	[`BUS_DATA_REG]		data_rs2		,

	input 	[`BUS_L_CODE]		load_code		,
	input 	[`BUS_S_CODE]		store_code		,
	input 	[`BUS_JMP_FLAG]		jmp_flag		,

	input						alu_add_sub		,
	input						alu_shift		,
	input	[`BUS_ALU_OP]		alu_operation	,
	input	[`BUS_DATA_REG]		alu_op_num1		,
	input	[`BUS_DATA_REG]		alu_op_num2		,
	input	[`BUS_DATA_REG]		jmp_op_num1		,
	input	[`BUS_DATA_REG]		jmp_op_num2		,



	output reg 	[`BUS_DATA_REG]	alu_result		,
	output reg 	[`BUS_DATA_MEM]	data_mem_wr		,
	output reg 	[`BUS_ADDR_MEM]	addr_mem_wr		,
	output reg 	[`BUS_ADDR_MEM]	addr_mem_rd		,
	output reg 					mem_state		,
	output reg					jmp_en			,
	output	[`BUS_ADDR_MEM]		jmp_to
	
);
	
	wire [4:0] shamt;

	wire [`BUS_DATA_REG] sra_mask;
	wire [`BUS_DATA_REG] sra_sign;

	wire [`BUS_DATA_REG] alu_add;
	wire [`BUS_DATA_REG] alu_sub;
	wire [`BUS_DATA_REG] alu_sl;
	wire [`BUS_DATA_REG] alu_slt;
	wire [`BUS_DATA_REG] alu_sltu;
	wire [`BUS_DATA_REG] alu_xor;
	wire [`BUS_DATA_REG] alu_srl;
	wire [`BUS_DATA_REG] alu_sra;
	wire [`BUS_DATA_REG] alu_or;
	wire [`BUS_DATA_REG] alu_and;




	assign shamt = alu_op_num2[4:0];

	assign sra_mask = ~(32'hffffffff >> shamt);
	assign sra_sign = sra_mask & {32{alu_op_num1[31]}};


	assign alu_add = alu_op_num1 + alu_op_num2;
	assign alu_sub = alu_op_num1 - alu_op_num2;
	assign alu_sl = alu_op_num1 << shamt;
	assign alu_slt = (alu_op_num1[31] == alu_op_num2[31]) ? ((alu_op_num1 < alu_op_num2) ? 32'd1 : 32'd0 ) : {31'd0,alu_op_num1[31]};
	assign alu_sltu = (alu_op_num1 < alu_op_num2) ? 32'd1 : 32'd0;
	assign alu_xor = alu_op_num1 ^ alu_op_num2;
	assign alu_srl = alu_op_num1 >> shamt;
	assign alu_sra = (alu_op_num1 >> shamt) + sra_sign;
	assign alu_or = alu_op_num1 | alu_op_num2;
	assign alu_and = alu_op_num1 & alu_op_num2;




	assign jmp_to = jmp_op_num1 + jmp_op_num2;


	always@(*)begin
		case(alu_operation)
			`INSTR_ADD: begin
				case(alu_add_sub)
					`ALU_ADD_EN:	alu_result <= alu_add;
					`ALU_SUB_EN:	alu_result <= alu_sub;
					default:		alu_result <= `ZERO_WORD;
				endcase
			end
			`INSTR_SL:		alu_result <= alu_sl;
			`INSTR_SLT:		alu_result <= alu_slt;
			`INSTR_SLTU:	alu_result <= alu_sltu;
			`INSTR_XOR:		alu_result <= alu_xor;
			`INSTR_SR: begin
				case(alu_shift)
					`ALU_SHIFT_L:	alu_result <= alu_srl;
					`ALU_SHIFT_A:	alu_result <= alu_sra;
					default:		alu_result <= `ZERO_WORD;
				endcase
			end
			`INSTR_OR:		alu_result <= alu_or;
			`INSTR_AND:		alu_result <= alu_and;
			default:		alu_result <= `ZERO_WORD;
		endcase
	end

	always@(*) begin
		case(load_code)
			`INSTR_LB,`INSTR_LH,`INSTR_LW,`INSTR_LBU,`INSTR_LHU: begin
				addr_mem_rd <= alu_result;
			end
			default: begin
				addr_mem_rd <= `MEM_ADDR_ZERO;
			end
		endcase
	end

	always@(*) begin
		case(store_code)
			`INSTR_SB: begin
				data_mem_wr <= {24'd0,data_rs2[7:0]};
				addr_mem_wr <= alu_result;
				mem_state <= `MEM_WR_EN;
			end
			`INSTR_SH: begin
				data_mem_wr <= {16'd0,data_rs2[15:0]};
				addr_mem_wr <= alu_result;
				mem_state <= `MEM_WR_EN;
			end
			`INSTR_SW: begin
				data_mem_wr <= data_rs2;
				addr_mem_wr <= alu_result;
				mem_state <= `MEM_WR_EN;
			end
			default: begin
				data_mem_wr <= `ZERO_WORD;
				addr_mem_wr <= `MEM_ADDR_ZERO;
				mem_state <= `MEM_RD_EN;
			end
		endcase
	end

	always@(*) begin
		case(jmp_flag)
			`INSTR_BEQ:		jmp_en <= (data_rs1 == data_rs2) ? `JMP_EN : `JMP_DIS;
			`INSTR_BNE:		jmp_en <= (data_rs1 != data_rs2) ? `JMP_EN : `JMP_DIS;
			`INSTR_BLT:		jmp_en <= alu_slt[0] ? `JMP_EN : `JMP_DIS;
			`INSTR_BGE:		jmp_en <= alu_slt[0] ? `JMP_DIS : `JMP_EN;
			`INSTR_BLTU:	jmp_en <= alu_sltu[0] ? `JMP_EN : `JMP_DIS;
			`INSTR_BGEU:	jmp_en <= alu_sltu[0] ? `JMP_DIS : `JMP_EN;
			`JMP_J: 		jmp_en <= `JMP_EN;
			default:		jmp_en <= `JMP_DIS;
		endcase
	end

endmodule


