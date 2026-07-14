module dffr (input clk, input areset, input d, output reg q);
  always @(posedge clk, posedge areset) begin
    if (areset) q <= 1'b0;
    else q <= d;
  end
endmodule
