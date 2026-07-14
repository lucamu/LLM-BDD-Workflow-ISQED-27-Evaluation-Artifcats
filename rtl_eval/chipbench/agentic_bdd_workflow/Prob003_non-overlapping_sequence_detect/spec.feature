Feature: Sequence Detector for Pattern 011100 (Non-overlapping Groups)

  The TopModule detects the 6-bit sequence 011100 on the `data` input,
  processing input in independent, non-overlapping groups of six clock
  cycles. At the end of every sixth cycle, exactly one of `match` or
  `not_match` is asserted for that single cycle, based on whether the
  six bits collected in that group equal 011100.

  Background:
    Given a signal "clk" that provides the system clock
    Given a signal "rst_n" that is an asynchronous active-low reset
    Given a signal "data" representing the single-bit input to be checked
    Given a signal "match" that asserts when a completed 6-bit group equals 011100
    Given a signal "not_match" that asserts when a completed 6-bit group does not equal 011100
    Given the module evaluates data groups in fixed, non-overlapping blocks of six clock cycles

  @reset @async
  Formal Scenario: Asynchronous reset forces both outputs low regardless of state
    Given the module is in an arbitrary internal state within any group position
    And data holds an arbitrary value X
    When rst_n is asserted low asynchronously, independent of any clock edge
    Then match should be 0
    And not_match should be 0

  @reset @sync
  Formal Scenario: Reset causes a fresh group to begin on the next clock edge
    Given rst_n is asserted low
    When a rising clock edge occurs
    Then match should be 0
    And not_match should be 0
    And the module should begin counting a new group starting at bit position zero

  @mutex
  Formal Scenario: Match and not_match are mutually exclusive at every clock cycle
    Given rst_n is deasserted high
    And data takes an arbitrary sequence of values across successive clock edges
    When any rising clock edge occurs
    Then match and not_match should never both equal 1 simultaneously

  @timing @intermediate
  Formal Scenario: No output asserts before a group of six cycles completes
    Given rst_n is deasserted high
    And a new group begins at the current clock edge with bit position zero
    And data bits D0, D1, D2, D3, D4 are applied on the first five clock edges of the group with arbitrary symbolic values
    When between one and five clock edges have occurred within the current group
    Then match should be 0
    And not_match should be 0

  @match
  Formal Scenario: Match asserts on the sixth cycle when the group equals the target sequence
    Given rst_n is deasserted high
    And a new group begins at the current clock edge with bit position zero
    And six successive data bits D0, D1, D2, D3, D4, D5 are applied on six consecutive clock edges
    And the bit sequence D0, D1, D2, D3, D4, D5 equals 0, 1, 1, 1, 0, 0
    When the sixth clock edge of the group occurs
    Then match should be 1
    And not_match should be 0

  @not_match
  Formal Scenario: Not_match asserts on the sixth cycle when the group differs from the target sequence
    Given rst_n is deasserted high
    And a new group begins at the current clock edge with bit position zero
    And six successive data bits D0, D1, D2, D3, D4, D5 are applied on six consecutive clock edges
    And the bit sequence D0, D1, D2, D3, D4, D5 does not equal 0, 1, 1, 1, 0, 0
    When the sixth clock edge of the group occurs
    Then not_match should be 1
    And match should be 0

  @timing @pulse
  Formal Scenario: Match or not_match pulses for exactly one clock cycle
    Given rst_n is deasserted high
    And a group has just completed at the current clock edge with either match or not_match asserted
    When the next rising clock edge occurs
    Then match should be 0
    And not_match should be 0

  @timing @group_restart
  Formal Scenario: A new group begins immediately after every completed group, regardless of the result
    Given rst_n is deasserted high
    And a group of six cycles has just completed, producing either match or not_match
    When the next rising clock edge occurs
    Then the module should begin evaluating a new group starting at bit position zero
    And the data bit sampled at this cycle should be treated as the first bit of the new group's comparison against target value 0

  @coverage @first_bit_mismatch
  Formal Scenario: Group still requires exactly six cycles even if the first bit already mismatches
    Given rst_n is deasserted high
    And a new group begins with bit position zero
    And the first data bit D0 does not equal 0
    And data bits D1, D2, D3, D4, D5 are arbitrary symbolic values on the following five clock edges
    When the sixth clock edge of the group occurs
    Then not_match should be 1
    And match should be 0