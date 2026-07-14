Feature: Overlapping "1011" Sequence Detector (TopModule)

  As a hardware designer
  I want to formally verify a Moore-style overlapping sequence detector
  So that "1011" is correctly detected in the input stream, including overlapping occurrences

  Background:
    Given a synchronous design with input "clk" and active-low reset "rst"
    And a single-bit input "data" sampled on the rising edge of "clk"
    And a single-bit registered output "flag"
    And an internal state register "seq_state" with possible values S0, S1, S2, S3, S4
    And S0 represents "no partial match"
    And S1 represents "matched prefix 1"
    And S2 represents "matched prefix 10"
    And S3 represents "matched prefix 101"
    And S4 represents "matched full pattern 1011 (detection state)"
    And the state transition function follows KMP-style overlap logic for pattern "1011"

  @reset
  Formal Scenario: Reset forces state and flag to known initial values
    Given rst is 0
    When a rising edge of clk occurs
    Then seq_state should be S0
    And flag should be 0

  @reset
  Formal Scenario: Flag remains 0 immediately after reset deassertion with no valid history
    Given rst was 0 in the previous cycle
    And rst is 1 in the current cycle
    When a rising edge of clk occurs
    Then flag should be 0

  @transition
  Formal Scenario: State S0 transitions correctly on any data value
    Given seq_state is S0
    And data is value D
    When a rising edge of clk occurs
    Then seq_state should be S1 if D equals 1
    And seq_state should be S0 if D equals 0
    And flag should be 0

  @transition
  Formal Scenario: State S1 transitions correctly on any data value
    Given seq_state is S1
    And data is value D
    When a rising edge of clk occurs
    Then seq_state should be S1 if D equals 1
    And seq_state should be S2 if D equals 0
    And flag should be 0

  @transition
  Formal Scenario: State S2 transitions correctly on any data value
    Given seq_state is S2
    And data is value D
    When a rising edge of clk occurs
    Then seq_state should be S3 if D equals 1
    And seq_state should be S0 if D equals 0
    And flag should be 0

  @transition @detection
  Formal Scenario: State S3 detects the pattern when data completes "1011"
    Given seq_state is S3
    And data is value D
    When a rising edge of clk occurs
    Then seq_state should be S4 if D equals 1
    And seq_state should be S2 if D equals 0
    And flag should be 1 if D equals 1
    And flag should be 0 if D equals 0

  @transition @overlap
  Formal Scenario: State S4 continues detection with overlap logic
    Given seq_state is S4
    And data is value D
    When a rising edge of clk occurs
    Then seq_state should be S1 if D equals 1
    And seq_state should be S2 if D equals 0
    And flag should be 0

  @flag_pulse
  Formal Scenario: Flag is asserted for exactly one clock cycle after detection
    Given seq_state is S3
    And data is value D
    And D equals 1
    When a rising edge of clk occurs
    Then flag should be 1
    When a subsequent rising edge of clk occurs
    And data is value D2
    Then flag should be 0

  @flag_pulse
  Formal Scenario: Flag never asserts unless the previous state was S3 with data equal to 1
    Given seq_state is any value other than S3
    And data is value D
    When a rising edge of clk occurs
    Then flag should be 0

  @invariant
  Formal Scenario: Flag is always a pure function of the previous state and data
    Given seq_state is any valid state S
    And data is value D
    When a rising edge of clk occurs
    Then flag should equal 1 if and only if S equals S3 and D equals 1

  @invariant
  Formal Scenario: State register always holds one of the five valid encoded states
    Given any reachable configuration of the design
    When a rising edge of clk occurs
    Then seq_state should be one of S0, S1, S2, S3, S4

  @invariant @overlap
  Formal Scenario: Overlap transitions depend only on current state and data, not on history
    Given seq_state is S4
    And data is value D
    When a rising edge of clk occurs
    Then seq_state should be S1 if D equals 1
    And seq_state should be S2 if D equals 0
    And this transition should hold regardless of the sequence of states or data values that led to S4

  @cover @example
  Formal Scenario: Cover overlapping detection is correctly identified twice for "10110111"
    Given seq_state is S0
    And rst is 1
    When data is 1 on a rising clk edge
    Then seq_state should become S1
    When data is 0 on a rising clk edge
    Then seq_state should become S2
    When data is 1 on a rising clk edge
    Then seq_state should become S3
    When data is 1 on a rising clk edge
    Then seq_state should become S4
    And flag should be 1
    When data is 0 on a rising clk edge
    Then seq_state should become S2
    And flag should be 0
    When data is 1 on a rising clk edge
    Then seq_state should become S3
    When data is 1 on a rising clk edge
    Then seq_state should become S4
    And flag should be 1
    When data is 1 on a rising clk edge
    Then seq_state should become S1
    And flag should be 0
    And this scenario is a bounded example trace to be expressed as a cover property, not an assert property

  @cover @example
  Formal Scenario: Cover non-matching sequence never asserts flag
    Given seq_state is S0
    And rst is 1
    When data is 1 on a rising clk edge
    Then seq_state should become S1
    When data is 0 on a rising clk edge
    Then seq_state should become S2
    When data is 0 on a rising clk edge
    Then seq_state should become S0
    And flag should be 0
    When data is 0 on a rising clk edge
    Then seq_state should become S0
    And flag should be 0
    And this scenario is a bounded example trace to be expressed as a cover property, not an assert property