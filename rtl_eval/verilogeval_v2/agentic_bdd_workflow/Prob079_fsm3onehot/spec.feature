Feature: Moore State Machine Combinational Logic (One-Hot Encoded)

  Combinational implementation of state transition and output logic for a
  4-state, one-input, one-output Moore machine using one-hot encoding:
  A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000.

  Background:
    Given the design is purely combinational with no clock or reset
    And state is a 4-bit one-hot encoded value
    And in is a single-bit input
    And next_state is a 4-bit one-hot encoded output
    And out is a single-bit output

  @state_A @transition
  Formal Scenario: State A transitions correctly based on input
    Given state equals 4'b0001
    When in equals 0
    Then next_state should equal 4'b0001
    And out should equal 0

  @state_A @transition
  Formal Scenario: State A transitions to B on input 1
    Given state equals 4'b0001
    When in equals 1
    Then next_state should equal 4'b0010
    And out should equal 0

  @state_B @transition
  Formal Scenario: State B transitions to C on input 0
    Given state equals 4'b0010
    When in equals 0
    Then next_state should equal 4'b0100
    And out should equal 0

  @state_B @transition
  Formal Scenario: State B remains in B on input 1
    Given state equals 4'b0010
    When in equals 1
    Then next_state should equal 4'b0010
    And out should equal 0

  @state_C @transition
  Formal Scenario: State C transitions to A on input 0
    Given state equals 4'b0100
    When in equals 0
    Then next_state should equal 4'b0001
    And out should equal 0

  @state_C @transition
  Formal Scenario: State C transitions to D on input 1
    Given state equals 4'b0100
    When in equals 1
    Then next_state should equal 4'b1000
    And out should equal 0

  @state_D @transition
  Formal Scenario: State D transitions to C on input 0
    Given state equals 4'b1000
    When in equals 0
    Then next_state should equal 4'b0100
    And out should equal 1

  @state_D @transition
  Formal Scenario: State D transitions to B on input 1
    Given state equals 4'b1000
    When in equals 1
    Then next_state should equal 4'b0010
    And out should equal 1

  @output_logic
  Formal Scenario: Output is asserted exactly when in state D
    Given state is any valid one-hot encoded value
    When in is any valid input value
    Then out should equal 1 if state equals 4'b1000
    And out should equal 0 if state does not equal 4'b1000

  @next_state_onehot
  Formal Scenario: Next state is always a valid one-hot encoding
    Given state is any valid one-hot encoded value
    When in is any valid input value
    Then exactly one bit of next_state should be 1
    And next_state should equal one of 4'b0001, 4'b0010, 4'b0100, 4'b1000

  @next_state_no_selfloop_undefined
  Formal Scenario: Next state depends only on current state and input
    Given state equals a fixed one-hot encoded value S
    And in equals a fixed value V
    When the combinational logic evaluates next_state and out
    Then next_state should be a deterministic function of S and V only
    And out should be a deterministic function of S only