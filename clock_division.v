/**************************************************************/
/* This file consists of several clock divider modules that   */
/* generate desired frequencies                               */
/*                                                            */
/* Last edit: added 2Hz clock division                        */
/*                                                            */
/**************************************************************/


`timescale 1ns/1ns


//50MHz to 5 MHz
module clock_5MHz(CLOCK_50,clock_5MHz);
	input CLOCK_50;
	output clock_5MHz;
	reg clock_5MHz = 0;
	reg [2:0]count = 0;
	
	always@(posedge CLOCK_50)
	begin
		if(count < 3'd5 - 1)
			count <= count + 1;
		else 
			begin
					count <= 3'd0;
					clock_5MHz = ~clock_5MHz;
			end
	end
endmodule

//5MHz to 16 Hz
module clock_16Hz(clock_5MHz,clock_16Hz);   //1/16 second
	input clock_5MHz;
	output reg clock_16Hz = 0;
	reg [21:0]count = 0;
	always@(posedge clock_5MHz)
	begin
		if(count < 22'd156250 - 1)
			count <= count + 1;
		else 
			begin
				count <= 22'd0;
				clock_16Hz = ~clock_16Hz;
			end
	end
endmodule

module clock_2Hz(clock_5MHz,clock_2Hz);   //1/2 second
	input clock_5MHz;
	output reg clock_2Hz = 0;
	reg [21:0]count = 0;
	always@(posedge clock_5MHz)
	begin
		if(count < 22'd1250000 - 1)
			count <= count + 1;
		else 
			begin
				count <= 22'd0;
				clock_2Hz = ~clock_2Hz;
			end
	end
endmodule



