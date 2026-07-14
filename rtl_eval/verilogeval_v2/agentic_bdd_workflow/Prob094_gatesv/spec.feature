Feature: Bitwise Neighbour Relationship Detector

  This module examines a 4-bit input vector and computes three derived
  4-bit outputs describing relationships between each bit and its
  neighbour(s): a logical AND with the left neighbour, a logical OR with
  the right neighbour, and an XOR with the left neighbour (wrapping
  around for the top bit).

  Background:
    Given a 4-bit input vector "in"
    And the design is purely combinational with no clock or reset

  @out_both @bit0
  Formal Scenario: out_both bit 0 reflects AND of in[0] and in[1]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_both[0] should equal (in[0] AND in[1])

  @out_both @bit1
  Formal Scenario: out_both bit 1 reflects AND of in[1] and in[2]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_both[1] should equal (in[1] AND in[2])

  @out_both @bit2
  Formal Scenario: out_both bit 2 reflects AND of in[2] and in[3]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_both[2] should equal (in[2] AND in[3])

  @out_both @unused
  Formal Scenario: out_both bit 3 is unspecified and unconstrained
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_both[3] should be unconstrained by this specification

  @out_any @bit1
  Formal Scenario: out_any bit 1 reflects OR of in[1] and in[0]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_any[1] should equal (in[1] OR in[0])

  @out_any @bit2
  Formal Scenario: out_any bit 2 reflects OR of in[2] and in[1]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_any[2] should equal (in[2] OR in[1])

  @out_any @bit3
  Formal Scenario: out_any bit 3 reflects OR of in[3] and in[2]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_any[3] should equal (in[3] OR in[2])

  @out_any @unused
  Formal Scenario: out_any bit 0 is unspecified and unconstrained
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_any[0] should be unconstrained by this specification

  @out_different @bit0
  Formal Scenario: out_different bit 0 reflects XOR of in[0] and in[1]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_different[0] should equal (in[0] XOR in[1])

  @out_different @bit1
  Formal Scenario: out_different bit 1 reflects XOR of in[1] and in[2]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_different[1] should equal (in[1] XOR in[2])

  @out_different @bit2
  Formal Scenario: out_different bit 2 reflects XOR of in[2] and in[3]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_different[2] should equal (in[2] XOR in[3])

  @out_different @bit3 @wraparound
  Formal Scenario: out_different bit 3 reflects XOR of in[3] and wrapped neighbour in[0]
    Given the input vector "in" has an arbitrary 4-bit value
    When the combinational logic evaluates
    Then out_different[3] should equal (in[3] XOR in[0])

  @combinational @no_state
  Formal Scenario: Outputs depend only on the current input with no memory
    Given the input vector "in" has an arbitrary 4-bit value X
    And the input vector "in" later has a different arbitrary 4-bit value Y
    When the combinational logic evaluates for value X
    Then out_both, out_any, and out_different should be functions solely of X
    When the combinational logic evaluates for value Y
    Then out_both, out_any, and out_different should be functions solely of Y
    And no output bit should depend on any previously applied value of "in"