Feature: Bit-Reversal Combinational Module

  As a hardware designer
  I want to verify that TopModule reverses the bit ordering of a 100-bit input
  So that out[i] always equals in[99-i] for every bit position

  Background:
    Given a combinational module "TopModule"
    And an input "in" of width 100 bits
    And an output "out" of width 100 bits
    And the module has no clock or reset signal
    And "out" is a pure combinational function of "in"

  @core_property @bit_reversal
  Formal Scenario: Output bit at any position equals input bit at mirrored position
    Given an input vector "in" holding an arbitrary 100-bit value
    And a bit index "i" such that "i" is any integer in the range 0 to 99
    When the combinational logic evaluates
    Then "out[i]" should equal "in[99 - i]"

  @symmetry @involution
  Formal Scenario: Reversing twice returns the original value
    Given an input vector "in" holding an arbitrary 100-bit value
    When the combinational logic evaluates to produce "out" from "in"
    And the combinational logic evaluates again to produce "out2" from "out"
    Then "out2" should equal "in"

  @boundary @msb_lsb_swap
  Formal Scenario: Most significant and least significant bits are swapped
    Given an input vector "in" holding an arbitrary 100-bit value
    When the combinational logic evaluates
    Then "out[99]" should equal "in[0]"
    And "out[0]" should equal "in[99]"

  @width_preservation @interface
  Formal Scenario: Output interface width matches specification
    Given the module interface declares "in" as a 100-bit vector "[99:0]"
    And the module interface declares "out" as a 100-bit vector "[99:0]"
    Then the declared width of "out" should be 100 bits
    And the declared width of "in" should be 100 bits

  @all_zeros_case
  Formal Scenario: All-zero input produces all-zero output
    Given an input vector "in" where every bit equals 0
    When the combinational logic evaluates
    Then "out" should equal a 100-bit vector where every bit equals 0

  @all_ones_case
  Formal Scenario: All-one input produces all-one output
    Given an input vector "in" where every bit equals 1
    When the combinational logic evaluates
    Then "out" should equal a 100-bit vector where every bit equals 1

  @linearity_no_state
  Formal Scenario: Output depends only on current input with no memory
    Given an input vector "in" holding an arbitrary 100-bit value "A"
    When the combinational logic evaluates to produce "out" as "R1"
    And the input vector "in" changes to a different arbitrary 100-bit value "B"
    And the combinational logic evaluates to produce "out" as "R2"
    Then "R1" should equal the bit-reversal of "A"
    And "R2" should equal the bit-reversal of "B"