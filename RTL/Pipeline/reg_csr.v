//ECNURVCORE
//Pipeline CPU

// WPRI: Reserved writes preserve values, reads ignore value

`include "define.v"

module reg_csr
(
	input						clk				,
	input						rst_n			,
	
//	input	[`BUS_ADDR_MEM]		pc_i			,
//	input	[`BUS_DATA_INSTR]	instr_i			,
	
//	input						ext_irq_i		,
//	input						sft_irq_i		,
//	input						tmr_irq_i		,
//	input  						irq_src_i		,
//	input  						exp_src_i		,
	
	output	[`BUS_ADDR_MEM]		irq_pc_o		,	//中断入口地址
	output	[`BUS_ADDR_MEM]		mepc_o			,   //中断返回后需要执行的PC
	input  						mret_ena_i		,	//中断返回使能
	
	input						clt_we_i 		,
	input	[`BUS_CSR_IMM]		clt_addr_i		,
	input	[`BUS_DATA_REG]		clt_data_i 		,
	output	[`BUS_DATA_REG]		clt_data_o 		,
	
	output						meie_o			,	//外部中断使能
	output						msie_o			,	//软件中断使能
	output						mtie_o			,	//计时器中断使能
	output						glb_irq_o			//全局中断使能
);


	assign o_csr_val = csr_reh_sel;  //CSR寄存器读出来的值
	
	always @(*) begin
		case (clt_addr_i & {12{i_csr_rden}})
	
			12'h300: csr_reh_sel = w_mstatus;
			12'h301: csr_reh_sel = w_misa;
			12'h304: csr_reh_sel = w_mie;
			12'h305: csr_reh_sel = w_mtvec;
			12'h306: csr_reh_sel = w_mcounteren;
			12'hf11: csr_reh_sel = w_mvendorid;
			12'hf12: csr_reh_sel = w_marchid;
			12'hf13: csr_reh_sel = w_mimpid;
			12'hf14: csr_reh_sel = w_mhartid;
			12'h340: csr_reh_sel = w_mscratch;
			12'h341: csr_reh_sel = o_mepc;
			12'h342: csr_reh_sel = w_mcause;
			12'h343: csr_reh_sel = w_mtval;
			12'h344: csr_reh_sel = w_mip;
			12'hb00: csr_reh_sel = w_mcycle_l;
			12'hb80: csr_reh_sel = w_mcycle_h;
			12'hb02: csr_reh_sel = w_minstret_l;
			12'hb82: csr_reh_sel = w_minstret_h;
			12'h7b0: csr_reh_sel = i_dcsr;
			12'h7b1: csr_reh_sel = i_dpc;
			12'h7b2: csr_reh_sel = i_dscratch;
			
			default: csr_reh_sel = 32'b0;
		endcase
	end
	
	assign o_glb_irq = w_mstatus[3];  //全局中断使能

	wire [31:0] vect_pc = {w_mtvec[31:2],2'b00} + {w_mcause[3:0],2'b00};		// Mode1，向量地址 = base + 4 X cause
	
//	assign o_irq_pc = (w_mtvec[1:0] == 0) ? {w_mtvec[31:2],2'b00}:				//选择中断入口地址
//					  (w_mtvec[1:0] == 1) ? vect_pc : o_irq_pc;
	assign o_irq_pc = (w_mtvec[1:0] == 0) ? {w_mtvec[31:2],2'b00} : vect_pc;

	wire status_ena = w_mstatus[3] & (o_meie | o_mtie | o_msie) & irq_src_i;	//发生中断


	// ================================ mtvec ================================
	wire			mtvec_sel,mtvec_ena;
	wire	[31:0]	mtvec_nxt;
	wire	[31:0]	mtvec_r;
	
//	wire wbck_csr_wen = clt_we_i;
	assign mtvec_sel = clt_addr_i == 12'h305;
//	wire wr_mtvec = sel_mtvec & clt_we_i;          //确认该寄存器既可写，又的确是mtvec
	assign mtvec_ena = mtvec_sel & clt_we_i;		//确认mtvec寄存器可写
	assign mtvec_nxt = {clt_data_i[63:2],2'b00}; //中断入口地址都是基地址， MODE == 2'b00
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mtvec
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mtvec_ena),
		.data_in	(mtvec_nxt),
		.data_r_ini	(`ZERO_DOUBLE),
		.data_out	(mtvec_r)
	);
	
	// ================================ mstatus ================================
