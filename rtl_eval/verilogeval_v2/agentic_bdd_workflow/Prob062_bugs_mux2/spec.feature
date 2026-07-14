Feature: 8-bit 2-to-1 Multiplexer (Bug-Fixed)

  The original implementation declared the output as a single bit,
  causing truncation of the 8-bit mux result. This specification
  verifies the corrected module produces a full 8-bit output that
  correctly selects between operand A and operand B based on sel,
  for every bit position.

  Background:
    Given the design is combinational with no clock or reset
    And input sel is a 1-bit signal
    And input a is an 8-bit vector
    And input b is an 8-bit vector
    And output out is an 8-bit vector

  @core @select-a
  Formal Scenario: Output equals A when select is deasserted
    Given sel is 0
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out should equal A

  @core @select-b
  Formal Scenario: Output equals B when select is asserted
    Given sel is 1
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out should equal B

  @width @no-truncation
  Formal Scenario: Output preserves all 8 bits of A when selected
    Given sel is 0
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out[7:0] should equal A[7:0]
    And out should not be truncated to a single bit of A

  @width @no-truncation
  Formal Scenario: Output preserves all 8 bits of B when selected
    Given sel is 1
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out[7:0] should equal B[7:0]
    And out should not be truncated to a single bit of B

  @bitwise @per-bit
  Formal Scenario: Each output bit follows the mux equation independently
    Given sel is value S
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out should equal ((~S replicated to 8 bits) & A) | ((S replicated to 8 bits) & B)

  @equivalence @exhaustive
  Formal Scenario: Output matches ternary selection for all inputs
    Given sel is value S
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out should equal (S == 0) ? A : B

  @stability @no-x-no-z
  Formal Scenario: Output is fully defined for all valid inputs
    Given sel is value S
    And a is value A
    And b is value B
    When the combinational logic evaluates
    Then out should not contain unknown or high-impedance bits
    And out should be a valid 8-bit value

  @symmetry @a-equals-b
  Formal Scenario: Output equals common value when A equals B regardless of select
    Given a is value A
    And b is value A
    And sel is value S
    When the combinational logic evaluates
    Then out should equal A