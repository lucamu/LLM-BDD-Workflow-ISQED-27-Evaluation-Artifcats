Feature: Combinational Passthrough Buffer

  As a hardware designer
  I want the output port to always mirror the input port combinationally
  So that no clock or state is involved in signal propagation

  Background:
    Given the module TopModule
    And the design is purely combinational with no clock or reset signals
    And input in is a 1-bit signal
    And output out is a 1-bit signal

  @combinational @passthrough @core
  Formal Scenario: Output equals input for any value
    Given input in is set to a symbolic value X
    When the combinational logic evaluates
    Then output out should equal X

  @combinational @passthrough @zero
  Formal Scenario: Output reflects logic-zero input
    Given input in is set to constant 1'b0
    When the combinational logic evaluates
    Then output out should equal 1'b0

  @combinational @passthrough @one
  Formal Scenario: Output reflects logic-one input
    Given input in is set to constant 1'b1
    When the combinational logic evaluates
    Then output out should equal 1'b1

  @combinational @passthrough @stability
  Formal Scenario: Output has no memory of previous input
    Given input in is set to a symbolic value X1
    And input in is independently set to a different symbolic value X2
    When the combinational logic evaluates for each assignment
    Then output out should equal X1 when input in equals X1
    And output out should equal X2 when input in equals X2

  @combinational @passthrough @invariant
  Formal Scenario: Output depends only on the current input value
    Given output out is assumed to hold an arbitrary symbolic value Y prior to evaluation
    And input in is set to a symbolic value X
    When the combinational logic evaluates
    Then output out should equal X
    And output out should equal X regardless of the value of Y