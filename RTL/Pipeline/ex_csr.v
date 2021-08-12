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
<<<<<<< HEAD
	
	input	[`BUS_ALU_OP]		csr_instr_i		,	//csr的指令(6条之一)
	input	[`BUS_CSR_IMM]		csr_addr_i		,	//索引CSR寄存器的12位地址
	input	[`BUS_CSR_IMMEX]	csr_imm_i		,	//零扩展后的立即数
	
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
=======

	input	[`BUS_ALU_OP]		csr_instr_i		,	//csr的指�?(6条之�?)
	input	[`BUS_CSR_IMM]		csr_addr_i		,	//索引CSR寄存器的12位地�?
	input	[`BUS_CSR_IMMEX]	csr_imm_i		,	//零扩展后的立即数

	input						i_ext_irq		,	//外部中断请求
    input						i_sft_irq		,	//软件中断请求
    input						i_tmr_irq		,	//计时器中断请�?
    input  						i_irq_src		,	//中断�?
    input  						i_exp_src		,	//异常�?

    output [`BUS_ADDR_MEM]		o_irq_pc		,	//中断入口地址
    output [`BUS_ADDR_MEM]		o_mepc			,   //中断返回后需要执行的PC
    input  						i_mret_ena		,	//中断返回使能
	
	output [`BUS_DATA_REG] 		o_wr_csr_nxt	,	//写入CSR寄存器的�?
    output 						o_rd_wen		,	//CSR寄存器读使能，用于回�?
    output [`BUS_ADDR_REG]		o_wb_rd_idx		,	//回写索引
    output [`BUS_DATA_REG]		o_wb_data		,	//回写数据

    output						o_meie			,	//外部中断使能
    output						o_msie			,	//软件中断使能
    output						o_mtie			,	//计时器中断使�?
    output						o_glb_irq			//全局中断使能
>>>>>>> 4ddd646c2366b6b274ae1459deac17a7cb0395e4
);


	//--------------------省略部分信号的声明和赋值-------------------------
	// CSR指令按照如下排列
	// csr_instr_i = {rv32i_csrrci, rv32i_csrrsi, rv32i_csrrwi,
	//                rv32i_csrrc,  rv32i_csrrs,  rv32i_csrrw};
	
	reg		[`BUS_DATA_REG]	reg_csr_val;
	
	wire	[`BUS_DATA_REG]	w_csr_val;
	
	always@ (*) begin
		reg_csr_val <= 64'b0;
		
		if (i_SYSTEM & csr_wen) begin		
			case (csr_instr_i)
				6'h01: begin
					reg_csr_val <= data_rs1_i;						//rv32i_csrrw       
				end
				6'h02: begin
					reg_csr_val <= data_rs1_i | w_csr_val;		//rv32i_csrrs
				end
				6'h04: begin
					reg_csr_val <= ~data_rs1_i & w_csr_val;		//rv32i_csrrc
				end
				6'h08: begin
					reg_csr_val <= csr_imm_i; 						//rv32i_csrrwi
				end
				6'h10: begin
					reg_csr_val <= csr_imm_i | w_csr_val;  		//rv32i_csrrsi
				end
				6'h20: begin
					reg_csr_val <= ~csr_imm_i & w_csr_val;		//rv32i_csrrci
				end
				default: ;
			endcase
		end
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