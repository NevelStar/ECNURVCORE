//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20
//Edited in 2021.08.08

`include "define.v"

module decoder(
	input	[`BUS_DATA_REG]		data_rs1_reg	,
	input	[`BUS_DATA_REG]		data_rs2_reg	,
	input	[`BUS_ADDR_REG]		reg_rd_addr_t	,
	input	[`BUS_DATA_REG]		data_bypass		,
	input	[`BUS_DATA_INSTR]	instr			,
	input	[`BUS_ADDR_MEM]		addr_instr		,
	input 	[`BUS_L_CODE]		load_code_t		,



	output	[`BUS_DATA_REG]		data_rs1		,
	output	[`BUS_DATA_REG]		data_rs2		,
	output	reg [`BUS_ALU_OP]	alu_operation	,
	output	reg 				alu_add_sub		,
	output	reg 				alu_shift		,
	output	reg 				word_intercept	,
	output	reg [`BUS_DATA_REG]	alu_op_num1		,
	output	reg [`BUS_DATA_REG]	alu_op_num2		,
	output	reg [`BUS_DATA_REG]	jmp_op_num1		,
	output	reg [`BUS_DATA_REG]	jmp_op_num2		,
	output	reg [`BUS_JMP_FLAG]	jmp_flag		,

	output 	reg [`BUS_L_CODE]	load_code		,
	output 	reg [`BUS_S_CODE]	store_code		,

	output	reg [`BUS_ADDR_REG]	reg_rs1_addr	,
	output	reg [`BUS_ADDR_REG]	reg_rs2_addr	,
	output	reg [`BUS_ADDR_REG]	reg_wr_addr		,
	output	reg 				reg_wr_en		,
	output						load_bypass
);


	wire	[6:0]	operation_code;
	wire	[4:0]	addr_rd;
	wire	[2:0]	funct3;
	wire	[4:0]	addr_rs1;
	wire	[4:0]	addr_rs2;
	wire	[6:0]	funct7;
	wire	[5:0]	funct7_w;
	wire bypass_en1;
	wire bypass_en2;
	wire bypass_act;


	assign operation_code = instr[`OPERATION_CODE];
	assign addr_rd = instr[`ADDR_RD];
	assign funct3 = instr[`FUNCT3];
	assign addr_rs1 = instr[`ADDR_RS1];		
	assign addr_rs2 = instr[`ADDR_RS2];	
	assign funct7 = instr[`FUNCT7];
	assign funct7_w = instr[`FUNCT7_W];

	assign bypass_en1 = (reg_rs1_addr == reg_rd_addr_t) ? `BYPASS_EN : `BYPASS_DIS;
	assign bypass_en2 = (reg_rs2_addr == reg_rd_addr_t) ? `BYPASS_EN : `BYPASS_DIS;
	assign bypass_act = bypass_en1 | bypass_en2;

	assign data_rs1 = (bypass_en1 == `BYPASS_EN) ? data_bypass : data_rs1_reg;
	assign data_rs2 = (bypass_en2 == `BYPASS_EN) ? data_bypass : data_rs2_reg;

	assign load_bypass = bypass_act & (load_code_t != `LOAD_NOPE);


	always@(*) begin
		case(operation_code)
			`OPERATION_R: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= addr_rs1;
				reg_rs2_addr <= addr_rs2;
				reg_wr_addr <= addr_rd;
				
				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;
				
				alu_add_sub <= (funct7 == `FUNCT7_SUB) ? `ALU_SUB_EN : `ALU_ADD_EN;
				alu_shift <= (funct7 == `FUNCT7_SRA) ? `ALU_SHIFT_A : `ALU_SHIFT_L;
				word_intercept <= `INTERCEPT_DIS;
				alu_operation <= funct3;
				alu_op_num1	<= data_rs1;
				alu_op_num2	<= data_rs2;
				jmp_op_num1	<= `ZERO_DOUBLE;
				jmp_op_num2	<= `ZERO_DOUBLE;
			end
			`OPERATION_RW: begin
				case(funct3)
					`INSTR_ADDW,`INSTR_SLW,`INSTR_SRW: begin
						reg_wr_en <= `REG_WR_EN;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= addr_rs2;
						reg_wr_addr <= addr_rd;
						
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
						
						alu_add_sub <= (funct7 == `FUNCT7_SUB) ? `ALU_SUB_EN : `ALU_ADD_EN;
						alu_shift <= (funct7 == `FUNCT7_SRAW) ? `ALU_SHIFT_A : `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_EN;
						alu_operation <= funct3;
						alu_op_num1	<= data_rs1;
						alu_op_num2	<= data_rs2;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;
						
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
						
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_EN;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= `ZERO_DOUBLE;
						alu_op_num2	<= `ZERO_DOUBLE;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;

					end
				endcase
			end
								
			`OPERATION_I: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= addr_rs1;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;
				
				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;

				alu_add_sub <= `ALU_ADD_EN;
				alu_shift <= (funct7_w == `FUNCT7_W_SRA) ? `ALU_SHIFT_A : `ALU_SHIFT_L;
				word_intercept <= `INTERCEPT_DIS;
				alu_operation <= funct3;
				alu_op_num1	<= data_rs1;
				alu_op_num2	<= {{52{instr[31]}},instr[31:20]};
				jmp_op_num1	<= `ZERO_DOUBLE;
				jmp_op_num2	<= `ZERO_DOUBLE;
			end	
			`OPERATION_IW: begin
				case(funct3)
					`INSTR_ADDW,`INSTR_SLW,`INSTR_SRW: begin
						reg_wr_en <= `REG_WR_EN;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= addr_rd;
						
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
	
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= (funct7 == `FUNCT7_SRA) ? `ALU_SHIFT_A : `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_EN;
						alu_operation <= funct3;
						alu_op_num1	<= data_rs1;
						alu_op_num2	<= {{52{instr[31]}},instr[31:20]};
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;
						
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
						
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_EN;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= `ZERO_DOUBLE;
						alu_op_num2	<= `ZERO_DOUBLE;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
				endcase
			end
								
			`OPERATION_LUI: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;

				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;
				
				alu_add_sub <= `ALU_ADD_EN;
				alu_shift <= `ALU_SHIFT_L;
				alu_operation <= `ALU_ADD;
				word_intercept <= `INTERCEPT_DIS;
				alu_op_num1	<= {{32{instr[31]}},instr[31:12],12'h0};
				alu_op_num2	<= `ZERO_DOUBLE;
				jmp_op_num1	<= `ZERO_DOUBLE;
				jmp_op_num2	<= `ZERO_DOUBLE;
			end
								
			`OPERATION_LOAD: begin
				case(funct3)
					`INSTR_LB,`INSTR_LH,`INSTR_LW,`INSTR_LD,`INSTR_LBU,`INSTR_LHU,`INSTR_LWU: begin
						reg_wr_en <= `REG_WR_EN;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= addr_rd;

						jmp_flag <= `JMP_NOPE;
						load_code <= funct3;
						store_code <= `STORE_NOPE;
						
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= data_rs1;
						alu_op_num2	<= {{52{instr[31]}},instr[31:20]};
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;

						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= `ZERO_DOUBLE;
						alu_op_num2	<= `ZERO_DOUBLE;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
				endcase
			end

			`OPERATION_S: begin
				case(funct3)
					`INSTR_SB,`INSTR_SH,`INSTR_SW,`INSTR_SD: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= addr_rs2;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= funct3;
						
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= data_rs1;
						alu_op_num2	<= {{52{instr[31]}}, instr[31:25], instr[11:7]};
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;

						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= `ZERO_DOUBLE;
						alu_op_num2	<= `ZERO_DOUBLE;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
				endcase
			end

			`OPERATION_B: begin				
				case(funct3)
					`INSTR_BEQ,`INSTR_BNE,`INSTR_BLT,`INSTR_BGE,`INSTR_BLTU,`INSTR_BGEU: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= addr_rs2;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= funct3;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
						
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1 <= data_rs1;
						alu_op_num2 <= data_rs2;
						jmp_op_num1	<= addr_instr;
						jmp_op_num2	<= {{52{instr[31]}},instr[7],instr[30:25], instr[11:8],1'b0};
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;

						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= `ZERO_DOUBLE;
						alu_op_num2	<= `ZERO_DOUBLE;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
				endcase
			end

			`OPERATION_J: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;

				jmp_flag <= `JMP_J;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;
				
				alu_add_sub <= `ALU_ADD_EN;
				alu_shift <= `ALU_SHIFT_L;
				word_intercept <= `INTERCEPT_DIS;
				alu_operation <= `ALU_ADD;
				alu_op_num1 <= addr_instr;
				alu_op_num2 <= `PC_STEP;
				jmp_op_num1	<= addr_instr;
				jmp_op_num2	<= {{44{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
			end

			`OPERATION_JR: begin
				case(funct3)
					`INSTR_JALR: begin
						reg_wr_en <= `REG_WR_EN;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= addr_rd;
						
						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						alu_operation <= `ALU_ADD;
						word_intercept <= `INTERCEPT_DIS;
						alu_op_num1 <= addr_instr;
						alu_op_num2 <= `PC_STEP;
						jmp_op_num1	<= addr_rs1;
						jmp_op_num2	<= {{52{instr[31]}},instr[31:20]};

						jmp_flag <= `JMP_J;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;

						alu_add_sub <= `ALU_ADD_EN;
						alu_shift <= `ALU_SHIFT_L;
						word_intercept <= `INTERCEPT_DIS;
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= `ZERO_DOUBLE;
						alu_op_num2	<= `ZERO_DOUBLE;
						jmp_op_num1	<= `ZERO_DOUBLE;
						jmp_op_num2	<= `ZERO_DOUBLE;
					end
				endcase
			end

			`OPERATION_AUIPC: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;
				
				alu_add_sub <= `ALU_ADD_EN;
				alu_shift <= `ALU_SHIFT_L;
				alu_operation <= `ALU_ADD;
				word_intercept <= `INTERCEPT_DIS;
				alu_op_num1 <= addr_instr;
				alu_op_num2 <= {{32{instr[31]}},instr[31:12],12'd0};
				jmp_op_num1	<= `ZERO_DOUBLE;
				jmp_op_num2	<= `ZERO_DOUBLE;

				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;
			end

			`OPERATION_NOP: begin
				reg_wr_en <= `REG_WR_DIS;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= `REG_ADDR_ZERO;

				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;

				alu_add_sub <= `ALU_ADD_EN;
				alu_shift <= `ALU_SHIFT_L;
				word_intercept <= `INTERCEPT_DIS;
				alu_operation <= `ALU_ADD;
				alu_op_num1	<= `ZERO_DOUBLE;
				alu_op_num2	<= `ZERO_DOUBLE;
				jmp_op_num1	<= `ZERO_DOUBLE;
				jmp_op_num2	<= `ZERO_DOUBLE;
			end

			default: begin
				reg_wr_en <= `REG_WR_DIS;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= `REG_ADDR_ZERO;

				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;

				alu_add_sub <= `ALU_ADD_EN;
				alu_shift <= `ALU_SHIFT_L;
				word_intercept <= `INTERCEPT_DIS;
				alu_operation <= `ALU_ADD;
				alu_op_num1	<= `ZERO_DOUBLE;
				alu_op_num2	<= `ZERO_DOUBLE;
				jmp_op_num1	<= `ZERO_DOUBLE;
				jmp_op_num2	<= `ZERO_DOUBLE;
			end
		endcase
	end
	
endmodule