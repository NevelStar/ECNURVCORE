Pipeline RISC-V CPU

ver1.0:
·Support instruction:
	TYPE R: ADD SUB SLL SLT SLTU XOR SRL SRA AND
			ADDI SLLI SLTI SLTUI XORI SRLI SRAI ANDI
	TYPE S: SB SH SW
	TYPE L: LB LH LW LBU LHU
	TYPE J: JAL JALR
	TYPE B: BEQ BNE BLT BGE BLTU BGEU
	TYPE U: AUIPC LUI

·Data path is set from "ex.v" to "decoder.v" for RAW data hazard

·Control unit:
	Hold logic is set for load hazard
	The instruction can be set as NOPE in control hazard
	Module "ctrl.v" is reserved for branch prediction


ver 1.1:
·Branch prediction supported:
	Used a buffer whose depth is one to store the pc of branch instruction and target
	If the pc is stored in the buffer, ctrl unit will predict to jump