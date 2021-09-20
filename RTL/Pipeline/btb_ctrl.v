//ECNURVCORE
//Pipeline CPU
//Created by Chesed
//2021.08.02
//Edited in 2021.08.04

`include "define.v"

module btb_ctrl(
	input						clk					,
	input						rst_n				,


	input	[`BUS_HOLD_CODE]	hold_code			,
	
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
	reg pc_match_t;
	reg [`BUS_ADDR_MEM] target_prediction_t;

	reg [`BUS_PRE_STATE] prediction_state;

	wire jmp_en_error;
	wire jmp_target_error;
	wire prediction_error;

	wire pc_match;

	wire hold_n;

	assign hold_n = (hold_code == `HOLD_CODE_NOPE) ? `HOLD_DIS : `HOLD_EN;

	assign pc_match =  ((pc_i == pc_buffer) && (pc_i != `MEM_ADDR_ZERO)) ? `PC_MATCH : `PC_MISMATCH;

	assign target_pc_o = (jmp_prediction_o == `JMP_EN) ? target_buffer : `MEM_ADDR_ZERO;
	assign jmp_prediction_o = (pc_match == `PC_MATCH) ? prediction_state[1] : `JMP_DIS;

	assign jmp_en_error = (jmp_en_i == jmp_prediction_t) ? `JMP_RIGHT : `JMP_ERROR;
	assign jmp_target_error = (target_pc_i == target_prediction_t) ? `JMP_RIGHT : `JMP_ERROR;
	assign prediction_error = jmp_en_error | jmp_target_error;
	assign prediction_error_o = prediction_error;


	always@(posedge clk) begin
		if(!rst_n) begin
			hold_n_t <= `HOLD_DIS;
		end
		else begin
			hold_n_t <= hold_n;
		end
	end
	always@(posedge clk) begin
		if(!rst_n) begin
			pc_buffer <= `MEM_ADDR_ZERO;
			target_buffer <= `MEM_ADDR_ZERO;
			prediction_state <= `STATE_S_HOLD;
		end
		else begin
			if(hold_n_t) begin
				if(prediction_error == `JMP_ERROR) begin
					pc_buffer <= (jmp_en_i == `JMP_EN) ? pc_jmp_i : `MEM_ADDR_ZERO;
					target_buffer <= (jmp_en_i == `JMP_EN) ? target_pc_i : `MEM_ADDR_ZERO;
					prediction_state <= (jmp_en_i == `JMP_DIS) ? (prediction_state - 2'b01) : ((pc_match_t == `PC_MATCH) ? (prediction_state + 2'b01) : `STATE_W_HOLD);
				end
				else begin
					pc_buffer <= pc_buffer;
					target_buffer <= target_buffer;
					prediction_state <= (jmp_en_i == `JMP_EN) ? `STATE_S_JMP : ((pc_match_t == `PC_MATCH) ? `STATE_S_HOLD : prediction_state);
				end
			end
			else begin
				pc_buffer <= pc_buffer;
				target_buffer <= target_buffer;
				prediction_state <= prediction_state;
			end
		end
	end

	always@(posedge clk) begin
		if(!rst_n) begin
			jmp_prediction_t <= `JMP_DIS;
			target_prediction_t <= `MEM_ADDR_ZERO;
			pc_match_t <= `PC_MISMATCH;
		end
		else begin
			if(hold_n == `HOLD_DIS) begin
				jmp_prediction_t <= jmp_prediction_o;
				target_prediction_t <= target_pc_o;
				pc_match_t <= pc_match;
			end
			else begin
				jmp_prediction_t <= jmp_prediction_t;
				target_prediction_t <= target_prediction_t;
				pc_match_t <= pc_match_t;
			end
		end
	end


endmodule