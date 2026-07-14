Feature: TopModule Combinational Karnaugh-Map Function

  The module TopModule computes a single-bit output f from a 4-bit input
  vector x according to the Karnaugh map:

               x[0]x[1]
  x[2]x[3]  00  01  11  10
    00     | 1 | 0 | 0 | 1 |
    01     | 0 | 0 | 0 | 0 |
    11     | 1 | 1 | 1 | 0 |
    10     | 1 | 1 | 0 | 1 |

  This is a purely combinational design: f must depend only on the
  current value of x, with no memory, clock, or reset.

  Background:
    Given a combinational module TopModule with input x[3:0] and output f
    And there is no clock or reset signal in this design
    And f is evaluated as a pure function of the current value of x

  @full_function @combinational
  Formal Scenario: Output f matches the complete Karnaugh map function
    Given any 4-bit value of x composed of bits x[0], x[1], x[2], x[3]
    When the combinational logic evaluates f from x
    Then f should equal (NOT x[1] AND NOT x[2] AND NOT x[3])
      OR (x[2] AND x[3] AND (NOT x[0] OR x[1]))
      OR (x[2] AND NOT x[3] AND (NOT x[0] OR NOT x[1]))

  @row_x2_0_x3_0
  Formal Scenario: Row x[2]x[3] = 00 depends only on x[1]
    Given x[2] equal to 0
    And x[3] equal to 0
    And any value of x[0]
    And any value of x[1]
    When the combinational logic evaluates f from x
    Then f should equal NOT x[1]

  @row_x2_0_x3_1
  Formal Scenario: Row x[2]x[3] = 01 is always 0
    Given x[2] equal to 0
    And x[3] equal to 1
    And any value of x[0]
    And any value of x[1]
    When the combinational logic evaluates f from x
    Then f should equal 0

  @row_x2_1_x3_1
  Formal Scenario: Row x[2]x[3] = 11 follows OR relationship of x[0] and x[1]
    Given x[2] equal to 1
    And x[3] equal to 1
    And any value of x[0]
    And any value of x[1]
    When the combinational logic evaluates f from x
    Then f should equal (NOT x[0]) OR x[1]

  @row_x2_1_x3_0
  Formal Scenario: Row x[2]x[3] = 10 follows NAND relationship of x[0] and x[1]
    Given x[2] equal to 1
    And x[3] equal to 0
    And any value of x[0]
    And any value of x[1]
    When the combinational logic evaluates f from x
    Then f should equal (NOT x[0]) OR (NOT x[1])

  @column_x0_0_x1_0
  Formal Scenario: Column x[0]x[1] = 00 matches expected values across rows
    Given x[0] equal to 0
    And x[1] equal to 0
    And any value of x[2]
    And any value of x[3]
    When the combinational logic evaluates f from x
    Then f should equal (NOT x[2] AND NOT x[3])
      OR (x[2] AND x[3])
      OR (x[2] AND NOT x[3])

  @column_x0_0_x1_1
  Formal Scenario: Column x[0]x[1] = 01 matches expected values across rows
    Given x[0] equal to 0
    And x[1] equal to 1
    And any value of x[2]
    And any value of x[3]
    When the combinational logic evaluates f from x
    Then f should equal (x[2] AND x[3])
      OR (x[2] AND NOT x[3])

  @column_x0_1_x1_1
  Formal Scenario: Column x[0]x[1] = 11 matches expected values across rows
    Given x[0] equal to 1
    And x[1] equal to 1
    And any value of x[2]
    And any value of x[3]
    When the combinational logic evaluates f from x
    Then f should equal x[2] AND x[3]

  @column_x0_1_x1_0
  Formal Scenario: Column x[0]x[1] = 10 matches expected values across rows
    Given x[0] equal to 1
    And x[1] equal to 0
    And any value of x[2]
    And any value of x[3]
    When the combinational logic evaluates f from x
    Then f should equal (NOT x[2] AND NOT x[3])
      OR (x[2] AND NOT x[3])

  @no_state
  Formal Scenario: f has no dependency on past values (pure combinational check)
    Given any value of x at the current evaluation cycle
    And the same value of x is held constant for two consecutive evaluations
    When the combinational logic evaluates f from x on both evaluations
    Then f should be identical on both evaluations