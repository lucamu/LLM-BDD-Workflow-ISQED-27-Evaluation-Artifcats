Feature: Combinational Logic - OR of b and c

  Formal verification of a purely combinational module TopModule whose
  output q depends only on inputs b and c (b OR c), and is independent
  of inputs a and d.

  Background:
    Given a combinational module TopModule with inputs a, b, c, d
    And output q is a combinational function of a, b, c, d only
    And there is no clock or reset signal

  @core-logic @or-function
  Formal Scenario: Output q equals logical OR of b and c
    Given input a is any value A
    And input b is any value B
    And input c is any value C
    And input d is any value D
    When the circuit evaluates combinationally
    Then the output q should equal B or C

  @independence @input-a
  Formal Scenario: Output q is independent of input a
    Given input b is any value B
    And input c is any value C
    And input d is any value D
    And input a is value A1 in one evaluation and value A2 in another evaluation, with A1 not equal to A2, and with B, C, D held constant across both evaluations
    When the circuit evaluates combinationally for input a equal to A1
    And the circuit evaluates combinationally for input a equal to A2
    Then the output q when a equals A1 should equal the output q when a equals A2

  @independence @input-d
  Formal Scenario: Output q is independent of input d
    Given input a is any value A
    And input b is any value B
    And input c is any value C
    And input d is value D1 in one evaluation and value D2 in another evaluation, with D1 not equal to D2, and with A, B, C held constant across both evaluations
    When the circuit evaluates combinationally for input d equal to D1
    And the circuit evaluates combinationally for input d equal to D2
    Then the output q when d equals D1 should equal the output q when d equals D2

  @boundary @both-zero
  Formal Scenario: Output q is 0 when both b and c are 0
    Given input a is any value A
    And input b is 0
    And input c is 0
    And input d is any value D
    When the circuit evaluates combinationally
    Then the output q should be 0

  @boundary @b-set
  Formal Scenario: Output q is 1 when b is 1 regardless of c
    Given input a is any value A
    And input b is 1
    And input c is any value C
    And input d is any value D
    When the circuit evaluates combinationally
    Then the output q should be 1

  @boundary @c-set
  Formal Scenario: Output q is 1 when c is 1 regardless of b
    Given input a is any value A
    And input b is any value B
    And input c is 1
    And input d is any value D
    When the circuit evaluates combinationally
    Then the output q should be 1

  @combinational @no-state
  Formal Scenario: Output q equals b OR c at every independent evaluation
    Given input a is any value A
    And input b is any value B
    And input c is any value C
    And input d is any value D
    When the circuit evaluates combinationally
    Then the output q should equal B or C
    And this equivalence should hold for every evaluation of a, b, c, d, considered independently, with no dependence on any other evaluation