//	input i_mret_ena,        //中断返回
//	input mstatus_ena_i,      //由全局中断&中断使能(包括计时器/外部/软件)&中断源组成
//	output [31:0] o_mstatus, //输出mstatus
	
	wire			mstatus_sel,mstatus_ena;
	wire	[31:0]	mstatus_r;
	
	wire mstatus_sel = (clt_addr_i == 12'h300);
	wire mstatus_ena = mstatus_sel & clt_we_i;
	
	wire			mstatus_mpie_ena,mstatus_mpie_nxt,mstatus_mpie_r;
	wire			mstatus_mie_ena ,mstatus_mie_nxt ,mstatus_mie_r ;
	
	// 在以下情况更新MPIE位
	assign mstatus_mpie_ena = mstatus_ena | i_mret_ena | mstatus_ena_i;		// CSR指令写入 | 中断返回 | 中断到来
	assign mstatus_mpie_nxt = mstatus_ena_i ?						//中断来时，MPIE位更新为MIE位
						      mstatus_mie_r : i_mret_ena ?			// 中断返回时，MPIE设置成1
						      1'b1 : mstatus_ena ?					// CSR指令写入
						      clt_data_i[7] : mstatus_mpie_r;		// MPIE是mstatus寄存器的bit 7
	
	gnrl_dff # (.DW(1)) dff_mstatus_mpie
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mstatus_mpie_ena),
		.data_in	(mstatus_mpie_nxt),
		.data_r_ini	(1'b0),
		.data_out	(mstatus_mpie_r)
	);
	
	assign mstatus_mie_ena = mstatus_mpie_ena; 
	assign mstatus_mie_nxt = mstatus_ena_i ?						// 中断来临时，MIE将值给MPIE，然后自己清零
							 1'b0 : i_mret_ena ? 					// 中断返回时，MIE得到存储在MPIE中的值
							 mstatus_mpie_r : mstatus_ena ? 		// CSR指令写入
							 clt_data_i[3] : mstatus_mie_r;			// MIE是mstatus寄存器的bit 3
	
	gnrl_dff # (.DW(1)) dff_mstatus_mie
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mstatus_mie_ena),
		.data_in	(mstatus_mie_nxt),
		.data_r_ini	(1'b0),
		.data_out	(mstatus_mie_r)
	);
	
	assign mstatus_r[31]    = status_sd_r; 		// SD
	assign mstatus_r[30:23] = 8'b0; 			// WPRI
	assign mstatus_r[22:17] = 6'b0; 			// TSR--MPRV
	assign mstatus_r[16:15] = status_xs_r; 		// XS
	assign mstatus_r[14:13] = status_fs_r; 		// FS
	assign mstatus_r[12:11] = 2'b11; 			// MPP 
	assign mstatus_r[10:9]  = 2'b0; 			// WPRI
	assign mstatus_r[8]     = 1'b0; 			// SPP
	assign mstatus_r[7]     = mstatus_mpie_r; 	// MPIE
	assign mstatus_r[6]     = 1'b0; 			// WPRI
	assign mstatus_r[5]     = 1'b0; 			// SPIE 
	assign mstatus_r[4]     = 1'b0; 			// UPIE 
	assign mstatus_r[3]     = mstatus_mie_r; 	// MIE
	assign mstatus_r[2]     = 1'b0; 			// WPRI
	assign mstatus_r[1]     = 1'b0; 			// SIE 
	assign mstatus_r[0]     = 1'b0; 			// UIE
	
	// ================================ mtval ================================
	wire			mtval_sel,mtval_ena;
	wire	[31:0]	mtval_nxt;
	wire	[31:0]	mtval_r;
	
	assign mtval_sel = (i_csr_addr == 12'h343);
	assign mtval_ena = mtval_sel & clt_we_i;
	assign mtval_nxt = trap_mtval_ena ? i_trap_mtval_val : clt_data_i;	//如果是中断/异常，存储相关的信息，不然由CSR指令写入
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mtvec
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mtval_ena),
		.data_in	(mtval_nxt),
		.data_r_ini	(`ZERO_DOUBLE),
		.data_out	(mtval_r)
	);
	
	// ================================ mepc ================================
	wire mepc_valid = (i_irq_src | i_exp_src) ? 1'b1 : 1'b0;//中断或者异常到来
	assign i_mepc = mepc_valid ? i_exe_pc : mepc_r;//如果有中断/异常到来，把PC设置成当前PC，否则用之前存储的mepc
	
	
	wire sel_mepc = ( i_csr_addr == 12'h341 );//通过地址索引确认寄存器
	wire wr_mepc = sel_mepc & i_csr_wen;// mepc寄存器可写
	wire mepc_ena = wr_mepc | mepc_valid;//使能由CSR指令写入或者中断/异常置起来
	
	wire [ 31: 0 ] mepc_nxt;
	assign mepc_nxt[ 31: 1 ] = mepc_valid ? i_mepc[ 31 : 1 ] : i_csr_val[ 31 : 1 ];//如果有中断，写入中断的返回地址，不然由CSR指令写入
	assign mepc_nxt[ 0 ] = 1'b0; // mepc的地址至少要以2字节对齐，不然可能会生成地址错位异常
	
	fii_dfflr #( 32 ) epc_dfflr ( mepc_ena, mepc_nxt, mepc_r, sys_clk, rst_n );//锁存
	
endmodule