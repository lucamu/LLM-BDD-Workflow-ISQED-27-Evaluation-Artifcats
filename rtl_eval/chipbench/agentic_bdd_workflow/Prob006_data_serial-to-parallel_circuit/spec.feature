Feature: Serial-to-Parallel Converter with Valid-Ready Input and Valid-Only Output

  As a hardware designer
  I want a serial-to-parallel converter that packs 6 single-bit inputs into
  a 6-bit parallel output word
  So that upstream serial data can be consumed by wide downstream logic

  Background:
    Given the design is a synchronous module with clock "clk" and active-low
      reset "rst_n"
    And all signal sampling and state updates occur on the rising edge of clk
    And reset is asserted for at least one clock cycle before normal operation

  @reset
  Formal Scenario: Reset initializes the module to idle state
    Given rst_n is 0
    When a rising clock edge occurs
    Then ready_a should be 1
    And valid_b should be 0
    And the internal received-bit count should be 0

  @ready
  Formal Scenario: ready_a is always asserted regardless of input or state
    Given rst_n is 1
    And valid_a is any value V
    And data_a is any value D
    And the internal received-bit count is any value N
    When a rising clock edge occurs
    Then ready_a should be 1

  @accumulation
  Formal Scenario: Single valid input bit advances the internal bit counter
    Given rst_n is 1
    And the internal received-bit count is value N where N is less than 5
    And valid_a is 1
    And data_a is value D
    When a rising clock edge occurs
    Then the internal received-bit count should be N + 1
    And valid_b should be 0

  @no-advance
  Formal Scenario: Invalid input does not advance the internal bit counter
    Given rst_n is 1
    And the internal received-bit count is value N
    And valid_a is 0
    When a rising clock edge occurs
    Then the internal received-bit count should remain N
    And valid_b should be 0

  @bit-placement-lsb
  Formal Scenario: First received bit is placed in the LSB position
    Given rst_n is 1
    And the internal received-bit count is 0
    And valid_a is 1
    And data_a is value D0
    When a rising clock edge occurs
    Then bit 0 of the internally stored shift register should equal D0

  @bit-placement-msb
  Formal Scenario: Sixth received bit is placed in the MSB position
    Given rst_n is 1
    And the internal received-bit count is 5
    And valid_a is 1
    And data_a is value D5
    When a rising clock edge occurs
    Then bit 5 of the internally stored shift register should equal D5

  @full-conversion
  Formal Scenario: Six consecutive valid input bits produce a correctly packed output word
    Given rst_n is 1
    And the internal received-bit count is 0
    And on cycle 1 valid_a is 1 and data_a is value D0
    And on cycle 2 valid_a is 1 and data_a is value D1
    And on cycle 3 valid_a is 1 and data_a is value D2
    And on cycle 4 valid_a is 1 and data_a is value D3
    And on cycle 5 valid_a is 1 and data_a is value D4
    And on cycle 6 valid_a is 1 and data_a is value D5
    When 6 consecutive rising clock edges occur corresponding to cycles 1 through 6
    Then after cycle 6 valid_b should be 1
    And after cycle 6 data_b should equal the concatenation {D5, D4, D3, D2, D1, D0}

  @no-premature-valid
  Formal Scenario: valid_b remains deasserted before six bits have been received
    Given rst_n is 1
    And the internal received-bit count is value N where N is less than 5
    And valid_a is any value V
    When a rising clock edge occurs
    Then valid_b should be 0

  @valid-pulse
  Formal Scenario: valid_b is asserted for exactly one cycle after word completion
    Given rst_n is 1
    And the internal received-bit count is 5
    And valid_a is 1
    And data_a is value D5
    When a rising clock edge occurs
    Then valid_b should be 1
    And on the following rising clock edge, if the internal received-bit count
      restarts accumulation, valid_b should be 0 unless a new 6-bit word has
      just completed

  @counter-wrap
  Formal Scenario: Internal bit counter resets after completing a 6-bit word
    Given rst_n is 1
    And the internal received-bit count is 5
    And valid_a is 1
    And data_a is value D5
    When a rising clock edge occurs
    Then the internal received-bit count should be 0

  @back-to-back
  Formal Scenario: Module correctly begins accumulating a new word immediately after completing the previous one
    Given rst_n is 1
    And the internal received-bit count is 0 immediately following a completed
      6-bit word
    And valid_a is 1
    And data_a is value D0_next
    When a rising clock edge occurs
    Then the internal received-bit count should be 1
    And bit 0 of the internally stored shift register should equal D0_next
    And valid_b should be 0

  @gapped-accumulation
  Formal Scenario: Non-consecutive valid cycles still correctly accumulate six bits
    Given rst_n is 1
    And the internal received-bit count is 0
    And valid_a is 1 on some cycles and 0 on other cycles interspersed
      arbitrarily
    And exactly six cycles with valid_a equal to 1 occur, carrying values D0
      through D5 in temporal order
    When the clock advances through all cycles until the sixth valid_a
      assertion completes
    Then valid_b should be 1 exactly one cycle after the sixth valid_a
      assertion
    And data_b should equal the concatenation {D5, D4, D3, D2, D1, D0}