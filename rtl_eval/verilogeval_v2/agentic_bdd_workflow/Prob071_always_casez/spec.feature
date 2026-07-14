Feature: 8-bit Priority Encoder

  Combinational priority encoder that reports the index of the least
  significant '1' bit in an 8-bit input vector. If no bits are set,
  the output is zero.

  Background:
    Given the module TopModule
    And an 8-bit input in
    And a 3-bit output pos
    And this is a combinational module with no clock or reset

  @basic @zero_input
  Formal Scenario: All-zero input produces zero output
    Given the input in is 8'b00000000
    Then the output pos should be 3'd0

  @basic @bit0_priority
  Formal Scenario: Bit 0 set takes highest priority regardless of other bits
    Given an input value X
    And bit 0 of X is 1
    Then the output pos should be 3'd0

  @priority @bit_i_lowest_set
  Formal Scenario: Output equals index of lowest set bit when bit i is the lowest set bit
    Given an input value X
    And a bit index I
    And bit I of X is 1
    And all bits of X below index I are 0
    Then the output pos should equal I

  @priority @no_lower_bits_interfere
  Formal Scenario: Bits above the lowest set bit do not affect the output
    Given an input value X
    And a bit index I
    And bit I of X is 1
    And all bits of X below index I are 0
    And bits of X above index I may be arbitrary
    Then the output pos should equal I

  @exhaustive @correctness
  Formal Scenario: Priority encoder output is correct for any nonzero input
    Given an input value X
    And X is not equal to 8'b00000000
    Then bit (pos) of X should be 1
    And all bits of X below index (pos) should be 0

  @exhaustive @default_case
  Formal Scenario: Priority encoder output is zero only when input is zero or bit 0 is set
    Given an input value X
    When the output pos is 3'd0
    Then bit 0 of X should be 1 or X should equal 8'b00000000

  @consistency @deterministic
  Formal Scenario: Encoder output is a pure function of input
    Given two input values X and Y
    And X is equal to Y
    Then the output pos for X should equal the output pos for Y

  @boundary @highest_bit
  Formal Scenario: Only the most significant bit set produces maximum index
    Given an input value X
    And bit 7 of X is 1
    And all other bits of X are 0
    Then the output pos should be 3'd7

  @boundary @single_bit_each_position
  Formal Scenario: Single bit set at any position produces matching output
    Given an input value X
    And a bit index I
    And bit I of X is 1
    And all bits of X except bit I are 0
    Then the output pos should equal I