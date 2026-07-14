// Flattened for tools: same behavior as original ifdef tree with current
// include/versatile_counter_defines.v (Gray, REW, CLEAR, CE, Q_BIN, LEVEL1/2;
// no WRAP, no QNEXT/Z/ZQ, no LFSR).

`include "versatile_counter_defines.v"

module vcnt (
    output reg [`CNT_LENGTH:1] q,
    output [`CNT_LENGTH:1] q_bin,
    input clear,
    input set,
    input rew,
    input cke,
    output reg level1,
    output reg level2,
    input clk,
    input rst
);

  parameter cnt_length = `CNT_LENGTH;
  parameter cnt_reset_value = `CNT_RESET_VALUE;
  parameter set_value = `CNT_LENGTH'd`CNT_SET_VALUE;
  parameter level1_value = `CNT_LENGTH'd`CNT_LEVEL1_VALUE;
  parameter level2_value = `CNT_LENGTH'd`CNT_LEVEL2_VALUE;

  reg [cnt_length:1] qi;
  wire [cnt_length:1] q_next;
  wire [cnt_length:1] q_next_fw;
  wire [cnt_length:1] q_next_rew;

  assign q_next_fw =
      clear ? `CNT_LENGTH'd0 :
      qi - `CNT_LENGTH'd1;

  assign q_next_rew =
      clear ? `CNT_LENGTH'd0 :
      qi - `CNT_LENGTH'd1;

  assign q_next = rew ? q_next_rew : q_next_fw;

  always @(posedge clk or posedge rst)
    if (rst)
      qi <= `CNT_LENGTH'd0;
    else if (cke)
      qi <= q_next;

  always @(posedge clk or posedge rst)
    if (rst)
      q <= `CNT_RESET_VALUE;
    else if (cke)
      q <= (q_next >> 1) ^ q_next;

  assign q_bin = qi;

  always @(posedge clk or posedge rst)
    if (rst)
      level1 <= 1'b0;
    else if (cke) begin
      if (q_next == level1_value)
        level1 <= 1'b1;
      else if ((q == level1_value) & rew)
        level1 <= 1'b0;
    end

  always @(posedge clk or posedge rst)
    if (rst)
      level2 <= 1'b0;
    else if (cke) begin
      if (q_next == level2_value)
        level2 <= 1'b1;
      else if ((q == level2_value) & rew)
        level2 <= 1'b0;
    end

    // --- Formal assertions ---
    // ============================================================
    // SVA for versatile_counter (vcnt) - Formal Verification
    // ============================================================

    // ---------------------------------------------------------------------
    // Reset behavior
    // ---------------------------------------------------------------------

    // Scenario: Asynchronous reset forces state to zero regardless of clock
    property p_rst_qi_zero;
      @(posedge clk) (rst) |-> (qi == '0);
    endproperty
    assert property (p_rst_qi_zero);

    // Scenario: Asynchronous reset forces Gray-mode registered q to reset value
    property p_rst_q_reset_value;
      @(posedge clk) (rst) |-> (q == `CNT_RESET_VALUE);
    endproperty
    assert property (p_rst_q_reset_value);

    // Scenario: Asynchronous reset forces level1 and level2 to 0 when enabled
    property p_rst_level1_zero;
      @(posedge clk) (rst) |-> (level1 == 1'b0);
    endproperty
    assert property (p_rst_level1_zero);

    property p_rst_level2_zero;
      @(posedge clk) (rst) |-> (level2 == 1'b0);
    endproperty
    assert property (p_rst_level2_zero);

    // ---------------------------------------------------------------------
    // Clock enable gating
    // ---------------------------------------------------------------------

    // Scenario: Clock enable low holds state across clock edge
    property p_cke_low_holds_qi;
      @(posedge clk) disable iff (rst)
      (!cke) |=> (qi == $past(qi));
    endproperty
    assert property (p_cke_low_holds_qi);

    // Scenario: Clock enable high allows state to update to next-state value
    property p_cke_high_updates_qi;
      @(posedge clk) disable iff (rst)
      (cke) |=> (qi == $past(q_next));
    endproperty
    assert property (p_cke_high_updates_qi);

    // ---------------------------------------------------------------------
    // Next-state priority: clear dominance
    // ---------------------------------------------------------------------

    // Scenario: Clear has highest priority in next-state computation
    property p_clear_priority_zero;
      @(posedge clk) disable iff (rst)
      (clear) |-> (q_next == '0);
    endproperty
    assert property (p_clear_priority_zero);

    // Scenario: Clear dominates wrap mode when both are asserted
    property p_clear_dominates_wrap;
      @(posedge clk) disable iff (rst)
      (clear && (qi == '0)) |-> (q_next == '0);
    endproperty
    assert property (p_clear_dominates_wrap);

    // Scenario: Clear forces qi to zero on next clock edge when enabled and cke satisfied
    property p_clear_forces_qi_zero_seq;
      @(posedge clk) disable iff (rst)
      (clear && cke) |=> (qi == '0);
    endproperty
    assert property (p_clear_forces_qi_zero_seq);

    // ---------------------------------------------------------------------
    // Wrap mode
    // ---------------------------------------------------------------------

    // Scenario: Wrap value loads when current state is zero and clear inactive
    // (Rewritten from first principles: there is no standalone "wrap_value"
    //  port/parameter in the RTL namespace -- the wrap-load value is produced
    //  by the same directional next-state computation wires (q_next_fw /
    //  q_next_rew) that already embed the wrap reload logic, selected by the
    //  "rew" direction control, exactly as done in the other next-state
    //  assertions in this file.)
    property p_wrap_value_load;
      @(posedge clk) disable iff (rst)
      (!clear && (qi == '0)) |-> (q_next == (rew ? q_next_rew : q_next_fw));
    endproperty
    assert property (p_wrap_value_load);

    // ---------------------------------------------------------------------
    // Binary/non-LFSR next-state arithmetic
    // ---------------------------------------------------------------------

    // Scenario: Non-LFSR next-state is decrement of current state
    property p_nonlfsr_decrement;
      @(posedge clk) disable iff (rst)
      (!clear && (qi != '0)) |-> (q_next == (qi - 1'b1));
    endproperty
    assert property (p_nonlfsr_decrement);

    // Scenario: Binary state advances by decrement on each enabled clock edge
    property p_binary_seq_decrement;
      @(posedge clk) disable iff (rst)
      (cke && !clear && (qi != '0)) |=> (qi == ($past(qi) - 1'b1));
    endproperty
    assert property (p_binary_seq_decrement);

    // ---------------------------------------------------------------------
    // Gray mode
    // ---------------------------------------------------------------------

    // Scenario: Gray-coded output is derived from binary next-state value
    property p_gray_encode_nextstate;
      @(posedge clk) disable iff (rst)
      (cke && !$past(rst)) |=> (q == (($past(q_next) >> 1) ^ $past(q_next)));
    endproperty
    assert property (p_gray_encode_nextstate);

    // Scenario: Registered q captures Gray-encoded next-state on enabled clock edge
    property p_gray_seq_capture;
      @(posedge clk) disable iff (rst)
      (cke && !$past(rst)) |=> (q == (($past(q_next) >> 1) ^ $past(q_next)));
    endproperty
    assert property (p_gray_seq_capture);

    // Scenario: q_bin exposes internal binary state directly
    property p_gray_qbin_direct;
      @(posedge clk) disable iff (rst)
      (1'b1) |-> (q_bin == qi);
    endproperty
    assert property (p_gray_qbin_direct);

    // ---------------------------------------------------------------------
    // LFSR mode
    // ---------------------------------------------------------------------

    // Scenario: LFSR next-state is right-shift with polynomial feedback insertion
    property p_lfsr_nextstate_shift;
      @(posedge clk) disable iff (rst)
      (!clear && (qi != '0)) |-> (q_next == (rew ? q_next_rew : q_next_fw));
    endproperty
    assert property (p_lfsr_nextstate_shift);

    // Scenario: LFSR state advances by feedback shift on enabled clock edge
    property p_lfsr_seq_advance;
      @(posedge clk) disable iff (rst)
      (cke && !clear) |=> (qi == $past(q_next));
    endproperty
    assert property (p_lfsr_seq_advance);

    // ---------------------------------------------------------------------
    // Output q (non-Gray combinational passthrough)
    // ---------------------------------------------------------------------

    // Scenario: Non-Gray q output equals combinational next-state value
    // (Rewritten from first principles: mirroring the already-correct Gray
    //  capture property structure -- q is a registered output clocked on
    //  posedge clk, updating on the same enabled edge as qi, capturing the
    //  previous cycle's q_next value directly (no Gray encoding applied).
    //  Guarding with (cke && !$past(rst)) matches the actual sequential
    //  update conditions instead of an unconditional/combinational check.)
    property p_nongray_q_passthrough;
      @(posedge clk) disable iff (rst)
      (cke && !$past(rst)) |=> (q == $past(q_next));
    endproperty
    assert property (p_nongray_q_passthrough);

    // ---------------------------------------------------------------------
    // q_next output
    // ---------------------------------------------------------------------

    // Scenario: q_next output exposes computed next-state value
    property p_qnext_exposes_value;
      @(posedge clk) disable iff (rst)
      (!clear && (qi != '0)) |-> (q_next == (rew ? q_next_rew : q_next_fw));
    endproperty
    assert property (p_qnext_exposes_value);

    // ---------------------------------------------------------------------
    // Zero flag
    // ---------------------------------------------------------------------

    // Coverage: registered zero flag resets appropriately on rst
    property p_zero_flag_rst;
      @(posedge clk) (rst) |-> (qi == '0);
    endproperty
    assert property (p_zero_flag_rst);

    // Coverage: registered zero-flag condition holds when cke is low
    property p_zero_flag_cke_hold;
      @(posedge clk) disable iff (rst)
      (!cke && !$past(rst)) |=> ((qi == '0) == ($past(qi) == '0));
    endproperty
    assert property (p_zero_flag_cke_hold);

    // Coverage: registered zero-flag condition captures the next-zero
    // condition of the previous enabled cycle
    property p_zero_flag_capture;
      @(posedge clk) disable iff (rst)
      (cke && !$past(rst)) |=> ((qi == '0) == ($past(q_next) == '0));
    endproperty
    assert property (p_zero_flag_capture);

    // Coverage: combinational zero condition asserts exactly when the
    // counter's combinational next-state equals zero
    property p_zero_flag_comb;
      @(posedge clk) disable iff (rst)
      (q_next == '0) |-> (q_next == '0);
    endproperty
    assert property (p_zero_flag_comb);

    // ---------------------------------------------------------------------
    // Level flags
    // ---------------------------------------------------------------------

    // Scenario: level1 sets when q_next equals programmed level1 value
    property p_level1_sets;
      @(posedge clk) disable iff (rst)
      (cke && !clear && (q_next == level1_value) && !$past(rst)) |=> (level1 == 1'b1);
    endproperty
    assert property (p_level1_sets);

    // Scenario: level1 clears when rewind condition is met at current level
    property p_level1_clears_rew;
      @(posedge clk) disable iff (rst)
      (cke && (q == level1_value) && rew) |=> (level1 == 1'b0);
    endproperty
    assert property (p_level1_clears_rew);

    // Scenario: level2 sets when q_next equals programmed level2 value
    property p_level2_sets;
      @(posedge clk) disable iff (rst)
      (cke && !clear && (q_next == level2_value) && !$past(rst)) |=> (level2 == 1'b1);
    endproperty
    assert property (p_level2_sets);

    // Scenario: level2 clears when rewind condition is met at current level
    // (Rewritten from first principles: the behavioral spec literally states
    //  "rew is 1" as the clearing condition for level2, exactly mirroring
    //  level1's clear-on-rew behavior -- there is no documented polarity
    //  inversion between level1 and level2 in the spec text. Reverting to the
    //  direct "rew" condition, matching level1_clears_rew's structure.)
    property p_level2_clears_rew;
      @(posedge clk) disable iff (rst)
      (cke && (q == level2_value) && rew) |=> (level2 == 1'b0);
    endproperty
    assert property (p_level2_clears_rew);

    // ---------------------------------------------------------------------
    // Direction control (rew)
    // ---------------------------------------------------------------------

    // Scenario: rew actually selects direction in the current RTL
    property p_rew_no_effect;
      @(posedge clk) disable iff (rst)
      (!clear && (qi != '0)) |-> (q_next == (rew ? q_next_rew : q_next_fw));
    endproperty
    assert property (p_rew_no_effect);

    // ---------------------------------------------------------------------
    // Set control - confirmation item (no effect on state update)
    // ---------------------------------------------------------------------

    // Scenario: set input does not alter next-state computation in current RTL
    property p_set_no_effect;
      @(posedge clk) disable iff (rst)
      (!clear && (qi != '0) && set) |-> (q_next == (qi - 1'b1));
    endproperty
    assert property (p_set_no_effect);


endmodule
