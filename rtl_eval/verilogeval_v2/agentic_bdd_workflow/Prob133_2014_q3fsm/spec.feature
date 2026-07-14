Feature: TopModule FSM — Detect Exactly Two 1's in Each Three-Cycle Window of w

  As a formal verification engineer
  I want to verify TopModule's FSM behavior
  So that z is asserted exactly one cycle after any three-cycle window of w
  contains exactly two samples equal to 1, starting only after s has been
  observed high, with synchronous active-high reset.

  Background:
    Given a design named TopModule with inputs clk, reset, s, w and output z
    And all sequential logic is triggered on the rising edge of clk
    And reset is synchronous and active-high
    And the FSM begins in reset state A whenever reset is asserted

  @reset @safety
  Formal Scenario: Synchronous reset forces state A and z low
    Given reset is 1
    And s and w hold arbitrary values
    When a rising edge of clk occurs
    Then the FSM should be in state A
    And z should be 0

  @idle @safety
  Formal Scenario: FSM remains in state A while s is low
    Given reset is 0
    And the FSM is currently in state A
    And s is 0
    And w holds an arbitrary value
    When a rising edge of clk occurs
    Then the FSM should remain in state A
    And z should be 0

  @transition @safety
  Formal Scenario: FSM leaves state A only when s is asserted
    Given reset is 0
    And the FSM is currently in state A
    And s is 1
    And w holds an arbitrary value
    When a rising edge of clk occurs
    Then the FSM should no longer be in state A
    And z should be 0

  @core @functional
  Formal Scenario: z reflects exactly two 1's among the three monitored w values
    Given reset is 0
    And the FSM has just left state A because s was 1 on the previous cycle
    And w equals W1 on the first monitored cycle
    When a rising edge of clk occurs
    And w equals W2 on the second monitored cycle
    And a rising edge of clk occurs
    And w equals W3 on the third monitored cycle
    When a rising edge of clk occurs
    Then on the following rising edge of clk, z should be 1 if (W1 + W2 + W3) equals 2, else z should be 0

  @continuous @functional
  Formal Scenario: A new three-cycle window begins immediately after each output cycle
    Given reset is 0
    And the FSM has just completed a three-cycle monitoring window
    And the value of w on the output cycle is W_next
    When a rising edge of clk occurs
    Then the FSM should begin a new three-cycle monitoring window
    And W_next should be counted as the first sample of the new window

  @s_ignored @safety
  Formal Scenario: s has no effect once the FSM is monitoring w
    Given reset is 0
    And the FSM is currently within a three-cycle monitoring window (not state A)
    And s holds an arbitrary value
    And w holds an arbitrary value
    When a rising edge of clk occurs
    Then the next state should depend only on w and the current monitoring progress
    And the next state should not depend on s

  @reset_priority @safety
  Formal Scenario: Reset overrides monitoring progress at any point in the window
    Given the FSM is currently within a three-cycle monitoring window with an arbitrary partial count of 1's
    And reset is 1
    When a rising edge of clk occurs
    Then the FSM should be in state A
    And z should be 0

  @z_default @safety
  Formal Scenario: z is 0 in every cycle that is not immediately after a completed window
    Given reset is 0
    And the FSM is not on the cycle immediately following a completed three-cycle window
    When a rising edge of clk occurs
    Then z should be 0