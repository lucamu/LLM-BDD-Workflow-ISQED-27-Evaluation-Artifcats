Feature: Fractional Frequency Divider (8.7x) TopModule
  Formal verification of a fractional clock divider that produces an
  average division ratio of 8.7 using a repeating pattern of two
  period lengths (div_e = 8 and div_o = 9 clk_in cycles), summing to
  M_N = 87 clk_in cycles over every 10 clk_out periods, with switching
  point c89 = 24 controlling the div_e/div_o selection.

  Background:
    Given a synchronous design with input clock clk_in
    And an active-low synchronous reset rst
    And an output clock clk_out
    And the parameter M_N equals 8'd87
    And the parameter c89 equals 8'd24
    And the parameter div_e equals 5'd8
    And the parameter div_o equals 5'd9
    And all state updates occur on the rising edge of clk_in

  @reset @deterministic
  Formal Scenario: Active-low reset forces clk_out to a known state
    Given rst is 0
    When a rising edge of clk_in occurs
    Then clk_out should be 0
    And the internal period counter should be 0
    And the internal even/odd phase selector should be in its reset state

  @reset_release
  Formal Scenario: Deasserting reset resumes normal counting from a known state
    Given rst transitions from 0 to 1
    When the first rising edge of clk_in occurs after the transition
    Then the internal period counter should begin incrementing from 0
    And clk_out should remain consistent with the reset-defined initial phase

  @period_bound
  Formal Scenario: Each clk_out period length is either div_e or div_o clk_in cycles
    Given rst has been 1 (inactive) for at least one full clk_out period
    And N is defined as the number of clk_in rising edges observed between
      two consecutive rising edges of clk_out
    When N is measured over any such interval
    Then N should equal div_e or N should equal div_o
    And N should not equal any value other than div_e or div_o

  @average_ratio
  Formal Scenario: Sum of clk_in cycles over 10 consecutive clk_out periods equals M_N
    Given rst has been 1 (inactive) for at least 10 consecutive clk_out periods
    And S is defined as the sum of clk_in rising-edge counts across
      10 consecutive clk_out periods starting at any rising edge of clk_out
    When S is computed over that window
    Then S should equal M_N

  @pattern_composition
  Formal Scenario: The 10-period pattern contains the correct mix of div_e and div_o periods
    Given rst has been 1 (inactive) for at least 10 consecutive clk_out periods
    And countE is defined as the number of periods within any 10 consecutive
      clk_out periods whose length equals div_e
    And countO is defined as the number of periods within the same window
      whose length equals div_o
    When countE and countO are measured over that window
    Then countE plus countO should equal 10
    And countE times div_e plus countO times div_o should equal M_N

  @switching_threshold
  Formal Scenario: Period selection is governed by the c89 switching point
    Given rst has been 1 (inactive)
    And an internal fractional accumulator ACC tracks accumulated phase
      each clk_out period by adding M_N modulo a fixed base tied to c89
    When ACC crosses the c89 threshold during a given clk_out period
    Then the current period length should be div_o
    And when ACC does not cross the c89 threshold
    Then the current period length should be div_e

  @output_dependency
  Formal Scenario: clk_out is a pure function of clk_in and rst history
    Given two executions with identical sequences of clk_in and rst values
      from the same reset state
    When the same number of clk_in rising edges have elapsed in both executions
    Then clk_out should have the same value in both executions

  @no_glitch
  Formal Scenario: clk_out only changes value on a rising edge of clk_in
    Given rst is 1 (inactive)
    When clk_out changes value
    Then that change should occur immediately after a rising edge of clk_in
    And clk_out should not change between rising edges of clk_in

  @monotonic_counter
  Formal Scenario: Internal period counter increments monotonically within a period
    Given rst is 1 (inactive)
    And the internal period counter has value C before a rising edge of clk_in
    And C is less than the currently selected period length minus 1
    When a rising edge of clk_in occurs
    Then the internal period counter should become C + 1
    And clk_out should not toggle

  @counter_wrap
  Formal Scenario: Internal period counter wraps and toggles clk_out at period boundary
    Given rst is 1 (inactive)
    And the internal period counter has reached the currently selected period
      length minus 1
    When a rising edge of clk_in occurs
    Then the internal period counter should reset to 0
    And clk_out should toggle