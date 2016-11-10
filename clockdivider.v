module clock_5MHz(input CLOCK_50,output reg clk_5MHz);

	reg [2:0]count;
	always@(posedge CLOCK_50)
	begin
		if(count < 3'd5)
			count <= count + 1;
		else 
			begin
				count <= 3'd0;
				clk_5MHz = ~clk_5MHz;
			end
	end
endmodule


module clock_16Hz(input clk_5MHz,output reg clk_16Hz);

	reg [21:0]count;
	always@(posedge CLOCK_50)
	begin
		if(count < 22'd156250)
			count <= count + 1;
		else 
			begin
				count <= 22'd0;
				clk_16Hz = ~clk_16Hz;
			end
	end
endmodule

