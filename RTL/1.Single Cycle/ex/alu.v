//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//2021.07.11

module alu(

	input 	[31:0]		data_in1	,
	input 	[31:0]		data_in2	,

	input	[2:0]		funct3		,
	input				shift_ctrl	,
	input				sub_ctrl	,

	output reg [31:0]	data_out
);

	wire 	[4:0] shamt;
	assign shamt = data_in2[4:0];

	always(*) begin
		case(funct3)
			3'b000:		begin																//ADDI,ADD,SUB
							case(sub_ctrl)
								1'b0:	data_out <= data_in1 + data_in2;					//ADDI,ADD
								1'b1:	data_out <= data_in1 - data_in2;					//SUB
							endcase		
						end		
			3'b001:		data_out <= data_in1 << shamt;										//SLLI,SLL
			3'b010:		begin																//SLTI,SLT
							if(data_in1[31]==data_in2[31]) begin		
								data_out <= (data_in1 < data_in2) ? 32'd1 : 32'd0;		
							end		
							else begin		
								data_out <= {31'd0,data_in1[31]};		
							end		
						end		
			3'b011:		data_out <= (data_in1 < data_in2) ? 32'd1 : 32'd0;					//SLTIU,SLTU
			3'b100:		data_out <= data_in1 ^ data_in2;									//XORI,XOR
			3'b101:		begin																//SRL,SRLI,SRA,SRAI
							case(shift_ctrl)
								1'b0:	data_out <= data_in1 >> shamt;						//SRL,SRLI
								1'b1:	data_out <= {{32{data_in1[31]}},data_in1} >> shamt;	//SRA,SRAI
							endcase
						end
			3'b110:		data_out <= data_in1 | data_in2;									//ORI,OR
			3'b111:		data_out <= data_in1 & data_in2;									//ANDI,AND	
			default:	data_out <= 32'd0;
		endcase
	end

endmodule