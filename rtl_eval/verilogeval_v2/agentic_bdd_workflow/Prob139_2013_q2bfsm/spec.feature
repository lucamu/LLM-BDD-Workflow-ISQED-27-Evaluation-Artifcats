Feature: Motor Control FSM with Synchronous Active-Low Reset

  As a hardware designer
  I want the TopModule FSM to control outputs f and g based on x and y sequences
  So that the motor control protocol (f pulse, x pattern detection, y confirmation) is correctly implemented

  Background:
    Given a signal clk that triggers all sequential logic on its positive edge
    And a synchronous active-low reset signal resetn
    And an input x
    And an input y
    And an output f
    And an output g
    And the FSM resides in state A whenever resetn is 0

  @reset @safety
  Formal Scenario: Reset holds FSM in initial state with outputs deasserted
    Given resetn is 0
    When a positive clock edge occurs
    Then f should be 0
    And g should be 0
    And the FSM should remain in state A

  @reset @safety
  Formal Scenario: Reset asserted at any time overrides all FSM behavior
    Given the FSM is in any reachable state
    And x and y have any values
    When resetn is 0 at a positive clock edge
    Then f should be 0
    And g should be 0
    And on the following clock edge, if resetn remains 0, the FSM should stay in state A

  @f_pulse @liveness
  Formal Scenario: f asserts for exactly one cycle after reset de-assertion
    Given resetn was 0 in the previous cycle
    And resetn transitions to 1
    When a positive clock edge occurs
    Then f should be 1
    And g should be 0

  @f_pulse @safety
  Formal Scenario: f de-asserts one cycle after its single-cycle pulse
    Given f was 1 in the previous cycle due to reset de-assertion
    And resetn is 1
    When a positive clock edge occurs
    Then f should be 0

  @x_pattern @liveness
  Formal Scenario: g asserts the cycle after x produces the sequence 1, 0, 1
    Given the FSM has completed the f pulse cycle and resetn is 1
    And x equals 1 in cycle N
    And x equals 0 in cycle N+1
    And x equals 1 in cycle N+2
    When a positive clock edge occurs after cycle N+2
    Then g should be 1

  @x_pattern @safety
  Formal Scenario: g remains 0 while the x pattern 1,0,1 has not been completed
    Given the FSM has completed the f pulse cycle and resetn is 1
    And the sequence of x values observed so far does not match 1 then 0 then 1 in three consecutive cycles
    When a positive clock edge occurs
    Then g should be 0

  @x_pattern @safety
  Formal Scenario: A broken x pattern causes the FSM to keep searching without asserting g
    Given the FSM is partway through matching the sequence 1, 0
    And x equals 0 in the cycle where a 1 was expected to complete the pattern
    When a positive clock edge occurs
    Then g should be 0
    And the FSM should resume searching for the start of the sequence 1, 0, 1

  @y_confirm @liveness
  Formal Scenario: g remains permanently 1 if y equals 1 within one cycle after g asserts
    Given g became 1 in cycle M due to x pattern detection
    And resetn is 1
    And y equals 1 in cycle M
    When a positive clock edge occurs
    Then g should be 1
    And g should remain 1 in all subsequent cycles until resetn is de-asserted low

  @y_confirm @liveness
  Formal Scenario: g remains permanently 1 if y equals 1 exactly two cycles after g asserts
    Given g became 1 in cycle M due to x pattern detection
    And resetn is 1
    And y equals 0 in cycle M
    And y equals 1 in cycle M+1
    When a positive clock edge occurs after cycle M+1
    Then g should be 1
    And g should remain 1 in all subsequent cycles until resetn is de-asserted low

  @y_confirm @safety
  Formal Scenario: g becomes permanently 0 if y stays 0 for two cycles after g asserts
    Given g became 1 in cycle M due to x pattern detection
    And resetn is 1
    And y equals 0 in cycle M
    And y equals 0 in cycle M+1
    When a positive clock edge occurs after cycle M+1
    Then g should be 0
    And g should remain 0 in all subsequent cycles until resetn is de-asserted low

  @y_confirm @safety
  Formal Scenario: g does not change state while still within the two-cycle y monitoring window
    Given g became 1 in cycle M due to x pattern detection
    And resetn is 1
    And y equals 0 in cycle M
    When a positive clock edge occurs
    Then g should be 1
    And the FSM should continue monitoring y for one more cycle

  @f_g_exclusive @safety
  Formal Scenario: f and g are never asserted simultaneously
    Given resetn is 1
    And the FSM is in any reachable state
    When a positive clock edge occurs
    Then f and g should not both equal 1

  @state_stability @safety
  Formal Scenario: Once g is set permanently, subsequent x and y values do not alter it
    Given g has reached its permanent value (0 or 1) following y confirmation
    And resetn is 1
    When x and y take any values on subsequent positive clock edges
    Then g should remain unchanged at its permanent value