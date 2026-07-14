Feature: Next-State Logic for FSM Bit y[1]
  This module implements only the combinational next-state logic for bit
  y[1] of a 6-state Moore FSM (states A..F) encoded in 3-bit vector y.
  The module has no clock or reset. Y1 represents the next-state value
  of y[1] as a function of the current state y and input w.

  State encoding:
    A = 3'b000, B = 3'b001, C = 3'b010,
    D = 3'b011, E = 3'b100, F = 3'b101

  Background:
    Given a combinational module TopModule with 3-bit input y, 1-bit input w, and output Y1
    And y encodes the current FSM state
    And w is an unconstrained single-bit input
    And Y1 is the next-state value of bit y[1] as defined by the state transition table

  @state_A @next_state_y1
  Formal Scenario: Next-state y[1] from state A is always 0
    Given the current state y is 3'b000 representing state A
    And w may take any value
    Then Y1 should be 0 regardless of w

  @state_B @next_state_y1
  Formal Scenario: Next-state y[1] from state B is always 1
    Given the current state y is 3'b001 representing state B
    And w may take any value
    Then Y1 should be 1 regardless of w

  @state_C @next_state_y1
  Formal Scenario: Next-state y[1] from state C depends on w
    Given the current state y is 3'b010 representing state C
    And w may take any value
    Then Y1 should equal w

  @state_D @next_state_y1
  Formal Scenario: Next-state y[1] from state D is always 0
    Given the current state y is 3'b011 representing state D
    And w may take any value
    Then Y1 should be 0 regardless of w

  @state_E @next_state_y1
  Formal Scenario: Next-state y[1] from state E depends on w
    Given the current state y is 3'b100 representing state E
    And w may take any value
    Then Y1 should equal w

  @state_F @next_state_y1
  Formal Scenario: Next-state y[1] from state F is always 1
    Given the current state y is 3'b101 representing state F
    And w may take any value
    Then Y1 should be 1 regardless of w

  @unused_states @next_state_y1
  Formal Scenario: Unused state encodings do not constrain Y1
    Given the current state y is 3'b110 or 3'b111 which are unused encodings
    And w may take any value
    Then Y1 may take any value since these states are unreachable and unconstrained