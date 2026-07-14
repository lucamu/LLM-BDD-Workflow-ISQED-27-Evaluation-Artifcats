Feature: 8x1 Shift-Register Memory with Random-Access Read Multiplexer

  The circuit consists of an 8-bit shift register (flip-flops with outputs
  Q[0]..Q[7]) whose serial input is S, shifted synchronously on the
  positive edge of clk when enable is asserted (MSB Q[0] receives S first,
  values propagate Q[0]->Q[1]->...->Q[6]->Q[7]). The output Z is a
  combinational multiplexer that selects one of the 8 shift-register bits
  based on the 3-bit address formed by {A,B,C}, with A as the most
  significant bit and C as the least significant bit.

  Background:
    Given the design is triggered on the positive edge of clk
    And the shift register outputs are named Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    And there is no explicit reset input; state transitions are defined purely by shifting
    And Z is a purely combinational function of Q[0]..Q[7], A, B, and C

  @shift @enable
  Formal Scenario: Shift register shifts in S when enable is asserted
    Given enable is 1
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    And S holds value S_in
    When a rising edge of clk occurs
    Then Q[0] should become S_in
    And Q[1] should become the previous value of Q[0]
    And Q[2] should become the previous value of Q[1]
    And Q[3] should become the previous value of Q[2]
    And Q[4] should become the previous value of Q[3]
    And Q[5] should become the previous value of Q[4]
    And Q[6] should become the previous value of Q[5]
    And Q[7] should become the previous value of Q[6]

  @hold @disable
  Formal Scenario: Shift register holds its state when enable is deasserted
    Given enable is 0
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    And S holds any value S_in
    When a rising edge of clk occurs
    Then Q[0] should remain the previous value of Q[0]
    And Q[1] should remain the previous value of Q[1]
    And Q[2] should remain the previous value of Q[2]
    And Q[3] should remain the previous value of Q[3]
    And Q[4] should remain the previous value of Q[4]
    And Q[5] should remain the previous value of Q[5]
    And Q[6] should remain the previous value of Q[6]
    And Q[7] should remain the previous value of Q[7]

  @mux @boundary
  Formal Scenario: Z outputs Q[0] when address ABC is 000
    Given A is 0
    And B is 0
    And C is 0
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    Then Z should equal Q[0]

  @mux @boundary
  Formal Scenario: Z outputs Q[7] when address ABC is 111
    Given A is 1
    And B is 1
    And C is 1
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    Then Z should equal Q[7]

  @mux @address_mapping
  Formal Scenario: Z equals the shift register bit selected by the address formed by A, B, and C
    Given A, B, and C hold arbitrary values forming a 3-bit address, with A as the most significant bit and C as the least significant bit
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    Then Z should equal the value of Q at index {A,B,C}

  @combinational
  Formal Scenario: Z is combinational and does not require a clock edge to reflect the current address selection
    Given A, B, and C hold arbitrary values forming a 3-bit address
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    When no rising edge of clk occurs
    Then Z should equal the value of Q at index {A,B,C} without any clock edge occurring

  @independence @enable
  Formal Scenario: Z is independent of the enable input value
    Given enable holds any value
    And A, B, and C hold arbitrary values forming a 3-bit address
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7]
    Then Z should equal the value of Q at index {A,B,C} regardless of the value of enable

  @combined @shift_then_read
  Formal Scenario: Z reflects the newly shifted register contents immediately after a clock edge
    Given enable is 1
    And S holds value S_in
    And the shift register holds values Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7] before the clock edge
    And A, B, and C hold arbitrary values forming a 3-bit address
    When a rising edge of clk occurs
    Then Z should equal the value of the updated Q at index {A,B,C} after shifting