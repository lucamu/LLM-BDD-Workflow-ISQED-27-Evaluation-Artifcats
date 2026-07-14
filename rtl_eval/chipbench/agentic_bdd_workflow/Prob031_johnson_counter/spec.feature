Feature: 4-bit Johnson Counter

  As a hardware designer
  I want a 4-bit Johnson (twisted ring) counter
  So that the output cycles through the 8-state sequence: 0000 -> 1000 -> 1100 -> 1110 -> 1111 -> 0111 -> 0011 -> 0001 -> 0000

  Background:
    Given a signal clk
    And a signal rst_n
    And a signal Q of width 4
    And Q is updated on the positive edge of clk
    And rst_n is an asynchronous active-low reset

  @reset
  Formal Scenario: Asynchronous reset forces Q to 0000
    Given Q holds any current value
    When rst_n is deasserted low
    Then Q should become 4'b0000 immediately, independent of clk

  @reset
  Formal Scenario: Q remains 0000 while reset is held low
    Given rst_n is held low
    And Q is currently 4'b0000
    When a positive edge of clk occurs
    Then Q should remain 4'b0000

  @transition
  Formal Scenario: Transition from 0000 to 1000
    Given rst_n is high
    And Q is currently 4'b0000
    When a positive edge of clk occurs
    Then Q should become 4'b1000

  @transition
  Formal Scenario: Transition from 1000 to 1100
    Given rst_n is high
    And Q is currently 4'b1000
    When a positive edge of clk occurs
    Then Q should become 4'b1100

  @transition
  Formal Scenario: Transition from 1100 to 1110
    Given rst_n is high
    And Q is currently 4'b1100
    When a positive edge of clk occurs
    Then Q should become 4'b1110

  @transition
  Formal Scenario: Transition from 1110 to 1111
    Given rst_n is high
    And Q is currently 4'b1110
    When a positive edge of clk occurs
    Then Q should become 4'b1111

  @transition
  Formal Scenario: Transition from 1111 to 0111
    Given rst_n is high
    And Q is currently 4'b1111
    When a positive edge of clk occurs
    Then Q should become 4'b0111

  @transition
  Formal Scenario: Transition from 0111 to 0011
    Given rst_n is high
    And Q is currently 4'b0111
    When a positive edge of clk occurs
    Then Q should become 4'b0011

  @transition
  Formal Scenario: Transition from 0011 to 0001
    Given rst_n is high
    And Q is currently 4'b0011
    When a positive edge of clk occurs
    Then Q should become 4'b0001

  @transition
  Formal Scenario: Transition from 0001 to 0000
    Given rst_n is high
    And Q is currently 4'b0001
    When a positive edge of clk occurs
    Then Q should become 4'b0000

  @invariant
  Formal Scenario: Q always remains within the valid Johnson sequence set
    Given rst_n is high
    And Q is currently one of the eight valid Johnson states
    When a positive edge of clk occurs
    Then Q should still be one of the eight valid Johnson states
  @invariant
  Formal Scenario: Counter never enters an unreachable state
    Given rst_n is high
    And Q is currently any of the reachable Johnson states
    When a positive edge of clk occurs
    Then Q should not equal any 4-bit value outside the defined 8-state sequence

  @cycle
  Formal Scenario: Full cycle returns to initial state after eight clock edges
    Given rst_n is high
    And Q is currently 4'b0000
    When eight consecutive positive edges of clk occur
    Then Q should return to 4'b0000