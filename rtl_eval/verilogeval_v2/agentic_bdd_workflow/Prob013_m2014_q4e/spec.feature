Feature: 2-Input NOR Gate Combinational Logic

  As a hardware designer
  I want to verify that TopModule correctly implements a 2-input NOR gate
  So that out is always the logical NOR of in1 and in2

  Background:
    Given the design is a purely combinational module named TopModule
    And the inputs are in1 and in2
    And the output is out
    And there is no clock or reset signal
    And out is evaluated as a pure function of the current values of in1 and in2

  @combinational @core-functionality
  Formal Scenario: Output is the logical NOR of both inputs
    Given in1 is a symbolic value A
    And in2 is a symbolic value B
    When the combinational logic evaluates
    Then out should equal NOT (A OR B)

  @combinational @truth-table
  Formal Scenario: Output is 1 only when both inputs are 0
    Given in1 is 1'b0
    And in2 is 1'b0
    When the combinational logic evaluates
    Then out should be 1'b1

  @combinational @truth-table
  Formal Scenario: Output is 0 when in1 is 1 regardless of in2
    Given in1 is 1'b1
    And in2 is a symbolic value B
    When the combinational logic evaluates
    Then out should be 1'b0

  @combinational @truth-table
  Formal Scenario: Output is 0 when in2 is 1 regardless of in1
    Given in1 is a symbolic value A
    And in2 is 1'b1
    When the combinational logic evaluates
    Then out should be 1'b0

  @combinational @truth-table
  Formal Scenario: Output is 0 when both inputs are 1
    Given in1 is 1'b1
    And in2 is 1'b1
    When the combinational logic evaluates
    Then out should be 1'b0

  @combinational @symmetry
  Formal Scenario: Output is symmetric with respect to input order
    Given in1 is a symbolic value A
    And in2 is a symbolic value B
    When the combinational logic evaluates in a single combinational context
    Then out(A,B) should equal out(B,A)

  @structural @no-state
  Formal Scenario: TopModule contains no registers or memory elements
    Given the design TopModule is analyzed structurally
    Then TopModule should contain no clocked always blocks
    And TopModule should contain no registers or memory elements
    And out should be assigned only via combinational logic (e.g., a continuous assign or combinational always block)