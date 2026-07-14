Feature: TopModule Combinational Logic Verification
  Verify that TopModule correctly implements 4-input AND, OR, and XOR gates
  operating on the 4-bit input vector in[3:0].

  Background:
    Given the module TopModule is instantiated
    And in is a 4-bit input vector
    And out_and, out_or, and out_xor are combinational outputs with no clock or reset

  @and @combinational
  Formal Scenario: 4-input AND gate output equals bitwise AND of all input bits
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_and should equal in[3] AND in[2] AND in[1] AND in[0]

  @and @combinational
  Formal Scenario: 4-input AND gate outputs 1 only when all input bits are 1
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_and should be 1 if in equals 4'b1111
    And out_and should be 0 if in is not equal to 4'b1111

  @or @combinational
  Formal Scenario: 4-input OR gate output equals bitwise OR of all input bits
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_or should equal in[3] OR in[2] OR in[1] OR in[0]

  @or @combinational
  Formal Scenario: 4-input OR gate outputs 0 only when all input bits are 0
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_or should be 0 if in equals 4'b0000
    And out_or should be 1 if in is not equal to 4'b0000

  @xor @combinational
  Formal Scenario: 4-input XOR gate output equals bitwise XOR of all input bits
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_xor should equal in[3] XOR in[2] XOR in[1] XOR in[0]

  @xor @combinational @parity
  Formal Scenario: 4-input XOR gate output reflects odd parity of input bits
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_xor should be 1 if the number of set bits in in is odd
    And out_xor should be 0 if the number of set bits in in is even

  @combinational @independence
  Formal Scenario: Outputs depend only on current input value with no state
    Given an arbitrary 4-bit input value in applied at any time
    When the combinational logic evaluates
    Then out_and, out_or, and out_xor should depend only on the current value of in
    And out_and, out_or, and out_xor should not depend on any previous input value

  @combinational @consistency
  Formal Scenario: All three outputs are simultaneously consistent for the same input
    Given an arbitrary 4-bit input value in
    When the combinational logic evaluates
    Then out_and should equal in[3] AND in[2] AND in[1] AND in[0]
    And out_or should equal in[3] OR in[2] OR in[1] OR in[0]
    And out_xor should equal in[3] XOR in[2] XOR in[1] XOR in[0]