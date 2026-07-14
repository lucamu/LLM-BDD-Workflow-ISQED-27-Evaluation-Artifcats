# ── module: SignPrep ──
Feature: Signed Division Operand Preparation
  As a formal verification engineer
  I want to verify the combinational operand-preparation logic for the divider core
  So that dividend_o, divisor_o, quotient_sign_o, and remainder_sign_o are always correctly derived from opdata1_i, opdata2_i, and signed_div_i

  Background:
    Given the module is purely combinational with no internal state
    And the module has no clock and no reset dependency
    And opdata1_i is a 32-bit value representing operand A
    And opdata2_i is a 32-bit value representing operand B
    And signed_div_i is a 1-bit control signal
    And all outputs are evaluated as functions of the current inputs only

  @combinational @unsigned_mode
  Formal Scenario: Unsigned mode passes operands through unchanged
    Given signed_div_i is 0
    And opdata1_i is operand A
    And opdata2_i is operand B
    When the module computes its outputs
    Then dividend_o should equal operand A
    And divisor_o should equal operand B
    And quotient_sign_o should be 0
    And remainder_sign_o should be 0

  @combinational @signed_mode @both_positive
  Formal Scenario: Signed mode with both operands non-negative
    Given signed_div_i is 1
    And opdata1_i is operand A with bit 31 equal to 0
    And opdata2_i is operand B with bit 31 equal to 0
    When the module computes its outputs
    Then dividend_o should equal operand A
    And divisor_o should equal operand B
    And quotient_sign_o should be 0
    And remainder_sign_o should be 0

  @combinational @signed_mode @dividend_negative
  Formal Scenario: Signed mode with negative dividend and non-negative divisor
    Given signed_div_i is 1
    And opdata1_i is operand A with bit 31 equal to 1
    And opdata2_i is operand B with bit 31 equal to 0
    When the module computes its outputs
    Then dividend_o should equal the two's-complement negation of operand A
    And divisor_o should equal operand B
    And quotient_sign_o should be 1
    And remainder_sign_o should be 1

  @combinational @signed_mode @divisor_negative
  Formal Scenario: Signed mode with non-negative dividend and negative divisor
    Given signed_div_i is 1
    And opdata1_i is operand A with bit 31 equal to 0
    And opdata2_i is operand B with bit 31 equal to 1
    When the module computes its outputs
    Then dividend_o should equal operand A
    And divisor_o should equal the two's-complement negation of operand B
    And quotient_sign_o should be 1
    And remainder_sign_o should be 0

  @combinational @signed_mode @both_negative
  Formal Scenario: Signed mode with both operands negative
    Given signed_div_i is 1
    And opdata1_i is operand A with bit 31 equal to 1
    And opdata2_i is operand B with bit 31 equal to 1
    When the module computes its outputs
    Then dividend_o should equal the two's-complement negation of operand A
    And divisor_o should equal the two's-complement negation of operand B
    And quotient_sign_o should be 0
    And remainder_sign_o should be 1

  @combinational @signed_mode @quotient_sign_general
  Formal Scenario: Quotient sign equals XOR of dividend and divisor sign bits
    Given signed_div_i is 1
    And opdata1_i is operand A
    And opdata2_i is operand B
    When the module computes its outputs
    Then quotient_sign_o should equal bit 31 of operand A XOR bit 31 of operand B

  @combinational @signed_mode @remainder_sign_general
  Formal Scenario: Remainder sign equals dividend sign bit
    Given signed_div_i is 1
    And opdata1_i is operand A
    And opdata2_i is operand B
    When the module computes its outputs
    Then remainder_sign_o should equal bit 31 of operand A

  @combinational @signed_mode @magnitude_correctness
  Formal Scenario: Dividend magnitude equals absolute value of signed dividend
    Given signed_div_i is 1
    And opdata1_i is operand A
    And opdata2_i is operand B
    When the module computes its outputs
    Then dividend_o should equal operand A if bit 31 of operand A is 0
    And dividend_o should equal the two's-complement negation of operand A if bit 31 of operand A is 1

  @combinational @signed_mode @divisor_magnitude_correctness
  Formal Scenario: Divisor magnitude equals absolute value of signed divisor
    Given signed_div_i is 1
    And opdata1_i is operand A
    And opdata2_i is operand B
    When the module computes its outputs
    Then divisor_o should equal operand B if bit 31 of operand B is 0
    And divisor_o should equal the two's-complement negation of operand B if bit 31 of operand B is 1

  @combinational @edge_case @min_negative_dividend
  Formal Scenario: Signed mode with dividend equal to the minimum representable negative value
    Given signed_div_i is 1
    And opdata1_i is 32'h80000000
    And opdata2_i is operand B with bit 31 equal to 0
    When the module computes its outputs
    Then dividend_o should equal 32'h80000000
    And remainder_sign_o should be 1

  @combinational @edge_case @min_negative_divisor
  Formal Scenario: Signed mode with divisor equal to the minimum representable negative value
    Given signed_div_i is 1
    And opdata1_i is operand A with bit 31 equal to 0
    And opdata2_i is 32'h80000000
    When the module computes its outputs
    Then divisor_o should equal 32'h80000000
    And quotient_sign_o should be 1

  @combinational @sanity @unsigned_forces_flags_zero
  Formal Scenario: Sign flags are always forced to zero in unsigned mode regardless of operand values
    Given signed_div_i is 0
    And opdata1_i is operand A
    And opdata2_i is operand B
    When the module computes its outputs
    Then quotient_sign_o should be 0
    And remainder_sign_o should be 0
    And dividend_o should equal operand A
    And divisor_o should equal operand B

