Feature: AES Core Encryption Pipeline Verification
  As a hardware verification engineer
  I want to formally verify the AES-128/192/256 encryption cores
  So that pipeline timing, latency, and encryption correctness are guaranteed

  Background:
    Given the design is synchronous to the rising edge of clk
    And all input signals are sampled at the rising edge of clk
    And all output signals are driven by flip-flops and not combinationally derived from inputs
    And the core is a pipelined architecture accepting a new state and key every clock cycle
    And LATENCY_128 is defined as the constant 21
    And LATENCY_192 is defined as the constant 25
    And LATENCY_256 is defined as the constant 29
    And RESET_VALUE is defined as the constant 0

  @latency @aes128
  Formal Scenario: AES-128 core produces correct ciphertext after LATENCY_128 clock cycles
    Given the AES-128 core has state input value P at cycle T
    And the AES-128 core has key input value K at cycle T
    When LATENCY_128 clock cycles have elapsed since cycle T
    Then the out signal at cycle T+LATENCY_128 should equal AES128_Encrypt(P, K)

  @latency @aes192
  Formal Scenario: AES-192 core produces correct ciphertext after LATENCY_192 clock cycles
    Given the AES-192 core has state input value P at cycle T
    And the AES-192 core has key input value K at cycle T
    When LATENCY_192 clock cycles have elapsed since cycle T
    Then the out signal at cycle T+LATENCY_192 should equal AES192_Encrypt(P, K)

  @latency @aes256
  Formal Scenario: AES-256 core produces correct ciphertext after LATENCY_256 clock cycles
    Given the AES-256 core has state input value P at cycle T
    And the AES-256 core has key input value K at cycle T
    When LATENCY_256 clock cycles have elapsed since cycle T
    Then the out signal at cycle T+LATENCY_256 should equal AES256_Encrypt(P, K)

  @pipeline @throughput
  Formal Scenario: Pipeline accepts a new state/key pair every clock cycle
    Given the AES core variant under test is one of AES-128, AES-192, or AES-256
    And LATENCY_VARIANT equals LATENCY_128 for AES-128, LATENCY_192 for AES-192, or LATENCY_256 for AES-256, matching the variant under test
    And the AES core is in a valid pipeline-filled condition
    And state input value P1 and key input value K1 are applied at cycle T
    And state input value P2 and key input value K2 are applied at cycle T+1
    When the pipeline processes both inputs without stalling
    Then the out signal corresponding to P1,K1 should appear exactly LATENCY_VARIANT cycles after T
    And the out signal corresponding to P2,K2 should appear exactly LATENCY_VARIANT cycles after T+1
    And no cycle between them should be skipped or duplicated

  @output_stability
  Formal Scenario: Output signal remains stable between valid updates
    Given the out signal has value V at cycle T
    And no new valid ciphertext is scheduled to appear at cycle T+1
    When cycle T+1 occurs
    Then the out signal at cycle T+1 should equal V

  @non_combinational
  Formal Scenario: Output is never combinationally dependent on same-cycle inputs
    Given the AES core variant under test is one of AES-128, AES-192, or AES-256
    And LATENCY_VARIANT equals LATENCY_128 for AES-128, LATENCY_192 for AES-192, or LATENCY_256 for AES-256, matching the variant under test
    And the state input changes to a new symbolic value P_new at cycle T
    And the key input changes to a new symbolic value K_new at cycle T
    When cycle T is evaluated
    Then the out signal at cycle T should not depend on P_new or K_new
    And the out signal at cycle T should equal the value determined by inputs applied LATENCY_VARIANT cycles earlier

  @independence @aes128
  Formal Scenario: Successive independent state/key pairs produce independent correct outputs
    Given state value Pa and key value Ka are applied at cycle Ta
    And state value Pb and key value Kb are applied at cycle Tb where Tb is not equal to Ta
    When LATENCY_128 clock cycles have elapsed since Ta and since Tb respectively
    Then the out signal at cycle Ta+LATENCY_128 should equal AES128_Encrypt(Pa, Ka)
    And the out signal at cycle Tb+LATENCY_128 should equal AES128_Encrypt(Pb, Kb)

  @reset
  Formal Scenario: Reset forces the pipeline to a known initial state
    Given the AES core variant under test is one of AES-128, AES-192, or AES-256
    And LATENCY_VARIANT equals LATENCY_128 for AES-128, LATENCY_192 for AES-192, or LATENCY_256 for AES-256, matching the variant under test
    And the reset signal is asserted at cycle T
    When cycle T+1 occurs
    Then all internal pipeline registers should hold the value RESET_VALUE
    And the out signal should hold the value RESET_VALUE
    And the out signal should not be considered valid until LATENCY_VARIANT cycles after reset deassertion and a new state/key pair is applied

  @ctr_mode @encrypt
  Formal Scenario: CTR mode encryption produces ciphertext via XOR with keystream
    Given the state input is set to a counter value C at cycle T
    And the key input is set to fixed key value K
    And an external symbolic plaintext value PT is supplied outside the core, independent of core signals
    When LATENCY_128 clock cycles have elapsed since cycle T for AES-128
    Then the out signal at cycle T+LATENCY_128 should equal AES128_Encrypt(C, K)
    And the externally computed ciphertext CT should equal PT XOR the out signal at cycle T+LATENCY_128

  @ctr_mode @decrypt
  Formal Scenario: CTR mode decryption recovers plaintext via XOR with same keystream
    Given the state input is set to the same counter value C at cycle T as used during encryption
    And the key input is set to the same fixed key value K as used during encryption
    And an external symbolic ciphertext value CT is supplied outside the core, independent of core signals
    When LATENCY_128 clock cycles have elapsed since cycle T for AES-128
    Then the out signal at cycle T+LATENCY_128 should equal AES128_Encrypt(C, K)
    And the externally recovered plaintext PT should equal CT XOR the out signal at cycle T+LATENCY_128

  @key_width @aes128 @static_check
  Formal Scenario: AES-128 core key input width is statically 128 bits
    Given this is an elaboration-time structural check, not a temporal SVA property
    And the AES-128 core key input signal K is declared with a fixed bit width
    Then the declared width of K should equal 128 bits at elaboration time

  @key_width @aes192 @static_check
  Formal Scenario: AES-192 core key input width is statically 192 bits
    Given this is an elaboration-time structural check, not a temporal SVA property
    And the AES-192 core key input signal K is declared with a fixed bit width
    Then the declared width of K should equal 192 bits at elaboration time

  @key_width @aes256 @static_check
  Formal Scenario: AES-256 core key input width is statically 256 bits
    Given this is an elaboration-time structural check, not a temporal SVA property
    And the AES-256 core key input signal K is declared with a fixed bit width
    Then the declared width of K should equal 256 bits at elaboration time

  @state_width @static_check
  Formal Scenario: State and output widths are statically 128 bits regardless of key size
    Given this is an elaboration-time structural check, not a temporal SVA property
    And any AES core variant among AES-128, AES-192, AES-256 is declared with fixed bit widths
    Then the declared width of the state input signal should equal 128 bits at elaboration time
    And the declared width of the out output signal should equal 128 bits at elaboration time

  @deterministic
  Formal Scenario: Encryption result depends only on state and key value, not on cycle number
    Given the AES core variant under test is one of AES-128, AES-192, or AES-256
    And LATENCY_VARIANT equals LATENCY_128 for AES-128, LATENCY_192 for AES-192, or LATENCY_256 for AES-256, matching the variant under test
    And state value P and key value K are applied at cycle Ta
    And the identical state value P and identical key value K are applied at a different cycle Tb
    When LATENCY_VARIANT clock cycles have elapsed since each respective application
    Then the out signal produced from cycle Ta should equal the out signal produced from cycle Tb