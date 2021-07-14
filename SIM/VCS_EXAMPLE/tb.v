`timescale 1ns/1ps

module tb();
 reg clk ;
 reg rst_n;
 wire [15:0] out ;
  
	
  initial
    begin
     $fsdbDumpfile("wave.fsdb");
     $fsdbDumpvars(0);
     $fsdbDumpon;
    end

 initial
    begin
      clk <= 0;
      rst_n <=1;
      #10 rst_n<=0;
      #10 rst_n<=1;
      #500000 $finish();;
    end

always
begin
#1000  clk <= ~clk;
end
cnt_16 count1(.clk(clk),.rst_n(rst_n),.out(out));

endmodule
