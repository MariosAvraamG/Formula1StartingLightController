module lfsr14(
	input logic clk,
	input logic en,
	output logic [13:0] prbs
);

	logic [13:0] lfsr_value = 1;

	always_ff @(posedge clk)
		if (en) begin
			lfsr_value <= {lfsr_value[12:0], lfsr_value[13]^lfsr_value[4]};
		end
		
	assign prbs = lfsr_value%15751 + 250;
endmodule