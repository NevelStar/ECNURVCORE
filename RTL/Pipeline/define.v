//ECNURVCORE
//Pipline CPU
//Created by Chesed
//2021.07.19
//Edited in 2021.08.31


//the initial data
`define INSTR_ADDR_INI		64'h0000_0000_0000_0000

`define BASE_PC				64'h0000_0000_0000_0000
`define BASE_MEM			64'h0000_0000_0000_1000

`define PC_MAX				64'h0000_0000_0000_0fff

`define ADDR_TIMER_MIN      64'h0000_0000_1000_0000
`define ADDR_TIMER_MAX      64'h0000_0000_1fff_ffff


//zero
`define ZERO_WORD			32'h0000_0000
`define ZERO_DOUBLE			64'h0000_0000_0000_0000

`define MEM_ADDR_ZERO		64'h0000_0000_0000_0000
`define REG_ADDR_ZERO		5'h00
`define CSR_ADDR_ZERO		12'h000

`define AXI_ID_ZERO			4'b0000
`define AXI_LEN_ZERO		8'h00



//the constant
`define REG_NUM				32
`define DATA_WIDTH			64
`define ADDR_WIDTH         32
`define WR_STR_ALL			8'hff
`define WR_STR_WORD			8'h0f
`define WR_STR_HALF			8'h03
`define WR_STR_BYTE			8'h01
`define WR_STR_NONE			8'h00
`define PC_STEP				64'd4
`define ADDR_MAX_RAM		64'h0000_0001_0000_0000
`define AXI_OVER_PAGE		8'h01


//AXI size code
`define AXI_SIZE_BYTE		3'b000
`define AXI_SIZE_HALF		3'b001
`define AXI_SIZE_WORD		3'b010
`define AXI_SIZE_DOUBLE		3'b011

//AXI burst mode
`define AXI_BURST_FIX		2'b00
`define AXI_BURST_INCR		2'b01
`define AXI_BURST_WRAP		2'b10

//AXI ID
//master
`define AXI_ID_IF			4'b0000
`define AXI_ID_MEM			4'b0001
//slave
`define AXI_ID_RAM			4'b0000

//`define AXI_ID_MMIO			4'b0001






//the bus width
`define BUS_ADDR_REG		4:0
`define BUS_ADDR_MEM		63:0
`define BUS_DATA_REG		63:0
`define BUS_DATA_MEM		63:0
`define BUS_DATA_INSTR		31:0
`define BUS_ALU_OP			2:0
`define BUS_L_CODE			2:0
`define BUS_S_CODE			2:0
`define BUS_JMP_FLAG		2:0
`define BUS_HOLD_CODE		2:0
`define BUS_PRE_STATE		1:0
`define BUS_CSR_IMM			11:0
`define BUS_CSR_IMMEX		31:0
`define BUS_EXCEPT_CAUSE	2:0
`define BUS_CSR_CODE		5:0

//AXI bus
`define BUS_AXI_AWID		3:0
`define BUS_AXI_ARID		3:0
`define BUS_AXI_BID			3:0
`define BUS_AXI_RID			3:0
`define BUS_AXI_STRB		7:0
`define BUS_AXI_CACHE		3:0
`define BUS_AXI_LEN			7:0
`define BUS_AXI_SIZE		2:0
`define BUS_AXI_BURST		1:0
`define BUS_AXI_RESP		1:0
`define BUS_AXI_ADDR		31:0



//decode the instrument
`define OPERATION_CODE		6:0
`define ADDR_RD				11:7
`define FUNCT3				14:12
`define ADDR_RS1			19:15
`define ADDR_RS2			24:20
`define SHAMT				24:20
`define FUNCT7				31:25
`define FUNCT7_W			31:26




//operation code
`define OPERATION_NOP		7'b0000000
`define OPERATION_R			7'b0110011
`define OPERATION_RW		7'b0111011
`define OPERATION_I			7'b0010011
`define OPERATION_IW		7'b0011011

`define OPERATION_LUI		7'b0110111
`define OPERATION_LOAD		7'b0000011
`define OPERATION_S			7'b0100011

