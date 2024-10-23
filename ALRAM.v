//main
module ALRAM(
   input clk,
	input clk_1MHZ,
   input reset,
   input [5:0]KEY,
	output LED,
	output LEDalram,
   output [7:0]SEG_DATA,
   output reg [3:0]SEG_COM,
	output piezo
);

   reg [5:0] MIN = 0;
   reg [5:0] SEC = 0;
	reg [5:0] aMIN = 0;
   reg [5:0] aSEC = 0;
   wire [3:0] S10, S1, M10, M1;
	wire [3:0] aS10, aS1, aM10, aM1;
   reg [3:0] NUM;
	

   reg SEG_DOT;

   integer CNT, CNT2, CNT_SCAN;
	reg mod = 0; 
	reg isalram = 0;
	wire alram_sound;

   
   always @(posedge clk) begin
      if (!reset) begin
         MIN = 0;
         SEC = 0;
         CNT = 0;
			CNT2 = 0;
			isalram = 1'b0;
      end else begin
         if (CNT >= 999) begin
            CNT = 0;
            if (SEC >= 59) begin
               SEC = 0;
               if (MIN >= 59)
                  MIN = 0;
               else 
                  MIN = MIN + 1;
            end else 
               SEC = SEC + 1;
			
			end else 
            CNT = CNT + 1;
				
			
			if (KEY != 6'b000000) begin
				if (CNT2 >= 200) begin
					CNT2 = 0;
					case (KEY)
						6'b100000: begin
							if(mod == 1'b0) MIN = (MIN < 59) ? MIN + 1 : 0;
							else aMIN <= (aMIN < 59) ? aMIN + 1 : 0;	// MIN INC 1
						end
						6'b010000: begin
							if(mod == 1'b0) SEC = (SEC < 59) ? SEC + 1 : 0;
							else aSEC <= (aSEC < 59) ? aSEC + 1 : 0;//	SEC INC 5
						end
						6'b001000: begin
							if(mod == 1'b0) MIN = (MIN > 0) ? MIN - 1 : 59;
							else aMIN <= (aMIN > 0) ? aMIN - 1 : 59;// MIN DEC 2
						end
						6'b000100: begin
							if(mod == 1'b0)SEC = (SEC > 0) ? SEC - 1 : 59;
							else aSEC <= (aSEC > 0) ? aSEC - 1 : 59;// SEC DEC 6
						end
						6'b000010: mod = ~mod;	// mode change
						6'b000001: isalram = ~isalram;	// alram on/off
					endcase
				end else CNT2 = CNT2 + 1;
			end else CNT2 = 200;
      end
   end

   // CNT_SCAN => 7-segment display
   always @(posedge clk) begin
      if (!reset) begin
         SEG_DOT = 1'b0;
         SEG_COM = 4'b0000;
         NUM = 0;
         CNT_SCAN = 0;
			
      end else begin
         if (CNT_SCAN >= 3)
            CNT_SCAN = 0;
         else
            CNT_SCAN = CNT_SCAN + 1;
           
			case (CNT_SCAN)
				0: begin
					NUM = M10;
					SEG_DOT = 1'b0;
					SEG_COM = 4'b0111;
				end
				1: begin
					NUM = M1;
					SEG_DOT = 1'b1;
					SEG_COM = 4'b1011;
				end
				2: begin
					NUM = S10;
					SEG_DOT = 1'b0;
					SEG_COM = 4'b1101;
				end
				3: begin
					NUM = S1;
					SEG_DOT = 1'b1;
					SEG_COM = 4'b1110;
				end
				default: begin
					NUM = 0;
					SEG_DOT = 1'b0;
					SEG_COM = 4'b1111;
				end
			endcase
      end
   end

   HB_WT_SEP M_SEP(MIN, aMIN, mod, M10, M1);
   HB_WT_SEP S_SEP(SEC, aSEC, mod, S10, S1);
	
   HB_WT_DECODER S_DECODE(NUM, SEG_DOT, SEG_DATA);
	ALRAM_SET(clk, reset, isalram, MIN, SEC, aMIN, aSEC, LED, alram_sound, LEDalram);
	ALRAM_SOUND(clk, clk_1MHZ, reset, alram_sound, piezo);


endmodule
