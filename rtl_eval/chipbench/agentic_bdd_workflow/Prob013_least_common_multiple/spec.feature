Feature: Sequential LCM and GCD Calculator

  As a hardware designer
  I want to verify a sequential module that computes the LCM and GCD of two unsigned numbers
  So that the mathematical correctness and handshake behavior can be formally proven

  Background:
    Given a synchronous design with clock "clk" and active-low reset "rst_n"
    And all sequential logic updates on the rising edge of "clk"
    And input "A" is an 8-bit unsigned value
    And input "B" is an 8-bit unsigned value
    And output "lcm_out" is a 16-bit unsigned value
    And output "mcd_out" is an 8-bit unsigned value
    And output "vld_out" is a single-bit valid indicator
    And a symbolic upper bound N_MAX_CYCLES exists such that any valid computation completes within N_MAX_CYCLES clock edges

  @reset
  Formal Scenario: Reset deasserts output valid
    Given rst_n is deasserted (0)
    When one clock edge occurs
    Then vld_out should be 0

  @reset
  Formal Scenario: Reset holds output valid low while asserted
    Given rst_n is held at 0 for any number of consecutive cycles
    When each clock edge occurs
    Then vld_out should remain 0

  @handshake
  Formal Scenario: No new computation starts without a valid input request
    Given rst_n is asserted (1)
    And vld_in is 0 for the current cycle
    When one clock edge occurs
    Then vld_out should not change from its previous value this cycle
    And mcd_out should not change from its previous value this cycle
    And lcm_out should not change from its previous value this cycle

  @handshake
  Formal Scenario: Valid input eventually produces a valid output
    Given rst_n is asserted (1)
    And vld_in is asserted (1) with operand A and operand B on this cycle
    When at most N_MAX_CYCLES subsequent clock edges occur
    Then vld_out should become asserted (1) within N_MAX_CYCLES cycles of this request

  @correctness
  Formal Scenario: GCD divides operand A
    Given rst_n is asserted (1)
    And operand A and operand B are provided with vld_in asserted (1)
    When vld_out becomes asserted (1) after processing
    Then A modulo mcd_out should be 0

  @correctness
  Formal Scenario: GCD divides operand B
    Given rst_n is asserted (1)
    And operand A and operand B are provided with vld_in asserted (1)
    When vld_out becomes asserted (1) after processing
    Then B modulo mcd_out should be 0

  @correctness
  Formal Scenario: LCM is a multiple of operand A
    Given rst_n is asserted (1)
    And operand A and operand B are provided with vld_in asserted (1)
    When vld_out becomes asserted (1) after processing
    Then lcm_out modulo A should be 0

  @correctness
  Formal Scenario: LCM is a multiple of operand B
    Given rst_n is asserted (1)
    And operand A and operand B are provided with vld_in asserted (1)
    When vld_out becomes asserted (1) after processing
    Then lcm_out modulo B should be 0

  @correctness
  Formal Scenario: Product relationship between GCD and LCM
    Given rst_n is asserted (1)
    And operand A and operand B are provided with vld_in asserted (1)
    And operand A is nonzero
    And operand B is nonzero
    When vld_out becomes asserted (1) after processing
    Then mcd_out multiplied by lcm_out should equal A multiplied by B

  @edge_case
  Formal Scenario: GCD and LCM when operand A equals zero
    Given rst_n is asserted (1)
    And operand A is 0
    And operand B is provided with vld_in asserted (1)
    When vld_out becomes asserted (1) after processing
    Then mcd_out should equal B
    And lcm_out should equal 0

  @edge_case
  Formal Scenario: GCD and LCM when operand B equals zero
    Given rst_n is asserted (1)
    And operand B is 0
    And operand A is provided with vld_in asserted (1)
    When vld_out becomes asserted (1) after processing
    Then mcd_out should equal A
    And lcm_out should equal 0

  @edge_case
  Formal Scenario: GCD and LCM when both operands equal zero
    Given rst_n is asserted (1)
    And operand A is 0
    And operand B is 0
    And vld_in is asserted (1)
    When vld_out becomes asserted (1) after processing
    Then mcd_out should equal 0
    And lcm_out should equal 0

  @edge_case
  Formal Scenario: GCD and LCM when operand A equals operand B
    Given rst_n is asserted (1)
    And operand A equals operand B
    And vld_in is asserted (1)
    When vld_out becomes asserted (1) after processing
    Then mcd_out should equal A
    And lcm_out should equal A

  @stability
  Formal Scenario: Output remains stable while valid until next request is accepted
    Given rst_n is asserted (1)
    And vld_out is asserted (1) with mcd_out equal to value G and lcm_out equal to value L
    And vld_in is 0 for the current cycle
    When one clock edge occurs
    Then mcd_out should remain equal to G
    And lcm_out should remain equal to L
    And vld_out should remain asserted (1)

  @liveness
  Formal Scenario: A new valid input eventually clears the previous output validity and produces a new result
    Given rst_n is asserted (1)
    And vld_out is asserted (1) from a prior computation
    And vld_in is asserted (1) with new operand A and new operand B
    When at most N_MAX_CYCLES subsequent clock edges occur
    Then vld_out should become asserted (1) again within N_MAX_CYCLES cycles of this new request
    And mcd_out should divide both the new operand A and the new operand B
    And lcm_out should be a multiple of both the new operand A and the new operand B