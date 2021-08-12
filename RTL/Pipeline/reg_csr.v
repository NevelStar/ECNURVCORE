//ECNURVCORE
//Pipeline CPU

`include "define.v"

module reg_csr
(
	input						clk				,
	input						rst_n			,
	
	input	[`BUS_ADDR_MEM]		pc_i			,
	input	[`BUS_DATA_INSTR]	instr_i			,
	
	input						ext_irq_i		,	//外部中断请求
	input						sft_irq_i		,	//软件中断请求
	input						tmr_irq_i		,	//计时器中断请求
	input  						irq_src_i		,	//中断源
	input  						exp_src_i		,	//异常源
	
	output	[`BUS_ADDR_MEM]		irq_pc_o		,	//中断入口地址
	output	[`BUS_ADDR_MEM]		mepc_o			,   //中断返回后需要执行的PC
	input  						mret_ena_i		,	//中断返回使能
	
	input						csr_rden_i		,
	input	[`BUS_CSR_IMM]		csr_addr_i		,
	input	[`BUS_DATA_REG]		csr_val_i 		,
	input						csr_wen_i 		,
	output	[`BUS_DATA_REG]		csr_val_o 		,
	
	output						meie_o			,	//外部中断使能
	output						msie_o			,	//软件中断使能
	output						mtie_o			,	//计时器中断使能
	output						glb_irq_o			//全局中断使能
);




endmodule