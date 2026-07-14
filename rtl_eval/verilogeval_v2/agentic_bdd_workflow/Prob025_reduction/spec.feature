Feature: 8-bit Even Parity Generator

  As a hardware designer
  I want the TopModule to compute the even parity bit of an 8-bit input
  So that transmission errors can be detected using a 9th check bit

  Background:
    Given the design is a purely combinational module named TopModule
    And an 8-bit input "in"
    And a 1-bit output "parity"
    And parity is defined as the XOR of all 8 bits of "in"

  @core @xor-definition
  Formal Scenario: Parity output equals XOR of all input bits
    Given an arbitrary 8-bit value X on "in"
    When the combinational logic evaluates
    Then "parity" should equal the XOR-reduction of all 8 bits of X
    And "parity" should equal in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7]

  @edge-case @all-zeros
  Formal Scenario: All-zero input produces even parity of zero
    Given "in" is 8'b00000000
    When the combinational logic evaluates
    Then "parity" should be 0

  @edge-case @all-ones
  Formal Scenario: All-ones input produces even parity of zero
    Given "in" is 8'b11111111
    When the combinational logic evaluates
    Then "parity" should be 0

  @edge-case @single-bit-set
  Formal Scenario: Exactly one bit set produces odd parity of one
    Given an arbitrary 8-bit value X on "in"
    And exactly one bit of X is 1 and all other bits are 0
    When the combinational logic evaluates
    Then "parity" should be 1

  @property @bit-flip-invariance
  Formal Scenario: Flipping a single input bit always toggles parity
    Given an arbitrary 8-bit value X on "in"
    And an arbitrary bit index K such that K is in range 0 to 7
    And a second value Y equal to X with bit K inverted and all other bits unchanged
    When the combinational logic evaluates for X producing parity value P1
    And the combinational logic evaluates for Y producing parity value P2
    Then P2 should equal the logical NOT of P1

  @property @flipping-two-bits-preserves-parity
  Formal Scenario: Flipping any two distinct input bits preserves parity
    Given an arbitrary 8-bit value X on "in"
    And two arbitrary distinct bit indices K and L such that K is in range 0 to 7 and L is in range 0 to 7 and K does not equal L
    And a second value Y equal to X with bits K and L both inverted
    When the combinational logic evaluates for X producing parity value P1
    And the combinational logic evaluates for Y producing parity value P2
    Then P2 should equal P1

  @property @combinational-purity
  Formal Scenario: Output depends only on current input with no memory
    Given an arbitrary 8-bit value X on "in"
    When the combinational logic evaluates for X producing parity value P1
    And the same value X is re-applied to "in"
    And the combinational logic evaluates again producing parity value P2
    Then P2 should equal P1

  @property @weight-parity-equivalence
  Formal Scenario: Parity bit equals the least significant bit of the population count
    Given an arbitrary 8-bit value X on "in"
    When the combinational logic evaluates
    Then "parity" should equal the population count of X modulo 2