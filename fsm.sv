module f1fsm (
	input logic sysclk,
	input logic tick,
	input logic trigger,
	input logic time_out,
	output logic en_lfsr,
	output logic start_delay,
	output logic [9:0] ledr
);

	logic timeout;
	logic [9:0] count;
	logic [9:0] delay;


	typedef enum{IDLE, COUNT, DELAY} my_state;
	my_state current_state, next_state;

	always_ff @(posedge sysclk)
		current_state <= next_state;
		
		

	always_comb begin
        

        case (current_state)
            IDLE:
                if (trigger)
                    next_state = COUNT;

            COUNT:
                if (count == 9)
                    next_state = DELAY;

            DELAY:
                if (timeout)
                    next_state = IDLE;
        endcase
		  
		end





endmodule

	
	








