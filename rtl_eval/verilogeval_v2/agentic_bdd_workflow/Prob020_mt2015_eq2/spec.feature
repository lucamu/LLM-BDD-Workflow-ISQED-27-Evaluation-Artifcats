Feature: 2-bit Equality Comparator

  As a hardware designer
  I want to verify that TopModule correctly compares two 2-bit inputs
  So that the output z is asserted if and only if A equals B

  Background:
    Given the design is a purely combinational circuit
    And input A is a 2-bit value
    And input B is a 2-bit value
    And output z is a 1-bit value
    And there is no clock or reset signal

  @formal @core
  Formal Scenario: Output z reflects equality of A and B
    Given any value A
    And any value B
    When the circuit evaluates the inputs
    Then z should be 1 if A equals B
    And z should be 0 if A does not equal B

  @formal @equal_case
  Formal Scenario: Output z is asserted when A and B are equal
    Given a value A
    And a value B such that B equals A
    When the circuit evaluates the inputs
    Then z should be 1

  @formal @unequal_case
  Formal Scenario: Output z is deasserted when A and B differ
    Given a value A
    And a value B such that B does not equal A
    When the circuit evaluates the inputs
    Then z should be 0

  @formal @bitwise_definition
  Formal Scenario: Equality defined by matching individual bits
    Given any value A
    And any value B
    When the circuit evaluates the inputs
    Then z should be 1 if and only if bit 0 of A equals bit 0 of B and bit 1 of A equals bit 1 of B

  @formal @symmetry
  Formal Scenario: Equality comparison is symmetric
    Given any value A
    And any value B
    When the circuit evaluates A compared to B
    And the circuit evaluates B compared to A
    Then both evaluations should produce the same value of z

  @formal @reflexivity
  Formal Scenario: A value is always equal to itself
    Given any value A
    And B is set equal to A
    When the circuit evaluates the inputs
    Then z should be 1

  @formal @single_bit_difference
  Formal Scenario: Output z is 0 when only one bit differs
    Given any value A
    And a value B that differs from A in exactly one bit position
    When the circuit evaluates the inputs
    Then z should be 0

  @formal @combinational_no_state
  Formal Scenario: Output depends only on current inputs
    Given any value A
    And any value B
    When the circuit evaluates the inputs at any time step
    Then z should depend only on the current values of A and B
    And z should not depend on any previous input values