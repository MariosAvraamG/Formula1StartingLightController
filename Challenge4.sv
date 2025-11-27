module Challenge4(
	output logic [6:0] HEX0, HEX1, HEX2, HEX4,
	output logic [7:0] HEX3,
	input logic MAX10_CLK1_50,
	input logic [1:0] KEY,
	output logic [9:0] LEDR
);
	assign HEX3[7]=0;
	logic tick_ms, tick_halfs, en_lfsr, start_delay, time_out;
	logic [5:0] lfsr_out, lsfr_delay;
	logic [3:0] BCD0, BCD1, BCD2, BCD3;
	
	clktick  GEN_1K (.clk(MAX10_CLK1_50), .rst(1'b0), .en(1'b1), .N(16'd49999),  .tick(tick_ms));
	clktick  GEN_2 (.clk(MAX10_CLK1_50), .rst(1'b0), .en(tick_ms), .N(16'd499),  .tick(tick_halfs));
	
	f1fsm FSM(.sysclk(tick_ms), .tick(tick_halfs), .trigger(~KEY[1]),  .time_out(time_out), .ledr(LEDR[9:0]), .start_delay(start_delay), .en_lfsr(en_lfsr));
	
	delay Delay(.clk(tick_halfs), .rst(0), .N(5), .trigger(start_delay), .time_out(time_out));
	//lfsr LFSR(.clk(tick_ms), .en(en_lfsr), .prbs(lfsr_out));
	
assign lsfr_delay = (lfsr_out >> 2);
	
	bin2bcd_16 hextobcd(.x({10'd0, lsfr_delay}), .BCD0(BCD0), .BCD1(BCD1), .BCD2(BCD2), .BCD3(BCD3),  .BCD4(BCD4));

	hexto7seg SEG0(.in(BCD0), .out(HEX0));
	hexto7seg SEG1(.in(BCD1), .out(HEX1));
	hexto7seg SEG2(.in(BCD2), .out(HEX2));
	hexto7seg SEG3(.in(BCD3), .out(HEX3));
	hexto7seg SEG4(.in(BCD4), .out(HEX4));
	
endmodule