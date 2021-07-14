module cnt_16(
    input         clk,
    input         rst_n,
    output [15:0] out 
    );

    reg    [15:0] Counter;

always @(posedge clk or negedge rst_n)
  begin 
    if (!rst_n) 
       Counter  <=  16'b0;
    else 
       Counter  <=  Counter  +  16'b1;
  end 
assign  out =  Counter;

endmodule