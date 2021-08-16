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
	
	input						ext_irq_i		,	//外部中断请求
	input						sft_irq_i		,	//软件中断请求
	input						tmr_irq_i		,	//计时器中断请求
	input  						irq_src_i		,	//中断源
	input  						exp_src_i		,	//异常源
	
	output [`BUS_ADDR_MEM]		irq_pc_o		,	//中断入口地址
	output [`BUS_ADDR_MEM]		mepc_o			,   //中断返回后需要执行的PC
	input  						mret_ena_i		,	//中断返回使能
	
	output [`BUS_DATA_REG] 		wr_csr_nxt_o	,	//写入CSR寄存器的值
	output 						rd_wen_o		,	//CSR寄存器读使能，用于回写
	output [`BUS_ADDR_REG]		wb_rd_idx_o		,	//回写索引
	output [`BUS_DATA_REG]		wb_data_o		,	//回写数据
	
	output						meie_o			,	//外部中断使能
	output						msie_o			,	//软件中断使能
	output						mtie_o			,	//计时器中断使能
	output						glb_irq_o			//全局中断使能
);


	//--------------------省略部分信号的声明和赋值-------------------------
	// CSR指令按照如下排列
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

	
	reg_csr U_reg_csr
	(
		.clk        	(clk),
		.rst_n          (rst_n),
 
		.mret_ena_i     (mret_ena_i),
 
//		.i_EXE_vld      (i_EXE_vld),
		
		//中断请求和中断源
		.ext_irq_i      (ext_irq_i),
		.sft_irq_i      (sft_irq_i),
		.tmr_irq_i      (tmr_irq_i),
		.irq_src_i      (irq_src_i & glb_irq_o),
  
		//异常源，异常PC和异常指令  
		.exp_src_i      (exp_src_i),
		.exe_pc_i       (pc_i),
		.ir_i           (instr_i),
		
		//中断PC和中断入口地址
		.irq_pc_o       (irq_pc_o),
		.mepc_o         (mepc_o),
 
		//CSR指令相关信号    
		.csr_rden_i     (csr_rden),
		.csr_addr_i     (csr_addr_i),
		.csr_val_i      (reg_csr_val),
		.csr_wen_i      (csr_wen),
		.csr_val_o      (w_csr_val),
	
		//由mie，mstatus寄存器输出的中断使能信号
		.o_meie         (o_meie),
		.o_msie         (o_msie),
		.o_mtie         (o_mtie),
		.o_glb_irq      (o_glb_irq)
	);

endmodule