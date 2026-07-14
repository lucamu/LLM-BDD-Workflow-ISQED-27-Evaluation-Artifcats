Feature: 4-bit Unsigned Pipelined Multiplier
  As a hardware designer
  I want a pipelined 4-bit x 4-bit unsigned multiplier
  So that new multiplications can be issued every clock cycle while
  previous results propagate through a fixed-latency pipeline

  Background:
    Given a signal clk representing the system clock
    And a signal rst_n representing the active-low asynchronous reset
    And a signal mul_a representing a 4-bit unsigned operand
    And a signal mul_b representing a 4-bit unsigned operand
    And a signal mul_out representing the 8-bit registered product
    And all sequential logic is triggered on the positive edge of clk
    And rst_n is asynchronous and active low
    And the pipeline has a fixed latency of 2 clock cycles from input capture to output availability

  @reset @async
  Formal Scenario: Asynchronous reset forces the output to zero
    Given mul_a is any value A
    And mul_b is any value B
    When rst_n is deasserted low at any time, independent of clk edge
    Then mul_out should become 0 immediately, without waiting for a clock edge

  @reset @hold
  Formal Scenario: Output remains zero while reset is held low
    Given rst_n is held low for one or more consecutive clock cycles
    When a positive edge of clk occurs while rst_n is low
    Then mul_out should remain 0

  @pipeline @latency
  Formal Scenario: Pipelined product appears after fixed latency
    Given rst_n has been high for at least 2 clock cycles
    And mul_a held value A exactly 2 clock cycles ago
    And mul_b held value B exactly 2 clock cycles ago
    And rst_n remained high throughout those 2 clock cycles
    When the current positive clock edge occurs
    Then mul_out should equal A * B

  @pipeline @throughput
  Formal Scenario: New inputs accepted every clock cycle without stalling
    Given rst_n is high
    And mul_a and mul_b may change to new values A and B on every clock cycle
    When a positive edge of clk occurs
    Then the module should accept the new mul_a and mul_b values on this edge
    And no stall or backpressure signal is required to hold previous inputs

  @pipeline @ordering
  Formal Scenario: Back-to-back multiplications preserve order through the pipeline
    Given rst_n has been high for at least 3 clock cycles
    And mul_a held value A1 and mul_b held value B1 exactly 2 clock cycles ago
    And mul_a held value A2 and mul_b held value B2 exactly 1 clock cycle ago
    And rst_n remained high throughout those cycles
    When the current positive clock edge occurs
    Then mul_out at the current cycle should equal A1 * B1
    And mul_out at the next clock cycle should equal A2 * B2

  @functional @boundary
  Formal Scenario: Product is zero when either operand is zero
    Given rst_n has been high for at least 2 clock cycles
    And mul_a held value 4'b0000 exactly 2 clock cycles ago
    And mul_b held value B exactly 2 clock cycles ago
    And rst_n remained high throughout those 2 clock cycles
    When the current positive clock edge occurs
    Then mul_out should equal 0

  @functional @boundary
  Formal Scenario: Product reaches maximum value for maximum operands
    Given rst_n has been high for at least 2 clock cycles
    And mul_a held value 4'b1111 exactly 2 clock cycles ago
    And mul_b held value 4'b1111 exactly 2 clock cycles ago
    And rst_n remained high throughout those 2 clock cycles
    When the current positive clock edge occurs
    Then mul_out should equal 8'd225

  @reset @flush
  Formal Scenario: Reset asserted mid-pipeline clears in-flight results
    Given mul_a held value A and mul_b held value B exactly 1 clock cycle ago
    And rst_n was high 1 clock cycle ago
    When rst_n is asserted low before the result would emerge
    Then mul_out should become 0
    And the in-flight product A * B should not appear on mul_out after reset is asserted

  @functional @range
  Formal Scenario: Output value never exceeds the representable 8-bit product range
    Given rst_n has been high for at least 2 clock cycles
    And mul_a held value A exactly 2 clock cycles ago
    And mul_b held value B exactly 2 clock cycles ago
    And rst_n remained high throughout those 2 clock cycles
    When the current positive clock edge occurs
    Then mul_out should equal A * B
    And mul_out should always satisfy mul_out <= 8'd225