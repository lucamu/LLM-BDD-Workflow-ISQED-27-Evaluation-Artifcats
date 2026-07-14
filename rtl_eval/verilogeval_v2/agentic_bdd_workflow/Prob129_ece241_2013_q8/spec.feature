Feature: Mealy FSM Sequence Detector for "101" with Overlap Support

  As a hardware designer
  I want a 3-state Mealy FSM that detects overlapping occurrences of "101" on x
  So that z asserts combinationally in the same cycle the pattern completes,
  with an asynchronous active-low reset

  Background:
    Given a clock clk whose rising edge triggers all sequential logic
    And an asynchronous active-low reset aresetn
    And a single-bit input x
    And a single-bit Mealy output z that is a function of the current state and x
    And the FSM has exactly three states: STATE_IDLE, STATE_S1, STATE_S10
    And STATE_IDLE represents no progress toward "101"
    And STATE_S1 represents having last received a "1" with no valid "0" yet consumed
    And STATE_S10 represents having received "1" then "0" in sequence
    And when aresetn is deasserted to 0, the FSM asynchronously enters STATE_IDLE and z is driven to 0, independent of clk

  @reset @async
  Formal Scenario: Asynchronous reset forces output low regardless of input
    Given aresetn transitions to 0 asynchronously at any point in time
    And x holds any value V at that time
    Then z should be 0 immediately, without waiting for a clock edge
    And the FSM state should be STATE_IDLE immediately

  @reset @deassert
  Formal Scenario: FSM begins in idle state immediately after reset release
    Given aresetn is deasserted and then reasserted to 1
    And no clock edge has yet occurred since the reassertion
    Then the FSM state should be STATE_IDLE
    And z should be 0

  @sequence_detection @progress
  Formal Scenario: First "1" from idle state begins pattern tracking
    Given aresetn is asserted to 1
    And the FSM is in STATE_IDLE
    When x is 1
    Then z should be 0
    And the next state on the following clock edge should be STATE_S1

  @sequence_detection @idle_hold
  Formal Scenario: Zero input while idle keeps FSM idle
    Given aresetn is asserted to 1
    And the FSM is in STATE_IDLE
    When x is 0
    Then z should be 0
    And the next state on the following clock edge should remain STATE_IDLE

  @sequence_detection @s1_hold
  Formal Scenario: Repeated "1" input keeps FSM tracking a single "1"
    Given aresetn is asserted to 1
    And the FSM is in STATE_S1
    When x is 1
    Then z should be 0
    And the next state on the following clock edge should remain STATE_S1

  @sequence_detection @s1_to_s10
  Formal Scenario: A "0" following a tracked "1" advances the FSM
    Given aresetn is asserted to 1
    And the FSM is in STATE_S1
    When x is 0
    Then z should be 0
    And the next state on the following clock edge should be STATE_S10

  @sequence_detection @mealy_match
  Formal Scenario: A "1" following "10" completes the pattern combinationally
    Given aresetn is asserted to 1
    And the FSM is in STATE_S10
    When x is 1
    Then z should be 1 in the same clock cycle, since z is a Mealy output
    And the next state on the following clock edge should be STATE_S1

  @sequence_detection @no_match
  Formal Scenario: A "0" following "10" breaks the pattern
    Given aresetn is asserted to 1
    And the FSM is in STATE_S10
    When x is 0
    Then z should be 0
    And the next state on the following clock edge should be STATE_IDLE

  @overlapping @functional
  Formal Scenario: The "1" completing a match is reusable as the start of a new match
    Given aresetn is asserted to 1
    And the FSM is in STATE_S10
    And x is 1, causing z to be 1 and the next state to be STATE_S1
    When, from that resulting STATE_S1, x is subsequently 0, causing the next state to be STATE_S10
    And, from that resulting STATE_S10, x is subsequently 1
    Then z should be 1 on this second occurrence
    And the next state on the following clock edge should be STATE_S1
    And no additional "1" input beyond the one that completed the first match is required to begin the second match

  @overlapping @non_match
  Formal Scenario: z never asserts unless the FSM reaches STATE_S10 with x equal to 1
    Given aresetn is asserted to 1
    And the FSM is in any reachable state among STATE_IDLE, STATE_S1, or STATE_S10
    When the current state is not STATE_S10, or the current state is STATE_S10 but x is 0
    Then z should be 0
    And z should be asserted to 1 if and only if the current state is STATE_S10 and x is 1

  @overlapping @repeated_ones
  Formal Scenario: Detection depends only on the most recent "1", "0", "1" subsequence
    Given aresetn is asserted to 1
    And the FSM is in STATE_S1 after having consumed one or more consecutive "1" inputs
    When x subsequently transitions to 0, advancing the FSM to STATE_S10
    And x subsequently transitions to 1
    Then z should be 1 on that transition, regardless of how many consecutive "1" inputs preceded the "0"
    And the next state on the following clock edge should be STATE_S1
    And the number of prior consecutive "1" inputs should have no effect on whether z asserts

  @state_space @safety
  Formal Scenario: FSM state space is limited to three defined symbolic states
    Given aresetn is asserted to 1
    And the FSM state is encoded using a symbolic parameter with exactly three defined values: STATE_IDLE, STATE_S1, and STATE_S10
    Then the FSM state should always equal one of STATE_IDLE, STATE_S1, or STATE_S10 on every clock cycle
    And for any state encoding value distinct from STATE_IDLE, STATE_S1, and STATE_S10, that encoding should be unreachable from any valid input sequence starting from a reset state
    And this property should hold as an invariant over all time, suitable for expression as an SVA assert property with an always-true antecedent