# ── module: DivCore ──
Feature: Sequential Unsigned 32-bit Shift-and-Subtract Divider

  As a hardware designer
  I want to formally verify a 32-cycle sequential unsigned divider
  So that latching, iterative computation, completion, and abort behavior are provably correct

  Background:
    Given a clock signal clk
    And a synchronous reset signal rst
    And an input start_i requesting a new division
    And a 32-bit input dividend_i
    And a 32-bit input divisor_i
    And an input annul_i that can abort an in-progress operation
    And an output ready_o indicating a valid result
    And a 32-bit output quotient_o
    And a 32-bit output remainder_o
    And an internal state register that holds IDLE or BUSY
    And an internal 64-bit shift register holding {partial_remainder, partial_quotient}
    And an internal 32-bit divisor register
    And an internal cycle counter counting iterations from 0 to 31
    And all state updates occur only on the rising edge of clk

  @reset
  Formal Scenario: Reset forces the module to idle with cleared outputs
    Given the state register holds any value
    And the internal shift register, divisor register, and cycle counter hold any values
    When rst is asserted at a clock edge
    Then on the next clock edge the state should be IDLE
    And ready_o should be 0
    And quotient_o should be 0
    And remainder_o should be 0

  @idle_no_start
  Formal Scenario: Core remains idle when no start request is present
    Given the state is IDLE
    And rst is 0
    And start_i is 0
    When a clock edge occurs
    Then the state should remain IDLE
    And ready_o should be 0

  @idle_latch_start
  Formal Scenario: Start request latches operands and enters BUSY state
    Given the state is IDLE
    And rst is 0
    And start_i is 1
    And dividend_i is value A
    And divisor_i is value B
    When a clock edge occurs
    Then the internal shift register should be latched to A in the lower 32 bits with the upper 32 bits equal to 0
    And the internal divisor register should be latched to B
    And the internal cycle counter should be reset to 0
    And the state should become BUSY

  @busy_iteration_subtract
  Formal Scenario: Busy iteration subtracts divisor when partial remainder is sufficient
    Given the state is BUSY
    And rst is 0
    And annul_i is 0
    And the cycle counter is less than 31
    And the internal shift register holds value R before the clock edge
    And the internal divisor register holds value D
    And the upper 32 bits of (R shifted left by one bit) are greater than or equal to D
    When a clock edge occurs
    Then the upper 32 bits of the new shift register should equal the upper 32 bits of (R shifted left by one bit) minus D
    And the least significant bit of the new shift register should be 1
    And the cycle counter should increment by 1
    And the state should remain BUSY

  @busy_iteration_no_subtract
  Formal Scenario: Busy iteration skips subtraction when partial remainder is insufficient
    Given the state is BUSY
    And rst is 0
    And annul_i is 0
    And the cycle counter is less than 31
    And the internal shift register holds value R before the clock edge
    And the internal divisor register holds value D
    And the upper 32 bits of (R shifted left by one bit) are less than D
    When a clock edge occurs
    Then the upper 32 bits of the new shift register should equal the upper 32 bits of (R shifted left by one bit)
    And the least significant bit of the new shift register should be 0
    And the cycle counter should increment by 1
    And the state should remain BUSY

  @completion
  Formal Scenario: Division completes after the 32nd iteration and asserts ready
    Given the state is BUSY
    And rst is 0
    And annul_i is 0
    And the cycle counter equals 31
    And the internal shift register holds final value R_final before the clock edge
    When a clock edge occurs
    Then ready_o should be 1
    And quotient_o should equal the lower 32 bits of R_final
    And remainder_o should equal the upper 32 bits of R_final

  @ready_single_cycle
  Formal Scenario: Ready output remains asserted for exactly one cycle
    Given ready_o is 1 in the current cycle
    And rst is 0
    When a clock edge occurs
    Then ready_o should be 0
    And the state should be IDLE

  @annul_abort_busy
  Formal Scenario: Annul immediately aborts an in-progress operation
    Given the state is BUSY
    And rst is 0
    And annul_i is 1
    When a clock edge occurs
    Then the state should become IDLE
    And ready_o should be 0

  @annul_idle_noop
  Formal Scenario: Annul has no effect while the core is idle
    Given the state is IDLE
    And rst is 0
    And annul_i is 1
    And start_i is 0
    When a clock edge occurs
    Then the state should remain IDLE
    And ready_o should be 0

  @start_ignored_while_busy
  Formal Scenario: Start requests have no effect while the core is busy
    Given the state is BUSY
    And rst is 0
    And annul_i is 0
    And start_i is 1
    And the internal divisor register holds value D before the clock edge
    When a clock edge occurs
    Then the internal divisor register should remain equal to D
    And the state should remain BUSY

  @cycle_counter_reset_on_start
  Formal Scenario: Cycle counter resets whenever a new operation is started
    Given the state is IDLE
    And rst is 0
    And start_i is 1
    And the cycle counter holds any prior value
    When a clock edge occurs
    Then the cycle counter should equal 0

  @end_to_end_division_correctness
  Formal Scenario: Completed division satisfies the arithmetic division identity
    Given the state is IDLE
    And rst is 0
    And start_i is 1
    And dividend_i is value A
    And divisor_i is value B
    And B is not equal to 0
    When 32 consecutive clock edges occur with annul_i held at 0 throughout
    Then ready_o should be 1 after the 32nd clock edge
    And quotient_o should equal A divided by B using integer division
    And remainder_o should equal A modulo B
    And quotient_o multiplied by B plus remainder_o should equal A
    And remainder_o should be less than B

  @annul_mid_sequence_no_result
  Formal Scenario: Annul during a multi-cycle operation prevents any result from being produced
    Given the state is IDLE
    And rst is 0
    And start_i is 1
    And dividend_i is value A
    And divisor_i is value B
    When one clock edge occurs to enter BUSY
    And annul_i is asserted on a subsequent clock edge before the cycle counter reaches 31
    Then the state should become IDLE immediately on that edge
    And ready_o should be 0
    And no further shift-and-subtract iterations should occur for this operation

