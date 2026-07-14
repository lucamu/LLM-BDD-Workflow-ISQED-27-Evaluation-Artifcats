Feature: Stopwatch Module with Second and Minute Counters

  As a hardware designer
  I want a stopwatch module that counts seconds from 1 to 60 and minutes from 0 to 60
  So that it correctly tracks elapsed time and pauses when the minute counter saturates

  Background:
    Given the design is TopModule
    And clk is the system clock
    And rst_n is the active-low asynchronous reset
    And second is a 6-bit output register
    And minute is a 6-bit output register
    And all sequential updates occur on the positive edge of clk
    And rst_n is asserted asynchronously and takes effect immediately regardless of clk

  @reset @async
  Formal Scenario: Asynchronous reset clears both counters
    Given second holds any value S
    And minute holds any value M
    When rst_n is deasserted low
    Then second should become 0 immediately
    And minute should become 0 immediately

  @reset @deassert
  Formal Scenario: Counters remain zero while reset is held low
    Given rst_n is held low
    When a rising edge of clk occurs
    Then second should remain 0
    And minute should remain 0

  @init @from-reset
  Formal Scenario: Second counter starts counting from reset value
    Given rst_n is deasserted then asserted high
    And second equals 0
    And minute is less than 60
    When a rising edge of clk occurs
    Then second should become 1
    And minute should remain unchanged

  @normal @increment
  Formal Scenario: Second counter increments normally without wrap
    Given rst_n is asserted high
    And second equals value S where S is greater than 0 and less than 60
    And minute is less than 60
    When a rising edge of clk occurs
    Then second should become S + 1
    And minute should remain unchanged

  @wrap @minute-increment
  Formal Scenario: Second counter wraps from 60 to 1 and minute increments
    Given rst_n is asserted high
    And second equals 60
    And minute equals value M where M is less than 60
    When a rising edge of clk occurs
    Then second should become 1
    And minute should become M + 1

  @saturate @pause-trigger
  Formal Scenario: Minute counter reaches 60 and stopwatch enters pause state
    Given rst_n is asserted high
    And second equals 60
    And minute equals 59
    When a rising edge of clk occurs
    Then second should become 1
    And minute should become 60

  @pause @hold
  Formal Scenario: Stopwatch pauses when minute counter equals 60
    Given rst_n is asserted high
    And minute equals 60
    And second equals value S
    When a rising edge of clk occurs
    Then second should remain S
    And minute should remain 60

  @pause @multi-cycle-hold
  Formal Scenario: Stopwatch remains paused across multiple clock cycles
    Given rst_n is asserted high
    And minute equals 60
    And second equals value S
    When two consecutive rising edges of clk occur
    Then second should remain S
    And minute should remain 60

  @reset @priority
  Formal Scenario: Reset takes priority over paused state
    Given rst_n is asserted high
    And minute equals 60
    And second equals value S
    When rst_n is deasserted low
    Then second should become 0
    And minute should become 0

  @reset @priority-during-count
  Formal Scenario: Reset takes priority over normal counting
    Given rst_n is asserted high
    And second equals value S where S is greater than 0 and less than or equal to 60
    And minute equals value M where M is less than or equal to 60
    When rst_n is deasserted low at the same time as a rising edge of clk
    Then second should become 0
    And minute should become 0

  @boundary @minute-not-yet-max
  Formal Scenario: Second counter increments normally when minute is one below saturation
    Given rst_n is asserted high
    And second equals value S where S is greater than 0 and less than 60
    And minute equals 59
    When a rising edge of clk occurs
    Then second should become S + 1
    And minute should remain 59