`define OPERATION_B			7'b1100011
`define OPERATION_J			7'b1101111
`define OPERATION_JR		7'b1100111
`define OPERATION_FENCE		7'b0001111
`define OPERATION_AUIPC		7'b0010111
`define OPERATION_SYS		7'b1110011


//funct3 code
//type R
`define INSTR_ADD			3'b000
`define INSTR_SL			3'b001
`define INSTR_SLT			3'b010
`define INSTR_SLTU			3'b011
`define INSTR_XOR			3'b100
`define INSTR_SR			3'b101
`define INSTR_OR			3'b110
`define INSTR_AND			3'b111
//type RW
`define INSTR_ADDW			3'b000
`define INSTR_SLW			3'b001
`define INSTR_SRW			3'b101

//type B
`define INSTR_BEQ			3'b000
`define INSTR_BNE			3'B001
`define INSTR_BLT			3'B100
`define INSTR_BGE			3'B101
`define INSTR_BLTU			3'B110
`define INSTR_BGEU			3'B111

//type S
`define INSTR_SB			3'b000
`define INSTR_SH			3'b001
`define INSTR_SW			3'b010
`define INSTR_SD			3'b011
`define STORE_NOPE			3'b111

//type I JALR
`define INSTR_JALR			3'b000

//type I SYSTEM			
`define INSTR_IRQ			3'b000
`define INSTR_CSRRW			3'b001
`define INSTR_CSRRS			3'b010
`define INSTR_CSRRC			3'b011
`define INSTR_CSRRWI		3'b101
`define INSTR_CSRRSI		3'b110
`define INSTR_CSRRCI		3'b111



//LOAD
`define INSTR_LB			3'b000
`define INSTR_LH			3'b001
`define INSTR_LW			3'b010
`define INSTR_LD			3'b011
`define INSTR_LBU			3'b100
`define INSTR_LHU			3'b101
`define INSTR_LWU			3'b110
`define LOAD_NOPE			3'b111




//irq instruction
`define INSTR_EBREAK 		32'h00100073
`define INSTR_ECALL 		32'h00000073

`define INSTR_URET			32'h00200073
`define INSTR_SRET			32'h10200073
`define INSTR_MRET			32'h30200073

`define INSTR_WFI			32'h10500073



//funct7 code
`define FUNCT7_ADD			7'b0000000
`define FUNCT7_SUB			7'b0100000
`define FUNCT7_SRL			7'b0000000
`define FUNCT7_SRA			7'b0100000
`define FUNCT7_SRLW			7'b0000000
`define FUNCT7_SRAW			7'b0100000
`define FUNCT7_R_ACT		7'b0000000
`define FUNCT7_W_SRL		6'b000000
`define FUNCT7_W_SLL		6'b000000
`define FUNCT7_W_SRA		6'b010000

//jmp flag code
`define JMP_NOPE			3'b011
`define JMP_J				3'b010
//the jump code of type B is funct3


//alu operation
`define ALU_ADD				3'b000
`define ALU_SL				3'b001
`define ALU_SLT				3'b010
`define ALU_SLTU			3'b011
`define ALU_XOR				3'b100
`define ALU_SR				3'b101
`define ALU_OR				3'b110
`define ALU_AND				3'b111


