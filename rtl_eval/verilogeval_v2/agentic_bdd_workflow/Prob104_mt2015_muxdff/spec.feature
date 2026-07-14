Feature: Single-Bit Flip-Flop with Load Multiplexer (TopModule)

  As a hardware designer factoring full_module into hierarchical submodules,
  I want a single-bit TopModule that implements a D flip-flop preceded by
  a 2:1 multiplexer selecting between a load value (r_in) and a feedback
  value (q_in), controlled by the load enable L.

  This TopModule will be instantiated three times to build the 3-bit
  self-shifting register with XOR feedback in full_module.

  Background:
    Given a clock signal clk
    And clk transitions only on rising edges
    And the load enable signal L
    And the load data input r_in
    And the feedback data input q_in
    And the registered output Q

  @formal @load
  Formal Scenario: Loading r_in when L is asserted
    Given L is 1
    And r_in is any value X
    And q_in is any value Y
    When a rising edge of clk occurs
    Then Q should become X

  @formal @hold @shift
  Formal Scenario: Passing q_in through when L is deasserted
    Given L is 0
    And q_in is any value Y
    And r_in is any value X
    When a rising edge of clk occurs
    Then Q should become Y

  @formal @mux_selection
  Formal Scenario: Multiplexer selects correct source based on L
    Given L is any value S
    And r_in is any value X
    And q_in is any value Y
    When a rising edge of clk occurs
    Then Q should become X if S equals 1
    And Q should become Y if S equals 0

  @formal @stability
  Formal Scenario: Output remains stable between clock edges
    Given Q holds any value Z
    And no rising edge of clk occurs
    Then Q should remain Z

  @formal @output_registered
  Formal Scenario: Output only changes on clock edge
    Given Q holds any value Z
    And L is any value S
    And r_in is any value X
    And q_in is any value Y
    When no rising edge of clk occurs
    Then Q should remain Z regardless of L, r_in, and q_in

  @formal @determinism
  Formal Scenario: Next state is a deterministic function of L, r_in, and q_in
    Given L is any value S
    And r_in is any value X
    And q_in is any value Y
    When a rising edge of clk occurs
    Then Q should equal the value (S ? X : Y)