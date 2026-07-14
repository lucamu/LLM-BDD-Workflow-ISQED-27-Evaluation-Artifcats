Feature: Moore Finite State Machine Controller

  This feature formally specifies a 6-state Moore machine (states A through F)
  with synchronous reset and a single input w. The output z depends only on
  the current state (z=1 in states E and F, z=0 otherwise). The state
  transitions follow the diagram provided in the design specification.

  Background:
    Given a synchronous design with input clk, input reset, input w, and output z
    And all state transitions occur on the rising edge of clk
    And reset is synchronous and active-high
    And the state register holds one of the symbolic states A, B, C, D, E, or F

  @reset
  Formal Scenario: Reset forces the machine to state A
    Given the current state is any symbolic state
    When reset is 1
    And a rising clock edge occurs
    Then the next state should be A

  @reset @output
  Formal Scenario: Output is 0 immediately after reset
    Given reset is 1
    When a rising clock edge occurs
    Then z should be 0

  @transition
  Formal Scenario: Transition from state A
    Given reset is 0
    And the current state is A
    When w is symbolic value w
    Then the next state should be B if w equals 0
    And the next state should be A if w equals 1

  @transition
  Formal Scenario: Transition from state B
    Given reset is 0
    And the current state is B
    When w is symbolic value w
    Then the next state should be C if w equals 0
    And the next state should be D if w equals 1

  @transition
  Formal Scenario: Transition from state C
    Given reset is 0
    And the current state is C
    When w is symbolic value w
    Then the next state should be E if w equals 0
    And the next state should be D if w equals 1

  @transition
  Formal Scenario: Transition from state D
    Given reset is 0
    And the current state is D
    When w is symbolic value w
    Then the next state should be F if w equals 0
    And the next state should be A if w equals 1

  @transition
  Formal Scenario: Transition from state E
    Given reset is 0
    And the current state is E
    When w is symbolic value w
    Then the next state should be E if w equals 0
    And the next state should be D if w equals 1

  @transition
  Formal Scenario: Transition from state F
    Given reset is 0
    And the current state is F
    When w is symbolic value w
    Then the next state should be C if w equals 0
    And the next state should be D if w equals 1

  @output
  Formal Scenario: Output is 0 in states A, B, C, and D
    Given reset is 0
    And the current state is A or B or C or D
    Then z should be 0

  @output
  Formal Scenario: Output is 1 in states E and F
    Given reset is 0
    And the current state is E or F
    Then z should be 1

  @invariant
  Formal Scenario: State register always holds a valid state
    Given reset is 0
    And the current state is any symbolic state
    When a rising clock edge occurs
    Then the next state should always be one of A, B, C, D, E, or F

  @invariant
  Formal Scenario: Output depends only on current state, not on w
    Given reset is 0
    And the current state is any symbolic state
    When w is 0
    Then z should equal z when w is 1 for the same current state