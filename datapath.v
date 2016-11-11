/**************************************************************/
/*  This module receives enable signals from control module   */
/* and..                                                      */
/*                                                            */
/*                                                            */
/*  Last edit: Nov 10    set bmp : whole note 2s; 4 bars 8 s  */
/*                        delay counters simulation passed    */
/**************************************************************/




module datapath(input CLOCK_50,menu_enable,list_enable,note_enable,song_list_enable,
								draw_score,deleteEnable,InsertEnable,playEnable,end_vga_display,
					output score_drawn, is_full, insert_delay_done, play_done, //back to controller
								sound_out);

	/////////clock dividers	/////////////////////						
	clock_5MHz CLK5(CLOCK_50,clk_5M);	
	clock_16Hz CLK16(clk_5M,clk_16);
	wire [2:0]insert_delay_out;
	wire [6:0]play_delay_out;

	
	////////vga modules	////////////////////////
	menu M1();  				//VGA display module  -- draw menu
	modeSelect M2(); 			//VGA display module  -- draw menu list
	song S1();				   //play recorded songs // songList module included 
	blank_score BLANK();    //VGA display module  -- draw blank score
	endMode();              //VGA display module  -- draw ending
	drawnote D1();          //VGA display module  -- draw single note
	
	
	////////translate keyboard input into ascii/////////
	wire [7:0]keyboard_input;
	assign keyboard_input = ps2_received,
	
	
	//////keyboard translater ///////////////
	PS2_Controller KEYBOARD1(.CLOCK_50(clock),
									 .reset(resetn),
									 .the_command(),
									 .send_command(),
									 .PS2_CLK(ps2_clock),
									 .PS2_DAT(ps2_in),
									 .command_was_sent(),
									 .error_communication_timed_out(),
									 .received_data(ps2_received),                //received keyboard input ascii
									 .received_data_en(received_signal));
					
					
					
	////////////play 1 note & record/////////////				
	piano P1(.clock(CLOCK_50),
				.clk_5MHz(clk_5MHz),
				.resetn(resetn),
				.record(InsertEnable),				//record or erase note one by one
				.erase(deleteEnable),
				.play(InsertEnable)
				//.ps2_clock(ps2_clock),
				.ps2_in(keyboard_input),
				.hsync(VGA_HS),
				.vsync(VGA_VS),
				.vga_r(VGA_R),
				.vga_g(VGA_G),
				.vga_b(VGA_B),
				.sound(sound_out)
				);
				
				
	///////////////play all notes///////////////
	piano P1(.clock(CLOCK_50),
				.clk_5MHz(clk_5MHz),
				.resetn(resetn),
				.record(1'b0),					//make no change
				.erase(1'b0),
				.play(playEnable),
				//.ps2_clock(ps2_clock),
				.ps2_in(keyboard_input),
				.hsync(VGA_HS),
				.vsync(VGA_VS),
				.vga_r(VGA_R),
				.vga_g(VGA_G),
				.vga_b(VGA_B),
				.sound(sound_out)
				);
					
					
					
	///////when user enters a note, wait until note is drawn or its sound is played/////// tested
	
		
	defparam InsertDelay.n = 3;   //  0.5 second -> 2Hz
	updownCounter InsertDelay(clk_16,reset,InsertEnable,1'b1,insert_delay_out);
	assign insert_delay_done = (insert_delay_out == 3'b110) ? 1'b1 : 1'b0;
	
	
	///////when user decides to play all notes, wait until all nodes are played/////// tested
		
	defparam PlayDelay.n = 7; ///   4 bar -> 8 second
	updownCounter PlayDelay(clk_16,reset,playEnable,1'b1,play_delay_out);
	assign play_done = (play_delay_out == 7'b1111110) ? 1'b1 : 1'b0;

endmodule

module updownCounter(clock,reset,enable,up_down,Q);
	parameter n = 8;
	input clock,reset,enable,up_down;
	output reg [n-1:0]Q = 0;

	always@(posedge clock)
	begin
		if(reset)
			Q <= 0;
		else if(enable)
			Q <= Q + (up_down ? 1 : -1);
		
	end
		
endmodule

