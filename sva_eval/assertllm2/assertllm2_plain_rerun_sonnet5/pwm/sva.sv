// method: plain_prompt

// Global checker bound to top module: PWM
module PWM_sva_global (
    input logic down_clocking_even_i_clk,
    input logic down_clocking_even_i_rst,
    input logic down_clocking_even_o_clk,
    input logic down_clocking_odd_i_clk,
    input logic down_clocking_odd_i_rst,
    input logic down_clocking_odd_o_clk,
    input logic top_i_extclk,
    input logic top_i_valid_DC,
    input logic top_i_wb_clk,
    input logic top_i_wb_cyc,
    input logic top_i_wb_rst,
    input logic top_i_wb_stb,
    input logic top_i_wb_we,
    input logic top_o_pwm,
    input logic top_o_wb_ack
);

//======================================================================
// Assertions for Signal: top_o_wb_ack
// Primary label from model: top_o_wb_ack
//======================================================================
always_comb begin
  // o_wb_ack is combinationally mirrored from i_wb_stb per spec (section 5.2)
  assert (top_o_wb_ack == top_i_wb_stb);
end


//======================================================================
// Assertions for Signal: down_clocking_even_i_clk
// Primary label from model: down_clocking_even_i_clk
//======================================================================
always_comb begin
  // Odd and even divider submodules share the same selected working-clock source
  // (clock selection occurs upstream via Ctrl[0]; both dividers receive the same input clock,
  // with Divisor[0] only selecting which divider's output is used)
  assert (down_clocking_even_i_clk == down_clocking_odd_i_clk);
end


//======================================================================
// Assertions for Signal: down_clocking_even_i_rst
// Primary label from model: down_clocking_even_i_rst
//======================================================================
always_comb begin
  // Divider submodules share the same active-low reset source
  assert (down_clocking_even_i_rst == down_clocking_odd_i_rst);
  // Submodule reset is active-low while i_wb_rst is active-high; the divider reset
  // is expected to be the inverted form of the global WISHBONE reset
  assert (down_clocking_even_i_rst == ~top_i_wb_rst);
end


//======================================================================
// Assertions for Signal: down_clocking_odd_i_rst
// Primary label from model: down_clocking_odd_i_rst
//======================================================================
always_comb begin
  // Odd-path divider reset is expected to be the inverted form of the global WISHBONE reset
  assert (down_clocking_odd_i_rst == ~top_i_wb_rst);
end
endmodule

