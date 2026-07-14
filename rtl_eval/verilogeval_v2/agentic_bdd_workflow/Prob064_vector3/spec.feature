Feature: Vector Concatenation and Splitting (TopModule)
  The design concatenates six 5-bit input vectors (a, b, c, d, e, f) into a
  30-bit value, appends two constant '1' bits as the least-significant bits
  to form a 32-bit value, and then splits that 32-bit value into four 8-bit
  output vectors w, x, y, z (with w holding the most-significant byte and z
  holding the least-significant byte).

  Background:
    Given the design is combinational with no clock or reset
    And a 5-bit input vector a
    And a 5-bit input vector b
    And a 5-bit input vector c
    And a 5-bit input vector d
    And a 5-bit input vector e
    And a 5-bit input vector f
    And the conceptual 32-bit concatenation is defined as {a, b, c, d, e, f, 2'b11}

  @combinational @concatenation
  Formal Scenario: Output w equals the top 8 bits of the concatenation
    Given input vector a
    And input vector b
    When the 32-bit value {a, b, c, d, e, f, 2'b11} is formed
    Then output w should equal the concatenation of a and the top 3 bits of b
    And w should equal {a[4:0], b[4:2]}

  @combinational @concatenation
  Formal Scenario: Output x equals the next 8 bits of the concatenation
    Given input vector b
    And input vector c
    And input vector d
    When the 32-bit value {a, b, c, d, e, f, 2'b11} is formed
    Then output x should equal the concatenation of the bottom 2 bits of b, all 5 bits of c, and the top bit of d
    And x should equal {b[1:0], c[4:0], d[4]}

  @combinational @concatenation
  Formal Scenario: Output y equals the next 8 bits of the concatenation
    Given input vector d
    And input vector e
    When the 32-bit value {a, b, c, d, e, f, 2'b11} is formed
    Then output y should equal the concatenation of the bottom 4 bits of d and the top 4 bits of e
    And y should equal {d[3:0], e[4:1]}

  @combinational @concatenation
  Formal Scenario: Output z equals the bottom 8 bits of the concatenation including the constant bits
    Given input vector e
    And input vector f
    When the 32-bit value {a, b, c, d, e, f, 2'b11} is formed
    Then output z should equal the concatenation of the bottom bit of e, all 5 bits of f, and two constant 1 bits
    And z should equal {e[0], f[4:0], 2'b11}

  @combinational @full_reconstruction
  Formal Scenario: The four outputs together reconstruct the full concatenation
    Given input vectors a, b, c, d, e, f
    When outputs w, x, y, z are computed from a, b, c, d, e, f
    Then the 32-bit concatenation {w, x, y, z} should equal {a, b, c, d, e, f, 2'b11}

  @combinational @lsb_constant
  Formal Scenario: The two least significant bits of z are always 1
    Given any input vectors a, b, c, d, e, f
    When output z is computed
    Then bit 0 of z should equal 1
    And bit 1 of z should equal 1

  @combinational @bit_width
  Formal Scenario: All outputs remain within their declared bit widths
    Given any input vectors a, b, c, d, e, f
    When outputs w, x, y, z are computed
    Then w should be an 8-bit value
    And x should be an 8-bit value
    And y should be an 8-bit value
    And z should be an 8-bit value