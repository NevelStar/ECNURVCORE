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
	
	input						ex_we_i 		,
	input	[`BUS_CSR_IMM]		ex_addr_i		,
	input	[`BUS_DATA_REG]		ex_data_i 		,
	output	[`BUS_DATA_REG]		ex_data_o 		,
	
	input						clt_we_i 		,
	input	[`BUS_CSR_IMM]		clt_addr_i		,
	input	[`BUS_DATA_REG]		clt_data_i 		,
	output	[`BUS_DATA_REG]		clt_data_o 		,
	
	output	[`BUS_DATA_REG]		csr_mstatus		,
	output	[`BUS_DATA_REG]		csr_mie			,
	output	[`BUS_DATA_REG]		csr_mtvec		,		
	output	[`BUS_DATA_REG]		csr_mepc
	
//	output						meie_o			,	// external irq en
//	output						msie_o			,	// soft irq en
//	output						mtie_o			,	// timer irq en
//	output						glb_irq_o			// global irq en
);

	
	wire	[`BUS_DATA_REG]	csr_next;
	wire	[`BUS_CSR_IMM]	csr_addr;
	
	assign csr_next = ex_we_i ? ex_data_i : (clt_we_i ? clt_data_i : `ZERO_DOUBLE);
	assign csr_addr = ex_we_i ? ex_addr_i : (clt_we_i ? clt_addr_i : 12'b0);

	// ================================ mstatus ================================
	wire					mstatus_sel,mstatus_ena;
	wire	[`BUS_DATA_REG]	mstatus_init;
	
	assign mstatus_sel = csr_addr == `CSR_MSTATUS;
	assign mstatus_ena = mstatus_sel & clt_we_i;
	
	assign mstatus_init = {56'b0,
						   1'b0,			// MPIE
						   3'b0,
						   1'b1,			// MIE
						   3'b0};
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mstatus
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mstatus_ena),
		.data_in	(csr_next),
		.data_r_ini	(mstatus_init),
		.data_out	(csr_mstatus)
	);
	
	// ================================ misa ================================
	wire					misa_sel,misa_ena;
	wire	[`BUS_DATA_REG]	misa_init;
	wire	[`BUS_DATA_REG]	csr_misa;
	
	assign misa_sel = csr_addr == `CSR_MISA;
	assign misa_ena = misa_sel & clt_we_i;
	
	assign misa_init = `ISA_RV64I;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_misa
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(misa_ena),
		.data_in	(csr_next),
		.data_r_ini	(misa_init),
		.data_out	(csr_misa)
	);
	
	// ================================ mie ================================
	wire					mie_sel,mie_ena;
	wire	[`BUS_DATA_REG]	mie_init;
	
	assign mie_sel = csr_addr == `CSR_MIE;
	assign mie_ena = mie_sel & clt_we_i;
	
	assign mie_init = {52'b0,
					   1'b1,			// MEIE
					   3'b0,
					   1'b1,			// MTIE
					   3'b0,
					   1'b1,			// MSIE
					   3'b0};
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mie
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mie_ena),
		.data_in	(csr_next),
		.data_r_ini	(mie_init),
		.data_out	(csr_mie)
	);

	// ================================ mtvec ================================
	wire					mtvec_sel,mtvec_ena;
	wire	[`BUS_DATA_REG]	mtvec_init;
	
	assign mtvec_sel = csr_addr == `CSR_MTVEC;
	assign mtvec_ena = mtvec_sel & clt_we_i;
	
	assign mtvec_init = `IRQ_ENTRY_INIT;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mtvec
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mtvec_ena),
		.data_in	(csr_next),
		.data_r_ini	(mtvec_init),
		.data_out	(csr_mtvec)
	);
	
	// ================================ mscratch ================================
	wire					mscratch_sel,mscratch_ena;
	wire	[`BUS_DATA_REG]	mscratch_init;
	wire	[`BUS_DATA_REG]	csr_mscratch;
	
	assign mscratch_sel = csr_addr == `CSR_MSCRATCH;
	assign mscratch_ena = mscratch_sel & clt_we_i;
	
	assign mscratch_init = `ZERO_DOUBLE;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mscratch
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mscratch_ena),
		.data_in	(csr_next),
		.data_r_ini	(mscratch_init),
		.data_out	(csr_mscratch)
	);
	
	// ================================ mepc ================================
	wire					mepc_sel,mepc_ena;
	wire	[`BUS_DATA_REG]	mepc_init;
	
	assign mepc_sel = csr_addr == `CSR_MEPC;
	assign mepc_ena = mepc_sel & clt_we_i;

	assign mepc_init = `ZERO_DOUBLE;

	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mepc
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mepc_ena),
		.data_in	(csr_next),
		.data_r_ini	(mepc_init),
		.data_out	(csr_mepc)
	);
	
	// ================================ mcause ================================
	wire					mcause_sel,mcause_ena;
	wire	[`BUS_DATA_REG]	mcause_init;
	wire	[`BUS_DATA_REG]	csr_mcause;
	
	assign mcause_sel = csr_addr == `CSR_MCAUSE;
	assign mcause_ena = mcause_sel & clt_we_i;
	
	assign mcause_init = `ZERO_DOUBLE;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mcause
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mcause_ena),
		.data_in	(csr_next),
		.data_r_ini	(mcause_init),
		.data_out	(csr_mcause)
	);
	
	// ================================ mtval ================================
	wire					mtval_sel,mtval_ena;
	wire	[`BUS_DATA_REG]	mtval_init;
	wire	[`BUS_DATA_REG]	csr_mtval;
	
	assign mtval_sel = csr_addr == `CSR_MTVAL;
	assign mtval_ena = mtval_sel & clt_we_i;

	assign mtval_init = `ZERO_DOUBLE;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mtval
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mtval_ena),
		.data_in	(csr_next),
		.data_r_ini	(mtval_init),
		.data_out	(csr_mtval)
	);
	
	// ================================ mcycle ================================
	wire					mcycle_sel,mcycle_ena;
	wire	[`BUS_DATA_REG]	mcycle_init;
	wire	[`BUS_DATA_REG]	mcycle_nxt;
	wire	[`BUS_DATA_REG]	csr_mcycle;
	
	assign mcycle_sel = csr_addr == `CSR_MCYCLE;
	assign mcycle_ena = mcycle_sel & clt_we_i;
	
	assign mcycle_init = `ZERO_DOUBLE;
	assign mcycle_nxt  = mcycle_ena ? csr_next : csr_mcycle + 64'b1;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mcycle
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(1'b1),
		.data_in	(mcycle_nxt),
		.data_r_ini	(mcycle_init),
		.data_out	(csr_mcycle)
	);
	
	// ================================ mhartid ================================
	wire					mhartid_sel,mhartid_ena;
	wire	[`BUS_DATA_REG]	mhartid_init;
	wire	[`BUS_DATA_REG]	csr_mhartid;
	
	assign mhartid_sel = csr_addr == `CSR_MHARTID;
	assign mhartid_ena = mhartid_sel & clt_we_i;

	assign mhartid_init = `ZERO_DOUBLE;
	
	gnrl_dff # (.DW(`DATA_WIDTH)) dff_mhartid
	(
		.clk		(clk),
		.rst_n		(rst_n),
		.wr_en		(mhartid_ena),
		.data_in	(csr_next),
		.data_r_ini	(mhartid_init),
		.data_out	(csr_mhartid)
	);
	
	
	reg		[`BUS_DATA_REG]	csr_val_rd;

	assign ex_data_o = csr_val_rd;
	
	always @(*) begin
		case (clt_addr_i & {12{~ex_we_i}})
	
			`CSR_MSTATUS  : csr_val_rd = csr_mstatus;
			`CSR_MISA     : csr_val_rd = csr_misa;
			`CSR_MIE      : csr_val_rd = csr_mie;
			`CSR_MTVEC    : csr_val_rd = csr_mtvec;
//			12'h306: csr_val_rd = csr_mcounteren;
//			12'hf11: csr_val_rd = csr_mvendorid;
//			12'hf12: csr_val_rd = csr_marchid;
//			12'hf13: csr_val_rd = csr_mimpid;
			`CSR_MSCRATCH : csr_val_rd = csr_mscratch;
			`CSR_MEPC     : csr_val_rd = csr_mepc;
			`CSR_MCAUSE   : csr_val_rd = csr_mcause;
			`CSR_MTVAL    : csr_val_rd = csr_mtval;
//			`CSR_MIP      : csr_val_rd = csr_mip;
			`CSR_MCYCLE   : csr_val_rd = csr_mcycle;
			`CSR_MHARTID  : csr_val_rd = csr_mhartid;
//			12'hb80: csr_val_rd = csr_mcycle_h;
//			12'hb02: csr_val_rd = csr_minstret_l;
//			12'hb82: csr_val_rd = csr_minstret_h;
//			12'h7b0: csr_val_rd = i_dcsr;
//			12'h7b1: csr_val_rd = i_dpc;
//			12'h7b2: csr_val_rd = i_dscratch;
			
			default: csr_val_rd = 64'b0;
		endcase
	end
	
	
endmodule