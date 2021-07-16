//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//Edited in 2021.07.11
//Edited in 2021.07.12
//Edited in 2021.07.14

module core(
	input	clk		,
	input	rst_n	

);

wire [31:0] 	instr;
wire [31:0]		addr_instr;
wire [6:0]		operation;
wire [4:0]		addr_rd;
wire [4:0]		addr_rs1;
wire [4:0]		addr_rs2;
wire [2:0]		funct3;
wire [6:0]		funct7;

wire [11:0]		imm;
wire [19:0]		imm_u;
wire [31:0]		jmp;
wire [31:0]		jmp_to;

wire [31:0]		data_rs1;
wire [31:0]		data_rs2;

wire [31:0]		data_out;
wire [31:0]		data_wr;
wire [31:0]		data_mem;
wire [31:0]		addr_mem;

wire [2:0]		load_code;
wire [1:0]		store_code;

wire 			jmp_en;
wire 			jmpr_en;
wire 			jmpb_en;


wire 			wr_en;
wire			shift_ctrl;
wire			sub_ctrl;

instr_fetch cpu_if(

	.clk		(clk),
	.rst_n		(rst_n),
	.jmp_en		(jmp_en	),
	.jmpr_en	(jmpr_en),
	.jmpb_en	(jmpb_en),
	.jmp_to		(jmp_to	),

	.addr_instr	(addr_instr)
);


id cpu_id(
	.instr_in	(instr),

	.operation	(operation),
	.rd			(addr_rd),
	.funct3		(funct3),	
	.rs1		(addr_rs1),
	.rs2		(addr_rs2),
	.funct7		(funct7),

	.imm		(imm),
	.imm_u		(imm_u),
	.jmp		(jmp)

);

register general_reg(
	.clk		(clk),
	.rst_n		(rst_n),

	.wr_en		(wr_en),

	.addr_wr	(addr_rd),
	.addr_rd1	(addr_rs1),
	.addr_rd2	(addr_rs2),
	.data_wr	(data_wr),


	.data_rd1	(data_rs1),
	.data_rd2	(data_rs2)

);

ex cpu_ex(
	
	.operation	(operation),
	.data_rs1	(data_rs1),
	.data_rs2	(data_rs2),
	.jmp		(jmp),

	.imm		(imm),

	.funct3		(funct3),
	.shift_ctrl	(shift_ctrl),
	.sub_ctrl	(sub_ctrl),

	.data_out	(data_out),
	.addr_mem	(addr_mem),
	.jmp_to 	(jmp_to)
);

ctrl cpu_ctrl(

	.data_rs1	(data_rs1),
	.data_rs2	(data_rs2),
	.operation	(operation),


	.funct3		(funct3),
	.funct7		(funct7),


	.load_code	(load_code),
	.store_code	(store_code),
	.wr_en		(wr_en),

	.jmp_en		(jmp_en),
	.jmpr_en	(jmpr_en)	,
	.jmpb_en	(jmpb_en)	,

	.shift_ctrl	(shift_ctrl),
	.sub_ctrl	(sub_ctrl)

);

wb cpu_wb(
	.data_out	(data_out),
	.data_addr	(addr_instr),
	.data_mem	(data_mem),
	.operation	(operation),

	.data_wr	(data_wr)
);

mem_data mem_data_interact(


	.data_in	(data_rs2),
	.addr		(addr_mem),
	
	.load_code	(load_code),
	.store_code	(store_code),

	.data_out	(data_mem)	

);


mem_instr mem_instr_interact(

	.addr(addr_instr),

	.instr_out(instr)
);

endmodule