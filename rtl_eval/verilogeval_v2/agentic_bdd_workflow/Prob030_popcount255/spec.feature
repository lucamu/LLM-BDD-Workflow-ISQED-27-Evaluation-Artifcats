Feature: 255-bit Population Count Circuit

  As a hardware designer
  I want to verify a combinational population count circuit
  So that the output correctly reflects the number of '1' bits in the input vector

  Background:
    Given a combinational module TopModule
    And an input vector "in" of 255 bits
    And an output vector "out" of 8 bits
    And "out" represents the count of '1' bits in "in"

  @basic @zero
  Formal Scenario: All zeros produce a zero count
    Given "in" is 255'b0
    When the module evaluates the output
    Then "out" should equal 8'd0

  @basic @allones
  Formal Scenario: All ones produce maximum count
    Given "in" is 255'b1 repeated to fill all 255 bits (all bits set to 1)
    When the module evaluates the output
    Then "out" should equal 8'd255

  @basic @singlebit
  Formal Scenario: Exactly one bit set produces a count of one
    Given a symbolic bit position "k" such that 0 <= k <= 254
    And "in" has bit "k" set to 1 and all other bits set to 0
    When the module evaluates the output
    Then "out" should equal 8'd1

  @range
  Formal Scenario: Output is always within valid range
    Given any symbolic 255-bit input value "in"
    When the module evaluates the output
    Then "out" should be greater than or equal to 8'd0
    And "out" should be less than or equal to 8'd255

  @correctness
  Formal Scenario: Output equals the exact number of set bits
    Given any symbolic 255-bit input value "in"
    When the module evaluates the output
    Then "out" should equal the sum of all individual bits of "in"

  @complement
  Formal Scenario: Popcount of input plus popcount of complement equals total width
    Given any symbolic 255-bit input value "in"
    And a bitwise complement of "in" named "in_comp"
    When the module evaluates the output for "in" as "out"
    And the module evaluates the output for "in_comp" as "out_comp"
    Then "out" plus "out_comp" should equal 8'd255

  @incremental
  Formal Scenario: Setting an additional zero bit increases count by exactly one
    Given any symbolic 255-bit input value "in"
    And a symbolic bit position "k" such that 0 <= k <= 254
    And bit "k" of "in" is 0
    And a modified input "in_mod" equal to "in" with bit "k" set to 1
    When the module evaluates the output for "in" as "out"
    And the module evaluates the output for "in_mod" as "out_mod"
    Then "out_mod" should equal "out" plus 8'd1

  @invariant @clearing
  Formal Scenario: Clearing a set bit decreases count by exactly one
    Given any symbolic 255-bit input value "in"
    And a symbolic bit position "k" such that 0 <= k <= 254
    And bit "k" of "in" is 1
    And a modified input "in_mod" equal to "in" with bit "k" cleared to 0
    When the module evaluates the output for "in" as "out"
    And the module evaluates the output for "in_mod" as "out_mod"
    Then "out_mod" should equal "out" minus 8'd1

  @monotonic
  Formal Scenario: Bitwise superset input has count greater than or equal to subset input
    Given two symbolic 255-bit input values "in_a" and "in_b"
    And every bit set in "in_a" is also set in "in_b" (in_a is a bitwise subset of in_b)
    When the module evaluates the output for "in_a" as "out_a"
    And the module evaluates the output for "in_b" as "out_b"
    Then "out_b" should be greater than or equal to "out_a"

  @combinational @nostate
  Formal Scenario: Output has no dependency on previous state
    Given any symbolic 255-bit input value "in"
    When the module evaluates the output twice for the same "in" value
    Then both evaluations should produce identical "out" values