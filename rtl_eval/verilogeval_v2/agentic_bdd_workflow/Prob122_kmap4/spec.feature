Feature: 4-Input XOR (Parity) Combinational Logic

  Verify that TopModule implements the Karnaugh map, which reduces to
  the logical function: out = a XOR b XOR c XOR d (odd parity function).

  Background:
    Given the design is purely combinational with no clock or reset
    And inputs a, b, c, d are single-bit signals
    And output out is a single-bit signal

  @core-function
  Formal Scenario: Output equals the XOR of all four inputs
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When the combinational logic evaluates
    Then out should equal A ^ B ^ C ^ D

  @kmap-row-cd00
  Formal Scenario: Row cd=00 matches K-map pattern
    Given input c is 0
    And input d is 0
    And input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates
    Then out should equal A ^ B

  @kmap-row-cd01
  Formal Scenario: Row cd=01 matches K-map pattern
    Given input c is 0
    And input d is 1
    And input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates
    Then out should equal (A ^ B) ^ 1

  @kmap-row-cd11
  Formal Scenario: Row cd=11 matches K-map pattern
    Given input c is 1
    And input d is 1
    And input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates
    Then out should equal A ^ B

  @kmap-row-cd10
  Formal Scenario: Row cd=10 matches K-map pattern
    Given input c is 1
    And input d is 0
    And input a is any valid value A
    And input b is any valid value B
    When the combinational logic evaluates
    Then out should equal (A ^ B) ^ 1

  @symmetry-ab
  Formal Scenario: Output is symmetric under simultaneous complement of a and b
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When input a is replaced with the complement of A
    And input b is replaced with the complement of B
    And the combinational logic evaluates
    Then out should equal the original out for A, B, C, D

  @symmetry-cd
  Formal Scenario: Output is symmetric under simultaneous complement of c and d
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When input c is replaced with the complement of C
    And input d is replaced with the complement of D
    And the combinational logic evaluates
    Then out should equal the original out for A, B, C, D

  @toggle-single-bit
  Formal Scenario: Flipping any single input inverts the output
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When exactly one of the four inputs is complemented
    And the combinational logic evaluates
    Then out should equal the complement of the original out for A, B, C, D

  @no-combinational-loop
  Formal Scenario: Output has no dependency beyond the four inputs
    Given input a is any valid value A
    And input b is any valid value B
    And input c is any valid value C
    And input d is any valid value D
    When the combinational logic evaluates twice with identical A, B, C, D
    Then out should be identical on both evaluations