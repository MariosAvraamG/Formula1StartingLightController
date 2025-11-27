module f1fsm (
	input logic sysclk,
	input logic tick,
	input logic trigger,
	input logic time_out,
	output logic en_lfsr,
	output logic start_delay,
	output logic [9:0] ledr
);

	
	logic [9:0] count;
	logic [9:0] delay;
	logic started;


	typedef enum{IDLE, COUNT, DELAY} my_state;
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
                    next_state = IDLE;
					 else next_state = current_state;
						  
				default: next_state = IDLE;
						  
        endcase
		  
		end
		
		
		always_ff @(posedge sysclk) begin
			if(((current_state == COUNT) && (count < 10) && (tick))) begin
				ledr[9-count] <= 1;
				count <= count +1;
				
			end 
			
			if(current_state == IDLE) begin
				count <= 0;
				ledr <= 0;
				start_delay <= 0;
				started <= 0;
			end 
			
			if( (current_state == DELAY) && time_out == 0 && started == 0) begin
				start_delay <= 1;
				started <= 1;
				en_lfsr <= 1;
			end else if( (current_state == DELAY) && time_out == 0 && started == 1)
				start_delay <= 0;
				
		
		end



endmodule

	
	








