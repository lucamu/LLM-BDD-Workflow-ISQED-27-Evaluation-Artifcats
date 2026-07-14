Feature: Combinational Logic - 3-Input OR Function

  Verify that TopModule implements the Karnaugh map behavior, which
  simplifies to the logical OR of all three inputs: out = a | b | c.
  The output is 0 only when a=0, b=0, c=0; otherwise the output is 1.

  Background:
    Given a combinational module TopModule
    And input a
    And input b
    And input c
    And output out

  @combinational @core-function
  Formal Scenario: Output equals logical OR of all three inputs
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    When the circuit evaluates combinationally
    Then out should equal (A | B | C)

  @combinational @edge-case
  Formal Scenario: Output is zero only when all inputs are zero
    Given input a is 1'b0
    And input b is 1'b0
    And input c is 1'b0
    When the circuit evaluates combinationally
    Then out should equal 1'b0

  @combinational @edge-case
  Formal Scenario: Output is one when a is asserted regardless of b and c
    Given input a is 1'b1
    And input b is any valid value B
    And input c is any valid value C
    When the circuit evaluates combinationally
    Then out should equal 1'b1

  @combinational @edge-case
  Formal Scenario: Output is one when b is asserted regardless of a and c
    Given input a is any valid value A
    And input b is 1'b1
    And input c is any valid value C
    When the circuit evaluates combinationally
    Then out should equal 1'b1

  @combinational @edge-case
  Formal Scenario: Output is one when c is asserted regardless of a and b
    Given input a is any valid value A
    And input b is any valid value B
    And input c is 1'b1
    When the circuit evaluates combinationally
    Then out should equal 1'b1

  @combinational @consistency
  Formal Scenario: Output never depends on any hidden state
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    When the circuit evaluates combinationally twice with identical inputs
    Then out should be identical on both evaluations