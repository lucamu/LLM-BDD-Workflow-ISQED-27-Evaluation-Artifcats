Feature: 24-bit to 128-bit Data Width Converter with Valid-Only Handshake

  As a hardware designer
  I want to formally verify a width conversion module
  That accumulates 24-bit input words into a 128-bit output word using a
  bit-level accumulator, since 24 and 128 do not share an integer ratio
  (the repeating pattern spans 16 input words producing exactly 3 output
  words, because 16 * 24 = 384 = 3 * 128)
  Using valid-only handshake on both input and output interfaces

  Background:
    Given a synchronous design clocked on the rising edge of clk
    And an active-low synchronous reset rst_n
    And the module TopModule with input valid_in
    And the module TopModule with input data_in of 24 bits
    And the module TopModule with output valid_out
    And the module TopModule with output data_out of 128 bits
    And the module maintains an internal bit accumulator register that holds all
      data bits received but not yet emitted as part of a completed 128-bit
      output word
    And the module maintains an internal bit counter N representing the number
      of valid accumulator bits held prior to the current rising edge of clk,
      where N is always greater than or equal to 0 and less than 128
    And when rst_n is 0, on the next rising edge of clk the internal bit
      counter N is reset to 0
    And when rst_n is 0, on the next rising edge of clk the internal bit
      accumulator is reset to 0
    And when rst_n is 0, on the next rising edge of clk valid_out is driven to 0
    And when rst_n is 0, on the next rising edge of clk data_out is driven to 0
    And whenever valid_in is 1 on a rising edge of clk, the accumulator is
      updated by appending data_in after the previously accumulated N bits,
      preserving reception order so that earlier-received bits remain toward
      the most significant position
    And whenever valid_in is 1 on a rising edge of clk and N + 24 is less than
      128, the internal bit counter becomes N + 24, valid_out becomes 0, and
      data_out remains unchanged
    And whenever valid_in is 1 on a rising edge of clk and N + 24 is greater
      than or equal to 128, data_out becomes the topmost 128 bits of the
      accumulator formed by appending data_in after the previously accumulated
      N bits, valid_out becomes 1, and the internal bit counter becomes
      N + 24 - 128, with the remaining low-order bits retained in the
      accumulator for the next accumulation round
    And whenever valid_in is 0 on a rising edge of clk, the internal bit
      counter, the internal bit accumulator, and data_out all remain unchanged
      and valid_out becomes 0
    And since 16 times 24 bits equals 384 bits which equals 3 times 128 bits,
      the pattern of accumulation and output repeats identically every 16
      consecutive valid_in cycles, producing exactly 3 valid_out assertions
      per 16 cycles and returning the internal bit counter to its starting
      value after those 16 cycles

  @reset
  Formal Scenario: Reset forces outputs to known idle state
    Given rst_n is 0
    When a rising edge of clk occurs
    Then valid_out should be 0
    And data_out should be 0

  @reset_counter
  Formal Scenario: Reset forces the internal bit counter to zero
    Given rst_n is 0
    When a rising edge of clk occurs
    Then the internal bit counter should be 0

  @idle_hold
  Formal Scenario: Holding state when valid_in is deasserted
    Given rst_n is 1
    And valid_in is 0
    When a rising edge of clk occurs
    Then data_out should remain unchanged
    And valid_out should be 0

  @counter_invariant
  Formal Scenario: Internal bit counter always remains within its valid range
    Given rst_n is 1
    Then the internal bit counter should be greater than or equal to 0
    And the internal bit counter should be less than 128

  @single_accumulation
  Formal Scenario: A single valid input accumulates without completing a word
    Given rst_n is 1
    And the internal bit counter is N
    And N + 24 is less than 128
    And valid_in is 1
    And data_in is value W
    When a rising edge of clk occurs
    Then the internal bit counter should become N + 24
    And valid_out should be 0
    And data_out should remain unchanged
    And the internal bit accumulator should contain W appended after the
      previously accumulated N bits

  @word_completion
  Formal Scenario: Word completes and valid_out asserts when accumulated bits reach or exceed 128
    Given rst_n is 1
    And the internal bit counter is N
    And N + 24 is greater than or equal to 128
    And valid_in is 1
    And data_in is value W
    When a rising edge of clk occurs
    Then data_out should equal the topmost 128 bits of the accumulator formed
      by appending W after the previously accumulated N bits
    And valid_out should be 1
    And the internal bit counter should become N + 24 - 128

  @ordering
  Formal Scenario: Earliest received bits occupy the highest bits and the most recent word occupies the lowest bits
    Given rst_n is 1
    And the internal bit counter is N
    And N + 24 is greater than or equal to 128
    And valid_in is 1
    And data_in is value W
    When a rising edge of clk occurs
    Then the earliest-received bits still held in the accumulator should
      occupy the highest-order bit positions of data_out
    And W should occupy the lowest-order 24 bit positions of data_out
    And valid_out should be 1

  @valid_out_pulse
  Formal Scenario: valid_out deasserts on the cycle following a completed word
    Given rst_n is 1
    And the internal bit counter is N
    And N + 24 is greater than or equal to 128
    And valid_in is 1
    When a rising edge of clk occurs
    Then valid_out should be 1
    When a further rising edge of clk occurs with valid_in equal to 0
    Then valid_out should be 0

  @counter_wrap
  Formal Scenario: Internal bit counter wraps to the leftover bit count after completing a word
    Given rst_n is 1
    And the internal bit counter is N
    And N + 24 is greater than or equal to 128
    And valid_in is 1
    And data_in is value W
    When a rising edge of clk occurs
    Then the internal bit counter should become N + 24 - 128
    And the internal bit counter should be less than 24
    When a further rising edge of clk occurs with valid_in equal to 1 and data_in equal to value X
    Then the internal bit accumulator should contain X appended after the
      leftover bits retained from the previous round

  @continuous_streaming
  Formal Scenario: Back-to-back valid inputs produce exactly three valid_out assertions every sixteen cycles
    Given rst_n is 1
    And the internal bit counter is 0
    And valid_in is 1 on every rising edge of clk for sixteen consecutive cycles
    When the sixteen consecutive rising edges of clk occur
    Then valid_out should be 1 on exactly three of the sixteen cycles
    And each assertion of valid_out should occur precisely on the cycle where
      the accumulated bit count first reaches or exceeds 128 since the
      previous assertion or since reset
    And the internal bit counter should return to 0 after the sixteenth cycle

  @no_partial_output
  Formal Scenario: valid_out never asserts before accumulated bits reach 128
    Given rst_n is 1
    And the internal bit counter is N
    And N + 24 is less than 128
    And valid_in is 1
    When a rising edge of clk occurs
    Then valid_out should be 0

  @data_in_ignored_when_invalid
  Formal Scenario: data_in is ignored and no state progress occurs when valid_in is low
    Given rst_n is 1
    And the internal bit counter is N
    And valid_in is 0
    And data_in is any value Y
    When a rising edge of clk occurs
    Then the internal bit counter should remain equal to N
    And the internal bit accumulator should remain unchanged
    And data_out should remain unchanged
    And valid_out should be 0