Feature: 6-to-1 Multiplexer (TopModule)
  Combinational selection among six 4-bit data inputs based on a 3-bit
  select signal. When sel is 0 through 5, the corresponding data input
  is routed to out. For all other values of sel (6 and 7), out is 0.

  Background:
    Given the design is TopModule
    And sel is a 3-bit input
    And data0 is a 4-bit input
    And data1 is a 4-bit input
    And data2 is a 4-bit input
    And data3 is a 4-bit input
    And data4 is a 4-bit input
    And data5 is a 4-bit input
    And out is a 4-bit output
    And the design is purely combinational with no clock or reset

  @select0
  Formal Scenario: Select data0 when sel is 0
    Given sel is 3'b000
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0

  @select1
  Formal Scenario: Select data1 when sel is 1
    Given sel is 3'b001
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D1

  @select2
  Formal Scenario: Select data2 when sel is 2
    Given sel is 3'b010
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D2

  @select3
  Formal Scenario: Select data3 when sel is 3
    Given sel is 3'b011
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D3

  @select4
  Formal Scenario: Select data4 when sel is 4
    Given sel is 3'b100
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D4

  @select5
  Formal Scenario: Select data5 when sel is 5
    Given sel is 3'b101
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D5

  @select6_invalid
  Formal Scenario: Output is zero when sel is 6 (out of range)
    Given sel is 3'b110
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal 4'b0000

  @select7_invalid
  Formal Scenario: Output is zero when sel is 7 (out of range)
    Given sel is 3'b111
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal 4'b0000

  @general_mux_behavior
  Formal Scenario: General multiplexer functional correctness for any sel
    Given sel is any value S
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0 if S equals 3'b000
    And out should equal D1 if S equals 3'b001
    And out should equal D2 if S equals 3'b010
    And out should equal D3 if S equals 3'b011
    And out should equal D4 if S equals 3'b100
    And out should equal D5 if S equals 3'b101
    And out should equal 4'b0000 if S equals 3'b110
    And out should equal 4'b0000 if S equals 3'b111

  @independent_of_unselected_data_sel0
  Formal Scenario: Output for sel equal to 0 does not depend on data1
    Given sel is 3'b000
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0 regardless of the value of D1

  @independent_of_unselected_data_sel0_data2
  Formal Scenario: Output for sel equal to 0 does not depend on data2
    Given sel is 3'b000
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0 regardless of the value of D2

  @independent_of_unselected_data_sel0_data3
  Formal Scenario: Output for sel equal to 0 does not depend on data3
    Given sel is 3'b000
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0 regardless of the value of D3

  @independent_of_unselected_data_sel0_data4
  Formal Scenario: Output for sel equal to 0 does not depend on data4
    Given sel is 3'b000
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0 regardless of the value of D4

  @independent_of_unselected_data_sel0_data5
  Formal Scenario: Output for sel equal to 0 does not depend on data5
    Given sel is 3'b000
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated
    Then out should equal D0 regardless of the value of D5

  @combinational_determinism
  Formal Scenario: Output is a deterministic function of the current input vector
    Given sel is any value S
    And data0 is any value D0
    And data1 is any value D1
    And data2 is any value D2
    And data3 is any value D3
    And data4 is any value D4
    And data5 is any value D5
    When the outputs are evaluated for this input vector on two separate identical evaluations
    Then both evaluations should produce the same value of out