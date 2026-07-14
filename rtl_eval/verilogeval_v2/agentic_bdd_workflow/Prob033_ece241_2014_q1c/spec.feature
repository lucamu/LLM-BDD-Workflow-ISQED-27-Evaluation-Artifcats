Feature: 8-bit Two's Complement Adder with Overflow Detection

  As a hardware designer
  I want an 8-bit adder that computes signed sum and overflow flag
  So that arithmetic operations on 2's complement numbers are correctly detected for overflow

  Background:
    Given a combinational module named TopModule
    And an 8-bit input a representing a signed 2's complement number
    And an 8-bit input b representing a signed 2's complement number
    And an 8-bit output s representing the sum of a and b
    And a 1-bit output overflow indicating signed overflow

  @sum_correctness
  Formal Scenario: Sum output equals truncated addition of inputs
    Given operand A is any 8-bit value
    And operand B is any 8-bit value
    When the module computes the sum
    Then s should equal (A + B) truncated to 8 bits

  @overflow_positive_plus_positive
  Formal Scenario: Overflow detected when adding two positive numbers yields a negative result
    Given operand A is any 8-bit value with most significant bit 0
    And operand B is any 8-bit value with most significant bit 0
    When the module computes the sum
    Then overflow should be 1 if the most significant bit of s is 1
    And overflow should be 0 if the most significant bit of s is 0

  @overflow_negative_plus_negative
  Formal Scenario: Overflow detected when adding two negative numbers yields a positive result
    Given operand A is any 8-bit value with most significant bit 1
    And operand B is any 8-bit value with most significant bit 1
    When the module computes the sum
    Then overflow should be 1 if the most significant bit of s is 0
    And overflow should be 0 if the most significant bit of s is 1

  @no_overflow_mixed_signs
  Formal Scenario: No overflow occurs when operands have different signs
    Given operand A is any 8-bit value with most significant bit 0
    And operand B is any 8-bit value with most significant bit 1
    When the module computes the sum
    Then overflow should be 0

  @no_overflow_mixed_signs_reversed
  Formal Scenario: No overflow occurs when operands have opposite signs regardless of order
    Given operand A is any 8-bit value with most significant bit 1
    And operand B is any 8-bit value with most significant bit 0
    When the module computes the sum
    Then overflow should be 0

  @overflow_general_definition
  Formal Scenario: Overflow equals XOR of carry into and out of sign bit
    Given operand A is any 8-bit value
    And operand B is any 8-bit value
    When the module computes the sum
    Then overflow should equal 1 if and only if the sign bit of A equals the sign bit of B and the sign bit of s differs from the sign bit of A

  @zero_addition_identity
  Formal Scenario: Adding zero produces the original operand with no overflow
    Given operand A is any 8-bit value
    And operand B is the constant 8'b00000000
    When the module computes the sum
    Then s should equal A
    And overflow should be 0

  @commutativity
  Formal Scenario: Sum and overflow are commutative with respect to operand order
    Given operand A is any 8-bit value
    And operand B is any 8-bit value
    When the module computes the sum with inputs A and B
    And the module separately computes the sum with inputs B and A
    Then both computations should produce the same s
    And both computations should produce the same overflow

  @max_positive_overflow_boundary
  Formal Scenario: Overflow boundary check when adding maximum positive value to itself
    Given operand A is the constant 8'b01111111
    And operand B is the constant 8'b01111111
    When the module computes the sum
    Then s should equal 8'b11111110
    And overflow should be 1

  @min_negative_overflow_boundary
  Formal Scenario: Overflow boundary check when adding minimum negative value to itself
    Given operand A is the constant 8'b10000000
    And operand B is the constant 8'b10000000
    When the module computes the sum
    Then s should equal 8'b00000000
    And overflow should be 1