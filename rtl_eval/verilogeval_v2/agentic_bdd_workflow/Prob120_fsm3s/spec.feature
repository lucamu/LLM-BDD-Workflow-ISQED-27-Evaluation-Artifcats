Feature: TopModule Moore Finite State Machine

  The design implements a 4-state Moore machine (states A, B, C, D) with
  one input `in` and one output `out`. The output depends only on the
  current state (Moore semantics). A synchronous active-high reset
  forces the machine into state A.

  Background:
    Given a signal clk that is the positive-edge triggered clock
    And a signal reset that is the synchronous active-high reset
    And a signal in that is the single-bit input
    And a signal out that is the single-bit Moore output
    And the FSM has exactly four states A, B, C, D
    And the state register updates only on the rising edge of clk

  @reset
  Formal Scenario: Synchronous reset forces state A
    Given reset is 1
    When a rising clock edge occurs
    Then the next state should be A
    And out should be 0 in the next state

  @reset
  Formal Scenario: Reset overrides any current state and input
    Given the FSM is in any state S
    And in is any value X
    And reset is 1
    When a rising clock edge occurs
    Then the next state should be A regardless of S and X

  @output
  Formal Scenario: Output value in state A
    Given reset is 0
    And the FSM is in state A
    Then out should be 0

  @output
  Formal Scenario: Output value in state B
    Given reset is 0
    And the FSM is in state B
    Then out should be 0

  @output
  Formal Scenario: Output value in state C
    Given reset is 0
    And the FSM is in state C
    Then out should be 0

  @output
  Formal Scenario: Output value in state D
    Given reset is 0
    And the FSM is in state D
    Then out should be 1

  @transition
  Formal Scenario: Transition from state A
    Given reset is 0
    And the FSM is in state A
    And in is value X
    When a rising clock edge occurs
    Then the next state should be A if X is 0
    And the next state should be B if X is 1

  @transition
  Formal Scenario: Transition from state B
    Given reset is 0
    And the FSM is in state B
    And in is value X
    When a rising clock edge occurs
    Then the next state should be C if X is 0
    And the next state should be B if X is 1

  @transition
  Formal Scenario: Transition from state C
    Given reset is 0
    And the FSM is in state C
    And in is value X
    When a rising clock edge occurs
    Then the next state should be A if X is 0
    And the next state should be D if X is 1

  @transition
  Formal Scenario: Transition from state D
    Given reset is 0
    And the FSM is in state D
    And in is value X
    When a rising clock edge occurs
    Then the next state should be C if X is 0
    And the next state should be B if X is 1

  @invariant
  Formal Scenario: The FSM always occupies exactly one of the four defined states
    Given reset is 0
    And the FSM is in any state S
    Then S should equal exactly one of A, B, C, D

  @invariant
  Formal Scenario: Output is a pure function of the current state
    Given reset is 0
    And the FSM is in state S
    And in is any value X
    Then out should depend only on S and not on X

  @reachability
  Formal Scenario: State D is reachable only through state C with in equal to 1
    Given reset is 0
    And the next state is D
    Then the current state must have been C
    And in must have been 1