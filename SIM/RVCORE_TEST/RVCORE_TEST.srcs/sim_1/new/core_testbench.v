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


module core_testbench(

    );
    reg rst_n;
    reg clk;
    initial begin
        rst_n <= 1'b0;
        clk <= 1'b0;
        #20 rst_n <= 1'b1;
    end
    
    always #100 clk <= ~clk;
    
    core core_u(
        .clk(clk),
        .rst_n(rst_n)
    );
    
    
endmodule
