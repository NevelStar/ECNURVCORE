
`include "defines.v"

module clint_top
(
	input		clk,
	input		rst_n,
	
	// from core
//	input wire[`INT_BUS] int_flag_i,         // External Interrput
	
	// from if
	
	
	// from id
	input	[`BUS_DATA_INSTR]		instr_id_i			,
	input	[`BUS_ADDR_MEM]			addr_instr_id_i		,
	
	// from ex
//	input wire jump_flag_i,
//	input wire[`InstAddrBus] jump_addr_i,
//	input wire div_started_i,
	
	// from ctrl
//	input wire[`Hold_Flag_Bus] hold_flag_i,  // ��ˮ����ͣ��־
	
	// from csr_reg
	input	[`DATA_WIDTH]			csr_rdata_i,
//	input wire[`RegBus] csr_mtvec,  
//	input wire[`RegBus] csr_mepc,   
//	input wire[`RegBus] csr_mstatus,
	
	input wire global_int_en_i,              // ȫ���ж�ʹ�ܱ�־
	
	// to ctrl
//	output wire hold_flag_o,                 // ��ˮ����ͣ��־
	output	reg						int_assert_o,
	output	reg	[`BUS_DATA_INSTR]	int_addr_o,
	
	// to csr_reg
	output reg we_o				,                         
	output reg[`MemAddrBus] waddr_o,         
	output reg[`MemAddrBus] raddr_o,         
	output reg[`RegBus] data_o
);


// �ж�״̬����
localparam S_INT_IDLE            = 4'b0001;
localparam S_INT_SYNC_ASSERT     = 4'b0010;
localparam S_INT_ASYNC_ASSERT    = 4'b0100;
localparam S_INT_MRET            = 4'b1000;

// дCSR�Ĵ���״̬����
localparam S_CSR_IDLE            = 5'b00001;
localparam S_CSR_MSTATUS         = 5'b00010;
localparam S_CSR_MEPC            = 5'b00100;
localparam S_CSR_MSTATUS_MRET    = 5'b01000;
localparam S_CSR_MCAUSE          = 5'b10000;

reg[3:0] int_state;
reg[4:0] csr_state;
reg[`BUS_ADDR_MEM] inst_addr;
reg[31:0] cause;


assign hold_flag_o = ((int_state != S_INT_IDLE) | (csr_state != S_CSR_IDLE))? `HoldEnable: `HoldDisable;


// �ж��ٲ��߼�
always @ (*) begin
    if (!rst_n) begin
        int_state = S_INT_IDLE;
    end else begin
        if (inst_i == `INST_ECALL || inst_i == `INST_EBREAK) begin      //�ȴ���ͬ���쳣
            int_state = S_INT_SYNC_ASSERT;
        end else if (tmr_irq_i == `True && glb_irqen_i == `True) begin  //�ٴ����첽�ж�:��ʱ��
            int_state = S_INT_ASYNC_ASSERT;
        end
    end else if (inst_i == `INST_MRET) begin                            //����ص�ָ��
        int_state = S_INT_MRET;
    end else begin
        int_state = S_INT_IDLE;
    end
end
end

// дCSR�Ĵ���״̬�л�
// ��¼�жϲ���ʱ��PC��ַ
// ��¼�жϻ����쳣������ԭ��
always @ (posedge clk) begin
    if (!rst_n) begin
        csr_state <= S_CSR_IDLE;
        cause <= `ZeroWord;
        inst_addr <= `ZeroWord;
    end else begin
        case (csr_state)
            S_CSR_IDLE: begin
                // ͬ���ж�
                if (int_state == S_INT_SYNC_ASSERT) begin   
                    csr_state <= S_CSR_MEPC;
                    // ���жϴ�������Ὣ�жϷ��ص�ַ��4
                    if (jump_flag_i == `JumpEnable) begin
                        inst_addr <= jump_addr_i - 4'h4;
                    end else begin
                        inst_addr <= inst_addr_i;
                    end
                    case (inst_i)
                        `INST_ECALL: begin
                            cause <= 32'd11;  //environment call
                        end
                        `INST_EBREAK: begin
                            cause <= 32'd3;   //break point
                        end
                        default: begin
                            cause <= 32'd10;  //Reserved
                        end
                    endcase
                    // �첽�ж�
                end else if (int_state == S_INT_ASYNC_ASSERT) begin
                    cause <= 32'h80000007;     // ֻʵ���˻���ģʽ��ʱ���ж�
                    csr_state <= S_CSR_MEPC;
                    if (jump_flag_i == `JumpEnable) begin
                        inst_addr <= jump_addr_i;
                    end else begin
                        inst_addr <= inst_addr_i;
                    end
                    // �жϷ���
                end else if (int_state == S_INT_MRET) begin
                    csr_state <= S_CSR_MSTATUS_MRET;
                end
            end
            S_CSR_MEPC: begin
                csr_state <= S_CSR_MSTATUS;
            end
            S_CSR_MSTATUS: begin
                csr_state <= S_CSR_MCAUSE;
            end
            S_CSR_MCAUSE: begin
                csr_state <= S_CSR_IDLE;
            end
            S_CSR_MSTATUS_MRET: begin
                csr_state <= S_CSR_IDLE;
            end
            default: begin
                csr_state <= S_CSR_IDLE;
            end
        endcase
    end
end

// �����ж��ź�ǰ����д����CSR�Ĵ���
always @ (posedge clk) begin
    if (rst == `RstEnable) begin
        csr_wen_o <= `WriteDisable;
        csr_waddr_o <= `ZeroWord;
        csr_data_o <= `ZeroWord;
    end else begin
        case (csr_state)
            // ��mepc�Ĵ�����ֵ��Ϊ��ǰָ���ַ
            S_CSR_MEPC: begin
                csr_wen_o <= `WriteEnable;
                csr_waddr_o <= {20'h0, `CSR_MEPC};
                csr_data_o <= inst_addr;
            end
            // д�жϲ�����ԭ��
            S_CSR_MCAUSE: begin
                csr_wen_o <= `WriteEnable;
                csr_waddr_o <= {20'h0, `CSR_MCAUSE};
                csr_data_o <= cause;
            end
            // �ر�ȫ���ж�
            S_CSR_MSTATUS: begin
                csr_wen_o <= `WriteEnable;
                csr_waddr_o <= {20'h0, `CSR_MSTATUS};
                csr_data_o <= {csr_mstatus[31:4], 1'b0, csr_mstatus[2:0]};
            end
            // �жϷ���
            S_CSR_MSTATUS_MRET: begin
                csr_wen_o <= `WriteEnable;
                csr_waddr_o <= {20'h0, `CSR_MSTATUS};
                csr_data_o <= {csr_mstatus[31:4], csr_mstatus[7], csr_mstatus[2:0]};
            end
            default: begin
                csr_wen_o <= `WriteDisable;
                csr_waddr_o <= `ZeroWord;
                csr_data_o <= `ZeroWord;
            end
        endcase
    end
end

// �����ж��źŸ�exģ��
always @ (posedge clk) begin
    if (rst == `RstEnable) begin
        int_assert_o <= `INT_DEASSERT;
        int_addr_o <= `ZeroWord;
    end else begin
        case (csr_state)
            // �����жϽ����ź�.д��mcause�Ĵ������ܷ�
            S_CSR_MCAUSE: begin
                int_assert_o <= `INT_ASSERT;
                int_addr_o <= csr_mtvec;
            end
            // �����жϷ����ź�
            S_CSR_MSTATUS_MRET: begin
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
