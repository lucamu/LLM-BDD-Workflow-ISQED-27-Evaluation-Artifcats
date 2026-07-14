Feature: Five-State Moore FSM with Two-Stage Description

  As a hardware designer
  I want to verify the TopModule Moore state machine
  So that state transitions and output logic satisfy the specification

  Background:
    Given the module TopModule
    And input clk
    And input rst
    And input data
    And output flag
    And the design uses a two-stage description (state register + next-state/output combinational logic)
    And rst is active low
    And all state transitions occur on the rising edge of clk

  @reset
  Formal Scenario: Reset forces state machine to S0
    Given rst is asserted low
    When a rising edge of clk occurs
    Then the current state should become S0
    And flag should be 0

  @reset
  Formal Scenario: Flag remains 0 while reset is held low
    Given rst is asserted low
    And any value of data
    When a rising edge of clk occurs
    Then flag should be 0

  @transition @S0
  Formal Scenario: Transition from S0 depends on data
    Given rst is deasserted high
    And the current state is S0
    And data is a symbolic value D
    When a rising edge of clk occurs
    Then the next state should be S1 if D equals 1
    And the next state should be S0 if D equals 0

  @transition @S1
  Formal Scenario: Transition from S1 depends on data
    Given rst is deasserted high
    And the current state is S1
    And data is a symbolic value D
    When a rising edge of clk occurs
    Then the next state should be S2 if D equals 1
    And the next state should be S1 if D equals 0

  @transition @S2
  Formal Scenario: Transition from S2 depends on data
    Given rst is deasserted high
    And the current state is S2
    And data is a symbolic value D
    When a rising edge of clk occurs
    Then the next state should be S3 if D equals 1
    And the next state should be S2 if D equals 0

  @transition @S3
  Formal Scenario: Transition from S3 depends on data
    Given rst is deasserted high
    And the current state is S3
    And data is a symbolic value D
    When a rising edge of clk occurs
    Then the next state should be S4 if D equals 1
    And the next state should be S3 if D equals 0

  @transition @S4
  Formal Scenario: Transition from S4 depends on data
    Given rst is deasserted high
    And the current state is S4
    And data is a symbolic value D
    When a rising edge of clk occurs
    Then the next state should be S1 if D equals 1
    And the next state should be S0 if D equals 0

  @output
  Formal Scenario: Output flag is asserted only in state S4
    Given rst is deasserted high
    And the current state is a symbolic state ST
    And any value of data
    Then flag should be 1 if ST equals S4
    And flag should be 0 if ST is not equal to S4

  @output
  Formal Scenario: Output flag is combinational function of current state only
    Given rst is deasserted high
    And the current state is a symbolic state ST
    And data toggles between 0 and 1 while ST remains unchanged
    Then flag should remain constant equal to 1 if ST equals S4, else constant equal to 0

  @safety
  Formal Scenario: State register always holds one of the five valid states
    Given rst is deasserted high
    And any sequence of clk edges and data values
    Then the current state should always be one of S0, S1, S2, S3, S4

  @safety
  Formal Scenario: No transition skips directly to S4 without passing through S3
    Given rst is deasserted high
    And the current state is not S3
    And any value of data
    When a rising edge of clk occurs
    Then the next state should not be S4

  @liveness
  Formal Scenario: State S4 is reachable from S0 by holding data high
    Given rst is deasserted high
    And the current state is S0
    And data is held at 1 for four consecutive clock cycles
    When four rising edges of clk occur in sequence
    Then the current state should become S4

  @liveness
  Formal Scenario: Holding data low keeps state machine in its current state indefinitely
    Given rst is deasserted high
    And the current state is a symbolic state ST where ST is not S4
    And data is held at 0
    When a rising edge of clk occurs
    Then the next state should equal ST