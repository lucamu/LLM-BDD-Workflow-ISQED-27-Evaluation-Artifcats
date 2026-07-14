Feature: TopModule Combinational Lookup Table
  The TopModule maps a 3-bit input value "a" to a 16-bit output "q"
  through a fixed combinational lookup table. Each value of "a" is
  associated with exactly one constant 16-bit output.

  Background:
    Given the design is TopModule
    And input a is a 3-bit value
    And output q is a 16-bit value
    And the circuit is purely combinational with no clock or reset

  @lut @a0
  Formal Scenario: Output for input value 0
    Given a is 3'b000
    When the combinational logic evaluates
    Then q should be 16'h1232

  @lut @a1
  Formal Scenario: Output for input value 1
    Given a is 3'b001
    When the combinational logic evaluates
    Then q should be 16'haee0

  @lut @a2
  Formal Scenario: Output for input value 2
    Given a is 3'b010
    When the combinational logic evaluates
    Then q should be 16'h27d4

  @lut @a3
  Formal Scenario: Output for input value 3
    Given a is 3'b011
    When the combinational logic evaluates
    Then q should be 16'h5a0e

  @lut @a4
  Formal Scenario: Output for input value 4
    Given a is 3'b100
    When the combinational logic evaluates
    Then q should be 16'h2066

  @lut @a5
  Formal Scenario: Output for input value 5
    Given a is 3'b101
    When the combinational logic evaluates
    Then q should be 16'h64ce

  @lut @a6
  Formal Scenario: Output for input value 6
    Given a is 3'b110
    When the combinational logic evaluates
    Then q should be 16'hc526

  @lut @a7
  Formal Scenario: Output for input value 7
    Given a is 3'b111
    When the combinational logic evaluates
    Then q should be 16'h2f19

  @combinational @stability
  Formal Scenario: Output is a pure function of the current input
    Given a is any valid 3-bit value X
    When the combinational logic evaluates with input X held constant
    Then q should always equal the same fixed value associated with X
    And q should not depend on any previous value of a
    And q should not depend on any clock edge

  @combinational @no_memory
  Formal Scenario: Output changes immediately with input change
    Given a transitions from any value X to any different value Y
    When the combinational logic evaluates
    Then q should immediately equal the fixed value associated with Y
    And q should not retain the value associated with X