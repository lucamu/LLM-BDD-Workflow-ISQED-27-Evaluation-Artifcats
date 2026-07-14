`include "PID_defines.v"

// method: plain_prompt

// Global checker bound to top module: PID
module PID_sva_global (
    input logic adder_32bit_i_c,
    input logic adder_32bit_o_c,
    input logic multiplier_16x16bit_pipelined_i_clk,
    input logic multiplier_16x16bit_pipelined_i_rst,
    input logic multiplier_16x16bit_pipelined_i_start,
    input logic multiplier_16x16bit_pipelined_o_ready,
    input logic top_i_clk,
    input logic top_i_rst,
    input logic top_i_wb_cyc,
    input logic top_i_wb_stb,
    input logic top_i_wb_we,
    input logic top_o_valid,
    input logic top_o_wb_ack
);

//======================================================================
// Assertions for Signal: top_i_wb_stb
// Primary label from model: top_i_wb_stb
//======================================================================
// Wishbone strobe must only be asserted within an active cycle
always_comb begin
  assert (!top_i_wb_stb || top_i_wb_cyc);
end


//======================================================================
// Assertions for Signal: top_o_wb_ack
// Primary label from model: top_o_wb_ack
//======================================================================
// Acknowledge must only be issued in response to an active cycle+strobe request
always_comb begin
  assert (!top_o_wb_ack || (top_i_wb_cyc && top_i_wb_stb));
end


//======================================================================
// Assertions for Signal: multiplier_16x16bit_pipelined_i_rst
// Primary label from model: multiplier_16x16bit_pipelined_i_rst
//======================================================================
// Top-level drives the multiplier reset as the inverse of the top-level reset (active-low submodule reset)
always_comb begin
  assert (multiplier_16x16bit_pipelined_i_rst == ~top_i_rst);
end
endmodule

