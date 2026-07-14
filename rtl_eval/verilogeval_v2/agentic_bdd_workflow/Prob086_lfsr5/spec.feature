Feature: 5-bit Maximal-Length Galois LFSR with Taps at Positions 5 and 3

  As a hardware designer
  I want a 5-bit Galois LFSR with taps at bit positions 5 and 3
  So that it cycles through all 31 non-zero states before repeating

  Background:
    Given a synchronous design with input clk
    And an active-high synchronous reset input reset
    And a 5-bit output q
    And all state updates occur on the positive edge of clk

  @reset @synchronous
  Formal Scenario: Synchronous reset forces output to 1
    Given the current value of q is any 5-bit value Q
    And reset is 1
    When a positive edge of clk occurs
    Then q should become 5'b00001 in the next cycle

  @reset @priority
  Formal Scenario: Reset takes priority over LFSR shifting
    Given the current value of q is any 5-bit value Q
    And reset is 1
    When a positive edge of clk occurs
    Then q should become 5'b00001 in the next cycle
    And this holds regardless of the value of Q

  @transition @bit0
  Formal Scenario: Bit 0 shifts in from bit 1 with no tap
    Given the current value of q is any 5-bit value Q
    And reset is 0
    When a positive edge of clk occurs
    Then q[0] should become Q[1]

  @transition @bit1
  Formal Scenario: Bit 1 shifts in from bit 2 with no tap
    Given the current value of q is any 5-bit value Q
    And reset is 0
    When a positive edge of clk occurs
    Then q[1] should become Q[2]

  @transition @bit2 @tap
  Formal Scenario: Bit 2 shifts in from bit 3 XORed with feedback bit 0 (tap at position 3)
    Given the current value of q is any 5-bit value Q
    And reset is 0
    When a positive edge of clk occurs
    Then q[2] should become Q[3] ^ Q[0]

  @transition @bit3
  Formal Scenario: Bit 3 shifts in from bit 4 with no tap
    Given the current value of q is any 5-bit value Q
    And reset is 0
    When a positive edge of clk occurs
    Then q[3] should become Q[4]

  @transition @bit4 @tap
  Formal Scenario: Bit 4 receives wraparound feedback bit 0 (tap at position 5)
    Given the current value of q is any 5-bit value Q
    And reset is 0
    When a positive edge of clk occurs
    Then q[4] should become Q[0]

  @invariant @nonzero
  Formal Scenario: The LFSR never reaches the all-zero state
    Given the current value of q is any nonzero 5-bit value Q
    And reset is 0
    When a positive edge of clk occurs
    Then the resulting value of q should not equal 5'b00000

  @invariant @reachability
  Formal Scenario: The all-zero state cannot be entered even from reset value
    Given reset has been deasserted after being asserted at least once
    And q currently holds the reset value 5'b00001
    When any sequence of positive clk edges occurs with reset held at 0
    Then q should never equal 5'b00000

  @combinational @next_state_function
  Formal Scenario: Next state is a pure function of current state and reset
    Given the current value of q is any 5-bit value Q
    And reset is any value R
    When a positive edge of clk occurs
    Then the next value of q should equal 5'b00001 if R is 1
    And the next value of q should equal the concatenation of Q[0], Q[4], Q[3]^Q[0], Q[2], Q[1] if R is 0