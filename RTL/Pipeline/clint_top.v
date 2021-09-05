
`include "defines.v"

module clint_top
(
	input							clk,
	input							rst_n,
	
	// from if
	input							except_src_if		,
	input	[`BUS_EXCEPT_CAUSE]		except_cus_if		,
	
	// from id
	input							except_src_id		,
	input	[`BUS_EXCEPT_CAUSE]		except_cus_id		,
	input	[`BUS_DATA_INSTR]		instr_id_i			,
	input	[`BUS_ADDR_MEM]			addr_instr_id_i		,
	
	// from ex
	input							except_src_ex		,
	input	[`BUS_EXCEPT_CAUSE]		except_cus_ex		,
//	input							jump_flag_i,
//	input	[`InstAddrBus] 			jump_addr_i,
//	input							div_started_i,
	
	// from ctrl
//	input	[`Hold_Flag_Bus]		hold_flag_i,
	
	input							tmr_irq_i,
	input							ext_irq_i,
	input							glb_irqen_i,
	
	// to ctrl
//	output 							wire hold_flag_o,
	output	reg						int_assert_o,
	output	reg	[`BUS_ADDR_MEM]		int_addr_o,
	
	// from/to csr_reg
	output	reg						csr_we_o		,                         
	output	reg	[`BUS_CSR_IMM]		csr_addr_o		,
	input		[`BUS_DATA_MEM]		csr_data_i		,
	output	reg	[`BUS_DATA_MEM] 	csr_data_o
//	input	[`BUS_DATA_MEM]			csr_mtvec,  
//	input	[`BUS_DATA_MEM]			csr_mepc,   
//	input	[`BUS_DATA_MEM]			csr_mstatus

);


	localparam CSR_IDLE            = 5'b00001;
	localparam CSR_MSTATUS         = 5'b00010;
	localparam CSR_MEPC            = 5'b00100;
	localparam CSR_MSTATUS_MRET    = 5'b01000;
	localparam CSR_MCAUSE          = 5'b10000;

	reg		[4:0]	cur_csr_state;
	reg		[4:0]	nxt_csr_state;
	reg		[31:0] 	cause;

	wire 	except_src_assert;
	wire	mret_assert;
	wire	except_sync,except_mret;
	wire	except_async;

//	assign hold_flag_o = ((exc_state != EXCEPT_IDLE) | (csr_state != CSR_IDLE))? `HoldEnable: `HoldDisable;

	assign except_src_assert = except_src_if | except_src_id | except_src_ex;
	assign mret_assert = except_cus_id == `EXCEPT_MRET;
	
	assign except_sync  = except_src_assert & (~mret_assert);
	assign except_async = tmr_irq_i | ext_irq_i;
	assign except_mret  = except_src_assert &   mret_assert ;

	always @(posedge clk) begin
		if (!rst_n)
			cur_csr_state <= CSR_IDLE;
		else
			cur_csr_state <= nxt_csr_state;
	end

	always @(*) begin
		if (!rst_n) begin
			nxt_csr_state = CSR_IDLE;
		end 
		else begin
			nxt_csr_state = cur_csr_state;
			case (cur_csr_state)
				CSR_IDLE: begin
					if (except_sync | except_async) begin   
						nxt_csr_state <= CSR_MEPC;
					end 
					else if (except_mret) begin
						nxt_csr_state <= CSR_MSTATUS_MRET;
					end
				end

				CSR_MEPC: nxt_csr_state <= CSR_MSTATUS;

				CSR_MSTATUS: nxt_csr_state <= CSR_MCAUSE;

				CSR_MCAUSE: nxt_csr_state <= CSR_IDLE;

				CSR_MSTATUS_MRET: nxt_csr_state <= CSR_IDLE;

				default: nxt_csr_state <= CSR_IDLE;
			endcase
		end
	end

	always @ (posedge clk) begin
		if (!rst_n) begin
			csr_we_o <= `WriteDisable;
			csr_addr_o <= `ZERO_DOUBLE;
			csr_data_o <= `ZERO_DOUBLE;
		end 
		else begin
			case (nxt_csr_state)

				CSR_MEPC: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `CSR_MEPC;
					csr_data_o <= `IRQ_ENTRY_ADDR;
				end

				CSR_MCAUSE: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `CSR_MCAUSE;
					csr_data_o <= cause;
				end

				CSR_MSTATUS: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `CSR_MSTATUS;
					csr_data_o <= {csr_mstatus[31:4], 1'b0, csr_mstatus[2:0]};
				end

				CSR_MSTATUS_MRET: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `CSR_MSTATUS;
					csr_data_o <= {csr_mstatus[31:4], csr_mstatus[7], csr_mstatus[2:0]};
				end
				
				default: begin
					csr_we_o   <= `WriteDisable;
					csr_addr_o <= `ZeroWord;
					csr_data_o <= `ZeroWord;
				end

			endcase
		end
	end

	always @ (posedge clk) begin
		if (!rst_n) begin
			int_assert_o <= `INT_DEASSERT;
			int_addr_o <= `ZeroWord;
		end else begin
			case (csr_state)
				// 发出中断进入信号.写完mcause寄存器才能发
				CSR_MCAUSE: begin
					int_assert_o <= `INT_ASSERT;
					int_addr_o <= csr_mtvec;
				end
				// 发出中断返回信号
				CSR_MSTATUS_MRET: begin
					int_assert_o <= `INT_ASSERT;
					int_addr_o <= csr_mepc;
				end
				default: begin
					int_assert_o <= `INT_DEASSERT;
					int_addr_o <= `ZeroWord;
				end
			endcase
		end
	end

endmodule
