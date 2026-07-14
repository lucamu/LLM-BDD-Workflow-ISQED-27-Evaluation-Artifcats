Feature: TopModule Next-State Logic for One-Hot Encoded State Machine (Y1, Y3)

  This module implements combinational next-state logic for a one-hot
  encoded 6-state finite state machine (states A-F encoded as
  y[0]-y[5] respectively). Y1 represents the next-state value for
  state bit y[1] (state B), and Y3 represents the next-state value
  for state bit y[3] (state D). These are derived by inspection from
  the state transition diagram:

    A(y0) --0--> B    B(y1) --0--> C    C(y2) --0--> E
    A(y0) --1--> A    B(y1) --1--> D    C(y2) --1--> D
    D(y3) --0--> F    E(y4) --0--> E    F(y5) --0--> C
    D(y3) --1--> A    E(y4) --1--> D    F(y5) --1--> D

  Derived equations:
    Y1 = y[0] & ~w                          (only A->B transition)
    Y3 = w & (y[1] | y[2] | y[4] | y[5])    (B,C,E,F -> D transitions)

  Background:
    Given the design is a purely combinational module
    And the input state vector is y (6 bits), one-hot encoded
    And the input is w
    And the output Y1 is the next-state signal for state bit y[1] (state B)
    And the output Y3 is the next-state signal for state bit y[3] (state D)

  @Y1_logic @combinational
  Formal Scenario: Y1 equals AND of y[0] and complement of w
    Given a current state vector y
    And an input w
    When the combinational logic evaluates Y1
    Then Y1 should equal y[0] AND (NOT w)

  @Y1_logic @transition_A_to_B
  Formal Scenario: Y1 asserted only when in state A with w=0
    Given the current state vector y equals 6'b000001 representing state A
    And the input w equals 0
    When the combinational logic evaluates Y1
    Then Y1 should equal 1

  @Y1_logic @transition_A_self_loop
  Formal Scenario: Y1 deasserted when in state A with w=1
    Given the current state vector y equals 6'b000001 representing state A
    And the input w equals 1
    When the combinational logic evaluates Y1
    Then Y1 should equal 0

  @Y1_logic @non_A_states
  Formal Scenario: Y1 deasserted whenever current state is not A regardless of w
    Given the current state vector y has y[0] equal to 0
    And an input w
    When the combinational logic evaluates Y1
    Then Y1 should equal 0

  @Y3_logic @combinational
  Formal Scenario: Y3 equals AND of w and OR of y[1], y[2], y[4], y[5]
    Given a current state vector y
    And an input w
    When the combinational logic evaluates Y3
    Then Y3 should equal w AND (y[1] OR y[2] OR y[4] OR y[5])

  @Y3_logic @transition_B_to_D
  Formal Scenario: Y3 asserted when in state B with w=1
    Given the current state vector y equals 6'b000010 representing state B
    And the input w equals 1
    When the combinational logic evaluates Y3
    Then Y3 should equal 1

  @Y3_logic @transition_C_to_D
  Formal Scenario: Y3 asserted when in state C with w=1
    Given the current state vector y equals 6'b000100 representing state C
    And the input w equals 1
    When the combinational logic evaluates Y3
    Then Y3 should equal 1

  @Y3_logic @transition_E_to_D
  Formal Scenario: Y3 asserted when in state E with w=1
    Given the current state vector y equals 6'b010000 representing state E
    And the input w equals 1
    When the combinational logic evaluates Y3
    Then Y3 should equal 1

  @Y3_logic @transition_F_to_D
  Formal Scenario: Y3 asserted when in state F with w=1
    Given the current state vector y equals 6'b100000 representing state F
    And the input w equals 1
    When the combinational logic evaluates Y3
    Then Y3 should equal 1

  @Y3_logic @transition_D_to_A_not_D
  Formal Scenario: Y3 deasserted when in state D with w=1 since D goes to A
    Given the current state vector y equals 6'b001000 representing state D
    And the input w equals 1
    When the combinational logic evaluates Y3
    Then Y3 should equal 0

  @Y3_logic @w_zero_never_transitions_to_D
  Formal Scenario: Y3 deasserted whenever w equals 0 regardless of current state
    Given a current state vector y
    And the input w equals 0
    When the combinational logic evaluates Y3
    Then Y3 should equal 0

  @Y3_logic @non_contributing_states
  Formal Scenario: Y3 deasserted when current state is A or D with w=1
    Given the current state vector y has y[1] equal to 0
    And the current state vector y has y[2] equal to 0
    And the current state vector y has y[4] equal to 0
    And the current state vector y has y[5] equal to 0
    And the input w equals 1
    When the combinational logic evaluates Y3
    Then Y3 should equal 0

  @combinational @no_state_registers
  Formal Scenario: Outputs Y1 and Y3 depend only on current inputs with no memory
    Given a current state vector y
    And an input w
    When the same input values y and w are applied at any time
    Then Y1 should be identical for identical y and w
    And Y3 should be identical for identical y and w

  @mutual_exclusivity @one_hot_assumption
  Formal Scenario: Y1 and Y3 cannot both be asserted simultaneously under one-hot encoding
    Given a current state vector y that is one-hot encoded with exactly one bit set
    And an input w
    When the combinational logic evaluates Y1 and Y3
    Then it should not be the case that Y1 equals 1 and Y3 equals 1 at the same time