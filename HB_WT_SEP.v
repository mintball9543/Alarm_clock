//HB_WT_SEP.V

module HB_WT_SEP(
	NUMBER, aNUMBER, mod,
	SEP_A, SEP_B
);

input [5:0]NUMBER, aNUMBER;
input mod;

output [3:0]SEP_A, SEP_B;

reg [3:0]SEP_A, SEP_B;
reg [5:0]num;

always @(NUMBER or aNUMBER)
begin
	if(mod == 1'b0)
		num = NUMBER;
	else
		num = aNUMBER;

	if(num <= 9)
		begin
			SEP_A = 3'b000;
			SEP_B = num[3:0];
		end
	else if(num <= 19)
		begin
			SEP_A = 1;
			SEP_B = num - 10;
		end
	else if(num <= 29)
		begin
			SEP_A = 2;
			SEP_B = num - 20;
			end
	else if(num <= 39)
		begin
			SEP_A = 3;
			SEP_B = num -30;
			end
	else if(num <= 49)
		begin
			SEP_A = 4;
			SEP_B = num-40;
		end
	else if(num <= 59)
		begin
			SEP_A = 5;
			SEP_B = num - 50;
			end
	/*else if(num <= 69)
		begin
			SEP_A = 6;
			SEP_B = num -60;
			end
	else if(num <= 79)
		begin
			SEP_A = 7;
			SEP_B = num-70;
		end
	else if(num <= 89)
		begin
			SEP_A = 8;
			SEP_B = num - 80;
			end
	else if(num <= 99)
		begin
			SEP_A = 9;
			SEP_B = num -90;
			end
	else
		begin
			SEP_A = 0;
			SEP_B = 0;
		end*/
end

endmodule
