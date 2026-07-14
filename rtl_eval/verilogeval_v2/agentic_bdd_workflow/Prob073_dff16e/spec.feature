Feature: 16-bit Register with Byte Enable and Synchronous Reset

  As a hardware designer
  I want a 16-bit register file with independent byte-enable write control
  So that I can selectively update the upper or lower byte on each clock cycle

  Background:
    Given a design named "TopModule"
    And input "clk"
    And input "resetn"
    And input "byteena" (2 bits)
    And input "d" (16 bits)
    And output "q" (16 bits)
    And all flip-flops are triggered on the positive edge of "clk"
    And "resetn" is a synchronous active-low reset

  @reset @priority
  Formal Scenario: Synchronous reset clears all bits regardless of byte enable
    Given resetn is 0
    And byteena is any value B
    And d is any value D
    When a rising edge of clk occurs
    Then q should become 16'h0000

  @write @both_bytes
  Formal Scenario: Both bytes updated when byteena is fully asserted
    Given resetn is 1
    And byteena is 2'b11
    And d is any value D
    And q currently holds value Q_prev
    When a rising edge of clk occurs
    Then q should become D

  @write @upper_byte
  Formal Scenario: Only upper byte updated when byteena[1] is asserted and byteena[0] is deasserted
    Given resetn is 1
    And byteena is 2'b10
    And d is any value D
    And q currently holds value Q_prev
    When a rising edge of clk occurs
    Then q[15:8] should become D[15:8]
    And q[7:0] should remain Q_prev[7:0]

  @write @lower_byte
  Formal Scenario: Only lower byte updated when byteena[0] is asserted and byteena[1] is deasserted
    Given resetn is 1
    And byteena is 2'b01
    And d is any value D
    And q currently holds value Q_prev
    When a rising edge of clk occurs
    Then q[7:0] should become D[7:0]
    And q[15:8] should remain Q_prev[15:8]

  @hold @no_write
  Formal Scenario: Register holds its value when no byte enable bits are asserted
    Given resetn is 1
    And byteena is 2'b00
    And d is any value D
    And q currently holds value Q_prev
    When a rising edge of clk occurs
    Then q should remain Q_prev

  @reset @deasserted_upper
  Formal Scenario: Upper byte holds during reset deassertion with only upper enable and prior reset context
    Given resetn is 1
    And byteena is 2'b10
    And d is any value D
    And q currently holds value Q_prev
    When a rising edge of clk occurs
    Then q[15:8] should equal D[15:8]
    And q[7:0] should equal Q_prev[7:0]

  @reset @independent_of_d
  Formal Scenario: Reset overrides data input independent of its value
    Given resetn is 0
    And byteena is 2'b11
    And d is any value D
    When a rising edge of clk occurs
    Then q should become 16'h0000

  @stability @no_clock_edge
  Formal Scenario: q remains unchanged without a clock edge
    Given resetn is any value
    And byteena is any value
    And d is any value
    And q currently holds value Q_prev
    When no rising edge of clk occurs
    Then q should remain Q_prev