Feature: Decimal Up/Down Counter with Zero Detection
  This module implements a 4-bit BCD (0-9) up/down counter with an
  active-low asynchronous reset and a registered zero-detection flag.
  The zero flag is asserted one clock cycle after the counter value
  equals zero.

  Background:
    Given the design is TopModule
    And a clock clk with rising edge triggered sequential logic
    And an active-low asynchronous reset rst_n
    And a mode input mode
    And a 4-bit registered output number
    And a registered output zero

  @reset @async
  Formal Scenario: Asynchronous reset forces counter and zero to 0
    Given rst_n is 0
    When a rising edge of clk occurs
    Then number should be 4'b0000
    And zero should be 0

  @reset @async
  Formal Scenario: Reset holds counter and zero at 0 regardless of mode
    Given rst_n is 0
    And mode is any value M
    When a rising edge of clk occurs
    Then number should be 4'b0000
    And zero should be 0

  @count_up @increment
  Formal Scenario: Counter increments by one when mode is 1 and value is not 9
    Given rst_n is 1
    And mode is 1
    And number holds value N where N is less than 4'd9
    When a rising edge of clk occurs
    Then number should be N + 1

  @count_up @wraparound
  Formal Scenario: Counter wraps from 9 to 0 when mode is 1
    Given rst_n is 1
    And mode is 1
    And number holds value 4'd9
    When a rising edge of clk occurs
    Then number should be 4'd0

  @count_down @decrement
  Formal Scenario: Counter decrements by one when mode is 0 and value is not 0
    Given rst_n is 1
    And mode is 0
    And number holds value N where N is greater than 4'd0 and N is less than or equal to 4'd9
    When a rising edge of clk occurs
    Then number should be N - 1

  @count_down @wraparound
  Formal Scenario: Counter wraps from 0 to 9 when mode is 0
    Given rst_n is 1
    And mode is 0
    And number holds value 4'd0
    When a rising edge of clk occurs
    Then number should be 4'd9

  @range @invariant
  Formal Scenario: Counter value is always within the decimal range 0 to 9
    Given rst_n is 1
    And number holds any valid value N
    When a rising edge of clk occurs
    Then number should be less than or equal to 4'd9

  @zero_flag @assertion
  Formal Scenario: Zero flag asserts one cycle after number equals 0
    Given rst_n is 1
    And number holds value 4'd0
    When a rising edge of clk occurs
    Then zero should be 1

  @zero_flag @deassertion
  Formal Scenario: Zero flag deasserts one cycle after number is nonzero
    Given rst_n is 1
    And number holds value N where N is not equal to 4'd0
    When a rising edge of clk occurs
    Then zero should be 0

  @zero_flag @registered
  Formal Scenario: Zero flag reflects the number value from the previous cycle
    Given rst_n is 1
    And number holds value N
    When a rising edge of clk occurs
    Then zero should be 1 if N equals 4'd0 else 0

  @zero_flag @reset_interaction
  Formal Scenario: Zero flag is forced low during reset even if number was 0
    Given rst_n is 0
    And number holds value 4'd0
    When a rising edge of clk occurs
    Then zero should be 0

  @mode_switch @up_then_down
  Formal Scenario: Counter switches from increment to decrement behavior based on mode
    Given rst_n is 1
    And number holds value N where N is greater than 4'd0 and N is less than 4'd9
    And mode is 1
    When a rising edge of clk occurs
    Then number should be N + 1
    Given rst_n is 1
    And number holds value N
    And mode is 0
    When a rising edge of clk occurs
    Then number should be N - 1

  @stability @no_reset_no_change_mode
  Formal Scenario: Counter does not change value without a clock edge
    Given rst_n is 1
    And number holds value N
    And no rising edge of clk occurs
    Then number should remain N