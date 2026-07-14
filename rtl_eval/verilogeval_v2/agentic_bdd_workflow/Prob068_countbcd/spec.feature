Feature: 4-Digit BCD Counter with Digit Enables

  As a hardware designer
  I want a 4-digit BCD counter with synchronous reset
  So that each digit counts 0-9 and rolls over correctly, with enable
  signals indicating when upper digits should increment

  Background:
    Given a signal clk representing the system clock
    And a signal reset representing the synchronous active-high reset
    And an output ena representing the 3-bit enable signals for digits 1, 2, and 3
    And an output q representing the 16-bit BCD counter value
    And q[3:0] is the ones digit, q[7:4] is the tens digit, q[11:8] is the hundreds digit, q[15:12] is the thousands digit
    And all sequential updates occur on the rising edge of clk

  @reset
  Formal Scenario: Synchronous reset clears the counter to zero
    Given q holds any current value
    And reset is 1
    When a rising clock edge occurs
    Then q should become 16'h0000

  @reset
  Formal Scenario: Synchronous reset clears the enable signals
    Given q holds any current value
    And reset is 1
    When a rising clock edge occurs
    Then ena should become 3'b000

  @ones_digit_increment
  Formal Scenario: Ones digit increments when not at 9 and reset is deasserted
    Given the ones digit q[3:0] equals value D where D is less than 9
    And reset is 0
    When a rising clock edge occurs
    Then the ones digit q[3:0] should become D + 1
    And the tens digit q[7:4] should remain unchanged
    And the hundreds digit q[11:8] should remain unchanged
    And the thousands digit q[15:12] should remain unchanged

  @ones_digit_wrap
  Formal Scenario: Ones digit wraps from 9 to 0 and asserts ena[1]
    Given the ones digit q[3:0] equals 4'b1001
    And reset is 0
    When a rising clock edge occurs
    Then the ones digit q[3:0] should become 4'b0000
    And ena[1] should be 1 in the cycle before this transition

  @tens_digit_increment
  Formal Scenario: Tens digit increments only when ones digit is 9 and tens digit is not 9
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals value T where T is less than 9
    And reset is 0
    When a rising clock edge occurs
    Then the tens digit q[7:4] should become T + 1
    And ena[1] should be 1 prior to this clock edge

  @tens_digit_hold
  Formal Scenario: Tens digit holds when ones digit is not 9
    Given the ones digit q[3:0] equals value D where D is less than 9
    And the tens digit q[7:4] equals value T
    And reset is 0
    When a rising clock edge occurs
    Then the tens digit q[7:4] should remain T
    And ena[1] should be 0 prior to this clock edge

  @tens_digit_wrap
  Formal Scenario: Tens digit wraps from 9 to 0 and asserts ena[2] precondition
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals 4'b1001
    And reset is 0
    When a rising clock edge occurs
    Then the tens digit q[7:4] should become 4'b0000
    And ena[2] should be 1 prior to this clock edge

  @hundreds_digit_increment
  Formal Scenario: Hundreds digit increments only when ones and tens digits are both 9 and hundreds digit is not 9
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals 4'b1001
    And the hundreds digit q[11:8] equals value H where H is less than 9
    And reset is 0
    When a rising clock edge occurs
    Then the hundreds digit q[11:8] should become H + 1
    And ena[2] should be 1 prior to this clock edge

  @hundreds_digit_hold
  Formal Scenario: Hundreds digit holds when tens digit is not 9
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals value T where T is less than 9
    And the hundreds digit q[11:8] equals value H
    And reset is 0
    When a rising clock edge occurs
    Then the hundreds digit q[11:8] should remain H
    And ena[2] should be 0 prior to this clock edge

  @hundreds_digit_wrap
  Formal Scenario: Hundreds digit wraps from 9 to 0 and asserts ena[3] precondition
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals 4'b1001
    And the hundreds digit q[11:8] equals 4'b1001
    And reset is 0
    When a rising clock edge occurs
    Then the hundreds digit q[11:8] should become 4'b0000
    And ena[3] should be 1 prior to this clock edge

  @thousands_digit_increment
  Formal Scenario: Thousands digit increments only when ones, tens, and hundreds digits are all 9 and thousands digit is not 9
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals 4'b1001
    And the hundreds digit q[11:8] equals 4'b1001
    And the thousands digit q[15:12] equals value K where K is less than 9
    And reset is 0
    When a rising clock edge occurs
    Then the thousands digit q[15:12] should become K + 1
    And ena[3] should be 1 prior to this clock edge

  @thousands_digit_hold
  Formal Scenario: Thousands digit holds when hundreds digit is not 9
    Given the ones digit q[3:0] equals 4'b1001
    And the tens digit q[7:4] equals 4'b1001
    And the hundreds digit q[11:8] equals value H where H is less than 9
    And the thousands digit q[15:12] equals value K
    And reset is 0
    When a rising clock edge occurs
    Then the thousands digit q[15:12] should remain K
    And ena[3] should be 0 prior to this clock edge

  @full_rollover
  Formal Scenario: Full counter rolls over from 9999 to 0000
    Given q equals 16'h9999
    And reset is 0
    When a rising clock edge occurs
    Then q should become 16'h0000
    And ena[1] should be 1 prior to this clock edge
    And ena[2] should be 1 prior to this clock edge
    And ena[3] should be 1 prior to this clock edge

  @ena1_combinational
  Formal Scenario: ena[1] reflects whether ones digit is at maximum value
    Given the ones digit q[3:0] equals value D
    When ena is observed combinationally in the same cycle
    Then ena[1] should be 1 if D equals 4'b1001, else ena[1] should be 0

  @ena2_combinational
  Formal Scenario: ena[2] reflects whether ones and tens digits are both at maximum value
    Given the ones digit q[3:0] equals value D
    And the tens digit q[7:4] equals value T
    When ena is observed combinationally in the same cycle
    Then ena[2] should be 1 if D equals 4'b1001 and T equals 4'b1001, else ena[2] should be 0

  @ena3_combinational
  Formal Scenario: ena[3] reflects whether ones, tens, and hundreds digits are all at maximum value
    Given the ones digit q[3:0] equals value D
    And the tens digit q[7:4] equals value T
    And the hundreds digit q[11:8] equals value H
    When ena is observed combinationally in the same cycle
    Then ena[3] should be 1 if D equals 4'b1001 and T equals 4'b1001 and H equals 4'b1001, else ena[3] should be 0

  @bcd_range_invariant
  Formal Scenario: Each digit always remains within valid BCD range after any clock edge
    Given q holds any reachable value from reset
    And reset is 0
    When a rising clock edge occurs
    Then the ones digit q[3:0] should be less than or equal to 4'b1001
    And the tens digit q[7:4] should be less than or equal to 4'b1001
    And the hundreds digit q[11:8] should be less than or equal to 4'b1001
    And the thousands digit q[15:12] should be less than or equal to 4'b1001