# ── module: ResultCorrection ──
Feature: Sign Correction of Divider Quotient and Remainder

  This module is purely combinational (no clock, no reset, no internal
  state). It corrects the raw unsigned quotient and remainder produced by
  DivCore according to the sign flags computed by SignPrep. All properties
  below hold for every combination of inputs on every evaluation cycle,
  independent of any clock edge.

  Background:
    Given the module is purely combinational with no internal state
    And quotient_i is an unsigned value representing the raw quotient magnitude
    And remainder_i is an unsigned value representing the raw remainder magnitude
    And signed_div_i is a 1-bit control flag indicating signed division mode
    And quotient_sign_i is a 1-bit flag indicating the quotient should be negated
    And remainder_sign_i is a 1-bit flag indicating the remainder should be negated
    And quotient_o and remainder_o are combinationally derived from these inputs with no delay

  @combinational @unsigned_passthrough
  Formal Scenario: Unsigned mode passes quotient and remainder through unchanged
    Given signed_div_i is 0
    And quotient_i is value Q
    And remainder_i is value R
    And quotient_sign_i is any value
    And remainder_sign_i is any value
    When the sign correction logic is evaluated
    Then quotient_o should equal Q
    And remainder_o should equal R

  @combinational @signed_quotient_passthrough
  Formal Scenario: Signed mode with quotient_sign_i deasserted passes quotient through unchanged
    Given signed_div_i is 1
    And quotient_i is value Q
    And quotient_sign_i is 0
    When the sign correction logic is evaluated
    Then quotient_o should equal Q

  @combinational @signed_quotient_negation
  Formal Scenario: Signed mode with quotient_sign_i asserted negates the quotient
    Given signed_div_i is 1
    And quotient_i is value Q
    And quotient_sign_i is 1
    When the sign correction logic is evaluated
    Then quotient_o should equal the two's complement negation of Q
    And quotient_o should equal (bitwise NOT of Q) + 1

  @combinational @signed_remainder_passthrough
  Formal Scenario: Signed mode with remainder_sign_i deasserted passes remainder through unchanged
    Given signed_div_i is 1
    And remainder_i is value R
    And remainder_sign_i is 0
    When the sign correction logic is evaluated
    Then remainder_o should equal R

  @combinational @signed_remainder_negation
  Formal Scenario: Signed mode with remainder_sign_i asserted negates the remainder
    Given signed_div_i is 1
    And remainder_i is value R
    And remainder_sign_i is 1
    When the sign correction logic is evaluated
    Then remainder_o should equal the two's complement negation of R
    And remainder_o should equal (bitwise NOT of R) + 1

  @combinational @independence
  Formal Scenario: Quotient and remainder sign corrections are independent of each other
    Given signed_div_i is 1
    And quotient_i is value Q
    And remainder_i is value R
    And quotient_sign_i is value Sq
    And remainder_sign_i is value Sr
    When the sign correction logic is evaluated
    Then quotient_o should equal (Sq == 1) ? (two's complement negation of Q) : Q
    And remainder_o should equal (Sr == 1) ? (two's complement negation of R) : R

  @combinational @zero_invariance
  Formal Scenario: Negation of a zero value leaves it unchanged
    Given signed_div_i is 1
    And quotient_i is 0
    And quotient_sign_i is 1
    When the sign correction logic is evaluated
    Then quotient_o should equal 0

  @combinational @zero_invariance_remainder
  Formal Scenario: Negation of a zero remainder leaves it unchanged
    Given signed_div_i is 1
    And remainder_i is 0
    And remainder_sign_i is 1
    When the sign correction logic is evaluated
    Then remainder_o should equal 0

  @combinational @no_state
  Formal Scenario: Outputs depend only on current inputs with no memory across evaluations
    Given quotient_i is value Q1 and remainder_i is value R1 with signed_div_i, quotient_sign_i, remainder_sign_i set to some values at time T1
    And the same inputs are later changed to quotient_i value Q2 and remainder_i value R2 with possibly different sign flags at time T2
    When the sign correction logic is evaluated at time T2
    Then quotient_o and remainder_o should depend only on the inputs present at time T2
    And should be unaffected by the values present at time T1

# ── module: TopModule ──
Feature: TopModule - Hardware Division Unit with Signed/Unsigned Support and Annulment

  As a hardware verification engineer
  I want to formally verify the division unit
  So that quotient/remainder computation, control handshaking, and cancellation behave correctly

  Background:
    Given the design under test is TopModule
    And clk is the free-running clock
    And rst is an active-high synchronous reset
    And all registers update only on the rising edge of clk
    And signed_div_i, opdata1_i, opdata2_i, start_i, and annul_i are module inputs
    And result_o and ready_o are module outputs
    And the module contains an internal state register named state_r
    And state_r equals STATE_IDLE when the module is idle and awaiting start_i
    And state_r equals STATE_BUSY when the module is executing the shift-subtract division algorithm
    And state_r transitions from STATE_BUSY to STATE_IDLE in the same cycle that ready_o is asserted, unless annul_i or rst forces an earlier transition to STATE_IDLE
    And the module contains an internal cycle counter named cnt_r that increments by 1 on every clock edge while state_r equals STATE_BUSY
    And cnt_r is loaded to 0 in the cycle that start_i captures new operands and state_r transitions from STATE_IDLE to STATE_BUSY
    And the division algorithm has a fixed, bounded latency of N clock cycles, where N = 32 corresponding to the 32-bit operand width
    And ready_o deterministically asserts exactly N cycles after state_r enters STATE_BUSY, provided neither annul_i nor rst intervenes during that interval
    And "the module is currently performing a division calculation" means state_r equals STATE_BUSY
    And "the module is in its idle state" means state_r equals STATE_IDLE
    And "the duration of the operation" denotes the closed interval of cycles from the cycle after start_i is asserted, in which state_r first equals STATE_BUSY and cnt_r equals 0, through the cycle in which cnt_r equals N-1 and ready_o asserts, or through the earlier cycle in which annul_i or rst forces state_r back to STATE_IDLE

  @reset @safety
  Formal Scenario: Reset forces the module to an idle, not-ready state
    Given rst is asserted
    When a rising clock edge occurs
    Then ready_o should be 0
    And state_r should equal STATE_IDLE

  @reset @safety
  Formal Scenario: Reset overrides an in-progress calculation
    Given rst is deasserted
    And state_r equals STATE_BUSY
    When rst is asserted
    And a rising clock edge occurs
    Then ready_o should be 0
    And state_r should equal STATE_IDLE
    And the previous calculation should be discarded

  @idle @safety
  Formal Scenario: No calculation begins while start_i is deasserted
    Given rst is deasserted
    And state_r equals STATE_IDLE
    And start_i is 0
    When a rising clock edge occurs
    Then ready_o should remain 0
    And state_r should remain STATE_IDLE

  @start @safety
  Formal Scenario: Asserting start_i captures the operands and begins calculation
    Given rst is deasserted
    And state_r equals STATE_IDLE
    And opdata1_i is dividend D
    And opdata2_i is divisor V
    And signed_div_i is mode S
    And annul_i is 0
    And start_i is 1
    When a rising clock edge occurs
    Then state_r should equal STATE_BUSY
    And cnt_r should equal 0
    And ready_o should be 0
    And the operands latched for the calculation should equal D and V

  @start @safety
  Formal Scenario: start_i is ignored while a calculation is already in progress
    Given rst is deasserted
    And state_r equals STATE_BUSY
    And cnt_r is some value C where C is less than N-1
    And start_i is 1
    And opdata1_i and opdata2_i present new operands D2 and V2 different from the operands latched at the start of the current calculation
    When a rising clock edge occurs
    Then state_r should remain STATE_BUSY
    And cnt_r should equal C+1
    And the operands latched for the current calculation should remain unchanged
    And the new operands D2 and V2 should have no effect on the in-progress calculation

  @correctness @unsigned
  Formal Scenario: Unsigned division produces a correct quotient and remainder
    Given rst is deasserted
    And signed_div_i is 0
    And opdata1_i is dividend D
    And opdata2_i is divisor V where V is not equal to 0
    And start_i is pulsed for one cycle to begin the operation with operands D and V
    And annul_i remains 0 throughout every cycle for which state_r equals STATE_BUSY during this operation
    When the module subsequently asserts ready_o
    Then result_o bits 31 downto 0 should equal Q where Q = D divided by V using unsigned integer division
    And result_o bits 63 downto 32 should equal R where R = D modulo V using unsigned integer remainder
    And D should equal Q multiplied by V plus R
    And R should be less than V

  @correctness @signed
  Formal Scenario: Signed division produces a correctly signed quotient and remainder
    Given rst is deasserted
    And signed_div_i is 1
    And opdata1_i is dividend D interpreted as a signed 32-bit two's complement value
    And opdata2_i is divisor V interpreted as a signed 32-bit two's complement value where V is not equal to 0
    And start_i is pulsed for one cycle to begin the operation with operands D and V
    And annul_i remains 0 throughout every cycle for which state_r equals STATE_BUSY during this operation
    When the module subsequently asserts ready_o
    Then result_o bits 31 downto 0 should equal Q where Q = truncated signed division of D by V
    And result_o bits 63 downto 32 should equal R where R = D minus Q multiplied by V
    And R should equal 0 or have the same sign as D
    And the absolute value of R should be less than the absolute value of V

  @correctness @signed
  Formal Scenario: Sign of the quotient follows the sign rule of the operands
    Given rst is deasserted
    And signed_div_i is 1
    And opdata1_i is dividend D interpreted as a signed 32-bit two's complement value
    And opdata2_i is divisor V interpreted as a signed 32-bit two's complement value where V is not equal to 0
    And start_i is pulsed for one cycle to begin the operation with operands D and V
    And annul_i remains 0 throughout every cycle for which state_r equals STATE_BUSY during this operation
    When the module subsequently asserts ready_o
    Then the quotient Q in result_o bits 31 downto 0 should be negative if and only if exactly one of D and V is negative
    And Q should be non-negative if D and V have the same sign or Q equals 0

  @timing @liveness
  Formal Scenario: Division completes within a fixed, bounded latency of N cycles
    Given rst is deasserted
    And state_r equals STATE_IDLE
    And start_i is pulsed for one cycle to begin the operation with operands D and V where V is not equal to 0
    And annul_i remains 0 throughout every cycle for which state_r equals STATE_BUSY during this operation
    Then state_r should equal STATE_BUSY for exactly N consecutive cycles beginning the cycle after start_i is asserted
    And cnt_r should increment by exactly 1 each cycle while state_r equals STATE_BUSY, reaching N-1 in the final busy cycle
    And ready_o should assert exactly once, in the cycle immediately following the cycle where cnt_r equals N-1
    And state_r should return to STATE_IDLE in the cycle after ready_o asserts

  @handshake @safety
  Formal Scenario: ready_o is asserted for exactly one cycle upon completion
    Given rst is deasserted
    And ready_o is 1 in the current cycle
    And start_i is 0
    When a rising clock edge occurs
    Then ready_o should deassert to 0
    And state_r should equal STATE_IDLE

  @annul @safety
  Formal Scenario: Asserting annul_i terminates an in-progress calculation
    Given rst is deasserted
    And state_r equals STATE_BUSY
    And annul_i is asserted
    When a rising clock edge occurs
    Then state_r should equal STATE_IDLE
    And cnt_r should reset to 0
    And ready_o should not assert as a result of the annulled operation
    And the calculation in progress should be terminated

  @annul @boundary @safety
  Formal Scenario: Asserting annul_i on the final busy cycle still suppresses ready_o
    Given rst is deasserted
    And state_r equals STATE_BUSY
    And cnt_r equals N-1
    And annul_i is asserted
    When a rising clock edge occurs
    Then ready_o should be 0
    And state_r should equal STATE_IDLE
    And the calculation in progress should be terminated without producing a valid result

  @annul @safety
  Formal Scenario: annul_i has no effect when the module is idle
    Given rst is deasserted
    And state_r equals STATE_IDLE
    And start_i is 0
    And annul_i is asserted
    When a rising clock edge occurs
    Then ready_o should remain 0
    And state_r should remain STATE_IDLE

  @stability @safety
  Formal Scenario: result_o holds its completed value until overwritten by a subsequent operation or reset
    Given rst is deasserted
    And ready_o was 1 in the previous cycle with result value RES
    And start_i is 0
    And rst is 0
    When a rising clock edge occurs
    Then ready_o should be 0
    And result_o should remain equal to RES
    And result_o should continue to equal RES in every subsequent cycle until either state_r next equals STATE_IDLE-to-STATE_BUSY-to-completion producing a new ready_o pulse with a new result, or rst is asserted