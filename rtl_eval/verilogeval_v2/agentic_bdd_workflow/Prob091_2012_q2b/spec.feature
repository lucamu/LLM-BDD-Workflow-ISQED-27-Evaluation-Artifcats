Feature: Combinational State Output Logic for One-Hot Encoded FSM

  This module implements the next-state flip-flop input logic (Y1 and Y3)
  for a one-hot encoded Moore FSM with states A(y[0]) through F(y[5]).
  Y1 drives flip-flop y[1] (state B), Y3 drives flip-flop y[3] (state D).
  The logic is purely combinational, derived by inspection from the
  state transition table.

  Background:
    Given a combinational module TopModule with input y[5:0], input w
    And outputs Y1 and Y3
    And y is a one-hot encoded state vector where exactly one bit is 1
    And y[0] represents state A, y[1] represents state B, y[2] represents state C
    And y[3] represents state D, y[4] represents state E, y[5] represents state F

  @combinational @Y1
  Formal Scenario: Y1 asserted only when in state A with input w high
    Given the current state y is state A (y[0]=1, all other bits 0)
    And w is a value W
    When the combinational logic evaluates Y1
    Then Y1 should equal W

  @combinational @Y1
  Formal Scenario: Y1 deasserted when not in state A regardless of w
    Given the current state y is any state other than A (y[0]=0)
    And w is a value W
    When the combinational logic evaluates Y1
    Then Y1 should equal 0

  @combinational @Y1
  Formal Scenario: Y1 general symbolic equation
    Given the current state y is any valid one-hot state
    And w is a value W
    When the combinational logic evaluates Y1
    Then Y1 should equal y[0] AND W

  @combinational @Y3
  Formal Scenario: Y3 asserted when in state B, C, E, or F with w low
    Given the current state y is state B, state C, state E, or state F
    And w is a value W
    When the combinational logic evaluates Y3
    Then Y3 should equal NOT W

  @combinational @Y3
  Formal Scenario: Y3 deasserted when in state A or state D regardless of w
    Given the current state y is state A or state D
    And w is a value W
    When the combinational logic evaluates Y3
    Then Y3 should equal 0

  @combinational @Y3
  Formal Scenario: Y3 general symbolic equation
    Given the current state y is any valid one-hot state
    And w is a value W
    When the combinational logic evaluates Y3
    Then Y3 should equal (y[1] OR y[2] OR y[4] OR y[5]) AND (NOT W)

  @combinational @onehot @consistency
  Formal Scenario: Y1 and Y3 are never simultaneously asserted
    Given the current state y is any valid one-hot state
    And w is a value W
    When the combinational logic evaluates Y1 and Y3
    Then Y1 AND Y3 should equal 0

  @combinational @invalid_state
  Formal Scenario: Y1 and Y3 outputs when y is not one-hot are governed by the same equations
    Given the current state y is an arbitrary 6-bit vector that may not be one-hot
    And w is a value W
    When the combinational logic evaluates Y1 and Y3
    Then Y1 should equal y[0] AND W
    And Y3 should equal (y[1] OR y[2] OR y[4] OR y[5]) AND (NOT W)