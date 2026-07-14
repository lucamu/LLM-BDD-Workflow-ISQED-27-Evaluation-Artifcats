Feature: Combinational XNOR-XOR Circuit
  Verify that TopModule correctly implements a two-input XNOR of in1 and
  in2, whose output feeds a two-input XOR together with in3, producing out.

  Background:
    Given a combinational module TopModule
    And inputs in1, in2, in3
    And output out
    And the internal signal xnor_result represents XNOR(in1, in2)
    And out is defined as XOR(xnor_result, in3)

  @functional @core
  Formal Scenario: Output equals XNOR-XOR composition for any inputs
    Given in1 is any value A
    And in2 is any value B
    And in3 is any value C
    When the circuit evaluates combinationally
    Then out should equal (NOT (A XOR B)) XOR C

  @functional @truth-table
  Formal Scenario: Output is 0 when in1 equals in2 and in3 is 1
    Given in1 is any value A
    And in2 equals in1
    And in3 is 1
    When the circuit evaluates combinationally
    Then out should be 0

  @functional @truth-table
  Formal Scenario: Output is 1 when in1 equals in2 and in3 is 0
    Given in1 is any value A
    And in2 equals in1
    And in3 is 0
    When the circuit evaluates combinationally
    Then out should be 1

  @functional @truth-table
  Formal Scenario: Output is 1 when in1 differs from in2 and in3 is 1
    Given in1 is any value A
    And in2 equals NOT A
    And in3 is 1
    When the circuit evaluates combinationally
    Then out should be 1

  @functional @truth-table
  Formal Scenario: Output is 0 when in1 differs from in2 and in3 is 0
    Given in1 is any value A
    And in2 equals NOT A
    And in3 is 0
    When the circuit evaluates combinationally
    Then out should be 0

  @symmetry
  Formal Scenario: Output is symmetric with respect to in1 and in2
    Given in1 is any value A
    And in2 is any value B
    And in3 is any value C
    When in1 and in2 are swapped to produce out_swapped with in1 equal to B and in2 equal to A
    Then out_swapped should equal out

  @invariant
  Formal Scenario: Output is the XOR-inverse relationship with in3 toggling
    Given in1 is any value A
    And in2 is any value B
    And in3 is any value C
    When in3 is inverted to produce out_toggled with in3 equal to NOT C
    Then out_toggled should equal NOT out

  @invariant
  Formal Scenario: Output is invariant when in1 and in2 are both inverted
    Given in1 is any value A
    And in2 is any value B
    And in3 is any value C
    When in1 is inverted to NOT A and in2 is inverted to NOT B to produce out_inverted
    Then out_inverted should equal out

  @combinational
  Formal Scenario: Output has no dependency on past values
    Given in1 is any value A
    And in2 is any value B
    And in3 is any value C
    When the circuit evaluates combinationally with no clock or state
    Then out should depend only on the current values of in1, in2, and in3