module f1fsm (
	input logic sysclk,
	input logic tick,
	input logic trigger,
	input logic time_out,
	input logic reaction,
	output logic en_lfsr,
	output logic start_delay,
	output logic [9:0] ledr,
	output logic rst_counter,
	output logic en_counter,
	output logic choose_display
);

	
	logic [9:0] count;
	logic [9:0] delay;
	
	typedef enum{IDLE, COUNT, DELAY, REACTION_MEASURE} my_state;
	my_state current_state, next_state;

	always_ff @(posedge sysclk)
		current_state <= next_state;
		
	
	always_comb begin
        

        case (current_state)
            IDLE:
					if (trigger)
                    next_state = COUNT;
					else next_state = current_state;

            COUNT:
                if (count > 9)
                    next_state = DELAY;
					 else next_state = current_state;

            DELAY:
                if (time_out)
                    next_state = REACTION_MEASURE;
					 else next_state = current_state;
				
				REACTION_MEASURE:
					if (reaction)
						next_state = IDLE;
					else next_state = current_state;
						  
				default: next_state = IDLE;
						  
        endcase
		  
		end
		
		
		always_ff @(posedge sysclk) begin
			if((current_state == COUNT) && tick) begin
				ledr[9-count] <= 1;
				count <= count +1;
				
			end 
			
			if(current_state == IDLE) begin
				en_counter <= 0;
				choose_display <= 1;
				start_delay <= 0;
				en_lfsr <= 1;
			end 
			
			if(current_state == DELAY) begin
				if (count==10) begin
					start_delay <= 1;
					count <= 0;
					en_lfsr <= 0;
					choose_display <= 0;
					rst_counter <= 1;
				end
				else start_delay <= 0;
			end
			
			if(current_state == REACTION_MEASURE) begin
				rst_counter <= 0;
				en_counter <= 1;
				ledr <= 0;
			end
		
		end



endmodule


	
	
