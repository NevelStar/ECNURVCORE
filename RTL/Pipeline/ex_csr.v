//ECNURVCORE
//Pipeline CPU

`include "define.v"

module ex_csr
(
	input						clk				,
	input						rst_n			,
	
//	input	[`BUS_ADDR_MEM]		pc_i			,
//	input	[`BUS_DATA_INSTR]	instr_i			,
	input	[`OPERATION_CODE]	op_code_i		,
	input	[`BUS_DATA_REG]		data_rs1_i		,
//	input	[`BUS_DATA_REG]		data_rs2_i		,
	input	[`BUS_ADDR_REG]		addr_reg_wr_i	,	

	// from id
	input	[`BUS_ALU_OP]		csr_instr_i		,
	input	[`BUS_CSR_IMM]		csr_addr_i		,
	input	[`BUS_DATA_REG]		csr_imm_i		,
	
	// from/to reg_csr
	output						csr_we_o		,
	output	[`BUS_CSR_IMM]		csr_addr_o		,
	output	[`BUS_DATA_REG] 	csr_data_o		,
	input	[`BUS_DATA_REG]		csr_data_i			
);

	
	reg		[`BUS_DATA_REG]	reg_csr_val;
	
	assign csr_we_o   = (op_code_i == `OPERATION_SYS) & (csr_instr_i != `CSR_CODE_NOPE);
	assign csr_addr_o = csr_addr_i;
	assign csr_data_o = reg_csr_val;
	
	always@(*) begin
		reg_csr_val = 64'b0;
		case (csr_instr_i & {3{csr_we_o}})
			3'b001: begin
				reg_csr_val = data_rs1_i;					//rv32i_csrrw       
			end
			3'b010: begin
				reg_csr_val = data_rs1_i | csr_data_i;		//rv32i_csrrs
			end
			3'b011: begin
				reg_csr_val = ~data_rs1_i & csr_data_i;	//rv32i_csrrc
			end
			3'b101: begin
				reg_csr_val = csr_imm_i;					//rv32i_csrrwi
			end
			3'b110: begin
				reg_csr_val = csr_imm_i | csr_data_i;  	//rv32i_csrrsi
			end
			3'b111: begin
				reg_csr_val = ~csr_imm_i & csr_data_i;		//rv32i_csrrci
			end
			default: reg_csr_val = 64'b0;
		endcase
	end


endmodule