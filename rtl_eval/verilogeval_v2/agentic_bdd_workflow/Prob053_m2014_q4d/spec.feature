Feature: XOR Feedback D Flip-Flop
  Formal verification of a single D flip-flop whose data input is the
  XOR of the external signal 'in' and its own registered output 'out'.
  The flip-flop is positive-edge triggered and has no reset, so its
  initial value is unconstrained.

  Background:
    Given the design is TopModule
    And a symbolic input in
    And the flip-flop has no reset
    And the output out holds an arbitrary value before the first clock edge

  @combinational @feedback
  Formal Scenario: XOR gate computes flip-flop input from in and current out
    Given the current value of out is out_curr
    And the current value of in is in_curr
    When the combinational XOR is evaluated
    Then the flip-flop data input D should equal in_curr XOR out_curr

  @sequential @toggle
  Formal Scenario: Output toggles when in is asserted
    Given the current value of out is out_curr
    And in equals 1
    When a positive edge of clk occurs
    Then the next value of out should equal NOT out_curr

  @sequential @hold
  Formal Scenario: Output holds when in is deasserted
    Given the current value of out is out_curr
    And in equals 0
    When a positive edge of clk occurs
    Then the next value of out should equal out_curr

  @sequential @general
  Formal Scenario: Next state equals XOR of in and current out for any input
    Given the current value of out is out_curr
    And the current value of in is in_curr
    When a positive edge of clk occurs
    Then the next value of out should equal in_curr XOR out_curr

  @sequential @stability
  Formal Scenario: Output only changes on a positive clock edge
    Given the current value of out is out_curr
    And in is held constant between two evaluation points with no clk edge
    When no positive edge of clk occurs
    Then the value of out should remain out_curr

  @sequential @multi_cycle
  Formal Scenario: Output after two clock cycles equals XOR of two successive in values with initial out
    Given the current value of out is out_curr
    And the value of in at the first clock edge is in_first
    And the value of in at the second clock edge is in_second
    When two consecutive positive edges of clk occur
    Then the value of out after the first edge should equal in_first XOR out_curr
    And the value of out after the second edge should equal in_second XOR (in_first XOR out_curr)

  @no_reset
  Formal Scenario: Absence of reset leaves initial state unconstrained
    Given no reset signal exists in the design
    When the design powers on before any clock edge
    Then the initial value of out should be unconstrained by the design logic