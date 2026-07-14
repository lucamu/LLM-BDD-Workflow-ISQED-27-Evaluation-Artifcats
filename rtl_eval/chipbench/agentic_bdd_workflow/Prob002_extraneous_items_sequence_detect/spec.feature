Feature: Sequence Detector for Pattern "011XXX110"

  As a hardware designer
  I want to detect the 9-bit pattern "011XXX110" in a serial input stream
  So that match is asserted exactly when the last nine sampled bits satisfy
  the fixed prefix "011", fixed suffix "110", and arbitrary middle three bits

  Background:
    Given a synchronous module TopModule with inputs clk, rst_n, a and output match
    Given clk is a free-running clock with a rising edge each cycle
    Given the module contains a 9-bit shift register that shifts in the value of a on every rising edge of clk, with the newest bit entering position 0 and the oldest of the last nine bits residing at position 8
    Given match is derived from the shift register value as (bits 8:6 equal 3'b011) AND (bits 2:0 equal 3'b110), with bits 5:3 unconstrained
    Given rst_n is the active-low synchronous reset for the shift register and match

  @reset
  Formal Scenario: Reset forces match low
    Given rst_n is deasserted low
    When a rising edge of clk occurs while rst_n is low
    Then match should be 0

  @reset_release
  Formal Scenario: Match remains low immediately after reset release with no matching history
    Given rst_n transitions from low to high
    And the shift register has been cleared to all zeros by the reset
    When one rising edge of clk occurs with rst_n high and input a equal to any value V
    Then match should be 0

  @pattern_match_full
  Formal Scenario: Match asserted for exact prefix and suffix regardless of middle bits
    Given rst_n is asserted high for at least nine consecutive clock cycles
    And input a is driven with the sequence of bit values 0, 1, 1, X1, X2, X3, 1, 1, 0 on nine consecutive rising edges of clk, where X1, X2 and X3 are arbitrary bit values
    When the ninth rising edge of clk has completed
    Then match should be 1 for any values of X1, X2 and X3

  @no_match_prefix
  Formal Scenario: No match when the first three bits differ from 011
    Given rst_n is asserted high for at least nine consecutive clock cycles
    And input a is driven with the sequence P1, P2, P3, X1, X2, X3, 1, 1, 0 on nine consecutive rising edges of clk, where the 3-bit value P1P2P3 is not equal to 3'b011, and X1, X2, X3 are arbitrary
    When the ninth rising edge of clk has completed
    Then match should be 0

  @no_match_suffix
  Formal Scenario: No match when the last three bits differ from 110
    Given rst_n is asserted high for at least nine consecutive clock cycles
    And input a is driven with the sequence 0, 1, 1, X1, X2, X3, S1, S2, S3 on nine consecutive rising edges of clk, where the 3-bit value S1S2S3 is not equal to 3'b110, and X1, X2, X3 are arbitrary
    When the ninth rising edge of clk has completed
    Then match should be 0

  @no_match_both_wrong
  Formal Scenario: No match when both prefix and suffix are incorrect
    Given rst_n is asserted high for at least nine consecutive clock cycles
    And input a is driven with the sequence P1, P2, P3, X1, X2, X3, S1, S2, S3 on nine consecutive rising edges of clk, where P1P2P3 is not equal to 3'b011 and S1S2S3 is not equal to 3'b110, and X1, X2, X3 are arbitrary
    When the ninth rising edge of clk has completed
    Then match should be 0

  @general_combinational_property
  Formal Scenario: Match equals the combinational function of the shift register at every cycle
    Given rst_n is asserted high
    And the shift register holds an arbitrary 9-bit history B8, B7, B6, B5, B4, B3, B2, B1, B0 representing the last nine sampled values of a
    When a rising edge of clk occurs with rst_n high
    Then match should equal 1 if and only if B8 equals 0 AND B7 equals 1 AND B6 equals 1 AND B2 equals 1 AND B1 equals 1 AND B0 equals 0, for any values of B5, B4 and B3

  @continuous_no_latching
  Formal Scenario: Match deasserts once the matching window shifts out
    Given rst_n is asserted high
    And the shift register equals a value for which match is 1 on a given cycle
    When one additional rising edge of clk occurs with a new input value a equal to V, causing the oldest bit to shift out
    Then match should be recomputed from the new 9-bit shift register value and should be 0 if the new 8:6 or 2:0 fields no longer equal 3'b011 and 3'b110 respectively

  @overlap_detection
  Formal Scenario: Overlapping pattern occurrences are each independently detected
    Given rst_n is asserted high for at least ten consecutive clock cycles
    And input a is driven such that two overlapping 9-bit windows both satisfy the prefix 011 and suffix 110 with independent don't-care middle bits X1, X2, X3 and Y1, Y2, Y3
    When each respective ninth rising edge of clk for each window has completed
    Then match should be 1 at each of those cycles independent of the values of X1, X2, X3, Y1, Y2 and Y3