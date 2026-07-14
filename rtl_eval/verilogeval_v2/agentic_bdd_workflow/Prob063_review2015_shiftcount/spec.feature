Feature: Four-Bit Shift Register / Down Counter

  As a hardware designer
  I want a 4-bit register that shifts in serial data MSB-first when shift_ena is asserted
  and decrements its value when count_ena is asserted
  So that the same storage element can serve as both a shift register and a down counter

  Background:
    Given a synchronous design clocked on the positive edge of clk
    And the current register value is Q, a symbolic 4-bit value
    And the current input bit is D, a symbolic 1-bit value
    And the current control signals shift_ena and count_ena are symbolic 1-bit values

  @shift @formal
  Formal Scenario: Shift-in behavior when only shift_ena is asserted
    Given shift_ena is 1
    And count_ena is 0
    And data is D
    And q is Q
    When a positive edge of clk occurs
    Then q should equal {D, Q[3:1]}

  @count @formal
  Formal Scenario: Decrement behavior when only count_ena is asserted
    Given shift_ena is 0
    And count_ena is 1
    And q is Q
    When a positive edge of clk occurs
    Then q should equal Q - 1

  @hold @formal
  Formal Scenario: Register holds its value when neither control is asserted
    Given shift_ena is 0
    And count_ena is 0
    And q is Q
    When a positive edge of clk occurs
    Then q should equal Q

  @count @underflow @formal
  Formal Scenario: Down counter wraps around on underflow from zero
    Given shift_ena is 0
    And count_ena is 1
    And q is 4'b0000
    When a positive edge of clk occurs
    Then q should equal 4'b1111

  @shift @sequence @formal
  Formal Scenario: Two consecutive shifts correctly propagate two serial bits
    Given shift_ena is 1
    And count_ena is 0
    And q is Q
    And data is D0, a symbolic 1-bit value
    When a positive edge of clk occurs
    Then q should equal {D0, Q[3:1]}
    Given shift_ena is 1
    And count_ena is 0
    And data is D1, a symbolic 1-bit value
    When a positive edge of clk occurs
    Then q should equal {D1, D0, Q[3:2]}

  @count @sequence @formal
  Formal Scenario: Two consecutive decrements reduce the value by two
    Given shift_ena is 0
    And count_ena is 1
    And q is Q
    When a positive edge of clk occurs
    Then q should equal Q - 1
    Given shift_ena is 0
    And count_ena is 1
    When a positive edge of clk occurs
    Then q should equal Q - 2

  @dont_care @formal
  Formal Scenario: Behavior is unconstrained when both control signals are asserted
    Given shift_ena is 1
    And count_ena is 1
    And q is Q
    When a positive edge of clk occurs
    Then q may take any 4-bit value with no formal constraint imposed

  @stability @formal
  Formal Scenario: q only changes on a clock edge
    Given q is Q
    And shift_ena is 0
    And count_ena is 0
    When no positive edge of clk occurs
    Then q should remain equal to Q