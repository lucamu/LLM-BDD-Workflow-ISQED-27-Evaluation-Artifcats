Feature: 32-bit Galois LFSR with Taps at Positions 32, 22, 2, 1

  As a hardware designer
  I want a 32-bit Galois LFSR with synchronous active-high reset
  So that the output q evolves correctly according to the tap configuration

  Background:
    Given a signal clk representing the system clock
    And a signal reset representing the synchronous active-high reset
    And a 32-bit output q representing the LFSR state
    And all sequential updates occur on the positive edge of clk

  @reset
  Formal Scenario: Synchronous reset forces q to 32'h1
    Given the current value of q is any value Q
    And reset is 1
    When a positive clock edge occurs
    Then q should equal 32'h00000001 after the edge

  @feedback_bit0
  Formal Scenario: Feedback into bit 0 (tap position 1) XORs bit 1 with bit 0
    Given the current value of q is any value Q
    And reset is 0
    When a positive clock edge occurs
    Then q[0] after the edge should equal Q[1] XOR Q[0]

  @feedback_bit1
  Formal Scenario: Feedback into bit 1 (tap position 2) XORs bit 2 with bit 0
    Given the current value of q is any value Q
    And reset is 0
    When a positive clock edge occurs
    Then q[1] after the edge should equal Q[2] XOR Q[0]

  @feedback_bit21
  Formal Scenario: Feedback into bit 21 (tap position 22) XORs bit 22 with bit 0
    Given the current value of q is any value Q
    And reset is 0
    When a positive clock edge occurs
    Then q[21] after the edge should equal Q[22] XOR Q[0]

  @feedback_bit31
  Formal Scenario: Feedback into bit 31 (tap position 32) equals bit 0
    Given the current value of q is any value Q
    And reset is 0
    When a positive clock edge occurs
    Then q[31] after the edge should equal Q[0]

  @shift_non_tap_low
  Formal Scenario: Non-tap bits below position 22 shift right unchanged
    Given the current value of q is any value Q
    And reset is 0
    And a bit index i such that i is in the range 2 to 20 inclusive
    When a positive clock edge occurs
    Then q[i] after the edge should equal Q[i + 1]

  @shift_non_tap_high
  Formal Scenario: Non-tap bits above position 22 and below position 32 shift right unchanged
    Given the current value of q is any value Q
    And reset is 0
    And a bit index i such that i is in the range 22 to 30 inclusive
    When a positive clock edge occurs
    Then q[i] after the edge should equal Q[i + 1]

  @reset_priority
  Formal Scenario: Reset takes priority over normal LFSR update
    Given the current value of q is any value Q
    And reset is 1
    When a positive clock edge occurs
    Then q after the edge should equal 32'h00000001 regardless of Q

  @no_reset_full_update
  Formal Scenario: Full next-state function when reset is deasserted
    Given the current value of q is any value Q
    And reset is 0
    When a positive clock edge occurs
    Then q[0] after the edge should equal Q[1] XOR Q[0]
    And q[1] after the edge should equal Q[2] XOR Q[0]
    And q[21] after the edge should equal Q[22] XOR Q[0]
    And q[31] after the edge should equal Q[0]
    And for every bit index i in the range 2 to 20 inclusive, q[i] after the edge should equal Q[i + 1]
    And for every bit index i in the range 22 to 30 inclusive, q[i] after the edge should equal Q[i + 1]

  @deterministic_reset_value
  Formal Scenario: Output is a deterministic function of state and reset with no unknown bits
    Given the current value of q is any value Q
    And reset is any value R
    When a positive clock edge occurs
    Then q after the edge should equal 32'h00000001 if R equals 1
    And if R equals 0 then q[0] after the edge should equal Q[1] XOR Q[0]
    And if R equals 0 then q[1] after the edge should equal Q[2] XOR Q[0]
    And if R equals 0 then q[21] after the edge should equal Q[22] XOR Q[0]
    And if R equals 0 then q[31] after the edge should equal Q[0]
    And if R equals 0 then for every bit index i in the range 2 to 20 inclusive, q[i] after the edge should equal Q[i + 1]
    And if R equals 0 then for every bit index i in the range 22 to 30 inclusive, q[i] after the edge should equal Q[i + 1]