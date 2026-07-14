Feature: Timer Control FSM (Pattern Detector, Shift, Count, Done/Ack Handshake)

  As a hardware designer
  I want the TopModule FSM to detect the serial pattern 1101,
  shift in 4 duration bits, wait for counting to finish,
  and handshake with the user via done/ack
  So that the timer control logic behaves correctly under all input sequences

  Background:
    Given a signal clk representing the system clock
    And a signal reset representing an active-high synchronous reset
    And a signal data representing the serial input bit
    And a signal done_counting representing the counter-finished input
    And a signal ack representing the user acknowledgment input
    And a signal shift_ena representing the shift-enable output
    And a signal counting representing the counting-active output
    And a signal done representing the done-notification output
    And all sequential state updates occur on the rising edge of clk
    And reset is synchronous and active-high

  @reset
  Formal Scenario: Synchronous reset forces the FSM to the initial search state
    Given reset is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    And counting should be 0
    And done should be 0

  @reset @override
  Formal Scenario: Reset overrides any current FSM state
    Given the FSM may currently have shift_ena equal to 1, or counting equal to 1, or done equal to 1
    And reset is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    And counting should be 0
    And done should be 0
    And on the following clock edge, with reset held at 0 and data equal to 0,
        shift_ena should remain 0 and counting should remain 0 and done should remain 0

  @pattern_detection
  Formal Scenario: Pattern 1101 detected after search causes shift_ena to assert
    Given reset is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given reset is 0
    And data is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 0
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 1
    And counting should be 0
    And done should be 0

  @pattern_detection @mismatch
  Formal Scenario: Incomplete pattern does not assert shift_ena
    Given reset is 1
    When a rising clock edge occurs
    Given reset is 0
    And data is 1
    When a rising clock edge occurs
    Given data is 1
    When a rising clock edge occurs
    Given data is 0
    When a rising clock edge occurs
    Given data is 0
    When a rising clock edge occurs
    Then shift_ena should be 0
    And counting should be 0
    And done should be 0

  @pattern_detection @overlap
  Formal Scenario: Overlapping partial matches are correctly tracked
    Given reset is 1
    When a rising clock edge occurs
    Given reset is 0
    And data is 1
    When a rising clock edge occurs
    Given data is 1
    When a rising clock edge occurs
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 0
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 1

  @shift_duration
  Formal Scenario: shift_ena remains asserted for exactly 4 consecutive cycles
    Given the FSM has just detected the pattern 1101 so that shift_ena is 1 at the current cycle
    And reset is 0
    When a rising clock edge occurs with data equal to any value X1
    Then shift_ena should be 1
    When a rising clock edge occurs with data equal to any value X2
    Then shift_ena should be 1
    When a rising clock edge occurs with data equal to any value X3
    Then shift_ena should be 1
    When a rising clock edge occurs with data equal to any value X4
    Then shift_ena should be 0
    And counting should be 1
    And done should be 0

  @counting_wait
  Formal Scenario: counting remains asserted while done_counting is 0
    Given the FSM is in the counting state so that counting is 1
    And reset is 0
    And done_counting is 0
    When a rising clock edge occurs
    Then counting should be 1
    And done should be 0
    And shift_ena should be 0

  @counting_to_done
  Formal Scenario: done asserts on the cycle after done_counting is observed high
    Given the FSM is in the counting state so that counting is 1
    And reset is 0
    And done_counting is 1
    When a rising clock edge occurs
    Then counting should be 0
    And done should be 1
    And shift_ena should be 0

  @done_wait
  Formal Scenario: done remains asserted while ack is 0
    Given the FSM is in the done state so that done is 1
    And reset is 0
    And ack is 0
    When a rising clock edge occurs
    Then done should be 1
    And counting should be 0
    And shift_ena should be 0

  @ack_return
  Formal Scenario: ack returns the FSM to the initial search state
    Given the FSM is in the done state so that done is 1
    And reset is 0
    And ack is 1
    When a rising clock edge occurs
    Then done should be 0
    And counting should be 0
    And shift_ena should be 0

  @ack_return @resume_search
  Formal Scenario: After ack-driven return, the FSM correctly resumes pattern search
    Given the FSM is in the done state so that done is 1
    And reset is 0
    And ack is 1
    When a rising clock edge occurs
    Then done should be 0
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 0
    When a rising clock edge occurs
    Then shift_ena should be 0
    Given data is 1
    When a rising clock edge occurs
    Then shift_ena should be 1

  @mutual_exclusion
  Formal Scenario: shift_ena, counting, and done are never simultaneously asserted
    Given reset is 0
    When a rising clock edge occurs with data, done_counting, and ack equal to any values
    Then at most one of shift_ena, counting, done should be 1
    And shift_ena AND counting should be 0
    And shift_ena AND done should be 0
    And counting AND done should be 0

  @stability
  Formal Scenario: counting output is independent of data while counting
    Given the FSM is in the counting state so that counting is 1
    And reset is 0
    And done_counting is 0
    When a rising clock edge occurs with data equal to any value X
    Then counting should be 1
    And shift_ena should be 0
    And done should be 0

  @stability
  Formal Scenario: done output is independent of data while waiting for ack
    Given the FSM is in the done state so that done is 1
    And reset is 0
    And ack is 0
    When a rising clock edge occurs with data equal to any value X
    Then done should be 1
    And shift_ena should be 0
    And counting should be 0