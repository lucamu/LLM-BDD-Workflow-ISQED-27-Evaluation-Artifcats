Feature: 100-bit Reduction Gates (AND, OR, XOR)

  This module implements a purely combinational circuit that computes
  the 100-input AND reduction, OR reduction, and XOR reduction of the
  input vector in[99:0]. There is no clock or reset; outputs must be
  valid functions of the current input vector at all times.

  Background:
    Given the design is combinational with no clock or reset
    And an input vector "in" of 100 bits
    And an output "out_and" representing the AND reduction of all bits of "in"
    And an output "out_or" representing the OR reduction of all bits of "in"
    And an output "out_xor" representing the XOR reduction of all bits of "in"

  @and_reduction @all_ones
  Formal Scenario: AND output is 1 only when all input bits are 1
    Given an arbitrary input vector "in"
    When all 100 bits of "in" are equal to 1
    Then out_and should be 1

  @and_reduction @any_zero
  Formal Scenario: AND output is 0 if any input bit is 0
    Given an arbitrary input vector "in"
    When at least one bit of "in" is equal to 0
    Then out_and should be 0

  @and_reduction @functional_equivalence
  Formal Scenario: AND output equals reduction AND of all input bits
    Given an arbitrary input vector "in"
    When the circuit evaluates its outputs
    Then out_and should equal the logical AND of all 100 bits of "in"

  @or_reduction @all_zeros
  Formal Scenario: OR output is 0 only when all input bits are 0
    Given an arbitrary input vector "in"
    When all 100 bits of "in" are equal to 0
    Then out_or should be 0

  @or_reduction @any_one
  Formal Scenario: OR output is 1 if any input bit is 1
    Given an arbitrary input vector "in"
    When at least one bit of "in" is equal to 1
    Then out_or should be 1

  @or_reduction @functional_equivalence
  Formal Scenario: OR output equals reduction OR of all input bits
    Given an arbitrary input vector "in"
    When the circuit evaluates its outputs
    Then out_or should equal the logical OR of all 100 bits of "in"

  @xor_reduction @parity
  Formal Scenario: XOR output equals parity of all input bits
    Given an arbitrary input vector "in"
    When the circuit evaluates its outputs
    Then out_xor should equal the logical XOR (parity) of all 100 bits of "in"

  @xor_reduction @even_ones_count
  Formal Scenario: XOR output is 0 when the number of 1 bits in input is even
    Given an arbitrary input vector "in"
    When the count of bits in "in" equal to 1 is even
    Then out_xor should be 0

  @xor_reduction @odd_ones_count
  Formal Scenario: XOR output is 1 when the number of 1 bits in input is odd
    Given an arbitrary input vector "in"
    When the count of bits in "in" equal to 1 is odd
    Then out_xor should be 1

  @combinational_purity
  Formal Scenario: Outputs depend only on current input, with no internal state
    Given two arbitrary input vectors "in" evaluated at different times
    When the input vector "in" is identical at both times
    Then out_and should be identical at both times
    And out_or should be identical at both times
    And out_xor should be identical at both times

  @independence_of_bit_order
  Formal Scenario: Each output is a pure combinational function of the 100 input bits
    Given an arbitrary input vector "in"
    When any single bit of "in" changes value
    Then out_and, out_or, and out_xor should be recomputed as functions of the new "in" value
    And no output should retain any value from a previous input vector