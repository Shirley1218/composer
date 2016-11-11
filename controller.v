`timescale 1ns/1ns
/**************************************************************/
/*  description: This module takes input from users and       */
/* output enable signals to the data-path module              */
/*                                                            */
/*                                                            */
/*  Last update: Nov 10   Simulation passed                   */
/**************************************************************/


module controller(clk,reset,restart,start,make_my_own,play_saved,score_drawn,insert,delete,end_insert,is_full,insert_delay_done,play,play_done,play_again,
						menu_enable,list_enable,note_enable,song_list_enable,draw_score,deleteEnable,InsertEnable,playEnable,end_vga_display);
	//inputs
	input clk,reset,restart,start,make_my_own,play_saved,score_drawn,insert,delete;
	input end_insert,is_full,insert_delay_done,play,play_done,play_again;
	//outputs
	output reg menu_enable,list_enable,note_enable,song_list_enable,draw_score,deleteEnable,InsertEnable,playEnable,end_vga_display; 
	
	
	reg [3:0]current_state,next_state = 0;
		localparam  MENU 					= 4'b0000,
						START					= 4'b0001,
						SELECT_MODE			= 4'b0010,	
						SELECT_SONG			= 4'b0011,
						DRAW_BLANK_SCORE  = 4'b0100,
						INSERT_OR_DELETE	= 4'b0101,
						DELETE				= 4'b0110,
						INSERT_NEXT			= 4'b0111,
						MAKE_SONG			= 4'b1000,
						PLAY_ALL_NOTE		= 4'b1001,
						PLAY_WAIT			= 4'b1010;
						
						
						
	always@(*)
	begin: state_table
		case(current_state)
			MENU 			     : next_state = start ? START : MENU;
			
			START				  : next_state = SELECT_MODE;
			
			SELECT_MODE	  	  : begin 
										if(make_my_own)
											next_state = DRAW_BLANK_SCORE;
										else if(play_saved)	
											next_state = SELECT_SONG;
										else next_state = SELECT_MODE;
									end	
			SELECT_SONG		  : next_state = play ? PLAY_ALL_NOTE : SELECT_SONG;

			DRAW_BLANK_SCORE : next_state = score_drawn? INSERT_OR_DELETE : DRAW_BLANK_SCORE;
			
			INSERT_OR_DELETE : begin
										if(delete)
											next_state = DELETE;
										else if(end_insert || is_full)
											next_state = MAKE_SONG;										
										else if(insert)
											next_state = INSERT_NEXT;
										else next_state = INSERT_OR_DELETE;
									end

			DELETE           : next_state = delete ? DELETE : INSERT_OR_DELETE;
			
			INSERT_NEXT      : begin
										if(insert_delay_done)
											next_state = INSERT_OR_DELETE;
										else 
											next_state = INSERT_NEXT;
								   end

			MAKE_SONG		  : next_state = play ? PLAY_ALL_NOTE : MAKE_SONG;

			PLAY_ALL_NOTE	  : next_state = play_done ? PLAY_WAIT : PLAY_ALL_NOTE;

			PLAY_WAIT		  : begin
										if(play_again)
											next_state = PLAY_ALL_NOTE;
										else if(restart)
											next_state = START;
										else
											next_state = PLAY_WAIT;				
										end

			default: next_state = MENU;
		endcase
	end
	
	always@(posedge clk)
	begin:state_FFs
		if(reset)
			current_state <= MENU;
		else if(restart)
			current_state <= START;
		else
			current_state <= next_state;
	end
	
	always@(posedge clk)
	begin: enable_signals
	
	//default signals
	menu_enable = 0;  list_enable = 0; note_enable = 0;//sound = 0;list_sound = 0;
	song_list_enable = 0; draw_score = 0; deleteEnable = 0; InsertEnable = 0; playEnable = 0;
	end_vga_display = 0;
		case(current_state)
			MENU: begin
					menu_enable <=1;
					end
					
			START: begin
					list_enable <= 1;
					end
					
			SELECT_MODE: 
					begin 
				//do nothing
					end
					
			SELECT_SONG: 
					begin
					song_list_enable <= 1;
					//select = 1 		
					end
			
			DRAW_BLANK_SCORE:
					begin
						draw_score <= 1; 		
					end
			
			INSERT_OR_DELETE: 
					begin
						//insert_module <= 1; 		
					end
					 
			DELETE: 
					begin
						deleteEnable <= 1;
					end
						
			INSERT_NEXT: 
					begin
						InsertEnable <= 1; //counter + n ;counter output : is_full
						note_enable <= 1;
					end

			MAKE_SONG: 
					begin
					//do nothing
					
					end
			PLAY_ALL_NOTE:
					begin 
						playEnable <= 1;
						//play_delaycounter <= 1;// counter output :play_done
					end
					
			PLAY_WAIT: 
					begin
						end_vga_display <= 1;
					end
		endcase
	end
	
endmodule

	
	
	