//enable/disable
`define INSTR_RD_EN 		1'b1
`define INSTR_RD_DIS		1'b0
`define REG_WR_EN			1'b1
`define REG_WR_DIS			1'b0
`define JMP_EN				1'b1
`define JMP_DIS				1'b0
`define MEM_WR_EN			1'b1
`define MEM_WR_DIS			1'b0
`define MEM_RD_EN			1'b1
`define MEM_RD_DIS			1'b0
`define ALU_SUB_EN			1'b1
`define ALU_ADD_EN			1'b0
`define ALU_SHIFT_L			1'b0
`define ALU_SHIFT_A			1'b1
`define BYPASS_EN			1'b0
`define BYPASS_DIS			1'b1
`define LOAD_BYPASS_EN		1'b1
`define LOAD_BYPASS_DIS		1'b0
`define HOLD_EN				1'b0
`define HOLD_DIS			1'b1
`define STALL_EN			1'b1
`define STALL_DIS			1'b0
`define MASK_EN				1'b1
`define MASK_DIS			1'b0
`define JMP_ERROR			1'b1
`define JMP_RIGHT			1'b0
`define PC_MATCH			1'b1
`define PC_MISMATCH			1'b0
`define INTERCEPT_EN		1'b1
`define INTERCEPT_DIS		1'b0

`define EXCEPT_NOPE			1'b0
`define EXCEPT_ACT			1'b1

`define HANDSHAKE_EN		1'b1
`define HANDSHAKE_DIS		1'b0
`define AXI_READY_EN		1'b1
`define AXI_READY_DIS		1'b0
`define AXI_VALID_EN		1'b1
`define AXI_VALID_DIS		1'b0
`define AXI_BUSY			1'b1
`define AXI_IDLE			1'b0
`define AXI_ADDR_ALIGN		1'b1
`define AXI_ADDR_UNALIGN	1'b0



//the scale of memory
`define NUM_DATA_MEM		0:255
`define NUM_INSTR_MEM		0:255


//hold code
`define HOLD_CODE_NOPE		3'b000
`define HOLD_CODE_PC		3'b001
`define HOLD_CODE_IF		3'b010
`define HOLD_CODE_ID		3'b011
`define HOLD_CODE_EX		3'b100


//prediction state
`define STATE_S_HOLD		2'b00
`define STATE_W_HOLD		2'b01
`define STATE_W_JMP			2'b10
`define STATE_S_JMP			2'b11

//exception cause
`define EXCEPT_NONE			3'b000
`define EXCEPT_PC_OVER		3'b001
`define EXCEPT_PC_ALIGN		3'b010
`define EXCEPT_ID_ILLEGAL	3'b011
`define EXCEPT_ECALL		3'b100
`define EXCEPT_EBREAK		3'b101
`define EXCEPT_MRET			3'b110
`define EXCEPT_MEM_ALIGN	3'b111


//CSR operation code
`define CSR_CODE_NOPE		3'b000
`define CSR_CODE_CSRRW		3'b001
`define CSR_CODE_CSRRS		3'b010
`define CSR_CODE_CSRRC		3'b011
`define CSR_CODE_CSRRWI		3'b101
`define CSR_CODE_CSRRSI		3'b110
`define CSR_CODE_CSRRCI		3'b111

// CSR reg addr
`define CSR_MSTATUS 	12'h300
`define CSR_MISA 		12'h301
`define CSR_MIE     	12'h304
`define CSR_MTVEC   	12'h305
`define CSR_MSCRATCH 	12'h340
`define CSR_MEPC     	12'h341
`define CSR_MCAUSE   	12'h342
`define CSR_MTVAL     	12'h343
`define CSR_MIP      	12'h344
`define CSR_MCYCLE   	12'hb00
`define CSR_MHARTID 	12'hf14

`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0

`define ISA_RV64I 64'h8000000000000100
`define RstEnable 1'b0

//mmio peripherals reg address
// | ADDRESS    		|  NAME    | FUNCTION 							|
// | 0x0000000002004000 | MTIMECMP | TRIG IRG WHEN MTIME >= MTIMECMP	|
// | 0x000000000200BFF8 | MTIME    | TIME CONUNTER						|

`define CLINT_MTIMECMP 32'h02004000
`define CLINT_MTIME    32'h0200BFF8

//IRQ base addr reset value
`define IRQ_ENTRY_ADDR 64'h30000000
