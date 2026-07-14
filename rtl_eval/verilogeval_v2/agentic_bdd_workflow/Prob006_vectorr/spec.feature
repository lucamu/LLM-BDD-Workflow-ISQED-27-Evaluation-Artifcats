Feature: TopModule Bit Reversal Combinational Logic

  As a hardware designer
  I want TopModule to reverse the bit ordering of an 8-bit input
  So that the output reflects the mirrored bit pattern of the input

  Background:
    Given a combinational module TopModule
    And an 8-bit input port "in"
    And an 8-bit output port "out"
    And no clock or reset signals are present

  @combinational @bitwise
  Formal Scenario: Output bit 0 equals input bit 7
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[0] should equal IN[7]

  @combinational @bitwise
  Formal Scenario: Output bit 1 equals input bit 6
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[1] should equal IN[6]

  @combinational @bitwise
  Formal Scenario: Output bit 2 equals input bit 5
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[2] should equal IN[5]

  @combinational @bitwise
  Formal Scenario: Output bit 3 equals input bit 4
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[3] should equal IN[4]

  @combinational @bitwise
  Formal Scenario: Output bit 4 equals input bit 3
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[4] should equal IN[3]

  @combinational @bitwise
  Formal Scenario: Output bit 5 equals input bit 2
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[5] should equal IN[2]

  @combinational @bitwise
  Formal Scenario: Output bit 6 equals input bit 1
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[6] should equal IN[1]

  @combinational @bitwise
  Formal Scenario: Output bit 7 equals input bit 0
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out[7] should equal IN[0]

  @combinational @full_reversal
  Formal Scenario: Full output is bit-reversed input
    Given an arbitrary 8-bit value IN on port "in"
    When the combinational logic evaluates
    Then out should equal the bit-reversed value of IN
    And out[7:0] should equal {IN[0], IN[1], IN[2], IN[3], IN[4], IN[5], IN[6], IN[7]}

  @combinational @involution @multi_instance
  Formal Scenario: Reversing twice returns original value
    Given two instances of TopModule, inst1 and inst2
    And inst2's input is connected to inst1's output
    When a symbolic value IN is applied to inst1's input
    Then inst2's output should equal IN

  @combinational @symmetry
  Formal Scenario: Palindromic input produces identical output
    Given an arbitrary 8-bit value IN on port "in"
    And IN is palindromic such that IN[0] equals IN[7], IN[1] equals IN[6], IN[2] equals IN[5], and IN[3] equals IN[4]
    When the combinational logic evaluates
    Then out should equal IN

  @combinational @stateless
  Formal Scenario: Output depends only on current input with no memory
    Given the module has no internal state
    When the same symbolic input IN is applied at any two separate evaluation instants with no intervening change
    Then out must be identical at both instants