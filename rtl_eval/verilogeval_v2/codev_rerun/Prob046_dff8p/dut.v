module DFF (input clk, input reset, input d, output reg q);
  always @(negedge clk) begin
    if (reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule
