Feature: Constant Zero Output Module

  As a hardware verification engineer
  I want to verify that TopModule always outputs a constant LOW value
  So that downstream logic can rely on this signal being permanently 0

  Background:
    Given the TopModule design with output zero
    And the design is a purely combinational circuit with no inputs

  @combinational @constant
  Formal Scenario: Output zero is always LOW under all conditions
    Given the TopModule has no inputs to constrain
    When the module is evaluated in any state
    Then the zero output should be 0

  @combinational @constant @invariant
  Formal Scenario: Output zero never transitions to HIGH
    Given the TopModule has no inputs to constrain
    When the module is evaluated at any arbitrary time step
    Then the zero output should remain equal to 0

  @combinational @constant @stability
  Formal Scenario: Output zero is stable and independent of any external condition
    Given the TopModule has no inputs to constrain
    When the module is evaluated under any hypothetical environmental condition
    Then the zero output should be 0
    And the zero output should not depend on any signal other than itself