Feature: Reed-Solomon (204,188) Decoder Formal Verification

  Formal specification of RS_dec covering reset behavior, input/output
  handshake protocol, staged pipeline completion pulses, GF resource
  arbitration, memory write qualification, output cadence, and
  overlap/completion-extension behavior. Each scenario is expressed as
  a checkable temporal/combinational property.

  Background:
    Given a synchronous design clocked on the rising edge of "clk"
    And an asynchronous active-high reset "reset"
    And the input interface signals "CE" and "input_byte"
    And the output interface signals "Out_byte", "CEO", and "Valid_out"
    And the internal stage-ready pulses "S_ready", "L_ready", "roots_ready", "poly_ready", and "DONE"
    And the internal stage flags "S_flag", "L_flag", "R_flag", "T_flag", "out_flag", and "DONE_ext"
    And the local output cadence pulse "CEO_0"

  @reset @async
  Formal Scenario: Asynchronous reset forces all stage flags and outputs idle
    Given "reset" is asserted at any point in time, regardless of clock edge
    When one clock edge occurs while "reset" remains asserted
    Then "S_flag" should be 0
    And "L_flag" should be 0
    And "R_flag" should be 0
    And "T_flag" should be 0
    And "out_flag" should be 0
    And "DONE_ext" should be 0
    And "Valid_out" should be 0
    And "CEO" should be 0
    And "CEO_0" should be 0

  @reset @recovery
  Formal Scenario: Deassertion of reset allows normal FSM startup from idle
    Given "reset" is asserted for at least one cycle
    And "reset" is then deasserted
    When no "CE" pulse has yet occurred after reset deassertion
    Then "S_flag" should be 0
    And "out_flag" should be 0
    And "Valid_out" should be 0

  @interface @protocol
  Formal Scenario: CE strobe is required to sample input_byte into the codeword buffer
    Given "reset" is deasserted
    And "input_byte" holds a symbolic value X
    When "CE" is asserted for exactly one clock cycle with "input_byte" equal to X
    Then the internal input buffer write at the current codeword write address should capture value X
    And no additional write to the input buffer should occur unless "CE" is reasserted

  @interface @protocol
  Formal Scenario: CE minimum spacing constraint holds between consecutive strobes
    Given "reset" is deasserted
    And "CE" is asserted at cycle T
    When "CE" is asserted again at cycle T plus some symbolic delay D
    Then D should be greater than or equal to 8 clock cycles

  @output @gating
  Formal Scenario: Top-level CEO is the logical AND of CEO_0 and Valid_out
    Given "reset" is deasserted
    And "CEO_0" holds a symbolic value C
    And "Valid_out" holds a symbolic value V
    When one clock edge occurs
    Then "CEO" should equal C AND V

  @output @sampling
  Formal Scenario: Out_byte is only meaningful when Valid_out is asserted
    Given "reset" is deasserted
    And "Valid_out" is 0 at the current cycle
    When downstream logic samples "Out_byte" in this cycle
    Then "Valid_out" being 0 implies no assertion is made on the value of "Out_byte"
    And "CEO" should equal 0 in this same cycle

  @fsm @stage1
  Formal Scenario: S_ready pulse transitions FSM from idle to Lambda-wait stage
    Given "reset" is deasserted
    And the FSM is in the state waiting for "S_ready" (state1)
    When "S_ready" is asserted for exactly one clock cycle
    Then on the next clock edge the FSM should transition to state2 (waiting for "L_ready")
    And "S_flag" should deassert no later than the cycle after "S_ready" is observed high

  @fsm @stage2
  Formal Scenario: L_ready pulse transitions FSM from Lambda-wait to root-search-wait stage
    Given "reset" is deasserted
    And the FSM is in state2 (waiting for "L_ready")
    When "L_ready" is asserted for exactly one clock cycle
    Then on the next clock edge the FSM should transition to state3 (waiting for "roots_ready")
    And "L_flag" should assert to enable "lamda_roots" and "Omega_Phy" operation

  @fsm @stage3
  Formal Scenario: roots_ready pulse transitions FSM from root-search-wait to correction-wait stage
    Given "reset" is deasserted
    And the FSM is in state3 (waiting for "roots_ready")
    When "roots_ready" is asserted for exactly one clock cycle
    Then on the next clock edge the FSM should transition to state4 (waiting for "DONE")
    And "R_flag" should assert to enable "error_correction" operation

  @fsm @stage4
  Formal Scenario: DONE pulse returns FSM to idle state for next codeword
    Given "reset" is deasserted
    And the FSM is in state4 (waiting for "DONE")
    When "DONE" is asserted for exactly one clock cycle
    Then on the next clock edge the FSM should return to the idle state (state1, waiting for "S_ready")
    And "R_flag" should deassert no later than the cycle after "DONE" is observed high

  @fsm @exclusivity
  Formal Scenario: Stage flags S_flag, L_flag, and R_flag are mutually exclusive
    Given "reset" is deasserted
    When the FSM is in any single defined state at any cycle
    Then at most one of "S_flag", "L_flag", "R_flag" should be asserted simultaneously

  @gf_arbitration @selector
  Formal Scenario: GF resource selector routes access exclusively to BM_lamda during S_flag
    Given "reset" is deasserted
    And "S_flag" is 1
    And "L_flag" is 0
    And "R_flag" is 0
    When a GF power/decimal ROM access occurs
    Then the address/data path should be steered to "BM_lamda"
    And neither "lamda_roots", "Omega_Phy", nor "error_correction" should receive the GF result in this cycle

  @gf_arbitration @selector
  Formal Scenario: GF resource selector routes shared access to lamda_roots and Omega_Phy during L_flag
    Given "reset" is deasserted
    And "S_flag" is 0
    And "L_flag" is 1
    And "R_flag" is 0
    When a GF power/decimal ROM access occurs
    Then the address/data path should be steered to "lamda_roots" and "Omega_Phy"
    And "BM_lamda" and "error_correction" should not receive the GF result in this cycle

  @gf_arbitration @selector
  Formal Scenario: GF resource selector routes exclusive access to error_correction during R_flag
    Given "reset" is deasserted
    And "S_flag" is 0
    And "L_flag" is 0
    And "R_flag" is 1
    When a GF power/decimal ROM access occurs
    Then the address/data path should be steered to "error_correction"
    And neither "BM_lamda", "lamda_roots", nor "Omega_Phy" should receive the GF result in this cycle

  @correction @write_qualification
  Formal Scenario: Correction write-enable is qualified to the payload address range
    Given "reset" is deasserted
    And "R_flag" is 1
    And "error_correction" produces address A and write-enable request W
    When the correction write cycle occurs
    Then the effective "WE" to output memory should be asserted only if W is 1 AND A is less than 188
    And no write should occur to output memory when A is greater than or equal to 188

  @correction @value_computation
  Formal Scenario: Corrected symbol equals original symbol XOR computed correction value
    Given "reset" is deasserted
    And "initial_value" read from output memory equals symbolic value M
    And the computed correction magnitude for the current address equals symbolic value E
    When "error_correction" produces "correction_value" for this address
    Then "correction_value" should equal M XOR E

  @correction @completion
  Formal Scenario: DONE is asserted as a single-cycle pulse upon correction pass completion
    Given "reset" is deasserted
    And "R_flag" is 1
    And the correction pass reaches its final candidate location
    When the correction pass completes
    Then "DONE" should be asserted for exactly one clock cycle
    And "DONE" should deassert on the following clock edge unless a new correction pass completes

  @transport @data_path
  Formal Scenario: Transport write path is sourced from input buffer during T_flag
    Given "reset" is deasserted
    And "T_flag" is 1
    And "Read_byte" from the input buffer equals symbolic value X
    When a transport write cycle to output memory occurs
    Then the output memory write data should equal X
    And the write data should not equal "correction_value" from "error_correction" during this cycle

  @transport @data_path
  Formal Scenario: Output memory write path switches to correction data after transport completes
    Given "reset" is deasserted
    And "T_flag" transitions from 1 to 0 due to "Wr_done"
    And "R_flag" is 1
    And "correction_value" equals symbolic value Y
    When an output memory write cycle occurs after transport completion
    Then the output memory write data should equal Y
    And the write data should not be sourced from "Read_byte" in this cycle

  @memory @bank_toggle
  Formal Scenario: Output memory bank selection toggles per completed codeword
    Given "reset" is deasserted
    And the active output-memory bank for codeword N is symbolic value B
    When codeword N completes and transport for codeword N+1 begins
    Then the active output-memory bank for codeword N+1 should equal the logical complement of B

  @output @cadence
  Formal Scenario: Output stage emits one valid byte every 8 clock cycles during active streaming
    Given "reset" is deasserted
    And "out_flag" is 1
    And "Valid_out" was asserted at cycle T
    When the next "Valid_out" assertion occurs at cycle T plus symbolic interval D
    Then D should equal 8 clock cycles

  @output @address_range
  Formal Scenario: Output streaming covers exactly the payload address range 0 to 187
    Given "reset" is deasserted
    And "out_flag" is 1
    And the output read address at the start of streaming equals 0
    When "out_stage" streams sequential addresses while "Valid_out" is asserted
    Then the last address emitted before "out_done" asserts should equal 187
    And no address greater than 187 should be emitted with "Valid_out" asserted

  @output @completion
  Formal Scenario: out_done asserts exactly once per completed 188-byte output stream
    Given "reset" is deasserted
    And "out_flag" is 1
    And the output address counter reaches value 187 with "Valid_out" asserted
    When one clock edge occurs after this final valid output
    Then "out_done" should be asserted for exactly one clock cycle
    And "out_flag" should deassert no later than the cycle following "out_done"

  @overlap @done_ext
  Formal Scenario: DONE_ext preserves output-start intent when correction completes before prior output finishes
    Given "reset" is deasserted
    And "DONE" is asserted while "out_done" for the previous codeword has not yet asserted
    When "out_stage" is still actively streaming the previous codeword's payload
    Then "DONE_ext" should be asserted and held until "out_stage" consumes the pending completion
    And there should exist a future cycle within a bounded window where "out_flag" equals 1 AND "Address" equals 0, triggered by the "DONE" event, equivalent to the property "DONE |-> ##[1:$] (out_flag && Address==0)"

  @overlap @start_condition
  Formal Scenario: Output stage starts on either DONE or DONE_ext
    Given "reset" is deasserted
    And "out_flag" is 0
    And either "DONE" is asserted or "DONE_ext" is asserted
    When the next clock edge occurs
    Then "out_flag" should transition to 1
    And output streaming should begin from payload address 0

  @erasure @tie_off
  Formal Scenario: Errors-only decoding is enforced by tying erasure inputs to zero
    Given "reset" is deasserted
    When "BM_lamda" operates during any decode transaction
    Then "erasure_cnt" presented to "BM_lamda" should equal 0
    And "erasure_ready" presented to "BM_lamda" should equal 0

  @pulse_integrity @S_ready
  Formal Scenario: S_ready is asserted for exactly one clock cycle per syndrome completion
    Given "reset" is deasserted
    And syndrome computation for a codeword completes at cycle T
    When "S_ready" is observed asserted at cycle T
    Then "S_ready" should be deasserted at cycle T+1
    And "S_ready" should not reassert until the next codeword's syndrome computation completes

  @pulse_integrity @L_ready
  Formal Scenario: L_ready is asserted for exactly one clock cycle per Lambda completion
    Given "reset" is deasserted
    And Lambda coefficient computation completes at cycle T
    When "L_ready" is observed asserted at cycle T
    Then "L_ready" should be deasserted at cycle T+1
    And "L_ready" should not reassert until the next codeword's Lambda computation completes

  @pulse_integrity @roots_and_poly
  Formal Scenario: roots_ready and poly_ready are single-cycle pulses that may occur independently
    Given "reset" is deasserted
    And "L_flag" is 1
    When "lamda_roots" completes its search and "Omega_Phy" completes its computation
    Then "roots_ready" should be asserted for exactly one clock cycle at its completion time
    And "poly_ready" should be asserted for exactly one clock cycle at its completion time
    And the two pulses may occur on different cycles relative to each other

  @capability @root_bound
  Formal Scenario: Root count never exceeds the decoder's error-correction capability
    Given "reset" is deasserted
    And "roots_ready" is asserted with "root_cnt" equal to symbolic value R
    When the Lambda polynomial degree corresponds to at most 8 errors
    Then R should be less than or equal to 8

  @capability @correction_bound
  Formal Scenario: Number of correction writes per codeword does not exceed root_cnt
    Given "reset" is deasserted
    And "root_cnt" for the current decode equals symbolic value R
    When "error_correction" completes its pass and asserts "DONE"
    Then the number of qualified write-enable pulses issued during this pass should be less than or equal to R