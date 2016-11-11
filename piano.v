/**************************************************************/
/*   This module takes keyboard ascii input, playbacks to     */
/*  users. It also records inputs one by one. Use playAll     */
/*  enbale to read notes from memory block and playback to    */
/*  user.                                                     */
/*                                                            */
/*  Last edit: remove VGA demo from this module               */
/*                                                            */
/**************************************************************/

module piano(clock,clk_5MHz,resetn,
					record,erase,play,ps2_received,playAll,
					//hsync,vsync,vga_r,vga_g,vga_b, 
					sound,out);
					
	input clock,clk_5MHz,resetn,record,erase,play,ps2_in,playAll;
	//output hsync,vsync,vga_r,vga_g,vga_b,
	output sound;
	output [7:0]out;
	
	
	wire no_match;
	wire sound_en;
	assign sound = sound_en;
	//wire [7:0]keyboard_input;
	//assign keyboard_input = ps2_received,
	
	
	
	record_and_replay R1( .clk_5MHz(clk_5MHz),
								 .recordEnable(record),      //write enable   one at a time
						 		 .eraseEnable(erase),        //erase one note at a time
							  	 .outEnable(playAll),				//read enable   read all
						 		 .key_in(ps2_received),      //keyboard input  ***make LUT later
								 .record_out(record_out));   //read memory
	
	
	assign out = playAll? record_out : ps2_received;
	
	
	always@(posedge clk_5MHz)
		begin 
			case(ps2_received)
				//display LUT
				//...
				
			default: ;
			endcase
		end
		
	assign no_match = (count == 00000); //LUT default value
	
	
	always@(posedge clk_5MHz)
		begin
			if(no_match)
				count = //LUT value;
			else count = count + 1;
		end
	
	//if input does not match, sound disabled
	always@(posedge no_match)
		begin 
			sound_en <= ~sound_en;
		end
		
		
endmodule

			
				