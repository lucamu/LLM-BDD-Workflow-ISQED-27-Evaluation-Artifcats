Feature: Combinational Logic Circuit (AND of two ORs)

  The TopModule implements a purely combinational function of four
  single-bit inputs a, b, c, d producing single-bit output q.
  Based on waveform analysis, the behavior corresponds to:
      q = (a OR b) AND (c OR d)

  Background:
    Given a combinational module "TopModule" with inputs a, b, c, d
    And output q
    And no clock or reset signals are present
    And q is a pure combinational function of a, b, c, and d

  @formal @core-function
  Formal Scenario: Output equals AND of two OR terms for any input combination
    Given input a is any valid value
    And input b is any valid value
    And input c is any valid value
    And input d is any valid value
    When the circuit evaluates combinationally
    Then q should equal ((a OR b) AND (c OR d))

  @formal @edge-case
  Formal Scenario: Output is 0 when both a and b are 0 regardless of c and d
    Given input a is 0
    And input b is 0
    And input c is any valid value
    And input d is any valid value
    When the circuit evaluates combinationally
    Then q should equal 0

  @formal @edge-case
  Formal Scenario: Output is 0 when both c and d are 0 regardless of a and b
    Given input a is any valid value
    And input b is any valid value
    And input c is 0
    And input d is 0
    When the circuit evaluates combinationally
    Then q should equal 0

  @formal @edge-case
  Formal Scenario: Output is 1 when at least one of a,b is 1 and at least one of c,d is 1
    Given input a is any valid value
    And input b is any valid value
    And input c is any valid value
    And input d is any valid value
    And (a OR b) equals 1
    And (c OR d) equals 1
    When the circuit evaluates combinationally
    Then q should equal 1

  @formal @symmetry
  Formal Scenario: Output is symmetric with respect to swapping a and b
    Given input a is value A
    And input b is value B
    And input c is any valid value
    And input d is any valid value
    When the circuit evaluates combinationally with inputs (A, B, c, d)
    And the circuit evaluates combinationally with inputs (B, A, c, d)
    Then both evaluations should produce the same q

  @formal @symmetry
  Formal Scenario: Output is symmetric with respect to swapping c and d
    Given input a is any valid value
    And input b is any valid value
    And input c is value C
    And input d is value D
    When the circuit evaluates combinationally with inputs (a, b, C, D)
    And the circuit evaluates combinationally with inputs (a, b, D, C)
    Then both evaluations should produce the same q

  @formal @monotonicity
  Formal Scenario: Output is monotonic non-decreasing with respect to each input
    Given input a is value A
    And input b is value B
    And input c is value C
    And input d is value D
    And a second input set with a' >= A, b' >= B, c' >= C, d' >= D
    When the circuit evaluates combinationally for both input sets
    Then q for the second input set should be greater than or equal to q for the first input set