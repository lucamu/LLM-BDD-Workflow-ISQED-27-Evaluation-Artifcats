module DFF(
	input clk,
	input resetn,
	input D,
	output reg Q
);
	always @(posedge clk) begin
		if(~resetn)
			Q <= 0;
		else
			Q <= D;
	end
endmodule
