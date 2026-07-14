Feature: Sequence Detector for "0110" Pattern with Data-Valid Gating

  As a hardware designer
  I want to detect the exact sequence "0110" in a filtered data stream
  So that match is asserted only when a valid 0-1-1-0 pattern completes, ignoring invalid samples

  Background:
    Given a clock signal clk
    And an active-low synchronous reset rst_n
    And an input data
    And an input data_valid
    And an output match
    And all state transitions occur on the rising edge of clk
    And the module implements a state machine tracking progress toward the sequence "0110" using only samples where data_valid is high

  @reset
  Formal Scenario: Reset forces match to zero
    Given rst_n is 0
    When a rising clock edge occurs with any data value X and any data_valid value V
    Then match should be 0

  @reset
  Formal Scenario: Match is zero on the first valid cycle after reset deassertion
    Given rst_n transitions from 0 to 1
    And data_valid is 1 at the first cycle after reset
    And the data input at the first cycle after reset equals any value X
    When a rising clock edge occurs
    Then match should be 0

  @sequence_detection
  Formal Scenario: Detect the exact sequence 0110 across four valid cycles
    Given rst_n is 1
    And data_valid is 1 at cycle 1, cycle 2, cycle 3, and cycle 4
    And the data input equals 0 at cycle 1
    And the data input equals 1 at cycle 2
    And the data input equals 1 at cycle 3
    And the data input equals 0 at cycle 4
    When these four values are processed sequentially on successive rising clock edges
    Then match should be 0 at cycle 1
    And match should be 0 at cycle 2
    And match should be 0 at cycle 3
    And match should be 1 at cycle 4

  @sequence_detection
  Formal Scenario: No match when the four valid data values do not form 0110
    Given rst_n is 1
    And data_valid is 1 at cycle 1, cycle 2, cycle 3, and cycle 4
    And the data values D1, D2, D3, D4 at cycles 1 through 4 do not equal 0, 1, 1, 0 in that exact order
    When these four values are processed sequentially on successive rising clock edges
    Then match should be 0 at cycle 4

  @data_valid
  Formal Scenario: Match is zero whenever data_valid is low regardless of data
    Given rst_n is 1
    And data_valid is 0
    When a rising clock edge occurs with any data value X
    Then match should be 0

  @data_valid
  Formal Scenario: Invalid samples are ignored and do not break an in-progress sequence
    Given rst_n is 1
    And data_valid is 1 at cycle 1 with data equal to 0
    And data_valid is 0 at cycle 2 with data equal to any value X
    And data_valid is 1 at cycle 3 with data equal to 1
    And data_valid is 1 at cycle 4 with data equal to 1
    And data_valid is 1 at cycle 5 with data equal to 0
    When these values are processed sequentially on successive rising clock edges
    Then match should be 0 at cycle 1
    And match should be 0 at cycle 2
    And match should be 0 at cycle 3
    And match should be 0 at cycle 4
    And match should be 1 at cycle 5

  @data_valid
  Formal Scenario: Invalid sample surrounded by non-matching valid data still allows correct detection
    Given rst_n is 1
    And data_valid is 1 at cycle 1 with data equal to 0
    And data_valid is 1 at cycle 2 with data equal to 1
    And data_valid is 0 at cycle 3 with data equal to any value X
    And data_valid is 1 at cycle 4 with data equal to 1
    And data_valid is 1 at cycle 5 with data equal to 0
    When these values are processed sequentially on successive rising clock edges
    Then match should be 0 at cycle 4
    And match should be 1 at cycle 5

  @overlap
  Formal Scenario: Overlapping sequence detection across seven valid cycles
    Given rst_n is 1
    And data_valid is 1 at every cycle from cycle 1 through cycle 7
    And the data values at cycles 1 through 7 equal 0, 1, 1, 0, 1, 1, 0 respectively
    When these values are processed sequentially on successive rising clock edges
    Then match should be 0 at cycle 1
    And match should be 0 at cycle 2
    And match should be 0 at cycle 3
    And match should be 1 at cycle 4
    And match should be 0 at cycle 5
    And match should be 0 at cycle 6
    And match should be 1 at cycle 7

  @output_logic
  Formal Scenario: Match pulse does not persist beyond the detection cycle
    Given rst_n is 1
    And data_valid is 1 at cycle 1, cycle 2, cycle 3, cycle 4, and cycle 5
    And the data values at cycles 1 through 4 equal 0, 1, 1, 0 respectively
    And the data value at cycle 5 equals any value X such that cycles 2 through 5 do not form 0, 1, 1, 0
    When these values are processed sequentially on successive rising clock edges
    Then match should be 1 at cycle 4
    And match should be 0 at cycle 5

  @output_logic
  Formal Scenario: Match is always a combinational function of reset and current sequence state
    Given rst_n is 1
    When a rising clock edge occurs with any data value X and any data_valid value V
    Then match should be 1 if and only if the last four valid data samples equal 0, 1, 1, 0 in order
    And match should be 0 otherwise