Feature: 4-bit Binary Counter with Synchronous Reset

  As a hardware designer
  I want a 4-bit counter that counts from 0 to 15 with wraparound
  So that I can use it for cyclic timing and sequencing operations

  Background:
    Given a signal clk
    And a signal reset
    And a signal q of width 4 bits
    And all sequential logic is triggered on the positive edge of clk
    And reset is active high and synchronous

  @reset @safety
  Formal Scenario: Synchronous reset forces counter to zero
    Given reset is 1
    When a positive edge of clk occurs
    Then q should be 4'b0000

  @reset @priority
  Formal Scenario: Reset takes priority over counting
    Given reset is 1
    And q holds any current value Q_CURRENT
    When a positive edge of clk occurs
    Then q should be 4'b0000
    And q should not depend on Q_CURRENT

  @increment @functional
  Formal Scenario: Counter increments by one when not at maximum and reset is low
    Given reset is 0
    And q holds value Q_CURRENT
    And Q_CURRENT is less than 4'b1111
    When a positive edge of clk occurs
    Then q should equal Q_CURRENT + 1

  @wraparound @functional
  Formal Scenario: Counter wraps to zero after reaching maximum value
    Given reset is 0
    And q holds value 4'b1111
    When a positive edge of clk occurs
    Then q should be 4'b0000

  @generic @functional
  Formal Scenario: Counter next value is current value plus one modulo sixteen
    Given reset is 0
    And q holds value Q_CURRENT
    When a positive edge of clk occurs
    Then q should equal (Q_CURRENT + 1) mod 16

  @invariant @safety
  Formal Scenario: Counter value always remains within valid 4-bit range
    Given any sequence of clk edges and reset values
    Then q should always be greater than or equal to 4'b0000
    And q should always be less than or equal to 4'b1111

  @periodicity @liveness
  Formal Scenario: Counter returns to same value after sixteen clock edges without reset
    Given reset is 0 for sixteen consecutive clock cycles
    And q holds value Q_START at the beginning of the first cycle
    When sixteen positive edges of clk occur consecutively with reset held at 0
    Then q should equal Q_START at the end of the sixteenth edge

  @stability @safety
  Formal Scenario: Counter does not change without a clock edge
    Given reset is 0
    And q holds value Q_CURRENT
    And no positive edge of clk occurs
    Then q should remain equal to Q_CURRENT