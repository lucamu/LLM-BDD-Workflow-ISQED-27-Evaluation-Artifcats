Feature: FSM TopModule Formal Verification
  Formal specification for a Moore-type finite state machine with 5 valid
  states (000, 001, 010, 011, 100), synchronous active-high reset, and
  single-bit input x and output z.

  Background:
    Given the design is TopModule
    And the clock signal is clk
    And the reset signal is reset
    And the input signal is x
    And the output signal is z
    And the internal state register is y with 3 bits
    And all sequential logic is triggered on the positive edge of clk

  @reset
  Formal Scenario: Synchronous reset forces state to 000
    Given the current state y is any valid state
    And input x is any value
    When reset is 1
    And a rising clock edge occurs
    Then the next state y should be 3'b000

  @reset
  Formal Scenario: Output is 0 immediately after reset
    Given the current state y is any valid state
    And input x is any value
    When reset is 1
    And a rising clock edge occurs
    Then output z should be 0

  @transition @state000
  Formal Scenario: Next state from state 000
    Given the current state y is 3'b000
    And reset is 0
    And input x is any value
    When a rising clock edge occurs
    Then the next state y should be 3'b001 if x equals 1
    And the next state y should be 3'b000 if x equals 0

  @output @state000
  Formal Scenario: Output from state 000
    Given the current state y is 3'b000
    Then output z should be 0

  @transition @state001
  Formal Scenario: Next state from state 001
    Given the current state y is 3'b001
    And reset is 0
    And input x is any value
    When a rising clock edge occurs
    Then the next state y should be 3'b100 if x equals 1
    And the next state y should be 3'b001 if x equals 0

  @output @state001
  Formal Scenario: Output from state 001
    Given the current state y is 3'b001
    Then output z should be 0

  @transition @state010
  Formal Scenario: Next state from state 010
    Given the current state y is 3'b010
    And reset is 0
    And input x is any value
    When a rising clock edge occurs
    Then the next state y should be 3'b001 if x equals 1
    And the next state y should be 3'b010 if x equals 0

  @output @state010
  Formal Scenario: Output from state 010
    Given the current state y is 3'b010
    Then output z should be 0

  @transition @state011
  Formal Scenario: Next state from state 011
    Given the current state y is 3'b011
    And reset is 0
    And input x is any value
    When a rising clock edge occurs
    Then the next state y should be 3'b010 if x equals 1
    And the next state y should be 3'b001 if x equals 0

  @output @state011
  Formal Scenario: Output from state 011
    Given the current state y is 3'b011
    Then output z should be 1

  @transition @state100
  Formal Scenario: Next state from state 100
    Given the current state y is 3'b100
    And reset is 0
    And input x is any value
    When a rising clock edge occurs
    Then the next state y should be 3'b100 if x equals 1
    And the next state y should be 3'b011 if x equals 0

  @output @state100
  Formal Scenario: Output from state 100
    Given the current state y is 3'b100
    Then output z should be 1

  @invariant
  Formal Scenario: State remains within valid encoded range
    Given the current state y is any valid state
    And reset is 0
    And input x is any value
    When a rising clock edge occurs
    Then the next state y should be one of 3'b000, 3'b001, 3'b010, 3'b011, 3'b100

  @invariant
  Formal Scenario: Output depends only on current state
    Given the current state y is any valid state
    Then output z should be 1 if the current state y equals 3'b011 or the current state y equals 3'b100
    And output z should be 0 if the current state y equals 3'b000 or the current state y equals 3'b001 or the current state y equals 3'b010