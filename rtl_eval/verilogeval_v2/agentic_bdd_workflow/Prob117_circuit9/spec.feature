Feature: TopModule sequential 3-bit counter with load control

  The module TopModule contains a 3-bit register q that is updated only
  on the rising edge of clk. The next value of q depends on the current
  value of q and on the input a:
    - If a is 1, q is loaded with the fixed value 4 (3'b100).
    - If a is 0 and q is less than 6, q increments by 1.
    - If a is 0 and q equals 6, q wraps around to 0.
  There is no reset input; the initial value of q is unconstrained
  (don't-care) until the first rising edge of clk.

  Background:
    Given a design named TopModule with input clk, input a, and output q of 3 bits
    And the register q updates only on the rising edge of clk
    And all other times q holds its previous value

  @load @posedge
  Formal Scenario: Loading fixed value 4 when a is asserted
    Given the current value of q is q_prev
    And the input a is 1
    When a rising edge of clk occurs
    Then q should become 3'b100

  @increment @posedge
  Formal Scenario: Incrementing q when a is deasserted and q_prev is below the wrap point
    Given the current value of q is q_prev
    And the input a is 0
    And q_prev is less than 3'b110
    When a rising edge of clk occurs
    Then q should become q_prev + 1

  @wraparound @posedge
  Formal Scenario: Wrapping to zero when a is deasserted and q_prev equals the wrap point
    Given the current value of q is q_prev
    And q_prev equals 3'b110
    And the input a is 0
    When a rising edge of clk occurs
    Then q should become 3'b000

  @stability @no_edge
  Formal Scenario: Holding value when no rising edge of clk occurs
    Given the current value of q is q_prev
    And the input a may take any value
    When no rising edge of clk occurs
    Then q should remain q_prev

  @load_priority @posedge
  Formal Scenario: Load takes priority over increment or wraparound
    Given the current value of q is q_prev
    And the input a is 1
    When a rising edge of clk occurs
    Then q should become 3'b100
    And q should not depend on q_prev