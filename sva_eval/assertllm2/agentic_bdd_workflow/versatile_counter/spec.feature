Feature: vcnt Configurable Counter Core
  Formal verification of the vcnt counter supporting binary, Gray-code, and LFSR
  counting styles, with configurable clear/set/direction/clock-enable control
  and status flag generation.

  Background:
    Given a synchronous design clocked on the rising edge of "clk"
    And an active-high asynchronous reset "rst"
    And an internal state register "qi" of width "cnt_length"
    And a combinational next-state signal "q_next"

  # ---------------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------------

  @reset @async
  Formal Scenario: Asynchronous reset forces state to zero regardless of clock
    Given "rst" is asserted to 1
    When any rising edge of "clk" occurs or does not occur
    Then "qi" should be 0 immediately upon "rst" assertion

  @reset @gray
  Formal Scenario: Asynchronous reset forces Gray-mode registered q to reset value
    Given "CNT_TYPE_GRAY" is enabled
    And "rst" is asserted to 1
    When any rising edge of "clk" occurs or does not occur
    Then registered output "q" should be "CNT_RESET_VALUE" immediately upon "rst" assertion

  @reset @flags
  Formal Scenario: Asynchronous reset forces zq to 1 when enabled
    Given "CNT_ZQ" is enabled
    And "rst" is asserted to 1
    When any rising edge of "clk" occurs or does not occur
    Then "zq" should be 1 immediately upon "rst" assertion

  @reset @flags
  Formal Scenario: Asynchronous reset forces level1 and level2 to 0 when enabled
    Given "CNT_LEVEL1" is enabled
    And "CNT_LEVEL2" is enabled
    And "rst" is asserted to 1
    When any rising edge of "clk" occurs or does not occur
    Then "level1" should be 0 immediately upon "rst" assertion
    And "level2" should be 0 immediately upon "rst" assertion

  # ---------------------------------------------------------------------
  # Clock enable gating
  # ---------------------------------------------------------------------

  @cke
  Formal Scenario: Clock enable low holds state across clock edge
    Given "CNT_CE" is enabled
    And "rst" is deasserted
    And "cke" is 0
    And "qi" holds value stateQ before the clock edge
    When a rising edge of "clk" occurs
    Then "qi" should remain equal to stateQ after the clock edge

  @cke
  Formal Scenario: Clock enable high allows state to update to next-state value
    Given "CNT_CE" is enabled
    And "rst" is deasserted
    And "cke" is 1
    And "q_next" evaluates to nextValue before the clock edge
    When a rising edge of "clk" occurs
    Then "qi" should equal nextValue after the clock edge

  @cke @flags
  Formal Scenario: Clock enable low holds registered status outputs
    Given "CNT_CE" is enabled
    And "CNT_ZQ" is enabled
    And "rst" is deasserted
    And "cke" is 0
    And "zq" holds value zqPrev before the clock edge
    When a rising edge of "clk" occurs
    Then "zq" should remain equal to zqPrev after the clock edge

  # ---------------------------------------------------------------------
  # Next-state priority: clear dominance
  # ---------------------------------------------------------------------

  @clear @priority
  Formal Scenario: Clear has highest priority in next-state computation
    Given "CNT_CLEAR" is enabled
    And "clear" is 1
    And "qi" holds any value stateQ
    Then "q_next" should be 0

  @clear @priority
  Formal Scenario: Clear dominates wrap mode when both are asserted
    Given "CNT_CLEAR" is enabled
    And "CNT_WRAP" is enabled
    And "clear" is 1
    And "qi" is 0
    Then "q_next" should be 0

  @clear @sequential
  Formal Scenario: Clear forces qi to zero on next clock edge when enabled and cke satisfied
    Given "CNT_CLEAR" is enabled
    And "rst" is deasserted
    And "clear" is 1
    And clock enable condition is satisfied
    When a rising edge of "clk" occurs
    Then "qi" should be 0 after the clock edge

  # ---------------------------------------------------------------------
  # Wrap mode
  # ---------------------------------------------------------------------

  @wrap @priority
  Formal Scenario: Wrap value loads when current state is zero and clear inactive
    Given "CNT_WRAP" is enabled
    And "clear" is inactive or "CNT_CLEAR" is not enabled
    And "qi" is 0
    Then "q_next" should be "wrap_value"

  @wrap @priority
  Formal Scenario: Wrap does not trigger when current state is nonzero
    Given "CNT_WRAP" is enabled
    And "clear" is inactive or "CNT_CLEAR" is not enabled
    And "qi" holds a nonzero value stateQ
    Then "q_next" should not be forced to "wrap_value" by the wrap condition
    And "q_next" should follow the normal mode-specific next-state computation

  # ---------------------------------------------------------------------
  # Binary/non-LFSR next-state arithmetic
  # ---------------------------------------------------------------------

  @binary @nextstate
  Formal Scenario: Non-LFSR next-state is decrement of current state
    Given "CNT_TYPE_LFSR" is not enabled
    And "CNT_CLEAR" is not enabled or "clear" is 0
    And "CNT_WRAP" is not enabled or "qi" is nonzero
    And "qi" holds value stateQ
    Then "q_next" should be "stateQ - 1"

  @binary @sequential
  Formal Scenario: Binary state advances by decrement on each enabled clock edge
    Given "CNT_TYPE_BINARY" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "CNT_CLEAR" is not enabled or "clear" is 0
    And "CNT_WRAP" is not enabled or "qi" is nonzero
    And "qi" holds value stateQ before the clock edge
    When a rising edge of "clk" occurs
    Then "qi" should equal "stateQ - 1" after the clock edge

  # ---------------------------------------------------------------------
  # Gray mode
  # ---------------------------------------------------------------------

  @gray @nextstate
  Formal Scenario: Gray-coded output is derived from binary next-state value
    Given "CNT_TYPE_GRAY" is enabled
    And "q_next" evaluates to nextValue
    Then the Gray-encoded value should be "(nextValue >> 1) ^ nextValue"

  @gray @sequential
  Formal Scenario: Registered q captures Gray-encoded next-state on enabled clock edge
    Given "CNT_TYPE_GRAY" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "q_next" evaluates to nextValue before the clock edge
    When a rising edge of "clk" occurs
    Then registered output "q" should equal "(nextValue >> 1) ^ nextValue" after the clock edge

  @gray @qbin
  Formal Scenario: q_bin exposes internal binary state directly
    Given "CNT_TYPE_GRAY" is enabled
    And "CNT_Q_BIN" is enabled
    And "qi" holds value stateQ
    Then "q_bin" should equal stateQ

  # ---------------------------------------------------------------------
  # LFSR mode
  # ---------------------------------------------------------------------

  @lfsr @nextstate
  Formal Scenario: LFSR next-state is right-shift with polynomial feedback insertion
    Given "CNT_TYPE_LFSR" is enabled
    And "CNT_CLEAR" is not enabled or "clear" is 0
    And "CNT_WRAP" is not enabled or "qi" is nonzero
    And "qi" holds value stateQ
    And the selected length polynomial defines feedback bit feedbackBit as a function of stateQ
    Then "q_next" should equal the right-shift of stateQ with feedbackBit inserted at the most significant tap position

  @lfsr @sequential
  Formal Scenario: LFSR state advances by feedback shift on enabled clock edge
    Given "CNT_TYPE_LFSR" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "CNT_CLEAR" is not enabled or "clear" is 0
    And "qi" holds value stateQ before the clock edge
    And "q_next" evaluates to lfsrNext according to the polynomial feedback function of stateQ
    When a rising edge of "clk" occurs
    Then "qi" should equal lfsrNext after the clock edge

  # ---------------------------------------------------------------------
  # Output q (non-Gray combinational passthrough)
  # ---------------------------------------------------------------------

  @output @nongray
  Formal Scenario: Non-Gray q output equals combinational next-state value
    Given "CNT_Q" is enabled
    And "CNT_TYPE_GRAY" is not enabled
    And "q_next" evaluates to nextValue
    Then "q" should equal nextValue

  @output @qnext
  Formal Scenario: q_next output exposes computed next-state value
    Given "CNT_QNEXT" is enabled
    And the internal next-state computation evaluates to nextValue
    Then "q_next" should equal nextValue

  # ---------------------------------------------------------------------
  # Zero flags
  # ---------------------------------------------------------------------

  @flags @z
  Formal Scenario: Combinational zero flag asserts when q equals zero
    Given "CNT_Z" is enabled
    And "q" holds value qValue
    Then "z" should be 1 if qValue equals 0
    And "z" should be 0 if qValue does not equal 0

  @flags @zq
  Formal Scenario: Registered zero flag captures next-zero condition on enabled clock edge
    Given "CNT_ZQ" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "q_next" evaluates to nextValue before the clock edge
    When a rising edge of "clk" occurs
    Then "zq" should be 1 if nextValue equals 0
    And "zq" should be 0 if nextValue does not equal 0

  # ---------------------------------------------------------------------
  # Level flags
  # ---------------------------------------------------------------------

  @flags @level1
  Formal Scenario: level1 sets when q_next equals programmed level1 value
    Given "CNT_LEVEL1" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "q_next" evaluates to nextValue before the clock edge
    And nextValue equals "level1_value"
    When a rising edge of "clk" occurs
    Then "level1" should be 1 after the clock edge

  @flags @level1
  Formal Scenario: level1 clears when rewind condition is met at current level
    Given "CNT_LEVEL1" is enabled
    And "CNT_REW" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "q" equals "level1_value" before the clock edge
    And "rew" is 1
    When a rising edge of "clk" occurs
    Then "level1" should be 0 after the clock edge

  @flags @level2
  Formal Scenario: level2 sets when q_next equals programmed level2 value
    Given "CNT_LEVEL2" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "q_next" evaluates to nextValue before the clock edge
    And nextValue equals "level2_value"
    When a rising edge of "clk" occurs
    Then "level2" should be 1 after the clock edge

  @flags @level2
  Formal Scenario: level2 clears when rewind condition is met at current level
    Given "CNT_LEVEL2" is enabled
    And "CNT_REW" is enabled
    And "rst" is deasserted
    And clock enable condition is satisfied
    And "q" equals "level2_value" before the clock edge
    And "rew" is 1
    When a rising edge of "clk" occurs
    Then "level2" should be 0 after the clock edge

  # ---------------------------------------------------------------------
  # Direction control (rew) - documented no-effect confirmation
  # ---------------------------------------------------------------------

  @rew @confirmation
  Formal Scenario: rew does not alter next-state arithmetic in current RTL
    Given "CNT_REW" is enabled
    And "qi" holds value stateQ
    And "CNT_CLEAR" is not enabled or "clear" is 0
    And "CNT_WRAP" is not enabled or "qi" is nonzero
    When "rew" is 0
    Then "q_next" should equal the value computed when "rew" is 1 for the same stateQ

  # ---------------------------------------------------------------------
  # Set control - confirmation item (no effect on state update)
  # ---------------------------------------------------------------------

  @set @confirmation
  Formal Scenario: set input does not alter next-state computation in current RTL
    Given "CNT_SET" is enabled
    And "qi" holds value stateQ
    And "CNT_CLEAR" is not enabled or "clear" is 0
    And "CNT_WRAP" is not enabled or "qi" is nonzero
    When "set" is 1
    Then "q_next" should equal the value computed when "set" is 0 for the same stateQ