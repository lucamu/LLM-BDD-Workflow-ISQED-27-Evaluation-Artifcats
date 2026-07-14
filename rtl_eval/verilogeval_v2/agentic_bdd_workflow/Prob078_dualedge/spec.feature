Feature: Dual-Edge Triggered Flip-Flop Emulation
  As a hardware designer targeting FPGAs without native dual-edge flip-flops
  I want a circuit built from single-edge triggered flip-flops
  That behaves functionally identical to a dual-edge triggered flip-flop,
  capturing the input d on both the rising and falling edges of clk.

  Background:
    Given a clock signal clk
    And a data input d
    And an output q
    And the circuit contains no explicit reset signal

  @rising_edge @capture
  Formal Scenario: Output captures input on rising clock edge
    Given d holds a symbolic value D immediately before a rising edge of clk
    When a rising edge of clk occurs
    Then q should equal D immediately after the edge

  @falling_edge @capture
  Formal Scenario: Output captures input on falling clock edge
    Given d holds a symbolic value D immediately before a falling edge of clk
    When a falling edge of clk occurs
    Then q should equal D immediately after the edge

  @stability @no_glitch
  Formal Scenario: Output remains stable between clock edges
    Given q holds a symbolic value Q immediately after any clock edge, rising or falling
    When no further clock edge occurs
    And d may change to any value during this interval
    Then q should remain equal to Q

  @dual_edge @full_period
  Formal Scenario: Output updates exactly twice per clock period
    Given d holds a symbolic value D1 immediately before a rising edge of clk
    And d holds a symbolic value D2 immediately before the subsequent falling edge of clk
    When one full clock period elapses consisting of one rising edge followed by one falling edge
    Then q should equal D1 immediately after the rising edge
    And q should equal D2 immediately after the falling edge

  @no_combinational_leak
  Formal Scenario: Output does not change without a clock edge
    Given q holds a symbolic value Q
    And d changes to a new symbolic value D_new
    When no rising or falling edge of clk occurs
    Then q should still equal Q

  @equivalence @behavioral
  Formal Scenario: Equivalence to ideal dual-edge flip-flop behavior
    Given d holds a symbolic value D at the moment of any clock edge, rising or falling
    When that clock edge occurs
    Then q should equal D
    And this relationship should hold identically for both rising and falling edges