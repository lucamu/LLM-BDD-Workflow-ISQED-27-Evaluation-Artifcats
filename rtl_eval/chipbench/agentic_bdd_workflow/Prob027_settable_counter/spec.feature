Feature: Hexadecimal Settable Counter

  As a hardware designer
  I want a 4-bit hexadecimal counter with synchronous set and asynchronous reset
  So that the counter can be verified formally for correct behavior

  Background:
    Given a signal clk
    And a signal rst_n
    And a signal set
    And a signal [3:0] set_num
    And a signal [3:0] number
    And a signal zero
    And all sequential logic is triggered on the positive edge of clk
    And rst_n is an active low asynchronous reset

  @reset
  Formal Scenario: Asynchronous reset forces counter to zero
    Given rst_n is 0
    When a rising edge of clk occurs
    Then number should be 4'h0
    And zero should be 1

  @reset
  Formal Scenario: Reset takes priority over set
    Given rst_n is 0
    And set is 1
    And set_num is any value X
    When a rising edge of clk occurs
    Then number should be 4'h0
    And zero should be 1

  @set
  Formal Scenario: Set operation loads set_num into number
    Given rst_n is 1
    And set is 1
    And set_num is any value X
    And number currently holds any value N
    When a rising edge of clk occurs
    Then number should be equal to X

  @set
  Formal Scenario: Zero flag reflects set_num value when set is asserted
    Given rst_n is 1
    And set is 1
    And set_num is any value X
    When a rising edge of clk occurs
    Then zero should be 1 if X equals 4'h0
    And zero should be 0 if X does not equal 4'h0

  @count
  Formal Scenario: Counter increments by one when set is inactive
    Given rst_n is 1
    And set is 0
    And number currently holds any value N
    When a rising edge of clk occurs
    Then number should be equal to N plus 1 modulo 16

  @count
  Formal Scenario: Counter wraps from F to 0
    Given rst_n is 1
    And set is 0
    And number currently holds value 4'hF
    When a rising edge of clk occurs
    Then number should be 4'h0
    And zero should be 1

  @zero
  Formal Scenario: Zero flag is high only when number is zero after counting
    Given rst_n is 1
    And set is 0
    And number currently holds any value N
    When a rising edge of clk occurs
    Then zero should be 1 if (N plus 1 modulo 16) equals 4'h0
    And zero should be 0 if (N plus 1 modulo 16) does not equal 4'h0

  @zero
  Formal Scenario: Zero output is combinationally consistent with number
    Given rst_n is 1
    And number currently holds any value N
    Then zero should be 1 if N equals 4'h0
    And zero should be 0 if N does not equal 4'h0

  @stability
  Formal Scenario: Counter holds no undefined state after reset deassertion
    Given rst_n transitions from 0 to 1
    And set is 0
    When a rising edge of clk occurs
    Then number should be equal to 4'h1