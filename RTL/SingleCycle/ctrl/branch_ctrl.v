//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09

module branch_ctrl(
	
	input [31:0]	data_rs1	,
	input [31:0]	data_rs2	,

	input [2:0]		funct3		,

	output	reg		jmpb

);
	
	always@(*) begin
		case(funct3)
			3'b000:  	jmpb <= (data_rs1 == data_rs2) ? 1'b1 : 1'b0;	//BEQ
			3'b001:  	jmpb <= (data_rs1 == data_rs2) ? 1'b0 : 1'b1;	//BNE
			3'b100:		begin											//BLT
					 		if(data_rs1[31]==data_rs2[31]) begin
					 			jmpb <= (data_rs1 < data_rs2) ? 1'b1 : 1'b0;
					 		end
					 		else begin
					 			jmpb <= data_rs1[31];
					 		end
					 	end	
			3'b101:  	begin											//BGE
					 		if(data_rs1[31]==data_rs2[31]) begin
					 			jmpb <= (data_rs1 < data_rs2) ? 1'b0 : 1'b1;
					 		end
					 		else begin
					 			jmpb <= data_rs2[31];
					 		end
					 	end	
			3'b110:  	jmpb <= (data_rs1 < data_rs2) ? 1'b1 : 1'b0;	//BLTU
			3'b111:  	jmpb <= (data_rs1 > data_rs2) ? 1'b1 : 1'b0;	//BGEU
			default:  	jmpb <= 1'b0;
		endcase
	end



endmodule