Feature: Population Count Circuit (TopModule)
  The TopModule computes the number of '1' bits present in the 3-bit
  input vector `in` and reports the count on the 2-bit output `out`.
  This is a purely combinational function: out = popcount(in).

  Background:
    Given a combinational module TopModule
    And a 3-bit input "in"
    And a 2-bit output "out"
    And no clock or reset signals are used
    And "out" is driven only as a function of the current value of "in"

  @core @popcount_definition
  Formal Scenario: Output equals the exact number of set bits in the input
    Given an arbitrary 3-bit value IN assigned to "in"
    When the combinational logic evaluates
    Then "out" should equal the number of bits in IN that are 1
    And "out" should equal IN[0] + IN[1] + IN[2]

  @boundary @all_zero
  Formal Scenario: All-zero input produces a zero count
    Given "in" is 3'b000
    When the combinational logic evaluates
    Then "out" should equal 2'b00

  @boundary @all_one
  Formal Scenario: All-one input produces the maximum count
    Given "in" is 3'b111
    When the combinational logic evaluates
    Then "out" should equal 2'b11

  @single_bit @bit0
  Formal Scenario: Only bit 0 set yields a count of one
    Given "in" is 3'b001
    When the combinational logic evaluates
    Then "out" should equal 2'b01

  @single_bit @bit1
  Formal Scenario: Only bit 1 set yields a count of one
    Given "in" is 3'b010
    When the combinational logic evaluates
    Then "out" should equal 2'b01

  @single_bit @bit2
  Formal Scenario: Only bit 2 set yields a count of one
    Given "in" is 3'b100
    When the combinational logic evaluates
    Then "out" should equal 2'b01

  @two_bits
  Formal Scenario: Exactly two bits set yields a count of two
    Given an arbitrary 3-bit value IN assigned to "in"
    And exactly two bits of IN are 1
    When the combinational logic evaluates
    Then "out" should equal 2'b10

  @range @bounded_output
  Formal Scenario: Output value never exceeds the number of input bits
    Given an arbitrary 3-bit value IN assigned to "in"
    When the combinational logic evaluates
    Then "out" should be greater than or equal to 2'b00
    And "out" should be less than or equal to 2'b11

  @symmetry @bit_independence
  Formal Scenario: Output is invariant to the order of set bits (permutation symmetry)
    Given two arbitrary 3-bit values IN_A and IN_B assigned in separate evaluations to "in"
    And IN_A and IN_B have the same number of bits set to 1
    When the combinational logic evaluates for each value
    Then the resulting "out" for IN_A should equal the resulting "out" for IN_B

  @monotonic @single_bit_flip
  Formal Scenario: Setting an additional bit never decreases the output count
    Given an arbitrary 3-bit value IN assigned to "in"
    And a modified value IN_PLUS formed by setting one additional zero bit of IN to 1
    When the combinational logic evaluates for IN and for IN_PLUS
    Then the resulting "out" for IN_PLUS should equal the resulting "out" for IN plus 1

  @determinism @combinational_purity
  Formal Scenario: Output is a pure function of the current input with no hidden state
    Given an arbitrary 3-bit value IN assigned to "in"
    When the combinational logic evaluates twice with the same value IN and no other signal changes
    Then both evaluations should produce the same "out"