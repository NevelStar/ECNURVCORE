//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.07.20
//Edited in 2021.07.21
//Edited in 2021.07.23

`include "define.v"

module decoder(
	input	[`BUS_DATA_REG]		data_rs1		,
	input	[`BUS_DATA_REG]		data_rs2		,
	input	[`BUS_DATA_MEM]		instr			,
	input	[`BUS_ADDR_MEM]		addr_instr		,


	output	reg [`BUS_ALU_OP]	alu_operation	,
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
	output	reg 				reg_wr_en		
);


	wire	[6:0]	operation_code;
	wire	[4:0]	addr_rd;
	wire	[2:0]	funt3;
	wire	[4:0]	addr_rs1;
	wire	[4:0]	addr_rs2;
	wire	[6:0]	funt7;

	assign operation_code = instr[`OPERATION_CODE];
	assign addr_rd = instr[`ADDR_RD];
	assign funt3 = instr[`FUNCT3];
	assign addr_rs1 = instr[`ADDR_RS1];		
	assign addr_rs2 = instr[`ADDR_RS2];	
	assign funt7 = instr[`FUNCT7];


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
				
				alu_operation <= funct3;
				alu_op_num1	<= data_rs1;
				alu_op_num2	<= data_rs2;
			end
								
			`OPERATION_I: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= addr_rs1;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;
				
				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;

				alu_operation <= funct3;
				alu_op_num1	<= data_rs1;
				alu_op_num2	<= {{20{instr[31]}},instr[31:20]};
			end
								
			`OPERATION_LUI: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;

				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;
				
				alu_operation <= `ALU_ADD;
				alu_op_num1	<= {instr[31:12],12'h0};
				alu_op_num2	<= `ZERO_WORD;
			end
								
			`OPERATION_LOAD: begin
				case(funt3)
					`INSTR_LB,`INSTR_LH,`INSTR_LW,`INSTR_LBU,`INSTR_LHU: begin
						reg_wr_en <= `REG_WR_EN;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= addr_rd;

						jmp_flag <= `JMP_NOPE;
						load_code <= funct3;
						store_code <= `STORE_NOPE;
						
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= data_rs1;
						alu_op_num2	<= {{20{instr[31]}},instr[31:20]};
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
					end
				endcase
			end

			`OPERATION_S: begin
				case(funt3)
					`INSTR_SB,`INSTR_SH,`INSTR_SH: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= addr_rs2;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= funct3;
						
						alu_operation <= `ALU_ADD;
						alu_op_num1	<= data_rs1;
						alu_op_num2	<= {{20{instr[31]}}, instr[31:25], instr[11:7]};
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
					end
				endcase
			end

			`OPERATION_B: begin				
				case(funt3)
					`INSTR_BEQ,`INSTR_BNE,`INSTR_BLT,`INSTR_BGE,`INSTR_BLTU,`INSTR_BGEU: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= addr_rs2;
						reg_wr_addr <= `REG_ADDR_ZERO;

						jmp_flag <= `JMP_B;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
						
						alu_operation <= `ALU_ADD;
						alu_op_num1 <= data_rs1;
						alu_op_num2 <= data_rs2;
						jmp_op_num1	<= addr_instr;
						jmp_op_num2	<= {{20{instr[31]}},instr[7],instr[30:25], instr[11:8],1'b0};
					end
					default: begin
						reg_wr_en <= `REG_WR_DIS;
						reg_rs1_addr <= `REG_ADDR_ZERO;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= `REG_ADDR_ZERO;
						jmp_flag <= `JMP_NOPE;
						load_code <= `LOAD_NOPE;
						store_code <= `STORE_NOPE;
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
				
				alu_operation <= `ALU_ADD;
				alu_op_num1 <= addr_instr;
				alu_op_num2 <= 32'd4;
				jmp_op_num1	<= addr_instr;
				jmp_op_num2	<= {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
			end

			`OPERATION_JR: begin
				case(funct3)
					`INSTR_JALR: begin
						reg_wr_en <= `REG_WR_EN;
						reg_rs1_addr <= addr_rs1;
						reg_rs2_addr <= `REG_ADDR_ZERO;
						reg_wr_addr <= addr_rd;
						
						alu_operation <= `ALU_ADD;
						alu_op_num1 <= addr_instr;
						alu_op_num2 <= 32'd4;
						jmp_op_num1	<= addr_rs1;
						jmp_op_num2	<= {{20{instr[31]}},instr[31:20]};

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
					end
				endcase
			end

			`OPERATION_AUIPC: begin
				reg_wr_en <= `REG_WR_EN;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= addr_rd;
				
				alu_operation <= `JMP_J;
				alu_op_num1 <= addr_instr;
				alu_op_num2 <= 32'd4;
				jmp_op_num1	<= addr_instr;
				jmp_op_num2	<= {instr[31:12],12'd0};

				jmp_flag <= `JMP_EN;
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
			end

			default: begin
				reg_wr_en <= `REG_WR_DIS;
				reg_rs1_addr <= `REG_ADDR_ZERO;
				reg_rs2_addr <= `REG_ADDR_ZERO;
				reg_wr_addr <= `REG_ADDR_ZERO;
				jmp_flag <= `JMP_NOPE;
				load_code <= `LOAD_NOPE;
				store_code <= `STORE_NOPE;
			end
		endcase
	end
	
endmodule