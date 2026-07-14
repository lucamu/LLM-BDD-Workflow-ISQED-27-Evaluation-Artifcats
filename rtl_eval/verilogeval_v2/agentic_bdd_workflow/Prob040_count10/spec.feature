Feature: Decade Counter (0-9) with Synchronous Reset

  Formal verification of a 4-bit decade counter (TopModule) that counts
  from 0 through 9 inclusive with period 10, using synchronous active-high
  reset triggered on the positive edge of clk.

  Background:
    Given a signal clk
    And a signal reset
    And an output q of 4 bits
    And all sequential logic is triggered on the positive edge of clk
    And reset is active high and synchronous

  @reset @safety
  Formal Scenario: Synchronous reset forces counter to zero
    Given reset is 1
    When a positive edge of clk occurs
    Then q should be 4'b0000

  @reset @priority
  Formal Scenario: Reset takes priority over counting regardless of current state
    Given q holds any value Q in the range 0 to 9
    And reset is 1
    When a positive edge of clk occurs
    Then q should be 4'b0000

  @range @invariant
  Formal Scenario: Counter value is always within valid decade range
    Given q holds any value Q
    Then Q should be less than or equal to 9

  @increment @functional
  Formal Scenario: Counter increments by one when not at terminal count and not reset
    Given reset is 0
    And q holds a value Q where Q is less than 9
    When a positive edge of clk occurs
    Then q should be Q + 1

  @wraparound @functional
  Formal Scenario: Counter wraps from nine to zero when not reset
    Given reset is 0
    And q holds the value 4'b1001
    When a positive edge of clk occurs
    Then q should be 4'b0000

  @stability @invariant
  Formal Scenario: Counter never produces an invalid state after reset deassertion
    Given q holds any value Q in the range 0 to 9
    And reset is 0
    When a positive edge of clk occurs
    Then q should be less than or equal to 9

  @induction @safety
  Formal Scenario: No unreachable states greater than nine persist
    Given q holds any value Q
    And Q is greater than 9
    Then this state should be unreachable from a valid reset state

  @liveness @periodicity
  Formal Scenario: Counter returns to zero exactly every ten clock cycles when never reset
    Given reset is 0 for ten consecutive clock cycles
    And q holds the value 4'b0000 before the first of these cycles
    When ten positive edges of clk occur consecutively
    Then q should be 4'b0000 again after the tenth edge