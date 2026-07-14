Feature: Gaussian Noise Generator (gng) Formal Specification
  Formal verification of the gng core, comprising the gng_ctg Tausworthe
  uniform generator and the gng_interp ICDF interpolation datapath, including
  reset behavior, enable-controlled state advancement, pipeline latency,
  and output data formatting.

  Background:
    Given the design is synchronous to the rising edge of clk
    And rstn is a synchronous active-low reset
    And INIT_Z1, INIT_Z2, INIT_Z3 are parameterized 64-bit seed values
    And ce is the clock enable controlling CTG state advancement
    And valid_out and data_out are registered outputs of the composed pipeline

  # -----------------------------------------------------------------
  # Reset behavior
  # -----------------------------------------------------------------

  @reset @ctg
  Formal Scenario: Reset loads CTG state registers with parameterized seeds
    Given rstn is deasserted (rstn = 0)
    When a rising clock edge occurs
    Then z1 should equal INIT_Z1
    And z2 should equal INIT_Z2
    And z3 should equal INIT_Z3

  @reset @valid
  Formal Scenario: Reset clears all valid signals in the pipeline
    Given rstn is deasserted (rstn = 0)
    When a rising clock edge occurs
    Then valid_out_ctg should be 0
    And valid_out should be 0

  @reset @data
  Formal Scenario: Reset clears output data registers
    Given rstn is deasserted (rstn = 0)
    When a rising clock edge occurs
    Then data_out should equal 0

  @reset @recovery
  Formal Scenario: valid_out deasserts immediately when reset is applied mid-stream
    Given valid_out holds value V1 at cycle T due to prior ce activity
    And rstn is deasserted (rstn = 0) at cycle T
    When a rising clock edge occurs
    Then valid_out at cycle T+1 should be 0

  # -----------------------------------------------------------------
  # CTG state advancement
  # -----------------------------------------------------------------

  @ctg @state_hold
  Formal Scenario: CTG state registers hold their value when ce is deasserted
    Given rstn is asserted (rstn = 1)
    And z1 has value Z1, z2 has value Z2, z3 has value Z3 at cycle T
    And ce is 0 at cycle T
    When a rising clock edge occurs
    Then z1 at cycle T+1 should equal Z1
    And z2 at cycle T+1 should equal Z2
    And z3 at cycle T+1 should equal Z3

  @ctg @state_update
  Formal Scenario: CTG state registers advance per branch recurrence when ce is asserted
    Given rstn is asserted (rstn = 1)
    And z1 has value Z1, z2 has value Z2, z3 has value Z3 at cycle T
    And ce is 1 at cycle T
    When a rising clock edge occurs
    Then z1 at cycle T+1 should equal the branch-1 Tausworthe next-state function of Z1
    And z2 at cycle T+1 should equal the branch-2 Tausworthe next-state function of Z2
    And z3 at cycle T+1 should equal the branch-3 Tausworthe next-state function of Z3

  @ctg @valid_register
  Formal Scenario: CTG valid output is a one-cycle registered copy of ce
    Given rstn is asserted (rstn = 1)
    And ce has value CE at cycle T
    When a rising clock edge occurs
    Then valid_out_ctg at cycle T+1 should equal CE

  @ctg @data_register
  Formal Scenario: CTG data output captures XOR of next-state branch values
    Given rstn is asserted (rstn = 1)
    And ce is 1 at cycle T
    And z1_next, z2_next, z3_next are the branch next-state values computed at cycle T
    When a rising clock edge occurs
    Then data_out_ctg at cycle T+1 should equal (z1_next XOR z2_next XOR z3_next)

  # -----------------------------------------------------------------
  # Top-level connectivity
  # -----------------------------------------------------------------

  @connectivity
  Formal Scenario: gng_interp inputs are directly driven by gng_ctg outputs
    Given rstn is asserted (rstn = 1)
    And gng_ctg produces valid_out_ctg with value V and data_out_ctg with value D at cycle T
    When a rising clock edge occurs
    Then gng_interp valid_in at cycle T should equal V
    And gng_interp data_in at cycle T should equal D

  # -----------------------------------------------------------------
  # Latency and pipeline timing
  # -----------------------------------------------------------------

  @latency
  Formal Scenario: Top-level valid_out asserts exactly 11 cycles after a single ce pulse
    Given rstn is asserted (rstn = 1)
    And ce is 1 at cycle T and 0 at all other cycles
    When 11 rising clock edges occur following cycle T
    Then valid_out should be 1 at cycle T+11

  @latency @idle
  Formal Scenario: valid_out remains deasserted when ce has never been asserted since reset
    Given rstn is asserted (rstn = 1)
    And ce is 0 at every cycle since reset release
    When any number of rising clock edges occur
    Then valid_out should be 0

  @throughput
  Formal Scenario: Continuous ce produces a valid_out sample every cycle after pipeline fill
    Given rstn is asserted (rstn = 1)
    And ce is held at 1 for at least 11 consecutive cycles ending at cycle T
    When a rising clock edge occurs at cycle T with ce = 1
    Then valid_out at cycle T should be 1
    And valid_out at cycle T+1 should be 1 provided ce remains 1 at cycle T

  @latency @deassert
  Formal Scenario: valid_out deasserts 11 cycles after ce is deasserted following a single pulse
    Given rstn is asserted (rstn = 1)
    And ce is 1 only at cycle T and 0 thereafter
    When 12 rising clock edges occur following cycle T
    Then valid_out at cycle T+12 should be 0

  # -----------------------------------------------------------------
  # Interpolation datapath
  # -----------------------------------------------------------------

  @interp @lzd
  Formal Scenario: Leading-zero detector output determines segment classification from data_in magnitude
    Given data_in has value D at cycle T with magnitude field M equal to D bits [63:3]
    When the interpolation datapath processes D
    Then num_lzd should equal the leading-zero count of M
    And addr should be a function of num_lzd and offset derived from D

  @interp @mask
  Formal Scenario: Masked interpolation variable x is derived from data_in and segment address
    Given data_in has value D at cycle T
    And addr is the segment address derived from D
    When the interpolation datapath forms the local interpolation variable
    Then x should equal the masked bit-field of D selected according to addr

  @interp @sign
  Formal Scenario: Output sign bit matches the delayed input sign bit
    Given data_in has sign bit S at cycle T
    And the interpolation pipeline latency is L cycles
    When L rising clock edges occur following cycle T
    Then the sign of data_out at cycle T+L should equal S

  @interp @polynomial
  Formal Scenario: Unrounded interpolation result equals the second-order polynomial evaluation
    Given coefficients C0, C1, C2 are selected via addr for data_in value D
    And x is the masked interpolation variable derived from D
    When the pipelined multiply-add datapath evaluates the polynomial for D
    Then the unrounded interpolation result should equal ((C2 * x + C1) * x + C0)

  @interp @rounding
  Formal Scenario: Final output is the rounded and sign-restored polynomial result
    Given the unrounded polynomial result is R for a given data_in value D with sign S
    When rounding and sign composition are applied
    Then data_out corresponding to D should equal the rounded value of R with sign S applied in two's-complement form

  # -----------------------------------------------------------------
  # Output data format
  # -----------------------------------------------------------------

  @format
  Formal Scenario: data_out is always a valid 16-bit signed value in s<16,11> format
    Given rstn is asserted (rstn = 1)
    When any rising clock edge occurs
    Then data_out should be interpretable as a signed 16-bit fixed-point value with 11 fractional bits

  # -----------------------------------------------------------------
  # Integration / streaming constraints
  # -----------------------------------------------------------------

  @backpressure
  Formal Scenario: valid_out assertion is independent of any downstream ready signal
    Given rstn is asserted (rstn = 1)
    And ce is held at 1 for at least 11 consecutive cycles ending at cycle T
    When a rising clock edge occurs at cycle T
    Then valid_out at cycle T should be determined solely by internal pipeline state and ce history, with no dependency on any external ready input

  @determinism
  Formal Scenario: CTG state evolution is a deterministic function of seed and ce history
    Given rstn is asserted (rstn = 1) at cycle 0 with z1, z2, z3 equal to INIT_Z1, INIT_Z2, INIT_Z3
    And a fixed sequence of ce values CE_0 .. CE_N is applied from cycle 0 to cycle N
    When N rising clock edges occur applying that sequence
    Then z1, z2, z3 at cycle N should equal the deterministic recurrence composition of INIT_Z1, INIT_Z2, INIT_Z3 under CE_0 .. CE_N