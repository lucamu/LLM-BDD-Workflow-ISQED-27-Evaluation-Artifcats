Feature: Gaming Machine Billing System with Prepaid Charging

  As a hardware designer
  I want to formally verify the TopModule gaming machine billing system
  So that charging, deduction, and warning indicators behave correctly

  Background:
    Given a clock "clk"
    And an active-low asynchronous reset "rst_n"
    And a 10-bit input "money"
    And an input "set"
    And an input "boost"
    And a 10-bit output register "remain"
    And an output register "yellow"
    And an output register "red"
    And on the rising edge of "clk" all sequential outputs update
    And when "rst_n" is deasserted (0) all outputs reset asynchronously regardless of clock

  @reset
  Formal Scenario: Asynchronous reset initializes all outputs to zero
    Given any state of "remain", "yellow", "red", "money", "set", and "boost"
    When "rst_n" is deasserted to 0 asynchronously
    Then "remain" should become 10'b0000000000
    And "yellow" should become 0
    And "red" should become 0

  @charging
  Formal Scenario: Charging adds money to remaining balance when set is active
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 1
    And "boost" is 0
    And "money" holds value M
    When a rising edge of "clk" occurs
    Then "remain" should become R + M

  @charging_boost
  Formal Scenario: Charging adds money to remaining balance during boost mode
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 1
    And "boost" is 1
    And "money" holds value M
    When a rising edge of "clk" occurs
    Then "remain" should become R + M - 2 if R + M >= 2
    And "remain" should become 10'b0000000000 if R + M < 2

  @normal_deduction
  Formal Scenario: Normal mode deducts one yuan per clock cycle
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 0
    And "boost" is 0
    When a rising edge of "clk" occurs
    Then "remain" should become R - 1 if R >= 1
    And "remain" should become 10'b0000000000 if R < 1

  @boost_deduction
  Formal Scenario: Boost mode deducts two yuan per clock cycle
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 0
    And "boost" is 1
    When a rising edge of "clk" occurs
    Then "remain" should become R - 2 if R >= 2
    And "remain" should become 10'b0000000000 if R < 2

  @combined_charge_and_deduct_normal
  Formal Scenario: Simultaneous charging and normal-mode deduction combine correctly
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 1
    And "boost" is 0
    And "money" holds value M
    When a rising edge of "clk" occurs
    Then "remain" should become R + M - 1 if R + M >= 1
    And "remain" should become 10'b0000000000 if R + M < 1

  @combined_charge_and_deduct_boost
  Formal Scenario: Simultaneous charging and boost-mode deduction combine correctly
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 1
    And "boost" is 1
    And "money" holds value M
    When a rising edge of "clk" occurs
    Then "remain" should become R + M - 2 if R + M >= 2
    And "remain" should become 10'b0000000000 if R + M < 2

  @yellow_warning
  Formal Scenario: Yellow warning indicates low but nonzero balance
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    When the current cycle is evaluated combinationally
    Then "yellow" should be 1 if R > 0 and R < 10
    And "yellow" should be 0 if R == 0 or R >= 10

  @red_warning_normal
  Formal Scenario: Red warning indicates insufficient funds in normal mode
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "boost" is 0
    When the current cycle is evaluated combinationally
    Then "red" should be 1 if R < 1
    And "red" should be 0 if R >= 1

  @red_warning_boost
  Formal Scenario: Red warning indicates insufficient funds in boost mode
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "boost" is 1
    When the current cycle is evaluated combinationally
    Then "red" should be 1 if R < 2
    And "red" should be 0 if R >= 2

  @no_underflow
  Formal Scenario: Balance never underflows below zero regardless of mode
    Given "rst_n" is asserted (1)
    And "remain" holds value R
    And "set" is 0
    And "boost" holds any value B
    When a rising edge of "clk" occurs
    Then "remain" should never become greater than R

  @default_mode
  Formal Scenario: Default mode is normal mode when boost is deasserted
    Given "rst_n" is asserted (1)
    And "boost" is 0
    And "remain" holds value R
    And "set" is 0
    When a rising edge of "clk" occurs
    Then "remain" should become R - 1 if R >= 1
    And "remain" should become 10'b0000000000 if R < 1