Feature: 25-bit Pairwise Equality Comparator

  This module computes all pairwise one-bit XNOR (equality) comparisons
  among five 1-bit inputs (a, b, c, d, e), producing a 25-bit output
  vector. Each output bit is 1 if and only if the two corresponding
  input bits are equal.

  Background:
    Given a combinational module named "TopModule"
    And inputs "a", "b", "c", "d", "e" are single-bit signals
    And output "out" is a 25-bit vector

  @bit24 @self_comparison
  Formal Scenario: Bit 24 equals comparison of a with a
    Given a is signal A
    When the output is computed
    Then out[24] should equal 1

  @bit23
  Formal Scenario: Bit 23 equals comparison of a with b
    Given a is signal A
    And b is signal B
    When the output is computed
    Then out[23] should equal 1 if A equals B, else 0

  @bit22
  Formal Scenario: Bit 22 equals comparison of a with c
    Given a is signal A
    And c is signal C
    When the output is computed
    Then out[22] should equal 1 if A equals C, else 0

  @bit21
  Formal Scenario: Bit 21 equals comparison of a with d
    Given a is signal A
    And d is signal D
    When the output is computed
    Then out[21] should equal 1 if A equals D, else 0

  @bit20
  Formal Scenario: Bit 20 equals comparison of a with e
    Given a is signal A
    And e is signal E
    When the output is computed
    Then out[20] should equal 1 if A equals E, else 0

  @bit19
  Formal Scenario: Bit 19 equals comparison of b with a
    Given b is signal B
    And a is signal A
    When the output is computed
    Then out[19] should equal 1 if B equals A, else 0

  @bit18 @self_comparison
  Formal Scenario: Bit 18 equals comparison of b with b
    Given b is signal B
    When the output is computed
    Then out[18] should equal 1

  @bit17
  Formal Scenario: Bit 17 equals comparison of b with c
    Given b is signal B
    And c is signal C
    When the output is computed
    Then out[17] should equal 1 if B equals C, else 0

  @bit16
  Formal Scenario: Bit 16 equals comparison of b with d
    Given b is signal B
    And d is signal D
    When the output is computed
    Then out[16] should equal 1 if B equals D, else 0

  @bit15
  Formal Scenario: Bit 15 equals comparison of b with e
    Given b is signal B
    And e is signal E
    When the output is computed
    Then out[15] should equal 1 if B equals E, else 0

  @bit14
  Formal Scenario: Bit 14 equals comparison of c with a
    Given c is signal C
    And a is signal A
    When the output is computed
    Then out[14] should equal 1 if C equals A, else 0

  @bit13
  Formal Scenario: Bit 13 equals comparison of c with b
    Given c is signal C
    And b is signal B
    When the output is computed
    Then out[13] should equal 1 if C equals B, else 0

  @bit12 @self_comparison
  Formal Scenario: Bit 12 equals comparison of c with c
    Given c is signal C
    When the output is computed
    Then out[12] should equal 1

  @bit11
  Formal Scenario: Bit 11 equals comparison of c with d
    Given c is signal C
    And d is signal D
    When the output is computed
    Then out[11] should equal 1 if C equals D, else 0

  @bit10
  Formal Scenario: Bit 10 equals comparison of c with e
    Given c is signal C
    And e is signal E
    When the output is computed
    Then out[10] should equal 1 if C equals E, else 0

  @bit9
  Formal Scenario: Bit 9 equals comparison of d with a
    Given d is signal D
    And a is signal A
    When the output is computed
    Then out[9] should equal 1 if D equals A, else 0

  @bit8
  Formal Scenario: Bit 8 equals comparison of d with b
    Given d is signal D
    And b is signal B
    When the output is computed
    Then out[8] should equal 1 if D equals B, else 0

  @bit7
  Formal Scenario: Bit 7 equals comparison of d with c
    Given d is signal D
    And c is signal C
    When the output is computed
    Then out[7] should equal 1 if D equals C, else 0

  @bit6 @self_comparison
  Formal Scenario: Bit 6 equals comparison of d with d
    Given d is signal D
    When the output is computed
    Then out[6] should equal 1

  @bit5
  Formal Scenario: Bit 5 equals comparison of d with e
    Given d is signal D
    And e is signal E
    When the output is computed
    Then out[5] should equal 1 if D equals E, else 0

  @bit4
  Formal Scenario: Bit 4 equals comparison of e with a
    Given e is signal E
    And a is signal A
    When the output is computed
    Then out[4] should equal 1 if E equals A, else 0

  @bit3
  Formal Scenario: Bit 3 equals comparison of e with b
    Given e is signal E
    And b is signal B
    When the output is computed
    Then out[3] should equal 1 if E equals B, else 0

  @bit2
  Formal Scenario: Bit 2 equals comparison of e with c
    Given e is signal E
    And c is signal C
    When the output is computed
    Then out[2] should equal 1 if E equals C, else 0

  @bit1
  Formal Scenario: Bit 1 equals comparison of e with d
    Given e is signal E
    And d is signal D
    When the output is computed
    Then out[1] should equal 1 if E equals D, else 0

  @bit0 @self_comparison
  Formal Scenario: Bit 0 equals comparison of e with e
    Given e is signal E
    When the output is computed
    Then out[0] should equal 1

  @global @symmetry
  Formal Scenario: Output is symmetric with respect to signal ordering
    Given a is signal A
    And b is signal B
    And c is signal C
    And d is signal D
    And e is signal E
    When the output is computed
    Then out[23] should equal out[19]
    And out[22] should equal out[14]
    And out[21] should equal out[9]
    And out[20] should equal out[4]
    And out[17] should equal out[13]
    And out[16] should equal out[8]
    And out[15] should equal out[3]
    And out[11] should equal out[7]
    And out[10] should equal out[2]
    And out[5] should equal out[1]

  @global @diagonal
  Formal Scenario: All self-comparison bits are always 1
    Given a is signal A
    And b is signal B
    And c is signal C
    And d is signal D
    And e is signal E
    When the output is computed
    Then out[24] should equal 1
    And out[18] should equal 1
    And out[12] should equal 1
    And out[6] should equal 1
    And out[0] should equal 1