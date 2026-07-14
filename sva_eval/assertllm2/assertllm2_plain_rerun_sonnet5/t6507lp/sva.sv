`include "timescale.v"

// method: plain_prompt

// Global checker bound to top module: t6507lp
module t6507lp_sva_global (
    input logic [7:0] t6507lp_alu_alu_a,
    input logic t6507lp_alu_alu_enable,
    input logic [7:0] t6507lp_alu_alu_opcode,
    input logic [7:0] t6507lp_alu_alu_result,
    input logic [7:0] t6507lp_alu_alu_status,
    input logic [7:0] t6507lp_alu_alu_x,
    input logic [7:0] t6507lp_alu_alu_y,
    input logic t6507lp_alu_clk,
    input logic t6507lp_alu_reset_n,
    input logic t6507lp_fsm_address,
    input logic t6507lp_fsm_alu_a,
    input logic t6507lp_fsm_alu_opcode,
    input logic t6507lp_fsm_alu_result,
    input logic t6507lp_fsm_alu_status,
    input logic t6507lp_fsm_alu_x,
    input logic t6507lp_fsm_alu_y,
    input logic t6507lp_fsm_clk,
    input logic t6507lp_fsm_data_in,
    input logic t6507lp_fsm_data_out,
    input logic t6507lp_fsm_reset_n,
    input logic top_address,
    input logic top_clk,
    input logic top_data_in,
    input logic top_data_out,
    input logic top_reset_n,
    input logic top_rw_mem
);

//======================================================================
// Assertions for Signal: top_rw_mem
// Primary label from model: top_rw_mem
//======================================================================
// rw_mem must be a legal binary value with no unknown state
always_comb begin
  assert (!$isunknown(top_rw_mem));
end


//======================================================================
// Assertions for Signal: top_address
// Primary label from model: top_address
//======================================================================
// Address bus driven by FSM must never be unknown
always_comb begin
  assert (!$isunknown(top_address));
end

// Top-level address must match the FSM-generated address (direct wiring)
always_comb begin
  assert (top_address == t6507lp_fsm_address);
end


//======================================================================
// Assertions for Signal: top_data_out
// Primary label from model: top_data_out
//======================================================================
// Write data must be defined (no unknown) whenever a write is being performed
always_comb begin
  assert (top_rw_mem -> !$isunknown(top_data_out));
end

// Top-level write data must match the FSM-generated write data (direct wiring)
always_comb begin
  assert (top_data_out == t6507lp_fsm_data_out);
end


//======================================================================
// Assertions for Signal: top_data_in
// Primary label from model: top_data_in
//======================================================================
// Top-level read data must be passed through unchanged to the FSM control path
always_comb begin
  assert (top_data_in == t6507lp_fsm_data_in);
end


//======================================================================
// Assertions for Signal: top_clk
// Primary label from model: top_clk
//======================================================================
// The single clock domain must be distributed identically to FSM and ALU submodules
always_comb begin
  assert (top_clk == t6507lp_fsm_clk);
end

always_comb begin
  assert (top_clk == t6507lp_alu_clk);
end


//======================================================================
// Assertions for Signal: top_reset_n
// Primary label from model: top_reset_n
//======================================================================
// Active-low reset must be distributed identically to FSM and ALU submodules
always_comb begin
  assert (top_reset_n == t6507lp_fsm_reset_n);
end

always_comb begin
  assert (top_reset_n == t6507lp_alu_reset_n);
end


//======================================================================
// Assertions for Signal: t6507lp_alu_alu_status
// Primary label from model: t6507lp_alu_alu_status
//======================================================================
// Status register bit 5 must always be held high per ALU status handling
always_comb begin
  assert (t6507lp_alu_alu_status[5] == 1'b1);
end

// ALU status result must not be unknown when ALU operation is enabled
always_comb begin
  assert (t6507lp_alu_alu_enable -> !$isunknown(t6507lp_alu_alu_status));
end

// ALU status output must be correctly fed back into the FSM control path
always_comb begin
  assert (t6507lp_alu_alu_status == t6507lp_fsm_alu_status);
end


//======================================================================
// Assertions for Signal: t6507lp_alu_alu_result
// Primary label from model: t6507lp_alu_alu_result
//======================================================================
// ALU result must not be unknown when ALU operation is enabled
always_comb begin
  assert (t6507lp_alu_alu_enable -> !$isunknown(t6507lp_alu_alu_result));
end

// ALU result must be correctly fed back into the FSM control path
always_comb begin
  assert (t6507lp_alu_alu_result == t6507lp_fsm_alu_result);
end


//======================================================================
// Assertions for Signal: t6507lp_alu_alu_x
// Primary label from model: t6507lp_alu_alu_x
//======================================================================
// ALU X-register output must be correctly fed back into the FSM control path
always_comb begin
  assert (t6507lp_alu_alu_x == t6507lp_fsm_alu_x);
end

// X-register value must not be unknown
always_comb begin
  assert (!$isunknown(t6507lp_alu_alu_x));
end


//======================================================================
// Assertions for Signal: t6507lp_alu_alu_y
// Primary label from model: t6507lp_alu_alu_y
//======================================================================
// ALU Y-register output must be correctly fed back into the FSM control path
always_comb begin
  assert (t6507lp_alu_alu_y == t6507lp_fsm_alu_y);
end

// Y-register value must not be unknown
always_comb begin
  assert (!$isunknown(t6507lp_alu_alu_y));
end


//======================================================================
// Assertions for Signal: t6507lp_fsm_alu_opcode
// Primary label from model: t6507lp_fsm_alu_opcode
//======================================================================
// FSM-generated ALU opcode must be correctly wired into the ALU operation-code input
always_comb begin
  assert (t6507lp_fsm_alu_opcode == t6507lp_alu_alu_opcode);
end


//======================================================================
// Assertions for Signal: t6507lp_fsm_alu_a
// Primary label from model: t6507lp_fsm_alu_a
//======================================================================
// FSM-generated ALU operand must be correctly wired into the ALU operand input
always_comb begin
  assert (t6507lp_fsm_alu_a == t6507lp_alu_alu_a);
end


//======================================================================
// Assertions for Signal: t6507lp_alu_alu_enable
// Primary label from model: t6507lp_alu_alu_enable
//======================================================================
// ALU enable control must not be unknown
always_comb begin
  assert (!$isunknown(t6507lp_alu_alu_enable));
end
endmodule

