//ECNURVCORE
//Single Cycle CPU
//Created by Chesed
//2021.07.09
//Edited in 2021.07.11


module mem_data(


	input 		[31:0] 	data_in		,
	input 		[31:0] 	addr		,
	
	input 		[2:0]	load_code	,
	input 		[1:0]	store_code	,

	output reg	[31:0]	data_out	

);

	reg		[7:0]	data[0:255];

	initial begin
		$readmemh(".../1.Single Cycle/mem/memory_data.dat",data);
	end

	always@(load_code) begin
		case(load_code)
			3'b000:		data_out <= {{24{data[addr][7]}},data[addr]};							//LB
			3'b001:		data_out <= {{16{data[addr+1][7]}},data[addr+1],data[addr]};			//LH		
			3'b010:		data_out <= {data[addr+3],data[addr+2],data[addr+1],data[addr]};		//LW
			3'b100:		data_out <= {24'd0,data[addr]};											//LBU
			3'b101:		data_out <= {16'd0,data[addr+1],data[addr]};							//LHU
			default:	data_out <= 32'd0;
		endcase
	end

	always@(store_code) begin
		case(store_code)
			2'b00:		data[addr] <= data_in[7:0];				//SB
			2'b01:		begin									//SH
							data[addr] <= data_in[7:0];	
							data[addr+1] <= data_in[15:8];		
						end
			2'b10:		begin									//SW
							data[addr] <= data_in[7:0];	
							data[addr+1] <= data_in[15:8];		
							data[addr+2] <= data_in[23:16];	
							data[addr+3] <= data_in[31:24];		
						end
		endcase
	end

endmodule