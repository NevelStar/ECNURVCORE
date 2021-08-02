//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.02

module ctrl_btb(
	input						clk					,
	input						rst_n				,
	
	input	[`BUS_ADDR_MEM]		pc_i				,
	input	[`BUS_ADDR_MEM]		target_pc_i			,
	input						record_en_i			,
	
	
	output						prediction_o		,
	output						prediction_t_o		,
	output						prediction_error_o	,
	output	[`BUS_ADDR_MEM]		target_pc_o		
);

	reg [`BUS_ADDR_MEM] pc_buffer;
	reg [`BUS_ADDR_MEM] target_buffer;

	reg jmp_prediction_t;
	reg prediction_error;

	assign target_pc_o = (jmp_prediction == `JMP_EN) ? target_buffer : `MEM_ADDR_ZERO;
	assign prediction_o = (pc_i == pc_buffer) ? `JMP_EN : `JMP_DIS;
	assign prediction_error_o = prediction_error;
	assign prediction_t_o = jmp_prediction_t;

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pc_buffer <= `MEM_ADDR_ZERO;
			target_buffer <= MEM_ADDR_ZERO;
			prediction_error <= `JMP_RIGHT;
		end
		else begin
			case({jmp_prediction_t,record_en_i})
				2'b10: begin
					pc_buffer <= `MEM_ADDR_ZERO;
					target_buffer <= `MEM_ADDR_ZERO;
					prediction_error <= `JMP_ERROR;
				end
				2'b01: begin
					pc_buffer <= pc_i;
					target_buffer <= target_pc_i;
					prediction_error <= `JMP_ERROR;
				end
				default: begin
					pc_buffer <= pc_buffer;
					target_buffer <= target_buffer;
					prediction_error <= `JMP_RIGHT;
				end
			endcase
		end
	end

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			jmp_prediction_t <= `JMP_DIS;
		end
		else begin
			if(target_pc_i == pc_buffer) begin
				jmp_prediction_t <= prediction_o;
			end
		end
	end


endmodule