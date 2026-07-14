Feature: Combinational Byte Splitter (TopModule)
  Splits a 16-bit input into its upper and lower byte components.
  All properties are combinational (no clock, no reset) and must hold
  for every valuation of the input.

  Background:
    Given a combinational module TopModule
    And an input in (16 bits)
    And an output out_hi (8 bits)
    And an output out_lo (8 bits)

  @formal @core
  Formal Scenario: Lower byte equals bits [7:0] of input
    Given any value X on in
    When the circuit evaluates combinationally
    Then out_lo should equal X[7:0]

  @formal @core
  Formal Scenario: Upper byte equals bits [15:8] of input
    Given any value X on in
    When the circuit evaluates combinationally
    Then out_hi should equal X[15:8]

  @formal @reconstruction
  Formal Scenario: Concatenation of outputs reconstructs the input
    Given any value X on in
    When the circuit evaluates combinationally
    Then the concatenation of out_hi and out_lo, {out_hi, out_lo}, should equal X

  @formal @independence
  Formal Scenario: Output byte is independent of the other input byte
    Given any value X on in
    And a second value Y on in such that Y[7:0] equals X[7:0]
    When the circuit evaluates combinationally for both X and Y
    Then out_lo for X should equal out_lo for Y

  @formal @independence
  Formal Scenario: Output high byte is independent of the low input byte
    Given any value X on in
    And a second value Y on in such that Y[15:8] equals X[15:8]
    When the circuit evaluates combinationally for both X and Y
    Then out_hi for X should equal out_hi for Y

  @formal @stability
  Formal Scenario: Outputs are purely combinational functions of the current input
    Given any value X on in at time T
    And the same value X on in at time T plus one
    When the circuit evaluates combinationally at both times
    Then out_hi at time T should equal out_hi at time T plus one
    And out_lo at time T should equal out_lo at time T plus one

  @formal @boundary
  Formal Scenario: All-zero input produces all-zero outputs
    Given the value in equals 16'h0000
    When the circuit evaluates combinationally
    Then out_hi should equal 8'h00
    And out_lo should equal 8'h00

  @formal @boundary
  Formal Scenario: All-one input produces all-one outputs
    Given the value in equals 16'hFFFF
    When the circuit evaluates combinationally
    Then out_hi should equal 8'hFF
    And out_lo should equal 8'hFF