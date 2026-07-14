Feature: 8-bit Positive Edge Detector
  The TopModule detects, on a per-bit basis, a 0-to-1 transition of the
  8-bit input vector "in" from one clock cycle to the next. The output
  "pedge" is a registered signal: bit i of pedge is asserted in the cycle
  immediately following a cycle in which bit i of "in" was 0 and bit i of
  "in" became 1.

  Background:
    Given a signal clk that is the synchronous clock for TopModule
    And an 8-bit input signal in sampled on the rising edge of clk
    And an 8-bit registered output signal pedge updated on the rising edge of clk
    And pedge bit i reflects whether in bit i transitioned from 0 to 1 between the previous clock cycle and the current clock cycle, for each bit index i from 0 to 7

  @edge_detection @core
  Formal Scenario: Rising edge on a single bit produces pedge the following cycle
    Given bit index I of in held value 0 in the previous clock cycle
    And bit index I of in holds value 1 in the current clock cycle
    When the rising edge of clk occurs
    Then bit index I of pedge should be 1 in the next clock cycle

  @no_edge @stable_low
  Formal Scenario: Bit remaining 0 produces no pedge
    Given bit index I of in held value 0 in the previous clock cycle
    And bit index I of in holds value 0 in the current clock cycle
    When the rising edge of clk occurs
    Then bit index I of pedge should be 0 in the next clock cycle

  @no_edge @stable_high
  Formal Scenario: Bit remaining 1 produces no pedge
    Given bit index I of in held value 1 in the previous clock cycle
    And bit index I of in holds value 1 in the current clock cycle
    When the rising edge of clk occurs
    Then bit index I of pedge should be 0 in the next clock cycle

  @no_edge @falling_edge
  Formal Scenario: Falling edge (1 to 0) produces no pedge
    Given bit index I of in held value 1 in the previous clock cycle
    And bit index I of in holds value 0 in the current clock cycle
    When the rising edge of clk occurs
    Then bit index I of pedge should be 0 in the next clock cycle

  @per_bit_independence
  Formal Scenario: pedge computation is independent per bit
    Given an arbitrary 8-bit value PREV representing in in the previous clock cycle
    And an arbitrary 8-bit value CURR representing in in the current clock cycle
    When the rising edge of clk occurs
    Then for each bit index i from 0 to 7, bit i of pedge in the next clock cycle should equal 1 if and only if bit i of PREV equals 0 and bit i of CURR equals 1

  @one_cycle_pulse
  Formal Scenario: pedge pulse lasts exactly one cycle after a transition
    Given bit index I of in held value 0 in the previous clock cycle
    And bit index I of in holds value 1 in the current clock cycle
    And bit index I of in holds value 1 in the clock cycle following the current cycle
    When the rising edge of clk occurs twice in succession
    Then bit index I of pedge should be 1 exactly one cycle after the transition
    And bit index I of pedge should be 0 two cycles after the transition

  @no_combinational_leak
  Formal Scenario: pedge does not depend on the current-cycle sample alone
    Given bit index I of in holds value 1 in the current clock cycle
    And the value of bit index I of in in the previous clock cycle is unconstrained
    When the rising edge of clk occurs
    Then bit index I of pedge in the next clock cycle should equal 1 if and only if bit index I of in in the previous clock cycle was 0