//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.02
//Edited in 2021.08.03

module btb_ctrl(
	input						clk					,
	input						rst_n				,
	
	input	[`BUS_ADDR_MEM]		pc_i				,
	input	[`BUS_ADDR_MEM]		pc_jmp_i			,
	input	[`BUS_ADDR_MEM]		target_pc_i			,
	input						jmp_en_i			,
	
	
	output						jmp_prediction_o	,
	output	[`BUS_ADDR_MEM]		target_pc_o			,
	output						prediction_error_o
);

	reg [`BUS_ADDR_MEM] pc_buffer;
	reg [`BUS_ADDR_MEM] target_buffer;

	reg jmp_prediction_t;
	reg [`BUS_ADDR_MEM] target_prediction_t;

	wire jmp_en_error;
	wire jmp_target_error;
	wire prediction_error;


	assign target_pc_o = (jmp_prediction_o == `JMP_EN) ? target_buffer : `MEM_ADDR_ZERO;
	assign jmp_prediction_o = ((pc_i == pc_buffer) & (pc_i != `MEM_ADDR_ZERO)) ? `JMP_EN : `JMP_DIS;

	assign jmp_en_error = (jmp_en_i == jmp_prediction_t) ? `JMP_RIGHT : `JMP_ERROR;
	assign jmp_target_error = (target_pc_i == target_prediction_t) ? `JMP_RIGHT : `JMP_ERROR;
	assign prediction_error = jmp_en_error | jmp_target_error;
	assign prediction_error_o = prediction_error;

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pc_buffer <= `MEM_ADDR_ZERO;
			target_buffer <= `MEM_ADDR_ZERO;
		end
		else begin
			if(prediction_error == `JMP_ERROR) begin
				pc_buffer <= (jmp_en_i == `JMP_EN) ? pc_jmp_i : `MEM_ADDR_ZERO;
				target_buffer <= (jmp_en_i == `JMP_EN) ? target_pc_i : `MEM_ADDR_ZERO;
			end
			else begin
				pc_buffer <= pc_buffer;
				target_buffer <= target_buffer;
			end
		end
	end

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			jmp_prediction_t <= `JMP_DIS;
			target_prediction_t <= `MEM_ADDR_ZERO;
		end
		else begin
			jmp_prediction_t <= jmp_prediction_o;
			target_prediction_t <= target_pc_o;
		end
	end


endmodule