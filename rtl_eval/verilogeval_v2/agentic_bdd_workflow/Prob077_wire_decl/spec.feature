Feature: TopModule Combinational Logic - AND-OR-NOT Circuit

  As a hardware designer
  I want to verify the TopModule implements two AND gates feeding an OR gate,
  with an inverted output, exactly as specified
  So that out = (a AND b) OR (c AND d) and out_n = NOT(out)

  Background:
    Given the design is combinational with no clock or reset
    And input a is any valid value
    And input b is any valid value
    And input c is any valid value
    And input d is any valid value
    And the first AND gate computes the AND of a and b
    And the second AND gate computes the AND of c and d
    And the OR gate computes the OR of the two AND gate outputs
    And this OR gate output drives out
    And the NOT gate inverts out to produce out_n

  @combinational @core-logic
  Formal Scenario: Output out equals OR of two AND terms
    Given input a, input b, input c, input d hold arbitrary values
    When the circuit evaluates combinationally
    Then out should equal (a AND b) OR (c AND d)

  @combinational @core-logic
  Formal Scenario: Output out_n is the logical inverse of out
    Given input a, input b, input c, input d hold arbitrary values
    When the circuit evaluates combinationally
    Then out_n should equal NOT(out)

  @combinational @consistency
  Formal Scenario: out and out_n are always complementary
    Given input a, input b, input c, input d hold arbitrary values
    When the circuit evaluates combinationally
    Then out XOR out_n should always equal 1

  @combinational @edge-case
  Formal Scenario: Out is 1 only when first AND term is asserted regardless of second term
    Given a equals 1 and b equals 1
    And c and d hold arbitrary values
    When the circuit evaluates combinationally
    Then out should equal 1
    And out_n should equal 0

  @combinational @edge-case
  Formal Scenario: Out is 1 only when second AND term is asserted regardless of first term
    Given c equals 1 and d equals 1
    And a and b hold arbitrary values
    When the circuit evaluates combinationally
    Then out should equal 1
    And out_n should equal 0

  @combinational @edge-case
  Formal Scenario: Out is 0 when both AND terms are deasserted
    Given a equals 0 or b equals 0
    And c equals 0 or d equals 0
    When the circuit evaluates combinationally
    Then out should equal 0
    And out_n should equal 1

  @combinational @sensitivity
  Formal Scenario: Out is insensitive to c and d when first AND term is deasserted and second term forces the result
    Given a and b hold arbitrary values such that (a AND b) equals 0
    And c equals 1 and d equals 1
    When the circuit evaluates combinationally
    Then out should equal 1

  @combinational @sensitivity
  Formal Scenario: Out is insensitive to a and b when second AND term is deasserted and first term forces the result
    Given c and d hold arbitrary values such that (c AND d) equals 0
    And a equals 1 and b equals 1
    When the circuit evaluates combinationally
    Then out should equal 1