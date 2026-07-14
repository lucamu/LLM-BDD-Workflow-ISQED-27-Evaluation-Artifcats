Feature: Serial Timer with Pattern Detection, Programmable Delay, and Acknowledge Handshake

  As a hardware designer
  I want the TopModule to detect the serial pattern 1101, capture a 4-bit delay,
  count for (delay+1)*1000 cycles, and wait for acknowledgment
  So that the timer behaves as a correct serial-controlled delay circuit

  Background:
    Given clk is the system clock
    And reset is an active-high synchronous reset
    And all state transitions occur on the positive edge of clk
    And data is a single-bit serial input
    And ack is a single-bit input
    And count is a 4-bit output
    And counting and done are single-bit outputs

  @reset
  Formal Scenario: Synchronous reset forces the module into the searching state
    Given reset is 1
    When a positive clock edge occurs
    Then counting should be 0
    And done should be 0

  @reset
  Formal Scenario: Reset overrides any in-progress counting or done state
    Given the module is in any internal state, counting value C, and done value D
    And reset is 1
    When a positive clock edge occurs
    Then counting should be 0
    And done should be 0

  @pattern-detect
  Formal Scenario: Exact pattern 1101 on data begins delay-bit capture
    Given reset is 0
    And the module is in the searching state
    When data is 1 on clock edge 1
    And data is 1 on clock edge 2
    And data is 0 on clock edge 3
    And data is 1 on clock edge 4
    Then counting should be 0 after clock edge 4
    And done should be 0 after clock edge 4
    And the module should begin shifting in delay bits starting from clock edge 5

  @pattern-detect
  Formal Scenario: Non-matching bit sequence does not begin capture
    Given reset is 0
    And the module is in the searching state
    And a symbolic 4-bit sequence S applied to data on four consecutive clock edges
    And S is not equal to 1101
    Then counting should remain 0 on every clock edge during and after sequence S
    And done should remain 0 on every clock edge during and after sequence S

  @pattern-detect
  Formal Scenario: Overlapping partial matches are correctly re-evaluated
    Given reset is 0
    And the module is in the searching state
    When data is 1 on clock edge 1
    And data is 1 on clock edge 2
    And data is 1 on clock edge 3
    And data is 0 on clock edge 4
    And data is 1 on clock edge 5
    Then the module should recognize the pattern 1101 completed at clock edge 5
    And counting should be 0 through clock edge 5
    And the module should begin shifting in delay bits starting from clock edge 6

  @delay-capture
  Formal Scenario: Delay bits are captured MSB-first after pattern match
    Given reset is 0
    And the pattern 1101 has just been matched on data
    And a symbolic 4-bit delay value D3 D2 D1 D0 is applied to data on the next four consecutive clock edges, most-significant bit first
    When the fourth delay bit D0 is shifted in
    Then counting should become 1 on the following clock edge
    And count should equal the concatenation D3 D2 D1 D0 on that clock edge
    And done should be 0 on that clock edge

  @delay-capture
  Formal Scenario: Data input is ignored while counting
    Given reset is 0
    And counting is 1
    And a symbolic delay value delay is loaded into count
    And an arbitrary symbolic bit sequence is applied to data during counting
    Then the internal search/capture state should not change due to data
    And the eventual done assertion timing should be unaffected by data

  @counting
  Formal Scenario: Count holds the loaded delay value for the first 1000 cycles
    Given reset is 0
    And counting has just become 1 with count equal to a symbolic delay value delay
    When 999 additional clock edges occur while counting remains 1
    Then count should remain equal to delay for all of those 1000 cycles (the initial cycle plus 999 more)

  @counting
  Formal Scenario: Count decrements by 1 every 1000 clock cycles
    Given reset is 0
    And counting is 1
    And count equals a symbolic value N at some clock edge that is the start of a 1000-cycle block, with N greater than 0
    When exactly 1000 clock edges elapse
    Then count should equal N - 1 at the start of the next 1000-cycle block
    And counting should remain 1 throughout, provided N - 1 is not the terminal block

  @counting
  Formal Scenario: Total counting duration equals (delay+1)*1000 cycles
    Given reset is 0
    And counting becomes 1 with count initially equal to a symbolic delay value delay
    When exactly (delay + 1) * 1000 clock edges elapse since counting became 1
    Then counting should become 0 at that final clock edge
    And done should become 1 at that same clock edge

  @counting
  Formal Scenario: Counting remains asserted until the full duration elapses
    Given reset is 0
    And counting becomes 1 with count initially equal to a symbolic delay value delay
    When fewer than (delay + 1) * 1000 clock edges have elapsed since counting became 1
    Then counting should remain 1
    And done should remain 0

  @done-ack
  Formal Scenario: Done is asserted immediately after counting completes
    Given reset is 0
    And the counting duration (delay + 1) * 1000 has just elapsed
    Then done should be 1
    And counting should be 0

  @done-ack
  Formal Scenario: Done remains asserted until ack is received
    Given reset is 0
    And done is 1
    And ack is 0
    When a positive clock edge occurs
    Then done should remain 1
    And counting should remain 0

  @done-ack
  Formal Scenario: Acknowledge returns the module to the searching state
    Given reset is 0
    And done is 1
    And ack is 1
    When a positive clock edge occurs
    Then done should become 0
    And counting should become 0
    And the module should resume searching for the pattern 1101 on subsequent data inputs

  @done-ack
  Formal Scenario: A new pattern match is only recognized after acknowledge and return to searching
    Given reset is 0
    And the module has just returned to the searching state following an ack
    When data is 1 on clock edge 1
    And data is 1 on clock edge 2
    And data is 0 on clock edge 3
    And data is 1 on clock edge 4
    Then the module should begin capturing a new symbolic 4-bit delay value starting at clock edge 5
    And counting should be 0 through clock edge 4

  @mutual-exclusion
  Formal Scenario: Counting and done are never asserted simultaneously
    Given reset is 0
    Then it should never be the case that counting is 1 and done is 1 at the same clock edge

  @reset
  Formal Scenario: Reset during counting immediately clears counting and done
    Given reset is 0
    And counting is 1 with count equal to a symbolic value N
    When reset becomes 1
    And a positive clock edge occurs
    Then counting should be 0
    And done should be 0

  @reset
  Formal Scenario: Reset during done-wait immediately clears done
    Given reset is 0
    And done is 1
    And ack is 0
    When reset becomes 1
    And a positive clock edge occurs
    Then done should be 0
    And counting should be 0