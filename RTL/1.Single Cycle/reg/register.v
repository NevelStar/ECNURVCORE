//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//Edited in 2021.07.12


module register(
	input				clk,
	input				rst_n,

	input				wr_en,
	//	read is always enable

	input	[5:0]		addr_wr,
	input	[5:0]		addr_rd1,
	input	[5:0]		addr_rd2,
	input	[31:0]		data_wr,


	output reg	[31:0]	data_rd1,
	output reg	[31:0]	data_rd2


);


	reg [31:0]	register_x1;
	reg [31:0]	register_x2;
	reg [31:0]	register_x3;
	reg [31:0]	register_x4;
	reg [31:0]	register_x5;
	reg [31:0]	register_x6;
	reg [31:0]	register_x7;
	reg [31:0]	register_x8;
	reg [31:0]	register_x9;
	reg [31:0]	register_x10;
	reg [31:0]	register_x11;
	reg [31:0]	register_x12;
	reg [31:0]	register_x13;
	reg [31:0]	register_x14;
	reg [31:0]	register_x15;
	reg [31:0]	register_x16;
	reg [31:0]	register_x17;
	reg [31:0]	register_x18;
	reg [31:0]	register_x19;
	reg [31:0]	register_x20;
	reg [31:0]	register_x21;
	reg [31:0]	register_x22;
	reg [31:0]	register_x23;
	reg [31:0]	register_x24;
	reg [31:0]	register_x25;
	reg [31:0]	register_x26;
	reg [31:0]	register_x27;
	reg [31:0]	register_x28;
	reg [31:0]	register_x29;
	reg [31:0]	register_x30;
	reg [31:0]	register_x31;

	//x0 is always zero

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin	
			register_x1  <= 32'h0 ;
			register_x2  <= 32'h0 ;
			register_x3  <= 32'h0 ;
			register_x4  <= 32'h0 ;
			register_x5  <= 32'h0 ;
			register_x6  <= 32'h0 ;
			register_x7  <= 32'h0 ;
			register_x8  <= 32'h0 ;
			register_x9  <= 32'h0 ;
			register_x10 <= 32'h0 ;
			register_x11 <= 32'h0 ;
			register_x12 <= 32'h0 ;
			register_x13 <= 32'h0 ;
			register_x14 <= 32'h0 ;
			register_x15 <= 32'h0 ;
			register_x16 <= 32'h0 ;
			register_x17 <= 32'h0 ;
			register_x18 <= 32'h0 ;
			register_x19 <= 32'h0 ;
			register_x20 <= 32'h0 ;
			register_x21 <= 32'h0 ;
			register_x22 <= 32'h0 ;
			register_x23 <= 32'h0 ;
			register_x24 <= 32'h0 ;
			register_x25 <= 32'h0 ;
			register_x26 <= 32'h0 ;
			register_x27 <= 32'h0 ;
			register_x28 <= 32'h0 ;
			register_x29 <= 32'h0 ;
			register_x30 <= 32'h0 ;
			register_x31 <= 32'h0 ;
		end
		else begin
			if(wr_en) begin
				case(addr_wr)
					5'd1  	:	register_x1  <= data_wr ;
					5'd2  	:	register_x2  <= data_wr ;
					5'd3  	:	register_x3  <= data_wr ;
					5'd4  	:	register_x4  <= data_wr ;
					5'd5  	:	register_x5  <= data_wr ;
					5'd6  	:	register_x6  <= data_wr ;
					5'd7  	:	register_x7  <= data_wr ;
					5'd8  	:	register_x8  <= data_wr ;
					5'd9  	:	register_x9  <= data_wr ;
					5'd10 	:	register_x10 <= data_wr ;
					5'd11 	:	register_x11 <= data_wr ;
					5'd12 	:	register_x12 <= data_wr ;
					5'd13 	:	register_x13 <= data_wr ;
					5'd14 	:	register_x14 <= data_wr ;
					5'd15 	:	register_x15 <= data_wr ;
					5'd16 	:	register_x16 <= data_wr ;
					5'd17 	:	register_x17 <= data_wr ;
					5'd18 	:	register_x18 <= data_wr ;
					5'd19 	:	register_x19 <= data_wr ;
					5'd20 	:	register_x20 <= data_wr ;
					5'd21 	:	register_x21 <= data_wr ;
					5'd22 	:	register_x22 <= data_wr ;
					5'd23 	:	register_x23 <= data_wr ;
					5'd24 	:	register_x24 <= data_wr ;
					5'd25 	:	register_x25 <= data_wr ;
					5'd26 	:	register_x26 <= data_wr ;
					5'd27 	:	register_x27 <= data_wr ;
					5'd28 	:	register_x28 <= data_wr ;
					5'd29 	:	register_x29 <= data_wr ;
					5'd30 	:	register_x30 <= data_wr ;
					5'd31 	:	register_x31 <= data_wr ;
				endcase
			end
		end
	end


	always @(addr_rd1)begin
		case(addr_rd1)
			5'd0	:	data_rd1 <=  32'h0  	  ;
			5'd1  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x1  ;
			5'd2  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x2  ;
			5'd3  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x3  ;
			5'd4  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x4  ;
			5'd5  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x5  ;
			5'd6  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x6  ;
			5'd7  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x7  ;
			5'd8  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x8  ;
			5'd9  	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x9  ;
			5'd10 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x10 ;
			5'd11 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x11 ;
			5'd12 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x12 ;
			5'd13 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x13 ;
			5'd14 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x14 ;
			5'd15 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x15 ;
			5'd16 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x16 ;
			5'd17 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x17 ;
			5'd18 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x18 ;
			5'd19 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x19 ;
			5'd20 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x20 ;
			5'd21 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x21 ;
			5'd22 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x22 ;
			5'd23 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x23 ;
			5'd24 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x24 ;
			5'd25 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x25 ;
			5'd26 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x26 ;
			5'd27 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x27 ;
			5'd28 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x28 ;
			5'd29 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x29 ;
			5'd30 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x30 ;
			5'd31 	:	data_rd1 <=  ((addr_rd1==addr_wr) & wr_en) ? data_wr : register_x31 ;
			default	:	data_rd1 <=  32'h0													;
		endcase
	end

	always @(addr_rd2)begin
		case(addr_rd2)
			5'd0	:	data_rd2 <=  32'h0  	  ;
			5'd1  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x1  ;
			5'd2  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x2  ;
			5'd3  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x3  ;
			5'd4  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x4  ;
			5'd5  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x5  ;
			5'd6  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x6  ;
			5'd7  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x7  ;
			5'd8  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x8  ;
			5'd9  	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x9  ;
			5'd10 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x10 ;
			5'd11 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x11 ;
			5'd12 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x12 ;
			5'd13 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x13 ;
			5'd14 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x14 ;
			5'd15 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x15 ;
			5'd16 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x16 ;
			5'd17 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x17 ;
			5'd18 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x18 ;
			5'd19 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x19 ;
			5'd20 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x20 ;
			5'd21 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x21 ;
			5'd22 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x22 ;
			5'd23 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x23 ;
			5'd24 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x24 ;
			5'd25 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x25 ;
			5'd26 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x26 ;
			5'd27 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x27 ;
			5'd28 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x28 ;
			5'd29 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x29 ;
			5'd30 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x30 ;
			5'd31 	:	data_rd2 <=  ((addr_rd2==addr_wr) & wr_en) ? data_wr : register_x31 ;
			default	:	data_rd2 <=  32'h0													;
		endcase
	end

endmodule