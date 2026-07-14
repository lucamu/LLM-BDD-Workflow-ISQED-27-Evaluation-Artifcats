Feature: Two-Bit Saturating Counter for Branch Prediction

  As a hardware designer
  I want a two-bit saturating counter that trains on branch outcomes
  So that I can predict branch behavior with a standard saturating counter FSM

  Background:
    Given a module TopModule with input clk
    And input areset
    And input train_valid
    And input train_taken
    And output state with 2 bits
    And all sequential logic is triggered on the positive edge of clk
    And areset is an asynchronous, positive-edge-triggered reset

  @reset @async
  Formal Scenario: Asynchronous reset forces state to weakly not-taken
    Given areset is asserted with a positive edge
    When the next clock edge occurs
    Then state should be 2'b01 regardless of train_valid and train_taken

  @reset @hold
  Formal Scenario: State remains at reset value while areset stays asserted
    Given areset is 1
    And state currently equals 2'b01
    When any values of train_valid and train_taken are applied
    And a clock edge occurs
    Then state should remain 2'b01

  @no_training @hold_value
  Formal Scenario: State holds its value when not training
    Given areset is 0
    And state currently equals value S
    And train_valid is 0
    When a clock edge occurs
    Then state should equal S

  @training @increment @max_saturation
  Formal Scenario: Counter increments toward maximum but saturates at 3
    Given areset is 0
    And state currently equals value S
    And train_valid is 1
    And train_taken is 1
    When a clock edge occurs
    Then state should equal S + 1 if S is less than 2'b11
    And state should equal 2'b11 if S equals 2'b11

  @training @decrement @min_saturation
  Formal Scenario: Counter decrements toward minimum but saturates at 0
    Given areset is 0
    And state currently equals value S
    And train_valid is 1
    And train_taken is 0
    When a clock edge occurs
    Then state should equal S - 1 if S is greater than 2'b00
    And state should equal 2'b00 if S equals 2'b00

  @range @invariant
  Formal Scenario: State value is always within valid two-bit range
    Given areset is 0
    And state currently equals value S
    When any values of train_valid and train_taken are applied
    And a clock edge occurs
    Then state should be greater than or equal to 2'b00
    And state should be less than or equal to 2'b11

  @training @no_overflow
  Formal Scenario: Incrementing at maximum value does not wrap around
    Given areset is 0
    And state currently equals 2'b11
    And train_valid is 1
    And train_taken is 1
    When a clock edge occurs
    Then state should equal 2'b11

  @training @no_underflow
  Formal Scenario: Decrementing at minimum value does not wrap around
    Given areset is 0
    And state currently equals 2'b00
    And train_valid is 1
    And train_taken is 0
    When a clock edge occurs
    Then state should equal 2'b00

  @reset_priority
  Formal Scenario: Reset takes priority over training inputs
    Given areset is asserted with a positive edge
    And train_valid is 1
    And train_taken is any value
    When the next clock edge occurs
    Then state should equal 2'b01