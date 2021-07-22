//ECNURVCORE
//Pipline CPU
//Created by Chesed
//2021.07.19


//the initial data
`define INSTR_ADDR_INI		32'h0000_0000

//zero
`define ZERO_WORD			32'h0000_0000
`define MEM_ADDR_ZERO		32'h0000_0000
`define REG_ADDR_ZERO		5'h00

//the constant
`define REG_NUM				32


//the bus width
`define BUS_ADDR_REG		4:0
`define BUS_ADDR_MEM		31:0
`define BUS_DATA_REG		31:0
`define BUS_DATA_MEM		31:0
`define BUS_ALU_OP			2:0
`define BUS_L_CODE			2:0
`define BUS_S_CODE			2:0

//decode the instrument
`define OPERATION_CODE		6:0
`define ADDR_RD				11:7
`define FUNCT3				14:12
`define ADDR_RS1			19:15
`define ADDR_RS2			24:20
`define SHAMT				24:20
`define FUNCT7				31:25



//operation code
`define OPERATION_NOP		7'b0000000
`define OPERATION_R			7'b0110011
`define OPERATION_I			7'b0010011

`define OPERATION_LUI		7'b0110111
`define OPERATION_LOAD		7'b0000011
`define OPERATION_S			7'b0100011

`define OPERATION_B			7'b1100011
`define OPERATION_J			7'b1101111
`define OPERATION_JR		7'b1100111
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
`define STORE_NOPE			3'b111

//type I JALR
`define INSTR_JALR			3'b000

//LOAD
`define INSTR_LB			3'b000
`define INSTR_LH			3'b001
`define INSTR_LW			3'b010
`define INSTR_LBU			3'b100
`define INSTR_LHU			3'b101
`define LOAD_NOPE			3'b111

//funct7 code
`define FUNCT7_ADD			7'b0000000
`define FUNCT7_SUB			7'b0100000
`define FUNCT7_SRL			7'b0000000
`define FUNCT7_SRA			7'b0100000



//alu operation
`define ALU_ADD				3'b000
`define ALU_SL				3'b001
`define ALU_SLT				3'b010
`define ALU_SLTU			3'b011
`define ALU_XOR				3'b100
`define ALU_SR				3'b101
`define ALU_OR				3'b110
`define ALU_AND				3'b111


//enable/disable flag
`define REG_WR_EN			1'b1
`define REG_WR_DIS			1'b0
`define JMP_EN				1'b1
`define JMP_DIS				1'b0
`define MEM_WR_EN			1'b1
`define MEM_RD_EN			1'b0