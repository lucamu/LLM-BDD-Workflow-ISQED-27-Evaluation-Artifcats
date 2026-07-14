Feature: Combinational AND Gate with Inverted Input (in2)

  This module implements a two-input AND gate where the in2 input
  is inverted (bubble) before entering the AND gate.
  Logic: out = in1 AND (NOT in2)

  Background:
    Given the design under test is "TopModule"
    And the module has input "in1"
    And the module has input "in2"
    And the module has output "out"
    And the design is purely combinational with no clock or reset

  @combinational @truth_table
  Formal Scenario: Output reflects AND of in1 and inverted in2 for all input combinations
    Given in1 is any valid single-bit value A
    And in2 is any valid single-bit value B
    When the circuit evaluates combinationally
    Then out should equal A AND (NOT B)

  @combinational @in1_high @in2_low
  Formal Scenario: Output is high when in1 is 1 and in2 is 0
    Given in1 is 1
    And in2 is 0
    When the circuit evaluates combinationally
    Then out should equal 1

  @combinational @in1_high @in2_high
  Formal Scenario: Output is low when in1 is 1 and in2 is 1
    Given in1 is 1
    And in2 is 1
    When the circuit evaluates combinationally
    Then out should equal 0

  @combinational @in1_low
  Formal Scenario: Output is always low when in1 is 0 regardless of in2
    Given in1 is 0
    And in2 is any valid single-bit value B
    When the circuit evaluates combinationally
    Then out should equal 0

  @combinational @in2_dependency
  Formal Scenario: Output depends only on in2 being logically low when in1 is high
    Given in1 is 1
    And in2 is any valid single-bit value B
    When the circuit evaluates combinationally
    Then out should equal NOT B

  # Note: The circuit is purely combinational; out has no dependency on any
  # clock, reset, or previous state elements.
  @combinational @no_state
  Formal Scenario: Output equals AND of in1 and inverted in2 with no state dependency
    Given in1 is any valid single-bit value A
    And in2 is any valid single-bit value B
    And the circuit has no internal state elements
    When the circuit evaluates combinationally
    Then out should equal A AND (NOT B)