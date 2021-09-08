
`include "defines.v"

module clint
(
	input							clk,
	input							rst_n,
	
	// from if
	input							except_src_if		,
	input	[`BUS_EXCEPT_CAUSE]		except_cus_if		,
	
	// from id
	input							except_src_id,
	input	[`BUS_EXCEPT_CAUSE]		except_cus_id,
	input	[`BUS_DATA_INSTR]		instr_id_i,
	input	[`BUS_ADDR_MEM]			addr_instr_id_i,
	
	// from ex
	input							except_src_ex,
	input	[`BUS_EXCEPT_CAUSE]		except_cus_ex,
//	input							jump_flag_i,
//	input	[`InstAddrBus] 			jump_addr_i,
//	input							div_started_i,
	
	input							tmr_irq_i,
	input							ext_irq_i,
	
	// to ctrl
//	output 							wire hold_flag_o,
	output							irq_assert_o,
	output	reg	[`BUS_ADDR_MEM]		irq_addr_o,
	
	// from/to csr_reg
	output	reg						csr_we_o,                         
	output	reg	[`BUS_CSR_IMM]		csr_addr_o,
	input		[`BUS_DATA_REG]		csr_data_i,
	output	reg	[`BUS_DATA_REG] 	csr_data_o,

	input		[`BUS_DATA_REG]		csr_mstatus,
	input		[`BUS_DATA_REG]		csr_mie,
	input		[`BUS_DATA_REG]		csr_mtvec,  
	input		[`BUS_DATA_REG]		csr_mepc
);


	localparam S_IDLE            = 5'b00001;
	localparam S_MSTATUS         = 5'b00010;
	localparam S_MEPC            = 5'b00100;
	localparam S_MSTATUS_MRET    = 5'b01000;
	localparam S_MCAUSE          = 5'b10000;

	reg		[4:0]				cur_csr_state;
	reg		[4:0]				nxt_csr_state;
	reg		[`BUS_EXCEPT_CAUSE]	except_cus_reg;

	wire 						except_src_assert;
	wire						mret_assert;
	wire						except_sync,except_mret;
	wire						except_async;
	wire	[`BUS_EXCEPT_CAUSE]	except_cus;
	
	assign glb_irq_en = csr_mstatus[3];
	assign tmr_irq_en = csr_mie[7];
    assign sft_irq_en = csr_mie[3];
    assign ext_irq_en = csr_mie[11];

	assign except_src_assert = except_src_if | except_src_id | except_src_ex;
	assign mret_assert = except_cus_id == `EXCEPT_MRET;
	
	assign except_sync  = except_src_assert & (~mret_assert);
	assign except_async = glb_irq_en & ((tmr_irq_i & tmr_irq_en) | (ext_irq_i & ext_irq_en));
	assign except_mret  = except_src_assert &   mret_assert ;

	assign irq_assert_o = except_sync | except_async | except_mret;
	
	assign except_cus = except_src_if ? except_cus_if : (
						except_src_id ? except_cus_id : (
						except_src_ex ? except_cus_id : 3'b0
						));

	always @(posedge clk) begin
		if (!rst_n)
			cur_csr_state <= S_IDLE;
		else
			cur_csr_state <= nxt_csr_state;
	end

	always @(*) begin
		if (!rst_n) begin
			irq_addr_o    = `ZERO_DOUBLE;
			nxt_csr_state = S_IDLE;
		end 
		else begin
			nxt_csr_state = cur_csr_state;
			case (cur_csr_state)
				S_IDLE: begin
					if (except_sync | except_async) begin
						irq_addr_o    = csr_mtvec;
						nxt_csr_state = S_MEPC;
					end 
					else if (except_mret) begin
						irq_addr_o    = csr_mepc;
						nxt_csr_state = S_MSTATUS_MRET;
					end
				end

				S_MEPC: begin
					irq_addr_o    = `ZERO_DOUBLE;
					nxt_csr_state = S_MCAUSE;
				end

				S_MCAUSE: begin
					irq_addr_o    = `ZERO_DOUBLE;
					nxt_csr_state = S_MSTATUS;
				end

				S_MSTATUS: begin
					irq_addr_o    = `ZERO_DOUBLE;
					nxt_csr_state = S_IDLE;
				end

				S_MSTATUS_MRET: begin
					irq_addr_o    = `ZERO_DOUBLE;
					nxt_csr_state = S_IDLE;
				end

				default: begin
					irq_addr_o    = `ZERO_DOUBLE;
					nxt_csr_state = S_IDLE;
				end
				
			endcase
		end
	end

	always @(posedge clk) begin
		if (!rst_n) begin
			csr_we_o <= `WriteDisable;
			csr_addr_o <= `ZERO_DOUBLE;
			csr_data_o <= `ZERO_DOUBLE;
		end 
		else begin
			case(nxt_csr_state)

				S_MEPC: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `S_MEPC;
					csr_data_o <= addr_instr_id_i;
					
					except_cus_reg <= except_cus;
				end

				S_MCAUSE: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `S_MCAUSE;
					csr_data_o <= {61'b0,except_cus_reg};
				end

				S_MSTATUS: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `S_MSTATUS;
//					csr_data_o <= {csr_mstatus[31:4], 1'b0, csr_mstatus[2:0]};
					csr_data_o <= {csr_mstatus[63:8], 
								   csr_mstatus[3], 
								   csr_mstatus[6:4], 
								   1'b0, 
								   csr_mstatus[2:0]};
				end

				S_MSTATUS_MRET: begin
					csr_we_o   <= `WriteEnable;
					csr_addr_o <= `S_MSTATUS;
//					csr_data_o <= {csr_mstatus[31:4], csr_mstatus[7], csr_mstatus[2:0]};
					csr_data_o <= {csr_mstatus[63:8],
								   1'b1,
								   csr_mstatus[6:4],
								   csr_mstatus[7],
								   csr_mstatus[2:0]};
				end
				
				default: begin
					csr_we_o   <= `WriteDisable;
					csr_addr_o <= `ZERO_DOUBLE;
					csr_data_o <= `ZERO_DOUBLE;
				end

			endcase
		end
	end

//	always @(posedge clk) begin
//		if (!rst_n) begin
//			irq_assert_o <= `INT_DEASSERT;
//			irq_addr_o <= `ZeroWord;
//		end 
//		else begin
//			case(cur_csr_state)
//
//				S_MCAUSE: begin
//					irq_assert_o <= `INT_ASSERT;
//					irq_addr_o <= csr_mtvec;
//				end
//
//				S_MSTATUS_MRET: begin
//					irq_assert_o <= `INT_ASSERT;
//					irq_addr_o <= csr_mepc;
//				end
//				
//				default: begin
//					irq_assert_o <= `INT_DEASSERT;
//					irq_addr_o <= `ZeroWord;
//				end
//				
//			endcase
//		end
//	end

endmodule
