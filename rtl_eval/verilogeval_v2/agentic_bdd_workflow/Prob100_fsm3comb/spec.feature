Feature: Moore State Machine Combinational Logic (State Transition and Output)

  This is a purely combinational module implementing the next-state and
  output logic for a 4-state Moore machine. There is no clock or reset;
  next_state and out are pure functions of state and in.

  Background:
    Given the module TopModule with input "in"
    And input "state" (2 bits)
    And output "next_state" (2 bits)
    And output "out"
    And state encoding A=2'b00, B=2'b01, C=2'b10, D=2'b11

  @state_A @transition
  Formal Scenario: Next state from state A depends on input
    Given state is 2'b00
    And in is any valid value
    When the combinational logic evaluates
    Then next_state should be 2'b00 if in equals 0
    And next_state should be 2'b01 if in equals 1

  @state_B @transition
  Formal Scenario: Next state from state B depends on input
    Given state is 2'b01
    And in is any valid value
    When the combinational logic evaluates
    Then next_state should be 2'b10 if in equals 0
    And next_state should be 2'b01 if in equals 1

  @state_C @transition
  Formal Scenario: Next state from state C depends on input
    Given state is 2'b10
    And in is any valid value
    When the combinational logic evaluates
    Then next_state should be 2'b00 if in equals 0
    And next_state should be 2'b11 if in equals 1

  @state_D @transition
  Formal Scenario: Next state from state D depends on input
    Given state is 2'b11
    And in is any valid value
    When the combinational logic evaluates
    Then next_state should be 2'b10 if in equals 0
    And next_state should be 2'b01 if in equals 1

  @state_A @output
  Formal Scenario: Output is 0 in state A regardless of input
    Given state is 2'b00
    And in is any valid value
    When the combinational logic evaluates
    Then out should be 0

  @state_B @output
  Formal Scenario: Output is 0 in state B regardless of input
    Given state is 2'b01
    And in is any valid value
    When the combinational logic evaluates
    Then out should be 0

  @state_C @output
  Formal Scenario: Output is 0 in state C regardless of input
    Given state is 2'b10
    And in is any valid value
    When the combinational logic evaluates
    Then out should be 0

  @state_D @output
  Formal Scenario: Output is 1 in state D regardless of input
    Given state is 2'b11
    And in is any valid value
    When the combinational logic evaluates
    Then out should be 1

  @output_function
  Formal Scenario: Output depends only on current state, not input
    Given state is any valid value
    And in takes value 0
    When the combinational logic evaluates and out is captured as out0
    Given the same state value
    And in takes value 1
    When the combinational logic evaluates and out is captured as out1
    Then out0 should equal out1

  @next_state_validity
  Formal Scenario: Next state is always one of the four valid encoded states
    Given state is any valid value
    And in is any valid value
    When the combinational logic evaluates
    Then next_state should equal 2'b00 or 2'b01 or 2'b10 or 2'b11

  @combinational_purity
  Formal Scenario: Outputs depend only on current inputs with no memory
    Given state is any valid value
    And in is any valid value
    When the combinational logic evaluates twice with identical inputs
    Then next_state should be identical on both evaluations
    And out should be identical on both evaluations