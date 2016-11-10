/**************************************************************/
/*                                                            */
/*                                                            */
/*                                                            */
/**************************************************************/




module datapath(input memu_vga,list_vga,note_vga,menu_sound,note,sound,list_sound,
					song_list_vga,insert_module,InsertEnable,deleteEnable,counterEnable,
					playEnable,play_delaycounter,end_vga_display,output sound_out);

					
					
	menu M1();  //VGA display module
	modeSelect M2(); //VGA display module
	song S1(); //play recorded songs // songList module included 
	insertMode(); //VGA display module
	endMode(); //VGA display module
	

	VGA DRAWNOTE();
	
	///translate keyboard input into ascii///////
	wire [7:0]keyboard_input;
	assign keyboard_input = ps2_received,
	
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
					
					
					
	////play 1 note & record//////				
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
				
				
	////play all notes/////
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
					
					
					
		///////when user enters a note, wait until note is drawn or its sound is played///////
		
	defparam InsertDelay.n = ///???
	updownCounter InsertDelay(clock,reset,InsertEnable,1'b1,insert_delay_out);
	assign insert_delay_done = (insert_delay_out == ???) ? 1'b1 : 1'b0;
		///////when user decides to play all notes, wait until all nodes are played///////
		
	defparam PlayDelay.n = ///???
	updownCounter PlayDelay(clock,reset,PlayEnable,1'b1,Play_delay_out);
	assign play_done = (play_delay_out == ???) ? 1'b1 : 1'b0;

endmodule



module updownCounter(clock,reset,enable,up_down,Q);
	parameter n = 8;
	input clock,reset,enable,up_down;
	output reg [n-1:0]Q;

	always@(posedge clock)
	begin
		if(reset)
			Q <= 0;
		else if(enable)
			Q <= Q + (up_down ? 1 : -1);
	end
		
endmodule
