Feature: TopModule - Bitwise OR, Logical OR, and Bitwise NOT Operations

  As a hardware designer
  I want to verify the TopModule combinational logic
  So that bitwise-OR, logical-OR, and NOT operations are correctly computed

  Background:
    Given a 3-bit input "a"
    And a 3-bit input "b"
    And a 3-bit output "out_or_bitwise"
    And a 1-bit output "out_or_logical"
    And a 6-bit output "out_not"
    And this is a combinational design with no clock or reset

  @bitwise_or
  Formal Scenario: Bitwise OR computes per-bit OR of a and b
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then "out_or_bitwise" should equal A bitwise-OR B

  # Note: the specific zero-case checks below are subsumed by the general
  # logical-disjunction scenario ("logical_or_general"), which covers all
  # values of A and B including the all-zero case. Both are retained here
  # for explicit boundary-condition coverage.
  @logical_or_both_zero
  Formal Scenario: Logical OR is 0 only when both a and b are all zeros
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then "out_or_logical" should equal 1 if A is nonzero or B is nonzero
    And "out_or_logical" should equal 0 if A equals 0 and B equals 0

  @logical_or_general
  Formal Scenario: Logical OR equals logical disjunction of reduction-OR of a and b
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then "out_or_logical" should equal (A != 0) logical-OR (B != 0)

  # Note: the half-width checks below are subsumed by the full-concatenation
  # scenario ("not_full_concatenation"), which fully determines both halves
  # of out_not. Both are retained here for explicit per-half coverage.
  @not_lower_half
  Formal Scenario: Lower half of out_not is the bitwise inverse of a
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then bits [2:0] of "out_not" should equal bitwise-NOT of A

  @not_upper_half
  Formal Scenario: Upper half of out_not is the bitwise inverse of b
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then bits [5:3] of "out_not" should equal bitwise-NOT of B

  @not_full_concatenation
  Formal Scenario: out_not is the concatenation of inverted b and inverted a
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then "out_not" should equal concatenation of (bitwise-NOT of B) and (bitwise-NOT of A)

  # Note: this scenario restates the general functional scenarios above
  # ("bitwise_or", "logical_or_general", "not_full_concatenation") together
  # with an explicit signal-level equality check that each output depends
  # only on the current values of A and B, independent of any prior-cycle
  # value of the inputs or outputs. This makes the "no hidden state" property
  # directly checkable as an SVA-style equality assertion rather than a
  # structural/design-intent statement.
  @combinational_no_state
  Formal Scenario: Outputs depend only on current inputs with no memory
    Given input "a" is any valid 3-bit value A
    And input "b" is any valid 3-bit value B
    When the combinational logic evaluates
    Then "out_or_bitwise" should equal A bitwise-OR B
    And "out_or_logical" should equal (A != 0) logical-OR (B != 0)
    And "out_not" should equal concatenation of (bitwise-NOT of B) and (bitwise-NOT of A)
    And "out_or_bitwise" should equal A bitwise-OR B regardless of the previous-cycle value of "out_or_bitwise", "a", or "b"
    And "out_or_logical" should equal (A != 0) logical-OR (B != 0) regardless of the previous-cycle value of "out_or_logical", "a", or "b"
    And "out_not" should equal concatenation of (bitwise-NOT of B) and (bitwise-NOT of A) regardless of the previous-cycle value of "out_not", "a", or "b"