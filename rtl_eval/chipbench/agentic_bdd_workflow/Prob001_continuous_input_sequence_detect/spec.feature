Feature: 8-bit Shift Register with Pattern Match Detection

  As a hardware designer
  I want an 8-bit shift register that shifts in serial input `a`
  So that the module asserts `match` whenever the register equals pattern 8'b0111_0001

  Background:
    Given a signal clk
    And a signal rst_n
    And a signal a
    And an output match
    And an internal 8-bit shift register a_tem
    And the design updates state on the rising edge of clk

  @reset @synchronous
  Formal Scenario: Reset clears the shift register and de-asserts match
    Given rst_n is 0
    When a rising edge of clk occurs
    Then a_tem should be 8'b0000_0000
    And match should be 0

  @reset @deassert
  Formal Scenario: Reset holds shift register and match low regardless of input a
    Given rst_n is 0
    And a is any value X
    When a rising edge of clk occurs
    Then a_tem should be 8'b0000_0000
    And match should be 0

  @shift @functional
  Formal Scenario: Shift register shifts left and inserts input a at LSB
    Given rst_n is 1
    And a_tem holds value P before the clock edge
    And a is value X
    When a rising edge of clk occurs
    Then a_tem should be {P[6:0], X}

  @shift @sequence
  Formal Scenario: Shift register retains only the 8 most recent bits of a
    Given rst_n is 1
    And a_tem holds value P before the clock edge
    And a is value X
    When a rising edge of clk occurs
    Then bit 0 of a_tem should be X
    And bits 7:1 of a_tem should equal bits 6:0 of P

  @match @combinational
  Formal Scenario: Match asserts when shift register equals target pattern
    Given rst_n is 1
    And a_tem holds value P
    When P equals 8'b0111_0001
    Then match should be 1

  @match @combinational
  Formal Scenario: Match de-asserts when shift register does not equal target pattern
    Given rst_n is 1
    And a_tem holds value P
    When P does not equal 8'b0111_0001
    Then match should be 0

  @match @general
  Formal Scenario: Match output is a pure function of the shift register value
    Given rst_n is 1
    And a_tem holds value P
    Then match should be 1 if and only if P equals 8'b0111_0001

  @invariant @reset_recovery
  Formal Scenario: After reset de-assertion, shift register evolves only from shifted-in input
    Given rst_n is 0
    When a rising edge of clk occurs
    Then a_tem should be 8'b0000_0000
    Given rst_n is 1
    And a is value X0
    When a rising edge of clk occurs
    Then a_tem should be {7'b0000000, X0}