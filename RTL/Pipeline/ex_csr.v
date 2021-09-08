//ECNURVCORE
//Pipeline CPU

`include "define.v"

module ex_csr
(
	input						clk				,
	input						rst_n			,
	
	input	[`BUS_ADDR_MEM]		pc_i			,
	input	[`BUS_DATA_INSTR]	instr_i			,
	input	[`BUS_DATA_REG]		data_rs1_i		,
//	input	[`BUS_DATA_REG]		data_rs2_i		,
	input	[`BUS_ADDR_REG]		addr_reg_wr_i	,	
	
	input	[`BUS_ALU_OP]		csr_instr_i		,
	input	[`BUS_CSR_IMM]		csr_addr_i		,
	input	[`BUS_CSR_IMMEX]	csr_imm_i		,	// alu_op_num1[31:0]
	
	output [`BUS_DATA_REG] 		wr_csr_nxt_o	,	//写入CSR寄存器的值
	output 						rd_wen_o		,	//CSR寄存器读使能，用于回写
	output [`BUS_ADDR_REG]		wb_rd_idx_o		,	//回写索引
	output [`BUS_DATA_REG]		wb_data_o			//回写数据
);


	// csr_instr_i = {rv32i_csrrci, rv32i_csrrsi, rv32i_csrrwi,
	//                rv32i_csrrc,  rv32i_csrrs,  rv32i_csrrw};
	
	reg		[`BUS_DATA_REG]	reg_csr_val;
	
	wire	[`BUS_DATA_REG]	w_csr_val;
	
	always@ (*) begin
		reg_csr_val <= 64'b0;
//		if (i_SYSTEM & csr_wen) begin		
			case (csr_instr_i)
				3'b001: begin
					reg_csr_val <= data_rs1_i;					//rv32i_csrrw       
				end
				3'b010: begin
					reg_csr_val <= data_rs1_i | w_csr_val;		//rv32i_csrrs
				end
				3'b011: begin
					reg_csr_val <= ~data_rs1_i & w_csr_val;		//rv32i_csrrc
				end
				3'b101: begin
					reg_csr_val <= csr_imm_i;					//rv32i_csrrwi
				end
				3'b110: begin
					reg_csr_val <= csr_imm_i | w_csr_val;  		//rv32i_csrrsi
				end
				3'b111: begin
					reg_csr_val <= ~csr_imm_i & w_csr_val;		//rv32i_csrrci
				end
				default: ;
			endcase
//		end
	end

//	wire csr_wen  = i_EXE_vld & i_SYSTEM & (i_csr_addr[11:10] != 2'b11);
//	wire csr_rden = i_EXE_vld & i_SYSTEM;


endmodule