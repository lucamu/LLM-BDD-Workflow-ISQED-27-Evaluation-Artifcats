# ── module: Min2 ──
Feature: 8-bit Unsigned Minimum Comparator

  As a hardware designer
  I want to verify that data_min always reflects the smaller of data_a and data_b
  So that the combinational comparator logic is proven correct under all conditions

  Background:
    Given the design is purely combinational with no internal state
    And data_a is an 8-bit unsigned value
    And data_b is an 8-bit unsigned value
    And data_min is an 8-bit unsigned output
    And the output data_min is computed continuously from the current values of data_a and data_b
    And no clock edge or reset value affects the functional output data_min

  @combinational @core-behavior
  Formal Scenario: Output equals data_a when data_a is less than or equal to data_b
    Given data_a is value A
    And data_b is value B
    And A is less than or equal to B
    When the comparator evaluates the inputs
    Then data_min should equal A

  @combinational @core-behavior
  Formal Scenario: Output equals data_b when data_a is greater than data_b
    Given data_a is value A
    And data_b is value B
    And A is greater than B
    When the comparator evaluates the inputs
    Then data_min should equal B

  @combinational @equality-edge
  Formal Scenario: Output equals both inputs when they are equal
    Given data_a is value A
    And data_b is value B
    And A equals B
    When the comparator evaluates the inputs
    Then data_min should equal A
    And data_min should equal B

  @combinational @general-property
  Formal Scenario: Output always equals the minimum of the two inputs
    Given data_a is value A
    And data_b is value B
    When the comparator evaluates the inputs
    Then data_min should equal A if A is less than or equal to B
    And data_min should equal B if A is greater than B

  @combinational @range-check
  Formal Scenario: Output never exceeds either input
    Given data_a is value A
    And data_b is value B
    When the comparator evaluates the inputs
    Then data_min should be less than or equal to A
    And data_min should be less than or equal to B

  @combinational @range-check
  Formal Scenario: Output always equals one of the two inputs
    Given data_a is value A
    And data_b is value B
    When the comparator evaluates the inputs
    Then data_min should equal A or data_min should equal B

  @combinational @no-state
  Formal Scenario: Output is independent of clock and reset
    Given data_a is value A
    And data_b is value B
    When the clock toggles with data_a and data_b held constant
    Then data_min should remain equal to the minimum of A and B
    And data_min should not change due to reset assertion or deassertion

  @combinational @boundary
  Formal Scenario: Output correctness at minimum and maximum 8-bit boundary values
    Given data_a is value A
    And data_b is value B
    And A or B may equal 0 or 255
    When the comparator evaluates the inputs
    Then data_min should equal A if A is less than or equal to B
    And data_min should equal B if A is greater than B

# ── module: TopModule ──
Feature: Minimum of Three 8-bit Unsigned Values via Hierarchical Comparator Submodule

  As a hardware designer
  I want a TopModule that computes the minimum of three 8-bit unsigned values
  Using an instantiated 2-input minimum comparator submodule
  So that the design is modular, reusable, and functionally correct

  Background:
    Given a signal "clk" as the system clock
    And a signal "rst_n" as an active-low asynchronous reset
    And an 8-bit input "a"
    And an 8-bit input "b"
    And an 8-bit input "c"
    And an 8-bit output "d"
    And all sequential logic is triggered on the positive edge of "clk"
    And "rst_n" asynchronously resets the design when it is 0, independent of "clk"

  @reset @asynchronous
  Formal Scenario: Asynchronous reset forces output to zero
    Given value A on input "a"
    And value B on input "b"
    And value C on input "c"
    When "rst_n" is deasserted to 0 at any time, regardless of "clk"
    Then the output "d" should become 0 immediately, asynchronously

  @reset @recovery
  Formal Scenario: Output resumes normal computation after reset release
    Given value A on input "a"
    And value B on input "b"
    And value C on input "c"
    And "rst_n" has been 0 and is now released to 1
    When a rising edge occurs on "clk" after "rst_n" is 1
    Then the output "d" should equal the minimum of value A, value B, and value C

  @functional @minimum
  Formal Scenario: Output equals minimum of three values in normal operation
    Given value A on input "a"
    And value B on input "b"
    And value C on input "c"
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should equal the minimum of value A, value B, and value C

  @functional @equal_values
  Formal Scenario: Output equals the common value when all three inputs are equal
    Given value A on input "a"
    And input "b" equals value A
    And input "c" equals value A
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should equal value A

  @functional @two_equal_minimum
  Formal Scenario: Output equals the minimum when exactly two inputs are equal and smallest
    Given value A on input "a"
    And input "b" equals value A
    And value C on input "c"
    And value C is greater than value A
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should equal value A

  @functional @boundary
  Formal Scenario: Output equals zero when any input is zero and the smallest
    Given input "a" equals 8'b00000000
    And value B on input "b"
    And value C on input "c"
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should equal 8'b00000000

  @functional @boundary
  Formal Scenario: Output equals max value when all inputs equal maximum
    Given input "a" equals 8'b11111111
    And input "b" equals 8'b11111111
    And input "c" equals 8'b11111111
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should equal 8'b11111111

  @submodule @comparator
  Formal Scenario: Comparator submodule selects the smaller of two inputs
    Given value X as data_a to the comparator submodule
    And value Y as data_b to the comparator submodule
    When the comparator submodule evaluates its inputs
    Then the comparator submodule output should equal value X if value X is less than or equal to value Y
    And the comparator submodule output should equal value Y if value Y is less than value X

  @submodule @comparator @tie
  Formal Scenario: Comparator submodule handles equal inputs correctly
    Given value X as data_a to the comparator submodule
    And input data_b equals value X
    When the comparator submodule evaluates its inputs
    Then the comparator submodule output should equal value X

  @structural @invariant
  Formal Scenario: Output is always one of the three inputs
    Given value A on input "a"
    And value B on input "b"
    And value C on input "c"
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should equal value A or value B or value C

  @structural @invariant
  Formal Scenario: Output never exceeds any of the three inputs
    Given value A on input "a"
    And value B on input "b"
    And value C on input "c"
    And "rst_n" is held at 1
    When a rising edge occurs on "clk"
    Then the output "d" should be less than or equal to value A
    And the output "d" should be less than or equal to value B
    And the output "d" should be less than or equal to value C