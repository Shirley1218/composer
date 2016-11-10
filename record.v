module record_and_replay(clk_5MHz,recordEnable,eraseEnable,outEnable,key_in,record_out);
	input clk_5MHz;
	input recordEnable,eraseEnable,outEnable;
	input [7:0]key_in;
	output reg [7:0]record_out;
	
	reg [25:0]count_16;
	wire clk_16Hz;
	reg [7:0]memory[127:0]; //memory block , how to use On chip memory SRAM or RAM?
	reg [6:0]count;
	
	clock_16Hz CLK1(clk_5MHz,clk_16Hz);
	
	
	
	///input or erase////////////
	always@(posedge clk_16Hz)
	begin
		if(recordEnable == 1'b1)
			begin
				count <= count + 1;
				memory[count] <= key_in;
			end
		else if(eraseEnable == 1'b1)
			begin
				count <= count - 1;
				memory[count-1] <= 0;
			end
		
	end
	
	/////output memory///////////
	reg [6:0]ct = 0;
	always@(posedge clk_16Hz)
	begin
		if(outEnable == 1'b1) 
			begin
				if(ct <= 128 || stop) 
				record_out <= memory[ct];
				ct <= ct + 1; 
			end
	end
	
	wire stop = (memory[ct] == 0) ? 1 : 0;  // what if memory[ct] wasn't initialized?
	
endmodule
