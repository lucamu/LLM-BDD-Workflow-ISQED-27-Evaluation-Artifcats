Feature: Combinational Moore FSM Controller (One-Hot State Encoding)

  As a hardware designer
  I want to verify the combinational next-state and output logic of a
  10-state one-hot encoded Moore machine
  So that the design correctly reflects state transitions and outputs for
  any valid or multi-hot combination of the symbolic state vector

  Background:
    Given a combinational module "TopModule" with input "in"
    And a 10-bit input vector "state" with bits state[0] through state[9]
    And a 10-bit output vector "next_state" with bits next_state[0] through next_state[9]
    And output signals "out1" and "out2"
    And no clock or reset signals exist in this design
    And each state bit state[i] may independently be 0 or 1 (multi-hot allowed)

  @next_state @S0
  Formal Scenario: Next state bit 0 logic (transition to S0)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[0] is evaluated
    Then next_state[0] should equal (state0 OR state1 OR state2 OR state3 OR state4 OR state7 OR state8 OR state9) AND (NOT in)

  @next_state @S1
  Formal Scenario: Next state bit 1 logic (transition to S1)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[1] is evaluated
    Then next_state[1] should equal (state0 OR state8 OR state9) AND in

  @next_state @S2
  Formal Scenario: Next state bit 2 logic (transition to S2)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[2] is evaluated
    Then next_state[2] should equal state1 AND in

  @next_state @S3
  Formal Scenario: Next state bit 3 logic (transition to S3)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[3] is evaluated
    Then next_state[3] should equal state2 AND in

  @next_state @S4
  Formal Scenario: Next state bit 4 logic (transition to S4)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[4] is evaluated
    Then next_state[4] should equal state3 AND in

  @next_state @S5
  Formal Scenario: Next state bit 5 logic (transition to S5)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[5] is evaluated
    Then next_state[5] should equal state4 AND in

  @next_state @S6
  Formal Scenario: Next state bit 6 logic (transition to S6)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[6] is evaluated
    Then next_state[6] should equal state5 AND in

  @next_state @S7
  Formal Scenario: Next state bit 7 logic (transition to S7)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[7] is evaluated
    Then next_state[7] should equal (state6 OR state7) AND in

  @next_state @S8
  Formal Scenario: Next state bit 8 logic (transition to S8)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[8] is evaluated
    Then next_state[8] should equal state5 AND (NOT in)

  @next_state @S9
  Formal Scenario: Next state bit 9 logic (transition to S9)
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[9] is evaluated
    Then next_state[9] should equal state6 AND (NOT in)

  @output @out1
  Formal Scenario: Output out1 combinational logic
    Given state bits state0 through state9 representing state[0] through state[9]
    When out1 is evaluated
    Then out1 should equal state8 OR state9

  @output @out2
  Formal Scenario: Output out2 combinational logic
    Given state bits state0 through state9 representing state[0] through state[9]
    When out2 is evaluated
    Then out2 should equal state7 OR state9

  @output @independence
  Formal Scenario: Outputs are independent of input in
    Given state bits state0 through state9 representing state[0] through state[9]
    And two evaluations of the module with identical state vectors, one with in fixed to 0 and one with in fixed to 1
    When out1 and out2 are evaluated for both the in=0 case and the in=1 case
    Then out1 evaluated with in=0 should equal out1 evaluated with in=1 for the same state vector
    And out2 evaluated with in=0 should equal out2 evaluated with in=1 for the same state vector
    And this equivalence should assert that out1 equals (state8 OR state9) and out2 equals (state7 OR state9) in both cases

  @next_state @multihot
  Formal Scenario: Next state logic holds under multi-hot state combinations
    Given state bits state0 through state9 representing state[0] through state[9]
    And more than one state bit may be 1 simultaneously
    And input value "in"
    When next_state[9:0] is evaluated
    Then next_state[0] should equal (state0 OR state1 OR state2 OR state3 OR state4 OR state7 OR state8 OR state9) AND (NOT in)
    And next_state[1] should equal (state0 OR state8 OR state9) AND in
    And next_state[2] should equal state1 AND in
    And next_state[3] should equal state2 AND in
    And next_state[4] should equal state3 AND in
    And next_state[5] should equal state4 AND in
    And next_state[6] should equal state5 AND in
    And next_state[7] should equal (state6 OR state7) AND in
    And next_state[8] should equal state5 AND (NOT in)
    And next_state[9] should equal state6 AND (NOT in)

  @completeness
  Formal Scenario: Next state vector has no undefined bits
    Given state bits state0 through state9 representing state[0] through state[9]
    And input value "in"
    When next_state[9:0] is evaluated
    Then assert property (!$isunknown(next_state))