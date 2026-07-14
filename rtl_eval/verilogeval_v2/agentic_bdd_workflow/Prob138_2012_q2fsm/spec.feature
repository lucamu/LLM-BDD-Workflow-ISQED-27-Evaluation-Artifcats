Feature: Moore FSM State Machine with 6 States (A-F)

  Formal verification of a synchronous Moore state machine with states
  A, B, C, D, E, F. States E and F produce z=1; all others produce z=0.
  State transitions are determined by input w. Reset is synchronous
  active-high and forces the machine to state A.

  Background:
    Given the design is TopModule
    And clk is the clock signal
    And reset is synchronous active-high
    And all sequential logic updates on the positive edge of clk

  @reset
  Formal Scenario: Synchronous reset forces state A and output 0
    Given the current state is any valid state
    And reset is 1
    When a positive clock edge occurs
    Then the next state should be state A
    And z should be 0 in state A

  @state_A @output
  Formal Scenario: Output is 0 in state A
    Given reset is 0
    And the current state is state A
    Then z should be 0

  @state_A @transition
  Formal Scenario: State A transitions correctly on w
    Given reset is 0
    And the current state is state A
    And w is any valid value
    When a positive clock edge occurs
    Then the next state should be state B if w equals 1
    And the next state should be state A if w equals 0

  @state_B @output
  Formal Scenario: Output is 0 in state B
    Given reset is 0
    And the current state is state B
    Then z should be 0

  @state_B @transition
  Formal Scenario: State B transitions correctly on w
    Given reset is 0
    And the current state is state B
    And w is any valid value
    When a positive clock edge occurs
    Then the next state should be state C if w equals 1
    And the next state should be state D if w equals 0

  @state_C @output
  Formal Scenario: Output is 0 in state C
    Given reset is 0
    And the current state is state C
    Then z should be 0

  @state_C @transition
  Formal Scenario: State C transitions correctly on w
    Given reset is 0
    And the current state is state C
    And w is any valid value
    When a positive clock edge occurs
    Then the next state should be state E if w equals 1
    And the next state should be state D if w equals 0

  @state_D @output
  Formal Scenario: Output is 0 in state D
    Given reset is 0
    And the current state is state D
    Then z should be 0

  @state_D @transition
  Formal Scenario: State D transitions correctly on w
    Given reset is 0
    And the current state is state D
    And w is any valid value
    When a positive clock edge occurs
    Then the next state should be state F if w equals 1
    And the next state should be state A if w equals 0

  @state_E @output
  Formal Scenario: Output is 1 in state E
    Given reset is 0
    And the current state is state E
    Then z should be 1

  @state_E @transition
  Formal Scenario: State E transitions correctly on w
    Given reset is 0
    And the current state is state E
    And w is any valid value
    When a positive clock edge occurs
    Then the next state should be state E if w equals 1
    And the next state should be state D if w equals 0

  @state_F @output
  Formal Scenario: Output is 1 in state F
    Given reset is 0
    And the current state is state F
    Then z should be 1

  @state_F @transition
  Formal Scenario: State F transitions correctly on w
    Given reset is 0
    And the current state is state F
    And w is any valid value
    When a positive clock edge occurs
    Then the next state should be state C if w equals 1
    And the next state should be state D if w equals 0

  @output_consistency
  Formal Scenario: Output z depends only on current state
    Given reset is 0
    And the current state is any valid state
    And w is any valid value
    Then z should be 1 if the current state is state E or state F
    And z should be 0 if the current state is state A, state B, state C, or state D

  @reachability @cover
  Cover Scenario: All states are reachable from reset (existential, SVA cover property)
    Given the machine starts in state A after reset
    And w is driven with free, unconstrained values over multiple clock cycles
    Then there should exist a reachable sequence of clock edges and w values such that state B is visited
    And there should exist a reachable sequence of clock edges and w values such that state C is visited
    And there should exist a reachable sequence of clock edges and w values such that state D is visited
    And there should exist a reachable sequence of clock edges and w values such that state E is visited
    And there should exist a reachable sequence of clock edges and w values such that state F is visited

  @totality @deadlock_freedom
  Formal Scenario: Every state has a fully defined transition for both values of w
    Given reset is 0
    And the current state is any valid state
    Then a defined next state should exist when w equals 0
    And a defined next state should exist when w equals 1
    And the defined next state should always be one of state A, state B, state C, state D, state E, or state F