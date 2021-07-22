//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.21

`include "define.v"

module ex(

	input	[`BUS_DATA_REG]		data_rs1		,
	input	[`BUS_DATA_REG]		data_rs2		,

	input	[`BUS_DATA_MEM]		instr			,
	input	[`BUS_DATA_MEM]		data_mem		,

	input 	[`BUS_L_CODE]		load_code		,
	input 	[`BUS_S_CODE]		store_code		,

	input	[`BUS_ALU_OP]		alu_operation	,
	input	[`BUS_DATA_REG]		alu_op_num1		,
	input	[`BUS_DATA_REG]		alu_op_num2		,
	input	[`BUS_DATA_REG]		jmp_op_num1		,
	input	[`BUS_DATA_REG]		jmp_op_num2		,



	output reg 	[`BUS_DATA_REG]	data_reg_wr		,
	output reg 	[`BUS_DATA_MEM]	data_mem_wr		,
	output reg 	[`BUS_ADDR_MEM]	data_addr_wr	,
	output reg 	[`BUS_ADDR_MEM]	data_addr_rd	,
	output reg 					mem_wr_state	,
	output	[`BUS_ADDR_MEM]		jmp_to
	
);
	
	wire [4:0] shamt;
	wire [6:0] funct7;

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

	reg [`BUS_DATA_REG] alu_result;

	assign shamt = alu_op_num2[4:0];
	assign funct7 = instr[`FUNCT7];

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
				case(funct7)
					`FUNCT7_ADD:	alu_result <= alu_add;
					`FUNCT7_SUB:	alu_result <= alu_sub;
					default:		alu_result <= `ZERO_WORD;
				endcase
			end
			`INSTR_SL:		alu_result <= alu_sl;
			`INSTR_SLT:		alu_result <= alu_slt;
			`INSTR_SLTU:	alu_result <= alu_sltu;
			`INSTR_XOR:		alu_result <= alu_xor;
			`INSTR_SR: begin
				case(funct7)
					`FUNCT7_SRL:	alu_result <= alu_srl;
					`FUNCT7_SRA:	alu_result <= alu_sra;
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
			`INSTR_LB: begin
				data_reg_wr <= {{24{data_mem[7]}},data_mem[7:0]};
				data_addr_rd <= alu_result;
			end
			`INSTR_LH: begin
				data_reg_wr <= {{16{data_mem[15]}},data_mem[15:0]};
				data_addr_rd <= alu_result;
			end
			`INSTR_LW: begin
				data_reg_wr <= data_mem;
				data_addr_rd <= alu_result;
			end
			`INSTR_LBU: begin
				data_reg_wr <= {24'd0,data_mem[7:0]};
				data_addr_rd <= alu_result;
			end
			`INSTR_LHU: begin
				data_reg_wr <= {16'd0,data_mem[15:0]};
				data_addr_rd <= alu_result;
			end
			default: begin
				data_reg_wr <= alu_result;
				data_addr_rd <= `MEM_ADDR_ZERO;
			end
		endcase
	end

	always@(*) begin
		case(store_code)
			`INSTR_SB: begin
				data_mem_wr <= {24'd0,data_rs2[7:0]};
				data_addr_wr <= alu_result;
				mem_wr_state <= `MEM_WR_EN;
			end
			`INSTR_SH: begin
				data_mem_wr <= {16'd0,data_rs2[15:0]};
				data_addr_wr <= alu_result;
				mem_wr_state <= `MEM_WR_EN;
			end
			`INSTR_SW: begin
				data_mem_wr <= data_rs2;
				data_addr_wr <= alu_result;
				mem_wr_state <= `MEM_WR_EN;
			end
			default: begin
				data_mem_wr <= `ZERO_WORD;
				data_addr_wr <= `MEM_ADDR_ZERO;
				mem_wr_state <= `MEM_RD_EN;
			end
		endcase
	end

endmodule


