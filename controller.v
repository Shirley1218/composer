`timescale 1ns/1ns
/**************************************************************/
/*                                                            */
/*                                                            */
/*                                                            */
/**************************************************************/


module controller(clk,reset,restart,start,make_my_own,end_insert,is_full,play,play_again,TBD);
	//inputs
	input clk,reset,restart,start,make_my_own;
	input end_insert,is_full,play,play_again;
	//outputs
	output reg memu_vga,list_vga,note_vga,menu_sound,note,sound,list_sound,song_list_vga;
	output reg insert_module,deleteEnable,InsertEnable,playEnable,play_delaycounter,end_vga_display;

	//description: This module takes input from users and output enable signals to the data-path module
	
	reg [3:0]current_state,next_state = 0;
		localparam  MENU 					= 4'b0000,
						START					= 4'b0001,
						SELECT_MODE			= 4'b0010,	
						SELECT_SONG			= 4'b0011,
						INSERT_OR_DELETE	= 4'b0100,
						DELETE				= 4'b0101,
						INSERT_NEXT			= 4'b0110,
						MAKE_SONG			= 4'b0111,
						PLAY_ALL_NOTE		= 4'b1000,
						PLAY_WAIT			= 4'b1001;
						
						
						
	always@(*)
	begin: state_table
		case(current_state)
			MENU 			     : next_state = start ? START : MENU;
			
			START				  : next_state = SELECT_MODE;
			
			SELECT_MODE	  	  : next_state = make_my_own ? INSERT_OR_DELETE : SELECT_SONG;

			SELECT_SONG		  : next_state = play ? PLAY_ALL_NOTE : SELECT_SONG;

			INSERT_OR_DELETE : begin
										if(delete)
											next_state = DELETE;
										else if(insert)
											next_state = INSERT_NEXT;
										else if(end_insert || is_full)
											next_state = MAKE_SONG;
										else next_state = INSERT_OR_DELETE;

			DELETE           : next_state = INSERT_OR_DELETE;
			
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
	memu_vga,list_vga,note_vga,menu_sound,note,sound,list_sound,song_list_vga,insert_module,deleteEnable,InsertEnable,playEnable,play_delaycounter,end_vga_display;
		case(current_state)
			MENU: begin
					menu_vga <=1;
					menu_sound <= 1;
					end
					
			START: begin
					list_vga <= 1;
					list_sound <= 1;
					end
					
			SELECT_MODE: 
					begin 
				//do nothing
					end
					
			SELECT_SONG: 
					begin
					song_list_vga <= 1;
					//select = 1 		
					end
					 
			INSERT_OR_DELETE: 
					begin
						insert_module <= 1; 		
					end
					 
			DELETE: 
					begin
						deleteEnable <= 1;
					end
						
			INSERT_NEXT: 
					begin
						InsertENable <= 1; //counter + n ;counter output : is_full
						note_vga <= 1;
						note_sound <= 1;
					end

			MAKE_SONG: 
					begin
					//do nothing
					
					end
			PLAY_ALL_NODE:
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
	
	
	