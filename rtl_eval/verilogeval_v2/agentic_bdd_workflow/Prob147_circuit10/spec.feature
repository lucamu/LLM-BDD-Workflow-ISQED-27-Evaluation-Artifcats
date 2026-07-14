Feature: Full Adder Sequential Circuit with Carry Register

  The TopModule implements a synchronous circuit whose single flip-flop
  behaves as a carry bit, while the combinational output q behaves as a
  sum bit. On every positive clock edge, the flip-flop (state) updates to
  the majority function of the current inputs a, b and the current
  state (i.e., the carry-out of a full adder), and the output q is the
  XOR of a, b and the current state (i.e., the sum bit of a full adder).
  The module has no reset port; state is governed solely by the
  clock-edge-driven update rule below.

  Background:
    Given a clock signal clk that toggles every cycle
    And input a is driven to some symbolic value A
    And input b is driven to some symbolic value B

  @combinational @sum
  Formal Scenario: Output q is the XOR of a, b and the current state
    Given the current state register holds value S
    And input a holds value A
    And input b holds value B
    When the combinational logic evaluates
    Then q should equal (A XOR B XOR S)

  @sequential @carry
  Formal Scenario: Next state is the majority function of a, b and current state
    Given the current state register holds value S
    And input a holds value A
    And input b holds value B
    When a rising edge of clk occurs
    Then the next value of state should equal ((A AND B) OR (A AND S) OR (B AND S))

  @sequential @stability
  Formal Scenario: State does not change without a clock edge
    Given the current state register holds value S
    And input a holds value A
    And input b holds value B
    When no rising edge of clk occurs
    Then state should remain equal to S

  @combinational @consistency
  Formal Scenario: q is purely combinational and reflects the same-cycle state
    Given the current state register holds value S
    And input a holds value A
    And input b holds value B
    When inputs a and b change without a clock edge
    Then q should update immediately to (A XOR B XOR S)
    And state should remain equal to S

  @sequential @full_adder_equivalence
  Formal Scenario: Sequential behavior matches a chained full-adder carry propagation
    Given the current state register holds value S
    And input a holds value A
    And input b holds value B
    When a rising edge of clk occurs
    Then q should equal (A XOR B XOR S)
    And the next value of state should equal ((A AND B) OR (A AND S) OR (B AND S))
    And q and the next state together should equal the 2-bit sum (A + B + S)