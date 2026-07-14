Feature: 8-bit by Constant 0xFB Multiplier
  Verify that TopModule correctly computes the product of an 8-bit input A
  and the constant 0xFB (251 decimal), producing a 16-bit unsigned result B.
  This is a purely combinational multiplier optimized for minimal resource usage.

  Background:
    Given the design is combinational with no clock or reset
    And input A is an 8-bit value
    And output B is a 16-bit value
    And the constant multiplier is 0xFB (8'b11111011, decimal 251)

  @core_functionality
  Formal Scenario: Product equals A multiplied by constant 0xFB for any input
    Given an arbitrary 8-bit value A
    When the circuit computes the product
    Then B should equal A multiplied by 251

  @algebraic_decomposition
  Formal Scenario: Product matches shift-and-subtract decomposition of 251
    Given an arbitrary 8-bit value A
    When the circuit computes the product
    Then B should equal (A shifted left by 8 bits) minus (A shifted left by 2 bits) minus A

  @zero_input
  Formal Scenario: Product is zero when A is zero
    Given A equals 8'h00
    When the circuit computes the product
    Then B should equal 16'h0000

  @maximum_input
  Formal Scenario: Product is correct for maximum A value
    Given A equals 8'hFF
    When the circuit computes the product
    Then B should equal A multiplied by 251

  @single_bit_input_lsb
  Formal Scenario: Product equals constant 251 when A equals one
    Given A equals 8'h01
    When the circuit computes the product
    Then B should equal 16'h00FB

  @power_of_two_input
  Formal Scenario: Product scales correctly for power-of-two A values
    Given A equals a power of two value within the 8-bit range
    When the circuit computes the product
    Then B should equal A multiplied by 251

  @no_overflow
  Formal Scenario: Product never exceeds 16-bit representable range
    Given an arbitrary 8-bit value A
    When the circuit computes the product
    Then B should be less than or equal to 16'hFFFF
    And B should equal A multiplied by 251 with no truncation

  @output_width_consistency
  Formal Scenario: Output width remains fixed regardless of input value
    Given an arbitrary 8-bit value A
    When the circuit computes the product
    Then B should be exactly 16 bits wide
    And B should equal A multiplied by 251

  @monotonicity
  Formal Scenario: Product is monotonically non-decreasing with increasing A
    Given two arbitrary 8-bit values A1 and A2 where A1 is less than or equal to A2
    When the circuit computes the product for both values producing B1 and B2 respectively
    Then B1 should be less than or equal to B2

  @linearity_check
  Formal Scenario: Product satisfies distributive property with constant factor
    Given an arbitrary 8-bit value A that does not cause overflow when doubled
    When the circuit computes the product for A producing B
    And the circuit computes the product for the value A shifted left by 1 bit producing B_double
    Then B_double should equal B multiplied by 2 when no overflow occurs in the 8-bit domain