Feature: TopModule – Minimum SOP and POS Realizations of a 4-Input Function

  The module TopModule implements a completely combinational logic function
  of four single-bit inputs a, b, c, d (a = MSB, d = LSB, matching the
  example: decimal 7 = a,b,c,d = 0,1,1,1).

  The function must equal logic-1 for the input combinations representing
  decimal 2, 7, and 15; logic-1 must equal logic-0 for the input
  combinations representing decimal 0, 1, 4, 5, 6, 9, 10, 13, and 14;
  and the combinations representing decimal 3, 8, 11, and 12 are
  don't-cares.

  out_sop must realize the minimum sum-of-products form of this function.
  out_pos must realize the minimum product-of-sums form of this function.

  Background:
    Given TopModule is a purely combinational design with no clock and no reset
    And inputs a, b, c, and d are single-bit signals
    And output out_sop is the minimum sum-of-products realization of the function
    And output out_pos is the minimum product-of-sums realization of the function
    And the decimal value of a, b, c, d is computed as 8*a + 4*b + 2*c + d

  @required_ones
  Formal Scenario: Output is logic-1 for every specified minterm
    Given arbitrary values for a, b, c, and d
    And the decimal value of a, b, c, d equals 2, or equals 7, or equals 15
    Then out_sop should be 1
    And out_pos should be 1

  @required_zeros
  Formal Scenario: Output is logic-0 for every specified zero combination
    Given arbitrary values for a, b, c, and d
    And the decimal value of a, b, c, d equals 0, 1, 4, 5, 6, 9, 10, 13, or 14
    Then out_sop should be 0
    And out_pos should be 0

  @dont_care_consistency
  Formal Scenario: Don't-care combinations impose no fixed value but SOP and POS stay consistent
    Given arbitrary values for a, b, c, and d
    And the decimal value of a, b, c, d equals 3, 8, 11, or 12
    Then out_sop should equal out_pos

  @minimum_sop_formula
  Formal Scenario: out_sop matches the minimum sum-of-products expression
    Given arbitrary values for a, b, c, and d
    Then out_sop should equal ((not a) and (not b) and c) or (c and d)

  @minimum_pos_formula
  Formal Scenario: out_pos matches the minimum product-of-sums expression
    Given arbitrary values for a, b, c, and d
    Then out_pos should equal c and ((not a) or (not c) or d) and ((not b) or (not c) or d)

  @sop_pos_equivalence
  Formal Scenario: The SOP and POS realizations are functionally equivalent for all inputs
    Given arbitrary values for a, b, c, and d
    Then out_sop should equal out_pos