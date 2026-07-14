Feature: Priority Arbiter FSM (TopModule)
  Formal verification of a synchronous priority-based arbiter FSM with
  states A, B, C, D. Device 0 has highest priority, device 1 medium,
  device 2 lowest. A granted device retains its grant as long as it
  keeps requesting.

  Background:
    Given a signal clk representing the system clock
    And a signal resetn representing the active-low synchronous reset
    And a signal r representing the 3-bit request vector r[2:0]
    And a signal g representing the 3-bit grant vector g[2:0]
    And all state transitions occur on the rising edge of clk
    And resetn is sampled synchronously with clk

  @reset
  Formal Scenario: Synchronous reset forces state A and no grants
    Given the FSM is in any current state
    And r holds any value
    When resetn is 0
    And a rising edge of clk occurs
    Then the next state should be state A
    And g should be 3'b000 in the next state

  @state_A @priority_device0
  Formal Scenario: From state A, request from device 0 takes highest priority
    Given resetn is 1
    And the FSM is in state A
    And r0 is 1
    When a rising edge of clk occurs
    Then the next state should be state B

  @state_A @priority_device1
  Formal Scenario: From state A, request from device 1 is granted only if device 0 is not requesting
    Given resetn is 1
    And the FSM is in state A
    And r0 is 0
    And r1 is 1
    When a rising edge of clk occurs
    Then the next state should be state C

  @state_A @priority_device2
  Formal Scenario: From state A, request from device 2 is granted only if devices 0 and 1 are not requesting
    Given resetn is 1
    And the FSM is in state A
    And r0 is 0
    And r1 is 0
    And r2 is 1
    When a rising edge of clk occurs
    Then the next state should be state D

  @state_A @no_request
  Formal Scenario: From state A, no requests keep the FSM in state A
    Given resetn is 1
    And the FSM is in state A
    And r0 is 0
    And r1 is 0
    And r2 is 0
    When a rising edge of clk occurs
    Then the next state should be state A

  @state_B @hold
  Formal Scenario: State B holds grant while device 0 continues requesting
    Given resetn is 1
    And the FSM is in state B
    And r0 is 1
    When a rising edge of clk occurs
    Then the next state should be state B

  @state_B @release
  Formal Scenario: State B releases grant and returns to A when device 0 stops requesting
    Given resetn is 1
    And the FSM is in state B
    And r0 is 0
    When a rising edge of clk occurs
    Then the next state should be state A

  @state_C @hold
  Formal Scenario: State C holds grant while device 1 continues requesting
    Given resetn is 1
    And the FSM is in state C
    And r1 is 1
    When a rising edge of clk occurs
    Then the next state should be state C

  @state_C @release
  Formal Scenario: State C releases grant and returns to A when device 1 stops requesting
    Given resetn is 1
    And the FSM is in state C
    And r1 is 0
    When a rising edge of clk occurs
    Then the next state should be state A

  @state_D @hold
  Formal Scenario: State D holds grant while device 2 continues requesting
    Given resetn is 1
    And the FSM is in state D
    And r2 is 1
    When a rising edge of clk occurs
    Then the next state should be state D

  @state_D @release
  Formal Scenario: State D releases grant and returns to A when device 2 stops requesting
    Given resetn is 1
    And the FSM is in state D
    And r2 is 0
    When a rising edge of clk occurs
    Then the next state should be state A

  @output_mapping @state_A
  Formal Scenario: No grants asserted while FSM is in state A
    Given resetn is 1
    And the FSM is in state A
    Then g should be 3'b000

  @output_mapping @state_B
  Formal Scenario: Grant 0 asserted while FSM is in state B
    Given resetn is 1
    And the FSM is in state B
    Then g0 should be 1
    And g1 should be 0
    And g2 should be 0

  @output_mapping @state_C
  Formal Scenario: Grant 1 asserted while FSM is in state C
    Given resetn is 1
    And the FSM is in state C
    Then g1 should be 1
    And g0 should be 0
    And g2 should be 0

  @output_mapping @state_D
  Formal Scenario: Grant 2 asserted while FSM is in state D
    Given resetn is 1
    And the FSM is in state D
    Then g2 should be 1
    And g0 should be 0
    And g1 should be 0

  @mutual_exclusion
  Formal Scenario: At most one grant signal is asserted at any time
    Given resetn is 1
    And the FSM is in any reachable state
    Then at most one bit of g should be 1

  @stability
  Formal Scenario: Grant vector g depends only on current state, not on r directly
    Given resetn is 1
    And the FSM is in a fixed current state
    And r changes to any value while the current state remains unchanged
    Then g should remain unchanged

  @priority_invariant
  Formal Scenario: Simultaneous requests from all devices in state A always favor device 0
    Given resetn is 1
    And the FSM is in state A
    And r0 is 1
    And r1 is 1
    And r2 is 1
    When a rising edge of clk occurs
    Then the next state should be state B

  @priority_invariant
  Formal Scenario: Simultaneous requests from devices 1 and 2 in state A always favor device 1
    Given resetn is 1
    And the FSM is in state A
    And r0 is 0
    And r1 is 1
    And r2 is 1
    When a rising edge of clk occurs
    Then the next state should be state C