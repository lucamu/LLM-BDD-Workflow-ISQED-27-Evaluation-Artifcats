Feature: Gshare Branch Predictor

  As a processor front-end
  I want a gshare branch predictor with a 7-bit global history and a
  128-entry 2-bit saturating-counter PHT
  So that I can predict branch directions and train the predictor with
  correct priority and timing rules

  Background:
    Given clk is the system clock
    And areset is an asynchronous active-high reset
    And the design maintains an internal 7-bit history register that drives predict_history
    And the design maintains a 128-entry pattern history table (PHT) of 2-bit saturating counters
    And the PHT index used for prediction is computed as predict_pc XOR the current history register value
    And the PHT index used for training is computed as train_pc XOR train_history
    And predict_taken is the most significant bit of the PHT entry selected by the prediction index
    And a saturating counter increments toward 2'b11 on a taken outcome and decrements toward 2'b00 on a not-taken outcome, without wrapping

  @reset
  Formal Scenario: Asynchronous reset clears the history register immediately
    Given areset is 1
    Then predict_history should be 0, independent of any clock edge

  @reset
  Formal Scenario: Asynchronous reset initializes every PHT entry to weakly not-taken
    Given areset is 1
    And predict_valid is 1
    And predict_pc is any value PC
    Then predict_taken should be 0, independent of any clock edge

  @predict @combinational
  Formal Scenario: Predicted direction reflects the PHT entry selected by pc xor history
    Given areset is 0
    And predict_valid is 1
    And predict_pc is any value PC
    And the current history register value is H
    Then predict_taken should equal the most significant bit of the PHT entry at index (PC XOR H)

  @predict @combinational
  Formal Scenario: Predicted history equals the current history register value
    Given areset is 0
    And predict_valid is 1
    And predict_pc is any value PC
    And the current history register value is H
    Then predict_history should equal H

  @history @sequential
  Formal Scenario: History register shifts in predicted outcome when only predicting
    Given areset is 0
    And predict_valid is 1
    And predict_pc is any value PC
    And train_valid is 0
    And the current history register value is H
    And predict_taken evaluates to bit T for this cycle
    When a rising clock edge occurs
    Then the history register should equal {H[5:0], T}

  @history @sequential
  Formal Scenario: History register holds its value when neither predicting nor training
    Given areset is 0
    And predict_valid is 0
    And train_valid is 0
    And the current history register value is H
    When a rising clock edge occurs
    Then the history register should equal H

  @history @train @priority
  Formal Scenario: Misprediction recovery takes precedence over a concurrent prediction
    Given areset is 0
    And predict_valid is 1
    And predict_pc is any value PC
    And train_valid is 1
    And train_mispredicted is 1
    And train_history is any value TH
    And train_taken is any value TT
    When a rising clock edge occurs
    Then the history register should equal {TH[5:0], TT}
    And the history register should not depend on predict_pc or predict_taken

  @history @train
  Formal Scenario: Training without misprediction does not override a concurrent prediction's history update
    Given areset is 0
    And predict_valid is 1
    And predict_pc is any value PC
    And train_valid is 1
    And train_mispredicted is 0
    And the current history register value is H
    And predict_taken evaluates to bit T for this cycle
    When a rising clock edge occurs
    Then the history register should equal {H[5:0], T}

  @history @train
  Formal Scenario: Training misprediction with no concurrent prediction still recovers history
    Given areset is 0
    And predict_valid is 0
    And train_valid is 1
    And train_mispredicted is 1
    And train_history is any value TH
    And train_taken is any value TT
    When a rising clock edge occurs
    Then the history register should equal {TH[5:0], TT}

  @pht @train @saturation
  Formal Scenario: Training a taken outcome increments the saturating counter unless already saturated high
    Given areset is 0
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And train_taken is 1
    And the PHT entry at index (TPC XOR TH) has value C before training
    And C is less than 2'b11
    When a rising clock edge occurs
    Then the PHT entry at index (TPC XOR TH) should equal C + 1

  @pht @train @saturation
  Formal Scenario: Training a taken outcome leaves a saturated-high counter unchanged
    Given areset is 0
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And train_taken is 1
    And the PHT entry at index (TPC XOR TH) has value 2'b11 before training
    When a rising clock edge occurs
    Then the PHT entry at index (TPC XOR TH) should equal 2'b11

  @pht @train @saturation
  Formal Scenario: Training a not-taken outcome decrements the saturating counter unless already saturated low
    Given areset is 0
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And train_taken is 0
    And the PHT entry at index (TPC XOR TH) has value C before training
    And C is greater than 2'b00
    When a rising clock edge occurs
    Then the PHT entry at index (TPC XOR TH) should equal C - 1

  @pht @train @saturation
  Formal Scenario: Training a not-taken outcome leaves a saturated-low counter unchanged
    Given areset is 0
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And train_taken is 0
    And the PHT entry at index (TPC XOR TH) has value 2'b00 before training
    When a rising clock edge occurs
    Then the PHT entry at index (TPC XOR TH) should equal 2'b00

  @pht @train @sideeffect
  Formal Scenario: Training does not modify PHT entries other than the trained index
    Given areset is 0
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And the PHT entry at any index J different from (TPC XOR TH) has value C before training
    When a rising clock edge occurs
    Then the PHT entry at index J should still equal C

  @pht @timing @readbeforewrite
  Formal Scenario: Same-cycle prediction reads pre-training PHT state when indices coincide
    Given areset is 0
    And predict_valid is 1
    And predict_pc is any value PC
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And the current history register value is H
    And (PC XOR H) equals (TPC XOR TH)
    And the PHT entry at index (PC XOR H) has value C before this cycle
    Then predict_taken should equal the most significant bit of C
    And predict_taken should not reflect any update caused by this cycle's training

  @pht @timing
  Formal Scenario: PHT update from training is only visible after the next rising clock edge
    Given areset is 0
    And train_valid is 1
    And train_pc is any value TPC
    And train_history is any value TH
    And train_taken is any value TT
    And the PHT entry at index (TPC XOR TH) has value C before training
    Then the PHT entry at index (TPC XOR TH) should still equal C prior to the rising clock edge
    When a rising clock edge occurs
    Then the PHT entry at index (TPC XOR TH) should equal the saturated update of C toward TT