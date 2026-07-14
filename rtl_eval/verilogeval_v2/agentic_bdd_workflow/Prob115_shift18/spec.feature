Feature: 64-bit Arithmetic Shift Register with Synchronous Load

  As a hardware designer
  I want a 64-bit shifter that supports synchronous load and left/right
  arithmetic shifts by 1 or 8 bits
  So that data can be loaded and shifted based on control signals

  Background:
    Given a synchronous design clocked on the rising edge of clk
    And the current register value is q
    And q holds an arbitrary symbolic 64-bit value before the clock edge
    And load, ena, amount, and data are arbitrary symbolic values before the clock edge

  @load @priority
  Formal Scenario: Load takes priority over shifting
    Given load is 1
    And ena is any value
    And amount is any value
    And data is a symbolic 64-bit value D
    When a rising clock edge occurs
    Then q should equal D on the next cycle

  @shift @left @amount1
  Formal Scenario: Shift left by 1 bit when not loading
    Given load is 0
    And ena is 1
    And amount is 2'b00
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then q on the next cycle should equal {Q[62:0], 1'b0}

  @shift @left @amount8
  Formal Scenario: Shift left by 8 bits when not loading
    Given load is 0
    And ena is 1
    And amount is 2'b01
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then q on the next cycle should equal {Q[55:0], 8'b00000000}

  @shift @right @arithmetic @amount1
  Formal Scenario: Arithmetic shift right by 1 bit when not loading
    Given load is 0
    And ena is 1
    And amount is 2'b10
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then q on the next cycle should equal {Q[63], Q[63:1]}

  @shift @right @arithmetic @amount8
  Formal Scenario: Arithmetic shift right by 8 bits when not loading
    Given load is 0
    And ena is 1
    And amount is 2'b11
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then q on the next cycle should equal {{8{Q[63]}}, Q[63:8]}

  @hold @no_shift
  Formal Scenario: Register holds value when not loading and not enabled
    Given load is 0
    And ena is 0
    And amount is any value
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then q on the next cycle should equal Q

  @load @overrides_ena
  Formal Scenario: Load overrides shift enable regardless of amount value
    Given load is 1
    And ena is 0
    And amount is any value
    And data is a symbolic 64-bit value D
    When a rising clock edge occurs
    Then q on the next cycle should equal D

  @sign_extension @arithmetic_right
  Formal Scenario: Sign bit is preserved and replicated during arithmetic right shift by 1
    Given load is 0
    And ena is 1
    And amount is 2'b10
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then bit 63 of q on the next cycle should equal Q[63]

  @sign_extension @arithmetic_right8
  Formal Scenario: Sign bit is preserved and replicated during arithmetic right shift by 8
    Given load is 0
    And ena is 1
    And amount is 2'b11
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then bits 63 down to 56 of q on the next cycle should all equal Q[63]

  @zero_fill @left1
  Formal Scenario: Least significant bit is zero-filled during left shift by 1
    Given load is 0
    And ena is 1
    And amount is 2'b00
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then bit 0 of q on the next cycle should equal 1'b0

  @zero_fill @left8
  Formal Scenario: Least significant 8 bits are zero-filled during left shift by 8
    Given load is 0
    And ena is 1
    And amount is 2'b01
    And q holds a symbolic 64-bit value Q before the clock edge
    When a rising clock edge occurs
    Then bits 7 down to 0 of q on the next cycle should all equal 1'b0