//ECNURVCORE
//Pipline CPU
//Created by Chesed
//2021.07.19
//Edited in 2021.08.08


//the initial data
`define INSTR_ADDR_INI		32'h0000_0000

//zero
`define ZERO_WORD			32'h0000_0000
`define ZERO_DOUBLE			64'h0000_0000_0000_0000

`define MEM_ADDR_ZERO		32'h0000_0000
`define REG_ADDR_ZERO		5'h00

//the constant
`define REG_NUM				32
`define DATA_WIDTH			64

`define WR_STR_ALL			8'hff


//the bus width
`define BUS_ADDR_REG		4:0
`define BUS_ADDR_MEM		63:0
`define BUS_DATA_REG		63:0
`define BUS_DATA_MEM		63:0
`define BUS_DATA_INSTR		31:0
`define BUS_AXI_STRB		7:0
`define BUS_AXI_CACHE		3:0
`define BUS_ALU_OP			2:0
`define BUS_L_CODE			2:0
`define BUS_S_CODE			2:0
`define BUS_JMP_FLAG		2:0
`define BUS_HOLD_CODE		2:0
`define BUS_PRE_STATE		1:0

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

//LOAD
`define INSTR_LB			3'b000
`define INSTR_LH			3'b001
`define INSTR_LW			3'b010
`define INSTR_LD			3'b011
`define INSTR_LBU			3'b100
`define INSTR_LHU			3'b101
`define INSTR_LWU			3'b110
`define LOAD_NOPE			3'b111

//funct7 code
`define FUNCT7_ADD			7'b0000000
`define FUNCT7_SUB			7'b0100000
`define FUNCT7_SRL			7'b0000000
`define FUNCT7_SRA			7'b0100000
`define FUNCT7_SRLW			7'b0000000
`define FUNCT7_SRAW			7'b0101000
`define FUNCT7_W_SRL		6'b000000
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
`define INSTR_RD_EN 1'b1
`define INSTR_RD_DIS 1'b0
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