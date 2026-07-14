Feature: HDLC Bit Stuffing/Destuffing Frame Boundary Detector

  As a hardware designer
  I want to verify a Moore FSM that scans a serial bit stream
  So that it correctly detects discard bits (5 ones + 0), flags (6 ones + 0),
  and errors (7 or more consecutive ones)

  Background:
    Given a synchronous design with clock "clk" and active-high synchronous reset "reset"
    And all sequential state updates occur on the positive edge of "clk"
    And "in" is the single-bit serial input sampled each cycle
    And "disc", "flag", and "err" are Moore outputs that depend only on the current state
    And the reset state behaves as though the immediately preceding input bit was 0

  @reset @initialization
  Formal Scenario: Reset forces the idle state with no pending pattern
    Given reset is asserted on the current cycle
    When the next positive clock edge occurs
    Then disc should be 0 in the cycle after reset
    And flag should be 0 in the cycle after reset
    And err should be 0 in the cycle after reset
    And an input of 1 in that cycle should begin counting consecutive ones from 1

  @disc
  Formal Scenario: Five consecutive ones followed by a zero asserts disc one cycle later
    Given reset has been deasserted for at least 6 prior cycles
    And in was 0 at least one cycle before the run of ones began
    And in has been 1 for exactly 5 consecutive cycles
    When in becomes 0 on the cycle immediately following those 5 ones
    Then disc should be 1 exactly one cycle after the 0 is sampled
    And flag should be 0 in that same cycle
    And err should be 0 in that same cycle

  @flag
  Formal Scenario: Six consecutive ones followed by a zero asserts flag one cycle later
    Given reset has been deasserted for at least 7 prior cycles
    And in was 0 at least one cycle before the run of ones began
    And in has been 1 for exactly 6 consecutive cycles
    When in becomes 0 on the cycle immediately following those 6 ones
    Then flag should be 1 exactly one cycle after the 0 is sampled
    And disc should be 0 in that same cycle
    And err should be 0 in that same cycle

  @err
  Formal Scenario: Seven consecutive ones asserts err one cycle after the seventh one
    Given reset has been deasserted for at least 8 prior cycles
    And in was 0 at least one cycle before the run of ones began
    And in has been 1 for exactly 7 consecutive cycles
    When the 7th consecutive 1 is sampled
    Then err should be 1 exactly one cycle after the 7th one is sampled
    And disc should be 0 in that same cycle
    And flag should be 0 in that same cycle

  @err_persists
  Formal Scenario: Err remains asserted while ones continue beyond seven
    Given reset has been deasserted for at least 9 prior cycles
    And in was 0 at least one cycle before the run of ones began
    And in has been 1 for 7 or more consecutive cycles
    And err is 1 on the current cycle
    When in remains 1 on the next cycle
    Then err should still be 1 on that next cycle

  @err_terminates
  Formal Scenario: A zero following an error run clears err and returns to idle
    Given in has been 1 for 7 or more consecutive cycles
    And err is 1 on the current cycle
    When in becomes 0 on the following cycle
    Then err should be 0 exactly one cycle after that 0 is sampled
    And disc should be 0 in that same cycle
    And flag should be 0 in that same cycle

  @no_pattern
  Formal Scenario: Fewer than five consecutive ones followed by zero asserts no special output
    Given reset has been deasserted for at least 5 prior cycles
    And in was 0 at least one cycle before the run of ones began
    And in has been 1 for N consecutive cycles where N is less than 5
    When in becomes 0 on the cycle immediately following those N ones
    Then disc should be 0 exactly one cycle after the 0 is sampled
    And flag should be 0 in that same cycle
    And err should be 0 in that same cycle

  @mutual_exclusion
  Formal Scenario: disc, flag, and err are mutually exclusive in every cycle
    Given the design is out of reset
    When any sequence of input bits is applied
    Then at most one of disc, flag, err should be 1 in any given cycle

  @single_cycle_pulse_disc
  Formal Scenario: disc is asserted for exactly one cycle when not immediately followed by another trigger
    Given disc is 1 on the current cycle
    And in on the current cycle is not the start of a new run of five or more consecutive ones ending in a discard or flag condition
    When the next positive clock edge occurs
    Then disc should be 0 on the next cycle

  @single_cycle_pulse_flag
  Formal Scenario: flag is asserted for exactly one cycle when not immediately followed by another trigger
    Given flag is 1 on the current cycle
    And in on the current cycle is not the start of a new run of five or more consecutive ones ending in a discard or flag condition
    When the next positive clock edge occurs
    Then flag should be 0 on the next cycle

  @disc_resumes_counting
  Formal Scenario: After a discard, a new run of ones is counted from that point forward
    Given disc is 1 on the current cycle
    And in has been 1 for exactly 6 consecutive cycles starting on the current cycle
    When in becomes 0 on the cycle immediately following that new run of 6 ones
    Then flag should be 1 exactly one cycle after that 0 is sampled

  @flag_resumes_counting
  Formal Scenario: After a flag, a new run of ones is counted from that point forward
    Given flag is 1 on the current cycle
    And in has been 1 for exactly 7 consecutive cycles starting on the current cycle
    When the 7th consecutive 1 of that new run is sampled
    Then err should be 1 exactly one cycle after the 7th one is sampled

  @leading_zero_no_effect
  Formal Scenario: A zero input while already idle keeps all outputs deasserted
    Given the current state corresponds to zero consecutive ones
    When in is 0 on the current cycle
    Then disc should be 0 one cycle later
    And flag should be 0 one cycle later
    And err should be 0 one cycle later