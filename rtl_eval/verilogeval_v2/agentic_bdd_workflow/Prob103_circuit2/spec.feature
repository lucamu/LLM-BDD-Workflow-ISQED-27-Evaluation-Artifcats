Feature: Four-Input XNOR (Even Parity Detector)
  The TopModule implements a combinational circuit where the output q
  is the XNOR of all four inputs (a, b, c, d). Equivalently, q is 1
  when the number of 1's among the inputs is even, and 0 when it is odd.

  Background:
    Given a combinational circuit TopModule
    And input a
    And input b
    And input c
    And input d
    And output q

  @combinational @parity
  Formal Scenario: Output is the XNOR of all four inputs
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When the circuit evaluates combinationally
    Then output q should equal the logical NOT of (A XOR B XOR C XOR D)

  @combinational @parity @even
  Formal Scenario: Output is 1 when the number of asserted inputs is even
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When the circuit evaluates combinationally
    Then output q should be 1 if the sum of A, B, C, and D is even
    And output q should be 0 if the sum of A, B, C, and D is odd

  @combinational @boundary @all-zero
  Formal Scenario: All inputs zero produces output 1
    Given input a is 0
    And input b is 0
    And input c is 0
    And input d is 0
    When the circuit evaluates combinationally
    Then output q should be 1

  @combinational @boundary @all-one
  Formal Scenario: All inputs one produces output 1
    Given input a is 1
    And input b is 1
    And input c is 1
    And input d is 1
    When the circuit evaluates combinationally
    Then output q should be 1

  @combinational @single-bit-flip
  Formal Scenario: Flipping exactly one input inverts the output
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    And the resulting output is q
    When exactly one of the inputs is inverted while the others remain unchanged
    And the circuit evaluates combinationally to produce output q_flipped
    Then q_flipped should equal the logical NOT of q

  @combinational @symmetry
  Formal Scenario: Output is invariant under permutation of inputs
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When the circuit evaluates combinationally with inputs A, B, C, D
    And the circuit evaluates combinationally with the same four values assigned in any different order to a, b, c, d
    Then both evaluations should produce the same output q