Feature: D Flip-Flop with Active-High Synchronous Reset

  The TopModule implements a single-bit D flip-flop with a
  synchronous, active-high reset. On the rising edge of clk, if r
  is asserted the output q is driven to 0; otherwise q captures
  the value of d from the previous clock cycle.

  Background:
    Given a signal clk representing the system clock
    And a signal d representing the data input
    And a signal r representing the active-high synchronous reset
    And a signal q representing the registered output
    And all updates to q occur only on the rising edge of clk

  @reset @synchronous
  Formal Scenario: Synchronous reset forces output to 0
    Given r is 1 at the current rising edge of clk
    And d is any value X
    When the rising edge of clk occurs
    Then q should be 0 in the next cycle

  @data @capture
  Formal Scenario: Output captures data input when reset is not asserted
    Given r is 0 at the current rising edge of clk
    And d is value X
    When the rising edge of clk occurs
    Then q should be X in the next cycle

  @reset @priority
  Formal Scenario: Reset takes priority over data input
    Given r is 1 at the current rising edge of clk
    And d is value X
    When the rising edge of clk occurs
    Then q should be 0 in the next cycle regardless of the value of X

  @stability
  Formal Scenario: Output remains stable between clock edges
    Given q holds value Y after a rising edge of clk
    And no rising edge of clk occurs
    Then q should remain equal to Y

  @initial @poweron
  Formal Scenario: Reset guarantees known output value
    Given r is held at 1 for at least one rising edge of clk
    When the rising edge of clk occurs
    Then q should be 0
    And q should not be unknown or undefined