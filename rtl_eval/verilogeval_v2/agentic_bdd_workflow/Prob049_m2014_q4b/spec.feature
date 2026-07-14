Feature: D Flip-Flop with Asynchronous Reset
  Formal verification of TopModule, a positive-edge-triggered D flip-flop
  with an asynchronous reset signal "ar".

  Background:
    Given a signal clk representing the clock
    And a signal d representing the data input
    And a signal ar representing the asynchronous reset
    And a signal q representing the registered output
    And q is updated only on the rising edge of clk, except when ar is asserted
    And ar, when asserted, forces q to 0 immediately, independent of clk

  @reset @async
  Formal Scenario: Asynchronous reset forces output low regardless of clock
    Given ar is 1
    And d is any value X
    When ar is asserted at any time, synchronous or asynchronous to clk
    Then q should be 0

  @reset @async_deassert
  Formal Scenario: Output remains reset while ar stays asserted across clock edges
    Given ar is 1
    And d is any value X
    When a rising edge of clk occurs while ar is still 1
    Then q should remain 0

  @reset @priority
  Formal Scenario: Asynchronous reset takes priority over data capture at clock edge
    Given ar is 1
    And d is any value X
    When a rising edge of clk occurs simultaneously with ar being 1
    Then q should be 0 and not the value of d

  @capture @posedge
  Formal Scenario: Data is captured on rising clock edge when reset is inactive
    Given ar is 0
    And d is any value X
    When a rising edge of clk occurs
    Then q should become X

  @hold @no_edge
  Formal Scenario: Output holds its value when no clock edge occurs
    Given ar is 0
    And q currently holds value Q_prev
    And d is any value X
    When clk does not have a rising edge
    Then q should remain Q_prev

  @hold @falling_edge
  Formal Scenario: Output does not change on falling clock edge
    Given ar is 0
    And q currently holds value Q_prev
    And d is any value X
    When a falling edge of clk occurs
    Then q should remain Q_prev

  @reset_release @recapture
  Formal Scenario: Normal operation resumes after reset is released
    Given ar transitions from 1 to 0
    And d is any value X
    When a rising edge of clk occurs after ar is deasserted
    Then q should become X

  @stability @d_change_between_edges
  Formal Scenario: Changes in d between clock edges do not affect q until next edge
    Given ar is 0
    And q currently holds value Q_prev
    And d changes from value X to value Y between two rising edges of clk
    When no rising edge of clk has yet occurred after d changes to Y
    Then q should remain Q_prev

  @reset @immediate
  Formal Scenario: Reset assertion at any time immediately overrides current output
    Given q currently holds value Q_prev
    And ar transitions from 0 to 1 at any time
    When ar becomes 1
    Then q should immediately become 0, independent of clk