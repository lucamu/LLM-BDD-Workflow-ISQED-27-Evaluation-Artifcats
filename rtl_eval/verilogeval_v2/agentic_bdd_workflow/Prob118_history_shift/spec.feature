Feature: Global Branch History Register with Misprediction Rollback

  The TopModule implements a 32-bit global branch history shift register.
  On each clock edge, the register updates its value based on the priority
  of train_mispredicted over predict_valid. On misprediction, the register
  is loaded with the history before the mispredicted branch concatenated
  with the actual outcome. On a valid prediction (with no misprediction),
  the register shifts left, inserting predict_taken at the LSB. If neither
  event occurs, the register holds its value. areset asynchronously clears
  the register to zero.

  Background:
    Given a design named "TopModule"
    And an input "clk"
    And an input "areset"
    And an input "predict_valid"
    And an input "predict_taken"
    And an input "train_mispredicted"
    And an input "train_taken"
    And an input "train_history" of width 32 bits
    And an output "predict_history" of width 32 bits
    And all sequential logic is triggered on the positive edge of "clk"
    And "areset" is an asynchronous, active-high, positive-edge-triggered reset

  @reset @async
  Formal Scenario: Asynchronous reset clears history to zero
    Given areset is 1
    When a rising edge of clk occurs
    Then predict_history should be 32'h00000000

  @reset @async
  Formal Scenario: Asynchronous reset takes effect regardless of clock edge
    Given predict_history holds any prior value X
    And areset transitions to 1 asynchronously
    Then predict_history should immediately become 32'h00000000 without waiting for a clock edge

  @reset @deassert
  Formal Scenario: Deasserting reset allows normal operation on next clock edge
    Given areset is 0
    And predict_history holds value X
    And predict_valid is 0
    And train_mispredicted is 0
    When a rising edge of clk occurs
    Then predict_history should remain X

  @predict @shift
  Formal Scenario: Valid prediction shifts predict_taken into LSB
    Given areset is 0
    And predict_history holds value X
    And predict_valid is 1
    And predict_taken is value T
    And train_mispredicted is 0
    When a rising edge of clk occurs
    Then predict_history should be {X[30:0], T}

  @predict @noshift
  Formal Scenario: No prediction and no misprediction holds history constant
    Given areset is 0
    And predict_history holds value X
    And predict_valid is 0
    And train_mispredicted is 0
    When a rising edge of clk occurs
    Then predict_history should remain X

  @misprediction @rollback
  Formal Scenario: Misprediction loads rollback history with actual outcome
    Given areset is 0
    And train_mispredicted is 1
    And train_history is value H
    And train_taken is value A
    When a rising edge of clk occurs
    Then predict_history should be {H[30:0], A}

  @misprediction @priority
  Formal Scenario: Misprediction takes precedence over simultaneous prediction
    Given areset is 0
    And predict_valid is 1
    And predict_taken is value T
    And train_mispredicted is 1
    And train_history is value H
    And train_taken is value A
    When a rising edge of clk occurs
    Then predict_history should be {H[30:0], A}
    And predict_history should not depend on T

  @misprediction @independence
  Formal Scenario: Misprediction result does not depend on prior predict_history value
    Given areset is 0
    And predict_history holds any prior value X
    And train_mispredicted is 1
    And train_history is value H
    And train_taken is value A
    When a rising edge of clk occurs
    Then predict_history should be {H[30:0], A}
    And predict_history should not depend on X

  @ordering @lsb
  Formal Scenario: LSB of predict_history reflects the youngest branch outcome after prediction
    Given areset is 0
    And predict_history holds value X
    And predict_valid is 1
    And predict_taken is value T
    And train_mispredicted is 0
    When a rising edge of clk occurs
    Then predict_history bit 0 should equal T

  @ordering @lsb
  Formal Scenario: LSB of predict_history reflects the actual outcome after misprediction rollback
    Given areset is 0
    And train_mispredicted is 1
    And train_history is value H
    And train_taken is value A
    When a rising edge of clk occurs
    Then predict_history bit 0 should equal A

  @stability @idle
  Formal Scenario: History remains stable across multiple idle cycles
    Given areset is 0
    And predict_history holds value X
    And predict_valid is 0
    And train_mispredicted is 0
    When two consecutive rising edges of clk occur
    Then predict_history should remain X after each edge