Feature: NOT Gate Combinational Logic

  As a hardware designer
  I want the TopModule to implement a NOT gate
  So that the output is always the logical inverse of the input

  Background:
    Given a combinational module TopModule with input in and output out
    And the module has no clock or reset signals
    And out is continuously assigned based on the current value of in

  @core @inversion
  Formal Scenario: Output is logical negation of input
    Given the input in holds value X
    When the combinational logic evaluates
    Then the output out should be equal to NOT X
    And out should be 1 if and only if X is 0

  @boundary @low
  Formal Scenario: Input low produces output high
    Given the input in is 0
    When the combinational logic evaluates
    Then the output out should be 1

  @boundary @high
  Formal Scenario: Input high produces output low
    Given the input in is 1
    When the combinational logic evaluates
    Then the output out should be 0

  @consistency @double-negation
  Formal Scenario: Double inversion returns original value
    Given the input in holds value X
    When the combinational logic evaluates twice in sequence, feeding out back through an identical NOT operation
    Then the result of the second inversion should be equal to X

  @invariant @no-latch
  Formal Scenario: Output depends only on current input with no memory
    Given the input in holds value X at any evaluation cycle
    When the combinational logic evaluates
    Then the output out should be determined solely by X
    And out should not depend on any previous value of in or out

  @totality @single-bit
  Formal Scenario: Output is always a valid single bit
    Given the input in holds value X
    When the combinational logic evaluates
    Then the output out should be either 0 or 1
    And out should never be X or unknown when in is a defined value 0 or 1