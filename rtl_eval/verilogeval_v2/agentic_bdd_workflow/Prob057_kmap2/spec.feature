Feature: TopModule combinational logic defined by Karnaugh map

  The module TopModule implements a 4-input combinational function of
  a, b, c and d whose truth table is given by the Karnaugh map below.

                ab
     cd   00  01  11  10
     00 | 1 | 1 | 0 | 1 |
     01 | 1 | 0 | 0 | 1 |
     11 | 0 | 1 | 1 | 1 |
     10 | 1 | 1 | 0 | 0 |

  The minimized sum-of-products form used as the reference model is:
     out = (~b & ~c) | (~a & ~d) | (a & ~b & d) | (b & c & d)

  Background:
    Given a, b, c and d are single-bit inputs to TopModule
    And out is a single-bit output of TopModule
    And TopModule is a purely combinational circuit with no clock or reset
    And out is evaluated as a pure function of the current values of a, b, c and d

  @main @full_equation
  Formal Scenario: Output matches the complete minimized Boolean equation
    Given arbitrary bit values for a, b, c and d
    When TopModule evaluates the combinational logic
    Then out should equal ((not b and not c) or (not a and not d) or (a and not b and d) or (b and c and d))

  @row_cd_00
  Formal Scenario: Behavior when c is 0 and d is 0
    Given c equals 0
    And d equals 0
    And arbitrary bit values for a and b
    When TopModule evaluates the combinational logic
    Then out should equal (not a or not b)

  @row_cd_01
  Formal Scenario: Behavior when c is 0 and d is 1
    Given c equals 0
    And d equals 1
    And arbitrary bit values for a and b
    When TopModule evaluates the combinational logic
    Then out should equal (not b)

  @row_cd_11
  Formal Scenario: Behavior when c is 1 and d is 1
    Given c equals 1
    And d equals 1
    And arbitrary bit values for a and b
    When TopModule evaluates the combinational logic
    Then out should equal (a or b)

  @row_cd_10
  Formal Scenario: Behavior when c is 1 and d is 0
    Given c equals 1
    And d equals 0
    And arbitrary bit values for a and b
    When TopModule evaluates the combinational logic
    Then out should equal (not a)

  @column_ab_00
  Formal Scenario: Behavior when a is 0 and b is 0
    Given a equals 0
    And b equals 0
    And arbitrary bit values for c and d
    When TopModule evaluates the combinational logic
    Then out should equal (not c or not d)

  @column_ab_01
  Formal Scenario: Behavior when a is 0 and b is 1
    Given a equals 0
    And b equals 1
    And arbitrary bit values for c and d
    When TopModule evaluates the combinational logic
    Then out should equal (not d or (c and d))

  @column_ab_11
  Formal Scenario: Behavior when a is 1 and b is 1
    Given a equals 1
    And b equals 1
    And arbitrary bit values for c and d
    When TopModule evaluates the combinational logic
    Then out should equal (c and d)

  @column_ab_10
  Formal Scenario: Behavior when a is 1 and b is 0
    Given a equals 1
    And b equals 0
    And arbitrary bit values for c and d
    When TopModule evaluates the combinational logic
    Then out should equal (not c or d)

  @combinational_purity
  Formal Scenario: Output depends only on current inputs
    Given arbitrary bit values for a, b, c and d at time T
    And the same bit values for a, b, c and d at time T plus one cycle
    When TopModule evaluates the combinational logic at both times
    Then out at time T should equal out at time T plus one cycle