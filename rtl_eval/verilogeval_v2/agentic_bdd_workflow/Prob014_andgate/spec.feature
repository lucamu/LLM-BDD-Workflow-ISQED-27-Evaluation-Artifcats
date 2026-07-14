Feature: 2-Input AND Gate (TopModule)
  Formal verification of a purely combinational 2-input AND gate.
  The output must at all times equal the logical AND of the two inputs,
  with no dependency on clock, reset, or prior state.

  Background:
    Given the design is a combinational module with no clock or reset
    And input a is a 1-bit signal
    And input b is a 1-bit signal
    And output out is a 1-bit signal
    And out is driven combinationally as a function of a and b only

  @combinational @functional @core
  Formal Scenario: Output equals logical AND of inputs for any values
    Given input a is any valid 1-bit value A
    And input b is any valid 1-bit value B
    When the combinational logic evaluates
    Then out should be equal to (A and B)

  @combinational @functional @edge
  Formal Scenario: Output is 0 when a is 0 regardless of b
    Given input a is 0
    And input b is any valid 1-bit value B
    When the combinational logic evaluates
    Then out should be 0

  @combinational @functional @edge
  Formal Scenario: Output is 0 when b is 0 regardless of a
    Given input a is any valid 1-bit value A
    And input b is 0
    When the combinational logic evaluates
    Then out should be 0

  @combinational @functional @edge
  Formal Scenario: Output is 1 only when both inputs are 1
    Given input a is 1
    And input b is 1
    When the combinational logic evaluates
    Then out should be 1

  @combinational @invariant @no_state
  Formal Scenario: Output has no memory of previous input values
    Given input a is any valid 1-bit value A
    And input b is any valid 1-bit value B
    When the inputs change to any new values A2 and B2 on the next evaluation
    Then out should be equal to (A2 and B2)
    And out should not depend on the previous values of a or b

  @combinational @invariant @commutative
  Formal Scenario: AND operation is commutative
    Given input a is any valid 1-bit value A
    And input b is any valid 1-bit value B
    When the combinational logic evaluates with a = A and b = B
    And the combinational logic evaluates with a = B and b = A
    Then both evaluations should produce the same out value