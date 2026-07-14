Feature: Bitwise Neighbour Logic Module (TopModule)
  Combinational module that computes three 100-bit outputs from a 100-bit
  input vector by comparing each bit to its left or right neighbour,
  including a wraparound case for out_different.

  Background:
    Given a 100-bit input vector "in"
    And the module is purely combinational with no clock or reset

  @out_both @boundary
  Formal Scenario: Most significant bit of out_both has no left neighbour
    Given any value of input bit in[99]
    When the combinational logic evaluates
    Then out_both[99] should be 0

  @out_both @general
  Formal Scenario: Each out_both bit reflects AND with its left neighbour
    Given any bit position i such that i is in range 0 to 98
    And input bits in[i] and in[i+1] hold any symbolic values
    When the combinational logic evaluates
    Then out_both[i] should equal in[i] AND in[i+1]

  @out_any @boundary
  Formal Scenario: Least significant bit of out_any has no right neighbour
    Given any value of input bit in[0]
    When the combinational logic evaluates
    Then out_any[0] should be 0

  @out_any @general
  Formal Scenario: Each out_any bit reflects OR with its right neighbour
    Given any bit position i such that i is in range 1 to 99
    And input bits in[i] and in[i-1] hold any symbolic values
    When the combinational logic evaluates
    Then out_any[i] should equal in[i] OR in[i-1]

  @out_different @general
  Formal Scenario: Each non-wraparound out_different bit reflects XOR with its left neighbour
    Given any bit position i such that i is in range 0 to 98
    And input bits in[i] and in[i+1] hold any symbolic values
    When the combinational logic evaluates
    Then out_different[i] should equal in[i] XOR in[i+1]

  @out_different @wraparound
  Formal Scenario: Most significant bit of out_different wraps around to bit 0
    Given input bits in[99] and in[0] hold any symbolic values
    When the combinational logic evaluates
    Then out_different[99] should equal in[99] XOR in[0]