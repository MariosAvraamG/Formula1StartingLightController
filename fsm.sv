module f1fsm (
	input logic sysclk,
	input logic tick,
	input logic trigger,
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

always_comb
case (count)

1: ledr[0] = 1;
2: ledr[1] = 1;
3: ledr[2] = 1;
4: ledr[3] = 1;
5: ledr[4] = 1;
6: ledr[5] = 1;
7: ledr[6] = 1;
8: ledr[7] = 1;
9: ledr[8] = 1;
10:ledr[9] = 1;
default: ledr = 0;
endcase



always_ff @(posedge sysclk && tick) begin
if ((count < 10) && (current_state == COUNT))
count <= count + 1;
else count <= 0 ;
 timeout <=1 ;
end










endmodule