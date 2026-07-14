module DFF (
  input clk,
  input d,
  output q
);
  reg q_r;
  assign q = q_r;
  always @(posedge clk) begin
    q_r <= d;
  end
endmodule
