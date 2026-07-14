Feature: Two-State Moore Machine (OFF/ON) Controlled by J and K Inputs

  This feature specifies a Moore state machine with two states (OFF, ON),
  two inputs (j, k), and one output (out) that reflects the current state.
  The machine transitions from OFF to ON when j=1, and from ON to OFF
  when k=1. The output is 0 in state OFF and 1 in state ON.

  Background:
    Given a clock signal clk
    And an active-high synchronous reset signal reset
    And a single-bit input j
    And a single-bit input k
    And a single-bit output out
    And all state transitions occur on the rising edge of clk

  @reset @formal
  Formal Scenario: Synchronous reset forces state to OFF
    Given any current state
    And any value of j
    And any value of k
    When reset is 1
    And a rising edge of clk occurs
    Then out should be 0 on the next clock cycle

  @reset @formal
  Formal Scenario: Reset output is immediately consistent with OFF state
    Given reset is 1
    When a rising edge of clk occurs
    Then out should be 0

  @transition @formal
  Formal Scenario: OFF state holds when j is 0
    Given reset is 0
    And the current state is OFF
    And j is 0
    And any value of k
    When a rising edge of clk occurs
    Then the next state should be OFF
    And out should be 0 on the next clock cycle

  @transition @formal
  Formal Scenario: OFF state transitions to ON when j is 1
    Given reset is 0
    And the current state is OFF
    And j is 1
    And any value of k
    When a rising edge of clk occurs
    Then the next state should be ON
    And out should be 1 on the next clock cycle

  @transition @formal
  Formal Scenario: ON state holds when k is 0
    Given reset is 0
    And the current state is ON
    And k is 0
    And any value of j
    When a rising edge of clk occurs
    Then the next state should be ON
    And out should be 1 on the next clock cycle

  @transition @formal
  Formal Scenario: ON state transitions to OFF when k is 1
    Given reset is 0
    And the current state is ON
    And k is 1
    And any value of j
    When a rising edge of clk occurs
    Then the next state should be OFF
    And out should be 0 on the next clock cycle

  @output @formal
  Formal Scenario: Output reflects OFF state combinationally
    Given the current state is OFF
    Then out should be 0

  @output @formal
  Formal Scenario: Output reflects ON state combinationally
    Given the current state is ON
    Then out should be 1

  @invariant @formal
  Formal Scenario: Output is always a function of current state only
    Given any current state
    And any value of j
    And any value of k
    Then out should be 1 if and only if the current state is ON

  @invariant @formal
  Formal Scenario: State remains within valid state encoding
    Given any current state
    And any value of j
    And any value of k
    When a rising edge of clk occurs
    Then the next state should be either OFF or ON