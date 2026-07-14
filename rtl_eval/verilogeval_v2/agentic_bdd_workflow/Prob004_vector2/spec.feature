Feature: 32-bit Byte Order Reversal
  Formal verification of a combinational module that reverses the byte
  order of a 32-bit input vector. Byte 0 (bits [7:0]) becomes byte 3
  (bits [31:24]), byte 1 becomes byte 2, byte 2 becomes byte 1, and
  byte 3 becomes byte 0.

  Background:
    Given a combinational module TopModule
    And a 32-bit input in
    And a 32-bit output out
    And out is purely combinational function of in with no internal state

  @byte-swap @full-mapping
  Formal Scenario: Full byte order reversal
    Given an input value in
    When the module evaluates the output
    Then out[31:24] should equal in[7:0]
    And out[23:16] should equal in[15:8]
    And out[15:8] should equal in[23:16]
    And out[7:0] should equal in[31:24]

  @byte-swap @byte0
  Formal Scenario: Least significant byte maps to most significant byte
    Given an input value in
    When the module evaluates the output
    Then out[31:24] should equal in[7:0]

  @byte-swap @byte1
  Formal Scenario: Second byte maps to third byte
    Given an input value in
    When the module evaluates the output
    Then out[23:16] should equal in[15:8]

  @byte-swap @byte2
  Formal Scenario: Third byte maps to second byte
    Given an input value in
    When the module evaluates the output
    Then out[15:8] should equal in[23:16]

  @byte-swap @byte3
  Formal Scenario: Most significant byte maps to least significant byte
    Given an input value in
    When the module evaluates the output
    Then out[7:0] should equal in[31:24]

  @involution
  Formal Scenario: Reversing twice returns the original value
    Given an input value in
    When the module evaluates the output for in to produce an intermediate value mid
    And the module evaluates the output for mid to produce out
    Then out should equal in

  @bit-preservation
  Formal Scenario: Population count is preserved by byte reversal
    Given an input value in
    When the module evaluates the output
    Then the number of set bits in out should equal the number of set bits in in

  @determinism
  Formal Scenario: Output depends only on current input with no hidden state
    Given two evaluations of the module with the same input value in
    When the module evaluates the output for each evaluation
    Then both outputs should be equal

  @no-aliasing
  Formal Scenario: Distinct inputs that differ produce correspondingly distinct outputs
    Given two input values in and in2 such that in is not equal to in2
    When the module evaluates the output for in to produce out
    And the module evaluates the output for in2 to produce out2
    Then out should not equal out2