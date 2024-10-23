//ALRAM_SOUND.V

module ALRAM_SOUND(
	input clk, clk_1MHZ, reset, alram_sound,
	output piezo
);

reg buff;
integer CNT_SOUND, CNT_DURATION, STATE, LIMIT;
parameter DURATION = 300;

parameter HIGH_DO = 955;
parameter HIGH_RE = 851;
parameter HIGH_MI = 758;
parameter HIGH_FA = 715;
parameter HIGH_SOL = 637;
parameter HIGH_RA = 568;
parameter RA = 1136;
parameter FA = 1432;
parameter RE = 1702;


always @(posedge clk) begin
	if(alram_sound == 1'b1) begin
		if(~reset) begin
			CNT_DURATION = 0;
			STATE = 0;
			LIMIT = 0;
		end else begin
			if(CNT_DURATION >= DURATION) begin
				CNT_DURATION = 0;
				STATE = STATE + 1;
				if(STATE > 45) STATE = 0;
			end else
				CNT_DURATION = CNT_DURATION + 1;
		end
		
		case (STATE)
			0: LIMIT = HIGH_FA;
			1: LIMIT = HIGH_MI;
			2: LIMIT = HIGH_FA;
			3: LIMIT = HIGH_RA;
			4: LIMIT = HIGH_RE;
			
			5: LIMIT = HIGH_FA;
			6: LIMIT = HIGH_MI;
			7: LIMIT = HIGH_FA;
			8: LIMIT = HIGH_RA;
			9: LIMIT = HIGH_RE;
			
			10: LIMIT = HIGH_SOL;
			11: LIMIT = HIGH_FA;
			12: LIMIT = HIGH_MI;
			13: LIMIT = HIGH_RE;
			14: LIMIT = HIGH_DO;
			15: LIMIT = HIGH_RE;
			16: LIMIT = HIGH_MI;
			17: LIMIT = HIGH_DO;
			
			18: LIMIT = HIGH_RE;
			19: LIMIT = HIGH_MI;
			20: LIMIT = HIGH_FA;
			21: LIMIT = HIGH_SOL;
			22: LIMIT = HIGH_RA;
			
			23: LIMIT = HIGH_FA;
			24: LIMIT = HIGH_MI;
			25: LIMIT = HIGH_FA;
			26: LIMIT = HIGH_RA;
			27: LIMIT = HIGH_RE;
			
			28: LIMIT = HIGH_FA;
			29: LIMIT = HIGH_MI;
			30: LIMIT = HIGH_FA;
			31: LIMIT = HIGH_RA;
			32: LIMIT = HIGH_RE;
			
			33: LIMIT = HIGH_SOL;
			34: LIMIT = HIGH_FA;
			35: LIMIT = HIGH_MI;
			36: LIMIT = HIGH_RE;
			37: LIMIT = HIGH_DO;
			38: LIMIT = HIGH_RE;
			39: LIMIT = HIGH_MI;
			40: LIMIT = HIGH_DO;
			
			41: LIMIT = HIGH_RE;
			42: LIMIT = RA;
			43: LIMIT = FA;
			44: LIMIT = RA;
			45: LIMIT = RE;
			default: LIMIT = HIGH_DO;
		endcase
	end else begin
		CNT_DURATION = 0;
		LIMIT = 0;
		STATE = 0;
	end
end

always @(posedge clk_1MHZ) begin
	if(alram_sound == 1'b1) begin
		if(~reset) begin
			buff = 1'b0;
			CNT_SOUND = 0;
		end else begin	
			if(CNT_SOUND >= LIMIT) begin
					CNT_SOUND = 0;
					buff <= ~buff;
				end else
					CNT_SOUND = CNT_SOUND + 1;
		end
	end
end

assign piezo = buff;

endmodule
