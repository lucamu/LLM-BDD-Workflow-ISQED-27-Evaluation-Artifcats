Feature: 12-Hour Digital Clock with BCD Outputs and AM/PM Indicator

  As a hardware designer
  I want to verify a 12-hour clock module with BCD-encoded hours, minutes, seconds
  So that it correctly counts time, wraps at proper boundaries, and toggles AM/PM at the correct transition

  Background:
    Given a signal clk
    And a signal reset
    And a signal ena
    And a signal pm
    And an 8-bit signal hh
    And an 8-bit signal mm
    And an 8-bit signal ss
    And all sequential logic is triggered on the positive edge of clk
    And reset is synchronous and active high
    And hh represents two BCD digits: hh[7:4] is the tens digit and hh[3:0] is the ones digit
    And mm represents two BCD digits: mm[7:4] is the tens digit and mm[3:0] is the ones digit
    And ss represents two BCD digits: ss[7:4] is the tens digit and ss[3:0] is the ones digit

  @reset @priority
  Formal Scenario: Reset forces the clock to 12:00:00 AM regardless of enable
    Given reset is 1
    And ena is any value
    And pm has any value P
    And hh has any value H
    And mm has any value M
    And ss has any value S
    When a clock edge occurs
    Then pm should become 0
    And hh should become 8'h12
    And mm should become 8'h00
    And ss should become 8'h00

  @hold @idle
  Formal Scenario: No reset and no enable holds all state
    Given reset is 0
    And ena is 0
    And pm has value P
    And hh has value H
    And mm has value M
    And ss has value S
    When a clock edge occurs
    Then pm should remain P
    And hh should remain H
    And mm should remain M
    And ss should remain S

  @seconds @increment
  Formal Scenario: Seconds increment by one BCD count when enabled and not at 59
    Given reset is 0
    And ena is 1
    And ss has value S where S is a valid BCD value less than 8'h59
    And pm has value P
    And hh has value H
    And mm has value M
    When a clock edge occurs
    Then ss should become the BCD increment of S
    And mm should remain M
    And hh should remain H
    And pm should remain P

  @seconds @rollover
  Formal Scenario: Seconds roll over from 59 to 00 and increment minutes
    Given reset is 0
    And ena is 1
    And ss has value 8'h59
    And mm has value M where M is a valid BCD value less than 8'h59
    And pm has value P
    And hh has value H
    When a clock edge occurs
    Then ss should become 8'h00
    And mm should become the BCD increment of M
    And hh should remain H
    And pm should remain P

  @minutes @rollover
  Formal Scenario: Minutes roll over from 59 to 00 and increment hours when seconds also roll over
    Given reset is 0
    And ena is 1
    And ss has value 8'h59
    And mm has value 8'h59
    And hh has value H where H is a valid BCD hour value from 8'h01 to 8'h11
    And pm has value P
    When a clock edge occurs
    Then ss should become 8'h00
    And mm should become 8'h00
    And hh should become the BCD increment of H
    And pm should remain P

  @hours @increment @no_pm_toggle
  Formal Scenario: Hour increments from 1 through 11 without toggling AM/PM
    Given reset is 0
    And ena is 1
    And ss has value 8'h59
    And mm has value 8'h59
    And hh has value H where H is a valid BCD hour value from 8'h01 to 8'h10
    And pm has value P
    When a clock edge occurs
    Then hh should become the BCD increment of H
    And pm should remain P

  @hours @rollover @pm_toggle
  Formal Scenario: Hour rolls over from 12 to 1 and toggles AM/PM indicator
    Given reset is 0
    And ena is 1
    And ss has value 8'h59
    And mm has value 8'h59
    And hh has value 8'h12
    And pm has value P
    When a clock edge occurs
    Then hh should become 8'h01
    And pm should become the logical complement of P

  @hours @no_change_without_minute_rollover
  Formal Scenario: Hours do not change unless both minutes and seconds roll over
    Given reset is 0
    And ena is 1
    And hh has value H
    And pm has value P
    And NOT (ss equals 8'h59 and mm equals 8'h59)
    When a clock edge occurs
    Then hh should remain H
    And pm should remain P

  @invariant @bcd_seconds
  Formal Scenario: Seconds value always remains a valid BCD number in range 00-59
    Given reset is 0
    And ss has any valid BCD value less than or equal to 8'h59
    When a clock edge occurs with ena equal to any value
    Then ss[7:4] should be less than or equal to 4'd5
    And ss[3:0] should be less than or equal to 4'd9

  @invariant @bcd_minutes
  Formal Scenario: Minutes value always remains a valid BCD number in range 00-59
    Given reset is 0
    And mm has any valid BCD value less than or equal to 8'h59
    And ss has any valid BCD value less than or equal to 8'h59
    When a clock edge occurs with ena equal to any value
    Then mm[7:4] should be less than or equal to 4'd5
    And mm[3:0] should be less than or equal to 4'd9

  @invariant @bcd_hours
  Formal Scenario: Hour value always remains a valid BCD number in range 01-12
    Given reset is 0
    And hh has any valid BCD value between 8'h01 and 8'h12 inclusive
    And mm has any valid BCD value less than or equal to 8'h59
    And ss has any valid BCD value less than or equal to 8'h59
    When a clock edge occurs with ena equal to any value
    Then hh should be greater than or equal to 8'h01
    And hh should be less than or equal to 8'h12

  @invariant @never_zero_hour
  Formal Scenario: Hour value never equals zero
    Given reset is 0
    And hh has any valid BCD value between 8'h01 and 8'h12 inclusive
    And mm has any valid BCD value less than or equal to 8'h59
    And ss has any valid BCD value less than or equal to 8'h59
    When a clock edge occurs with ena equal to any value
    Then hh should not equal 8'h00

  @reset @sync_priority_over_hold
  Formal Scenario: Reset overrides an idle (disabled) state
    Given reset is 1
    And ena is 0
    And pm has value P
    And hh has value H
    And mm has value M
    And ss has value S
    When a clock edge occurs
    Then pm should become 0
    And hh should become 8'h12
    And mm should become 8'h00
    And ss should become 8'h00