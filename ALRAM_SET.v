//ALRAM_SET.v

module ALRAM_SET(
	input clk, reset,
	input isalram,
	input [5:0]min, sec, amin, asec,
	output reg LED,
	output reg alram_sound,
	output reg LEDalram
);

//LED is alram set on/off
always @(isalram) begin
	if (isalram == 1'b1) begin
		LED = 1'b1;
	end else begin
		LED = 1'b0;
	end
end

//LEDalram is alram sound on/off
always @(posedge clk) begin
	if(~reset) begin
		alram_sound = 1'b0;
		LEDalram = 1'b0;
	end else begin
		if(isalram == 1'b1) begin
			if(min == amin)
				if(sec == asec) begin
						alram_sound = 1'b1;
						LEDalram = 1'b1;
				end
		end else begin
			alram_sound = 1'b0;
			LEDalram = 1'b0;
		end
	end
end

endmodule
