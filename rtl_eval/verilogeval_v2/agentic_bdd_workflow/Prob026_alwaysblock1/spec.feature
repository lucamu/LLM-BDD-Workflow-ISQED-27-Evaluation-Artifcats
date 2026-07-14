Feature: TopModule AND Gate Combinational Logic Verification

  As a hardware designer
  I want to verify that TopModule correctly implements an AND gate
  using both an assign statement and a combinational always block
  So that both implementations produce identical, correct AND semantics

  Background:
    Given a combinational module named TopModule
    And input a is a single bit signal
    And input b is a single bit signal
    And output out_assign is a single bit signal
    And output out_alwaysblock is a single bit signal
    And there is no clock signal
    And there is no reset signal
    And all outputs are purely combinational functions of a and b

  @assign-statement @core-functionality
  Formal Scenario: out_assign implements bitwise AND of a and b
    Given an arbitrary value A for input a
    And an arbitrary value B for input b
    When the combinational logic settles
    Then out_assign should equal A & B

  @always-block @core-functionality
  Formal Scenario: out_alwaysblock implements bitwise AND of a and b
    Given an arbitrary value A for input a
    And an arbitrary value B for input b
    When the combinational logic settles
    Then out_alwaysblock should equal A & B

  @equivalence @cross-check
  Formal Scenario: out_assign and out_alwaysblock are always equivalent
    Given an arbitrary value A for input a
    And an arbitrary value B for input b
    When the combinational logic settles
    Then out_assign should equal out_alwaysblock

  @boundary @zero-case
  Formal Scenario: Both outputs are 0 when a is 0 regardless of b
    Given input a is 0
    And an arbitrary value B for input b
    When the combinational logic settles
    Then out_assign should equal 0
    And out_alwaysblock should equal 0

  @boundary @zero-case
  Formal Scenario: Both outputs are 0 when b is 0 regardless of a
    Given an arbitrary value A for input a
    And input b is 0
    When the combinational logic settles
    Then out_assign should equal 0
    And out_alwaysblock should equal 0

  @boundary @one-case
  Formal Scenario: Both outputs follow a when b is 1
    Given an arbitrary value A for input a
    And input b is 1
    When the combinational logic settles
    Then out_assign should equal A
    And out_alwaysblock should equal A

  @boundary @one-case
  Formal Scenario: Both outputs follow b when a is 1
    Given input a is 1
    And an arbitrary value B for input b
    When the combinational logic settles
    Then out_assign should equal B
    And out_alwaysblock should equal B

  @exhaustive @all-ones
  Formal Scenario: Both outputs are 1 only when both inputs are 1
    Given input a is 1
    And input b is 1
    When the combinational logic settles
    Then out_assign should equal 1
    And out_alwaysblock should equal 1

  @no-state @combinational-purity
  Formal Scenario: Outputs depend only on current inputs with no memory
    Given an arbitrary value A for input a
    And an arbitrary value B for input b
    When the combinational logic settles
    Then out_assign should equal A & B
    And out_alwaysblock should equal A & B
    And no internal state persists between evaluations