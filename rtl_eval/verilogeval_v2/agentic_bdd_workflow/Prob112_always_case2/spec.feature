Feature: 4-bit Priority Encoder
  Formal verification of a combinational priority encoder that outputs the
  position of the least-significant set bit in a 4-bit input vector. If no
  bits are set, the output is zero.

  Background:
    Given the module TopModule
    And input in is a 4-bit vector
    And output pos is a 2-bit vector
    And the design is purely combinational with no clock or reset

  @bit0_priority
  Formal Scenario: Bit 0 set takes highest priority
    Given in[0] is 1
    And in[3:1] are arbitrary values A2, A1, A0
    When the combinational logic evaluates
    Then pos should equal 2'd0

  @bit1_priority
  Formal Scenario: Bit 1 set with bit 0 clear yields position 1
    Given in[0] is 0
    And in[1] is 1
    And in[3:2] are arbitrary values A3, A2
    When the combinational logic evaluates
    Then pos should equal 2'd1

  @bit2_priority
  Formal Scenario: Bit 2 set with bits 0 and 1 clear yields position 2
    Given in[1:0] is 2'b00
    And in[2] is 1
    And in[3] is an arbitrary value A3
    When the combinational logic evaluates
    Then pos should equal 2'd2

  @bit3_priority
  Formal Scenario: Bit 3 set with bits 0,1,2 clear yields position 3
    Given in[2:0] is 3'b000
    And in[3] is 1
    When the combinational logic evaluates
    Then pos should equal 2'd3

  @all_zero
  Formal Scenario: All input bits zero yields position zero
    Given in is 4'b0000
    When the combinational logic evaluates
    Then pos should equal 2'd0

  @general_priority_function
  Formal Scenario: pos equals index of least-significant set bit for any input
    Given in is an arbitrary 4-bit value X
    When the combinational logic evaluates
    Then pos should equal 0 if X[0] is 1
    And pos should equal 1 if X[0] is 0 and X[1] is 1
    And pos should equal 2 if X[1:0] is 2'b00 and X[2] is 1
    And pos should equal 3 if X[2:0] is 3'b000 and X[3] is 1
    And pos should equal 0 if X is 4'b0000

  @output_range
  Formal Scenario: pos is always within valid 2-bit range
    Given in is an arbitrary 4-bit value X
    When the combinational logic evaluates
    Then pos should be less than or equal to 2'd3