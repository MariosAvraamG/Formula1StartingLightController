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


	always_comb
case (current_state)

IDLE: begin

if(trigger)
next_state = COUNT;
else next_state = current_state;
end

DELAY: begin

if(timeout)
next_state = IDLE;
else next_state = current_state;
end

COUNT: begin
if(count == 10)
next_state = DELAY;
else next_state = current_state;

end

default:next_state =IDLE;


endcase





always_ff @(posedge sysclk) begin
    if (tick) begin
        

        if (current_state == COUNT) begin
            if (count < 10) begin
                count <= count + 1;
                ledr[count] <= 1;
            end else begin
                count   <= 0;
                timeout <= 1;
            end
        end
    end
end











endmodule