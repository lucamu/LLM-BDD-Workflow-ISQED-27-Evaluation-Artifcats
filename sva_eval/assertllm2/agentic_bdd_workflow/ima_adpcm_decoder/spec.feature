Feature: IMA ADPCM Decoder (ima_adpcm_dec) Formal Verification

  # 4-bit IMA ADPCM decoder producing 16-bit PCM samples with
  # optional predictor/step-index state preload and a two-cycle
  # decode cadence gated by inReady/inValid/outValid handshaking.

  Background:
    Given the design operates on the rising edge of clock
    And reset is an asynchronous active-high signal
    And inReady is driven as the logical inverse of internal predValid
    And the control priority for predictor and step-index paths is reset, then inStateLoad, then inValid, then idle

  # ---------------------------------------------------------------
  # Reset behavior
  # ---------------------------------------------------------------

  @reset
  Formal Scenario: Asynchronous reset clears all state and outputs
    Given reset is asserted
    When a clock edge occurs
    Then predictorSamp should be 0
    And stepIndex should be 0
    And predValid should be 0
    And outValid should be 0
    And inReady should be 1

  @reset
  Formal Scenario: Reset takes priority over state load and valid input
    Given reset is asserted
    And inStateLoad is 1
    And inValid is 1
    And inPredictSamp is value P
    And inStepIndex is value S
    When a clock edge occurs
    Then predictorSamp should be 0
    And stepIndex should be 0
    And predValid should be 0

  # ---------------------------------------------------------------
  # inReady / handshake behavior
  # ---------------------------------------------------------------

  @handshake
  Formal Scenario: inReady reflects inverse of predValid
    Given reset is deasserted
    And predValid is value V
    Then inReady should be equal to the logical negation of V

  @handshake
  Formal Scenario: Accepted nibble sets predValid pending indication
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    When a clock edge occurs
    Then predValid should become 1

  @handshake
  Formal Scenario: Idle path holds internal state when no valid input or preload
    Given reset is deasserted
    And inStateLoad is 0
    And inValid is 0
    And predictorSamp is value Pcur
    And stepIndex is value Scur
    And predValid is value Vcur
    When a clock edge occurs
    Then predictorSamp should remain equal to Pcur
    And stepIndex should remain equal to Scur
    And predValid should remain equal to Vcur

  @handshake
  Formal Scenario: inValid deasserted while inReady is low has no effect on decode state
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 0
    And inValid is 1
    And predictorSamp is value Pcur
    And stepIndex is value Scur
    When a clock edge occurs
    Then predictorSamp should remain equal to Pcur
    And stepIndex should remain equal to Scur

  # ---------------------------------------------------------------
  # State preload behavior
  # ---------------------------------------------------------------

  @preload
  Formal Scenario: State preload loads predictor sample with internal scale alignment
    Given reset is deasserted
    And inStateLoad is 1
    And inPredictSamp is value P
    When a clock edge occurs
    Then predictorSamp should be equal to P scaled to internal predictor precision

  @preload
  Formal Scenario: State preload loads step index register
    Given reset is deasserted
    And inStateLoad is 1
    And inStepIndex is value S
    When a clock edge occurs
    Then stepIndex should be equal to S

  @preload
  Formal Scenario: State preload clears pending output-valid indication
    Given reset is deasserted
    And inStateLoad is 1
    And predValid is value Vcur
    When a clock edge occurs
    Then predValid should be 0

  @preload
  Formal Scenario: State preload takes priority over valid input acceptance
    Given reset is deasserted
    And inStateLoad is 1
    And inValid is 1
    And inPredictSamp is value P
    And inStepIndex is value S
    When a clock edge occurs
    Then predictorSamp should be equal to P scaled to internal predictor precision
    And stepIndex should be equal to S

  # ---------------------------------------------------------------
  # Decode computation: predictor update and sign application
  # ---------------------------------------------------------------

  @decode
  Formal Scenario: Predictor update adds dequantized magnitude for positive sign nibble
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And inPCM sign bit is 0
    And inPCM magnitude bits are M
    And predictorSamp is value Pcur
    And stepSize is value Scur
    When a clock edge occurs
    Then predictorSamp should be equal to the saturation of Pcur plus dequantSamp(M, Scur) to the signed internal range

  @decode
  Formal Scenario: Predictor update subtracts dequantized magnitude for negative sign nibble
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And inPCM sign bit is 1
    And inPCM magnitude bits are M
    And predictorSamp is value Pcur
    And stepSize is value Scur
    When a clock edge occurs
    Then predictorSamp should be equal to the saturation of Pcur minus dequantSamp(M, Scur) to the signed internal range

  @decode
  Formal Scenario: Predictor update is saturated at upper internal limit
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And prePredSamp exceeds the maximum signed internal predictor value
    When a clock edge occurs
    Then predictorSamp should be equal to the maximum signed internal predictor value

  @decode
  Formal Scenario: Predictor update is saturated at lower internal limit
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And prePredSamp is below the minimum signed internal predictor value
    When a clock edge occurs
    Then predictorSamp should be equal to the minimum signed internal predictor value

  # ---------------------------------------------------------------
  # Step index adaptation
  # ---------------------------------------------------------------

  @stepindex
  Formal Scenario: Step index decrements for low nibble magnitude values
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And inPCM magnitude bits M are in range 0 to 3
    And stepIndex is value Scur
    When a clock edge occurs
    Then preStepIndex should be equal to Scur plus stepDelta(M)
    And stepDelta(M) should correspond to the decrement mapping for M

  @stepindex
  Formal Scenario: Step index increments for high nibble magnitude values
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And inPCM magnitude bits M are in range 4 to 7
    And stepIndex is value Scur
    When a clock edge occurs
    Then preStepIndex should be equal to Scur plus stepDelta(M)
    And stepDelta(M) should correspond to the increment mapping for M

  @stepindex
  Formal Scenario: Step index saturates at upper table bound
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And preStepIndex exceeds 88
    When a clock edge occurs
    Then stepIndex should be equal to 88

  @stepindex
  Formal Scenario: Step index saturates at lower table bound
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    And preStepIndex is below 0
    When a clock edge occurs
    Then stepIndex should be equal to 0

  @stepindex
  Formal Scenario: Step size follows table lookup from updated step index
    Given reset is deasserted
    And stepIndex is value Snew after update
    When a clock edge occurs
    Then stepSize should be equal to stepSizeTable(Snew)

  # ---------------------------------------------------------------
  # Output sample computation and saturation
  # ---------------------------------------------------------------

  @output
  Formal Scenario: Output sample is derived from predictor scale with rounding before saturation
    Given predValid is 1
    And predictorSamp is value Pcur
    When a clock edge occurs
    Then preOutSamp should be equal to scaleDown(Pcur) plus the rounding term
    And outSamp should be equal to the saturation of preOutSamp to signed 16-bit range

  @output
  Formal Scenario: Output sample saturates at signed 16-bit maximum
    Given predValid is 1
    And preOutSamp exceeds 16'h7FFF as a signed value
    When a clock edge occurs
    Then outSamp should be equal to 16'h7FFF

  @output
  Formal Scenario: Output sample saturates at signed 16-bit minimum
    Given predValid is 1
    And preOutSamp is below 16'h8000 as a signed value
    When a clock edge occurs
    Then outSamp should be equal to 16'h8000

  @output
  Formal Scenario: outValid asserts only when output sample register is updated
    Given predValid is value Vcur
    When a clock edge occurs
    Then outValid should be equal to Vcur

  @output
  Formal Scenario: outValid deasserts when predValid is not pending
    Given predValid is 0
    When a clock edge occurs
    Then outValid should be 0

  @output
  Formal Scenario: outValid is cleared when state preload occurs regardless of prior predValid
    Given inStateLoad is 1
    And predValid is value Vcur
    When a clock edge occurs
    Then outValid should be 0

  # ---------------------------------------------------------------
  # Two-cycle decode cadence
  # ---------------------------------------------------------------

  @timing
  Formal Scenario: Accepted nibble sets predValid pending for next cycle output update
    Given reset is deasserted
    And inStateLoad is 0
    And inReady is 1
    And inValid is 1
    When a clock edge occurs
    Then predValid should become 1
    And outValid should be 0 at this clock edge
    And inReady should become 0 at this clock edge

  @timing
  Formal Scenario: Output update and predValid clearance follow one cycle after acceptance
    Given reset is deasserted
    And predValid is 1
    When a clock edge occurs
    Then outValid should be 1
    And outSamp should be updated to the saturated decoded sample
    And predValid should become 0
    And inReady should become 1

  @timing
  Formal Scenario: inReady is not re-asserted before output update completes
    Given reset is deasserted
    And predValid is 1
    Then inReady should be 0

  @timing
  Formal Scenario: No new nibble is accepted while inReady is deasserted
    Given reset is deasserted
    And inReady is 0
    And inValid is value X
    And predictorSamp is value Pcur
    And stepIndex is value Scur
    When a clock edge occurs
    Then predictorSamp should remain equal to Pcur
    And stepIndex should remain equal to Scur