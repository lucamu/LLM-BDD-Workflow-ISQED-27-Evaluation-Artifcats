`include "versatile_counter_defines.v"

// method: plain_prompt

// Global checker bound to top module: vcnt
module vcnt_sva_global (
    input logic top_cke,
    input logic top_clear,
    input logic top_clk,
    input logic [`CNT_LENGTH:1] top_q,
    input logic [`CNT_LENGTH:1] top_q_bin,
    input logic top_rew,
    input logic top_rst,
    input logic top_set
);

//======================================================================
// Assertions for Signal: top_clear
// Primary label from model: top_clear
//======================================================================
// Active-high synchronous clear control input must be a legal, known logic value
always_comb begin
  assert (!$isunknown(top_clear));
end

// clear is defined as active-high; its asserted value must be logic 1
always_comb begin
  assert (top_clear === 1'b0 || top_clear === 1'b1);
end


//======================================================================
// Assertions for Signal: top_set
// Primary label from model: top_set
//======================================================================
// set is an active-high control input and must always resolve to a known logic value
always_comb begin
  assert (!$isunknown(top_set));
end

// set is active-high per interface definition; only 0/1 are legal values
always_comb begin
  assert (top_set === 1'b0 || top_set === 1'b1);
end


//======================================================================
// Assertions for Signal: top_rew
// Primary label from model: top_rew
//======================================================================
// rew (direction/rewind control) must be a known, legal active-high signal
always_comb begin
  assert (!$isunknown(top_rew));
end

// rew is active-high per interface definition; only 0/1 are legal values
always_comb begin
  assert (top_rew === 1'b0 || top_rew === 1'b1);
end


//======================================================================
// Assertions for Signal: top_cke
// Primary label from model: top_cke
//======================================================================
// Clock-enable qualifier must always be a known, legal logic value
always_comb begin
  assert (!$isunknown(top_cke));
end

// cke is active-high per interface definition; only 0/1 are legal values
always_comb begin
  assert (top_cke === 1'b0 || top_cke === 1'b1);
end


//======================================================================
// Assertions for Signal: top_rst
// Primary label from model: top_rst
//======================================================================
// Reset control input must always be a known, legal logic value
always_comb begin
  assert (!$isunknown(top_rst));
end

// rst is active-high per interface definition; only 0/1 are legal values
always_comb begin
  assert (top_rst === 1'b0 || top_rst === 1'b1);
end


//======================================================================
// Assertions for Signal: top_q
// Primary label from model: top_q
//======================================================================
// Counter output q must always resolve to a known, legal logic value
always_comb begin
  assert (!$isunknown(top_q));
end

// q is a single-bit legal logic value (0 or 1) per interface width
always_comb begin
  assert (top_q === 1'b0 || top_q === 1'b1);
end


//======================================================================
// Assertions for Signal: top_q_bin
// Primary label from model: top_q_bin
//======================================================================
// Binary state visibility output q_bin must always resolve to a known, legal logic value
always_comb begin
  assert (!$isunknown(top_q_bin));
end

// q_bin is a single-bit legal logic value (0 or 1) per interface width
always_comb begin
  assert (top_q_bin === 1'b0 || top_q_bin === 1'b1);
end
endmodule

