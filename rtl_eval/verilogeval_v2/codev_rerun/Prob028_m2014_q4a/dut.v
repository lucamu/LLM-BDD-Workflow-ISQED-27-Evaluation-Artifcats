module Dlatch(d, ena, q);
  input d, ena;
  output q;
  reg q;
  always @ (ena or d) begin
    if (ena)
      q = d;
  end
endmodule
