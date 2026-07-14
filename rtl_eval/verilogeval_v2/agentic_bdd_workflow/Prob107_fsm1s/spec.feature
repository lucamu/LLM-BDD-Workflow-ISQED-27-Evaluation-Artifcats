Feature: Two-State Moore Machine (States A and B)

  This module implements a Moore state machine with two states, A and B.
  The reset state is B, output is 1 in state B and 0 in state A.
  Reset is active-high and synchronous.

  Background:
    Given a signal clk representing the system clock
    And a signal reset representing active-high synchronous reset
    And a signal in representing the single-bit input
    And a signal out representing the single-bit Moore output
    And the design has two internal states, A and B
    And out is 1 when the current state is B
    And out is 0 when the current state is A
    And state transitions occur only on the rising edge of clk

  @reset
  Formal Scenario: Synchronous reset forces state B
    Given the current state is any valid state
    And reset is asserted
    When a rising clock edge occurs
    Then the next state should be B
    And out should be 1

  @reset
  Formal Scenario: Reset takes priority over input value
    Given the current state is any valid state
    And in is any valid value
    And reset is asserted
    When a rising clock edge occurs
    Then the next state should be B
    And out should be 1

  @transition
  Formal Scenario: State B transitions to A when in is 0
    Given reset is deasserted
    And the current state is B
    And in is 0
    When a rising clock edge occurs
    Then the next state should be A
    And out should be 0

  @transition
  Formal Scenario: State B remains B when in is 1
    Given reset is deasserted
    And the current state is B
    And in is 1
    When a rising clock edge occurs
    Then the next state should be B
    And out should be 1

  @transition
  Formal Scenario: State A transitions to B when in is 0
    Given reset is deasserted
    And the current state is A
    And in is 0
    When a rising clock edge occurs
    Then the next state should be B
    And out should be 1

  @transition
  Formal Scenario: State A remains A when in is 1
    Given reset is deasserted
    And the current state is A
    And in is 1
    When a rising clock edge occurs
    Then the next state should be A
    And out should be 0

  @output
  Formal Scenario: Output is a Moore function of current state only
    Given the current state is any valid state
    And in is any valid value
    When the current cycle is evaluated
    Then out should equal 1 if the current state is B
    And out should equal 0 if the current state is A

  @invariant
  Formal Scenario: Next output is the complement of current output when in is 0
    Given reset is deasserted
    And the current state is any valid state
    And in is 0
    When a rising clock edge occurs
    Then the next out should be the logical complement of the current out

  @invariant
  Formal Scenario: Next output equals current output when in is 1
    Given reset is deasserted
    And the current state is any valid state
    And in is 1
    When a rising clock edge occurs
    Then the next out should equal the current out

  @coverage
  Formal Scenario: Only two reachable states exist
    Given reset has been asserted at least once in the past
    When any number of rising clock edges occur
    Then the current state should always be either A or B
    And out should always be either 0 or 1 accordingly