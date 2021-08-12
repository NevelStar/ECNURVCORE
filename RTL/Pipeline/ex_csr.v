//ECNURVCORE
//Pipeline CPU

`include "define.v"

module ex_stage
(
	input						clk				,
	input						rst_n			,

	input	[`BUS_ADDR_MEM]		pc_i			,
	input	[`BUS_DATA_INSTR]	instr_i			,
	input	[`BUS_DATA_REG]		data_rs1_i		,
//	input	[`BUS_DATA_REG]		data_rs2_i		,
	input	[`BUS_ADDR_REG]		addr_reg_wr_i	,	

	input	[`BUS_ALU_OP]		csr_instr_i		,	//csr的指令(6条之一)
	input	[`BUS_CSR_IMM]		csr_addr_i		,	//索引CSR寄存器的12位地址
	input	[`BUS_CSR_IMMEX]	csr_imm_i		,	//零扩展后的立即数

	input						i_ext_irq		,	//外部中断请求
    input						i_sft_irq		,	//软件中断请求
    input						i_tmr_irq		,	//计时器中断请求
    input  						i_irq_src		,	//中断源
    input  						i_exp_src		,	//异常源

    output [`BUS_ADDR_MEM]		o_irq_pc		,	//中断入口地址
    output [`BUS_ADDR_MEM]		o_mepc			,   //中断返回后需要执行的PC
    input  						i_mret_ena		,	//中断返回使能
	
	output [`BUS_DATA_REG] 		o_wr_csr_nxt	,	//写入CSR寄存器的值
    output 						o_rd_wen		,	//CSR寄存器读使能，用于回写
    output [`BUS_ADDR_REG]		o_wb_rd_idx		,	//回写索引
    output [`BUS_DATA_REG]		o_wb_data		,	//回写数据

    output						o_meie			,	//外部中断使能
    output						o_msie			,	//软件中断使能
    output						o_mtie			,	//计时器中断使能
    output						o_glb_irq			//全局中断使能
);




endmodule