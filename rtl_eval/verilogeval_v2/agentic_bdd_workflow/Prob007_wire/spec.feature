Feature: Combinational Wire Passthrough

  As a hardware designer
  I want TopModule to behave like a direct wire connection
  So that the output always reflects the current input value combinationally

  Background:
    Given a combinational module TopModule with input in and output out
    And there is no clock or reset signal
    And out is driven purely combinationally from in

  @core @passthrough
  Formal Scenario: Output equals input for any value
    Given the input in is set to a symbolic value X
    When the combinational logic evaluates
    Then the output out should be equal to X

  @edge @zero
  Formal Scenario: Output reflects logic 0 input
    Given the input in is set to constant 1'b0
    When the combinational logic evaluates
    Then the output out should be 1'b0

  @edge @one
  Formal Scenario: Output reflects logic 1 input
    Given the input in is set to constant 1'b1
    When the combinational logic evaluates
    Then the output out should be 1'b1

  @stability
  Formal Scenario: Output changes immediately with input with no latency
    Given the input in transitions from a symbolic value X to a symbolic value Y
    When the combinational logic evaluates after the transition
    Then the output out should be equal to Y
    And the output out should not depend on the previous value X

  @no_inversion
  Formal Scenario: Output is never the logical inversion of input
    Given the input in is set to a symbolic value X
    When the combinational logic evaluates
    Then the output out should not equal the logical NOT of X

  @determinism
  Formal Scenario: Output is a pure function of input only
    Given the input in is set to a symbolic value X
    And no other state or memory element affects out
    When the combinational logic evaluates
    Then the output out should be uniquely determined by X alone