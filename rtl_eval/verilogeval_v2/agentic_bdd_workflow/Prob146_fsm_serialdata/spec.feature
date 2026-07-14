Feature: Serial Receiver FSM with Start Bit, 8 Data Bits, and Stop Bit Framing

  As a hardware designer
  I want a synchronous serial receiver FSM
  So that it correctly detects start bits, shifts in 8 data bits LSB-first,
  validates the stop bit, and asserts done with the correct byte value

  Background:
    Given a positive-edge triggered clock clk
    And a synchronous active-high reset signal reset
    And a serial input line in
    And an 8-bit output out_byte
    And a done output signal
    And the line idle level is logic 1

  @reset
  Formal Scenario: Reset forces FSM to idle state with done deasserted
    Given reset is asserted 1
    When a positive edge of clk occurs
    Then done should be 0
    And the internal state should be idle waiting for a start bit

  @idle
  Formal Scenario: Idle line never asserts done
    Given reset is deasserted 0
    And the FSM is in the idle state
    When in holds logic 1 for any number of consecutive clock cycles
    Then done should remain 0 in every one of those cycles

  @start
  Formal Scenario: Start bit transitions FSM out of idle
    Given reset is deasserted 0
    And the FSM is in the idle state
    When in equals 0 for exactly one clock cycle representing the start bit
    Then done should be 0 on that cycle
    And on the following clock edge the FSM should begin sampling the first data bit

  @data @frame @correct
  Formal Scenario: Correctly framed byte asserts done with the correct value
    Given reset is deasserted 0
    And the FSM is in the idle state
    And eight arbitrary data bit values b0 b1 b2 b3 b4 b5 b6 b7 are chosen
    When in equals 0 on the start bit cycle
    And in equals b0 on the next cycle
    And in equals b1 on the following cycle
    And in equals b2 on the following cycle
    And in equals b3 on the following cycle
    And in equals b4 on the following cycle
    And in equals b5 on the following cycle
    And in equals b6 on the following cycle
    And in equals b7 on the following cycle
    And in equals 1 on the stop bit cycle immediately after b7
    Then done should be 1 exactly on the stop bit cycle
    And out_byte should equal {b7,b6,b5,b4,b3,b2,b1,b0} with b0 as the least significant bit

  @stop @error
  Formal Scenario: Missing stop bit suppresses done and forces error recovery
    Given reset is deasserted 0
    And the FSM is in the idle state
    And eight arbitrary data bit values d0 d1 d2 d3 d4 d5 d6 d7 are chosen
    When in equals 0 on the start bit cycle
    And in equals d0,d1,d2,d3,d4,d5,d6,d7 in order on the eight following cycles
    And in equals 0 on the cycle where the stop bit is expected
    Then done should be 0 on the expected stop bit cycle
    And done should remain 0 on every subsequent cycle until in equals 1
    And the FSM should not attempt to detect a new start bit while in remains 0

  @recovery
  Formal Scenario: FSM resumes normal detection after locating a delayed stop bit
    Given the FSM is in the error/wait recovery state following a missing stop bit
    When in equals 1 for one clock cycle
    Then done should be 0 on that cycle
    And on the next clock edge the FSM should return to the idle state ready to detect a new start bit

  @pulse
  Formal Scenario: done is asserted for exactly one clock cycle per valid frame
    Given reset is deasserted 0
    And a valid frame consisting of a start bit, eight arbitrary data bits, and a stop bit value of 1 is presented
    When the stop bit cycle occurs
    Then done should be 1 only on that single cycle
    And done should be 0 on the immediately preceding cycle
    And done should be 0 on the immediately following cycle

  @backtoback
  Formal Scenario: Two consecutive valid frames each produce correct done pulses and byte values
    Given reset is deasserted 0
    And the FSM is in the idle state
    And two sets of eight arbitrary data bits a0..a7 and c0..c7 are chosen
    When a first valid frame with start bit 0, data bits a0..a7, and stop bit 1 is received
    And immediately following the first stop bit cycle a second valid frame with start bit 0, data bits c0..c7, and stop bit 1 is received
    Then done should be 1 on the first stop bit cycle with out_byte equal to {a7,a6,a5,a4,a3,a2,a1,a0}
    And done should be 1 on the second stop bit cycle with out_byte equal to {c7,c6,c5,c4,c3,c2,c1,c0}
    And done should be 0 on all cycles between the two stop bit cycles that are not stop bit cycles themselves

  @out_byte @stability
  Formal Scenario: out_byte reflects last correctly received frame while done is asserted
    Given a valid frame has just completed with data bits e0..e7 and a correct stop bit
    When done is 1 on the stop bit cycle
    Then out_byte should equal {e7,e6,e5,e4,e3,e2,e1,e0} on that same cycle