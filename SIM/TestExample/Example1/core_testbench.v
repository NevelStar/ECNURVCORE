`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/12 19:59:07
// Design Name: 
// Module Name: core_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "define.v"
module core_testbench(

    );
    reg rst_n;
    reg clk;
    initial begin
        rst_n <= 1'b0;
        clk <= 1'b0;
        #20 rst_n <= 1'b1;
	  #13000 $finish();;
    end
    
    always #10 clk <= ~clk;
    wire mem_wr_en;
    wire mem_rd_en;
    wire instr_rd_en;
    wire [`BUS_ADDR_MEM] addr_instr;
    wire [`BUS_ADDR_MEM] pc;
    wire [`BUS_DATA_INSTR] instr;
    wire [`BUS_ADDR_MEM] addr_mem_rd;
    wire [`BUS_ADDR_MEM] addr_mem_wr;
    wire [`BUS_DATA_MEM] data_mem_rd;
    wire [`BUS_DATA_MEM] data_mem_wr;
    
    core core_u(
        .clk(clk),
        .rst_n(rst_n),
	  .stall(1'b0),
	  .instr_i(instr),
	  .addr_instr_i(addr_instr),
	  .data_mem_i(data_mem_rd),
	  .mem_wr_en_o(mem_wr_en),
	  .mem_rd_en_o(mem_rd_en),
	  .data_mem_wr_o(data_mem_wr),
	  .addr_mem_rd_o(addr_mem_rd),
	  .addr_mem_wr_o(addr_mem_wr),
	  .instr_rd_en_o(instr_rd_en),
	  .pc_o(pc)

    );

    bus_core bus_core_u(
	.clk(clk),

	.mem_wr_en_i(mem_wr_en),
	.mem_rd_en_i(mem_rd_en),
	.data_mem_wr_i(data_mem_wr),	
	.addr_mem_rd_i(addr_mem_rd),
	.addr_mem_wr_i(addr_mem_wr),
	.addr_instr_i(pc),		

	.instr_rd_en_i(instr_rd_en),
	.data_instr_o(instr),
	.addr_instr_o(addr_instr),
	.data_mem_rd_o(data_mem_rd)		
	

);



	initial begin     
		$fsdbDumpfile("wave.fsdb");
		$fsdbDumpvars(0);
		$fsdbDumpon;
	end
    
    
endmodule
