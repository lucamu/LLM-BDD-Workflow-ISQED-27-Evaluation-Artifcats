Feature: Serial UART Byte Framing Detector (Start-Data-Stop FSM)

  The TopModule monitors a serial line (in) that idles at logic 1.
  A valid frame consists of one start bit (0), 8 data bits (LSB first,
  any value), and one stop bit (1). The module must assert done for
  exactly one clock cycle when a complete, correctly framed byte has
  been received. If the stop bit is not 1 when expected, the FSM must
  not assert done and must resynchronize by waiting for a bit equal to
  1 before searching for the next start bit.

  Background:
    Given a signal clk that triggers all sequential logic on its rising edge
    And a synchronous active-high signal reset
    And an input signal in representing the serial line
    And an output signal done indicating a correctly framed byte was received
    And in is held at logic 1 whenever the line is idle

  @reset
  Formal Scenario: Synchronous reset forces done low and returns FSM to idle
    Given reset is asserted
    And in is any value X
    When a rising edge of clk occurs
    Then done should be 0

  @reset
  Formal Scenario: Reset overrides any in-progress frame reception
    Given the FSM is at an arbitrary point within receiving a byte
    And reset is asserted
    When a rising edge of clk occurs
    Then done should be 0
    And the FSM should behave as if idle on the following cycle when in is 1

  @idle
  Formal Scenario: Idle line never produces a done pulse
    Given reset is deasserted
    And in is held at 1 for N consecutive clock cycles
    When N rising edges of clk occur
    Then done should be 0 on every one of those cycles

  @start
  Formal Scenario: A 0 on the line while idle is interpreted as a start bit
    Given reset is deasserted
    And the FSM is idle (in has been 1)
    And in transitions to 0 on the next clock cycle
    When a rising edge of clk occurs
    Then done should be 0
    And the FSM should begin counting 8 subsequent data bits

  @data
  Formal Scenario: Data bit values do not affect done regardless of content
    Given reset is deasserted
    And a start bit 0 has just been received
    And in holds an arbitrary symbolic sequence of 8 bits D0 through D7 (each 0 or 1), presented one per clock cycle, LSB first
    When 8 rising edges of clk occur, one per data bit
    Then done should be 0 on each of those 8 cycles, regardless of the values of D0 through D7

  @stop_correct
  Formal Scenario: Correct stop bit asserts done for exactly one cycle
    Given reset is deasserted
    And a start bit 0 followed by 8 arbitrary data bits has been received
    And in equals 1 on the cycle corresponding to the stop bit position
    When a rising edge of clk occurs at the stop bit position
    Then done should be 1 on that cycle
    And done should return to 0 on the following cycle
    And the FSM should be ready to detect a new start bit immediately after

  @stop_incorrect
  Formal Scenario: Incorrect stop bit suppresses done and enters resync wait
    Given reset is deasserted
    And a start bit 0 followed by 8 arbitrary data bits has been received
    And in equals 0 on the cycle corresponding to the stop bit position
    When a rising edge of clk occurs at the stop bit position
    Then done should be 0 on that cycle
    And the FSM should enter a wait-for-stop resynchronization state

  @resync
  Formal Scenario: FSM remains in resync wait state while line stays 0
    Given the FSM is in the wait-for-stop resynchronization state
    And in is held at 0 for M consecutive clock cycles
    When M rising edges of clk occur
    Then done should be 0 on every one of those cycles
    And the FSM should remain in the wait-for-stop resynchronization state

  @resync
  Formal Scenario: FSM exits resync wait state when line returns to 1
    Given the FSM is in the wait-for-stop resynchronization state
    And in transitions to 1 on the next clock cycle
    When a rising edge of clk occurs
    Then done should be 0 on that cycle
    And the FSM should return to the idle state, ready to detect a new start bit

  @full_frame
  Formal Scenario: A complete valid frame yields exactly one done pulse and no more
    Given reset is deasserted
    And in follows the sequence: 1 (idle), 0 (start), D0 through D7 (arbitrary data bits), 1 (stop)
    When 11 rising edges of clk occur corresponding to this sequence
    Then done should be 0 on all cycles except the cycle corresponding to the stop bit
    And done should be 1 exactly on the cycle corresponding to the stop bit

  @back_to_back
  Formal Scenario: A new start bit can be detected immediately after a done pulse
    Given a valid frame has just completed with done equal to 1 on the previous cycle
    And in transitions to 0 on the following cycle
    When a rising edge of clk occurs
    Then done should be 0 on that cycle
    And the FSM should begin counting a new set of 8 data bits