Feature: SHA3-512 Core Formal Specification
  Formal properties describing the synchronous behavior of the SHA-3 512
  hash core (padding + permutation modules), covering reset, input
  handshake, buffer-full signaling, last-block padding semantics, and
  output stability, independent of the high/low throughput variant.

  Background:
    Given a synchronous design clocked on the rising edge of "clk"
    And a synchronous active-high reset signal "reset"
    And an input data port "data_in" of implementation-defined width W
    And an input byte-length port "in_len" indicating valid bytes in "data_in"
    And an input valid signal "valid"
    And an input last-block signal "is_last"
    And an output buffer-full signal "full"
    And an output 512-bit hash result "hash_out"
    And an output hash-ready signal "ready"
    And all inputs are sampled at the rising edge of "clk"
    And all outputs are registered and not combinationally driven

  @reset @safety
  Formal Scenario: Reset clears ready and full outputs
    Given the core is in an arbitrary internal state
    When "reset" is asserted for one rising edge of "clk"
    Then "ready" should be 0 in the next clock cycle
    And "full" should be 0 in the next clock cycle

  @reset @safety
  Formal Scenario: Reset must precede a new hash computation
    Given the core has previously asserted "ready" for a prior message
    When "reset" is asserted for one rising edge of "clk"
    And "reset" is deasserted on the following rising edge
    Then the internal buffer state should be cleared
    And "ready" should be 0 until a new complete padded block is processed

  @handshake @input_absorption
  Formal Scenario: Input is absorbed only when valid and not full
    Given "reset" is deasserted
    And "valid" is 1
    And "full" is 0
    And "data_in" holds symbolic value DATA
    And "in_len" holds symbolic value LEN
    When a rising edge of "clk" occurs
    Then the internal buffer should incorporate DATA using LEN valid bytes
    And the buffer write pointer should advance by LEN bytes

  @handshake @input_absorption
  Formal Scenario: Input is not absorbed when valid is deasserted
    Given "reset" is deasserted
    And "valid" is 0
    And "data_in" holds symbolic value DATA
    When a rising edge of "clk" occurs
    Then the internal buffer contents should remain unchanged

  @handshake @input_absorption
  Formal Scenario: Input is not absorbed when buffer is full
    Given "reset" is deasserted
    And "valid" is 1
    And "full" is 1
    And "data_in" holds symbolic value DATA
    When a rising edge of "clk" occurs
    Then the internal buffer contents should remain unchanged

  @handshake @input_hold
  Formal Scenario: Input value must be held stable while full is asserted
    Given "reset" is deasserted
    And "full" is 1 at cycle T
    And "data_in" holds symbolic value DATA at cycle T
    When "full" remains 1 at cycle T plus 1
    Then "data_in" should equal DATA at cycle T plus 1

  @buffer_full @safety
  Formal Scenario: Buffer full asserted when 576-bit block is assembled
    Given "reset" is deasserted
    And the internal buffer accumulates exactly 576 bits of absorbed input
    When a rising edge of "clk" occurs
    Then "full" should be 1

  @buffer_full @liveness
  Formal Scenario: Buffer full deasserted after permutation starts
    Given "full" is 1 at cycle T
    When the permutation module begins computation at cycle T plus 1
    Then "full" should be 0 at cycle T plus 1
    And the internal buffer should be cleared at cycle T plus 1

  @padding @correctness
  Formal Scenario: Last block sets is_last only when valid is asserted
    Given "reset" is deasserted
    And "is_last" holds symbolic value LAST
    And "valid" is 0
    When a rising edge of "clk" occurs
    Then LAST should have no effect on the padding logic

  @padding @correctness
  Formal Scenario: Multi-rate padding appended on last valid block
    Given "reset" is deasserted
    And "valid" is 1
    And "is_last" is 1
    And "data_in" holds symbolic value DATA with LEN valid bytes
    When a rising edge of "clk" occurs
    Then the padding module should append a single bit 1
    And the padding module should append the minimum number of zero bits
    And the padding module should append a final single bit 1
    And the resulting padded length should be a multiple of 576 bits

  @padding @alignment
  Formal Scenario: Partial input is aligned to most significant bit
    Given "reset" is deasserted
    And "valid" is 1
    And "in_len" holds symbolic value LEN less than W in bytes
    And "data_in" holds symbolic value DATA
    When a rising edge of "clk" occurs
    Then only the LEN most-significant bytes of DATA should be absorbed
    And the remaining low-order bytes of DATA should be ignored

  @output @correctness
  Formal Scenario: Hash output equals permutation result upon completion
    Given "reset" is deasserted
    And the permutation module completes computation over the fully
      padded message blocks derived from all absorbed input
    When the permutation module signals completion
    Then "ready" should be 1
    And "hash_out" should equal the Keccak-f[1600] sponge output squeezed
      to 512 bits from the finalized state

  @output @stability
  Formal Scenario: Hash output remains stable once ready is asserted
    Given "ready" is 1 at cycle T
    And "hash_out" equals symbolic value HASH at cycle T
    And "reset" remains 0 for all cycles after T
    When any number of subsequent rising edges of "clk" occur without reset
    Then "ready" should remain 1
    And "hash_out" should remain equal to HASH

  @output @reset_clears_ready
  Formal Scenario: Ready deasserted immediately after reset
    Given "ready" is 1 at cycle T
    When "reset" is asserted at cycle T plus 1
    Then "ready" should be 0 at cycle T plus 2

  @liveness
  Formal Scenario: Ready eventually asserted after last block absorption
    Given "reset" is deasserted
    And "valid" is 1
    And "is_last" is 1
    And the final block has been absorbed into the buffer at cycle T
    When sufficient clock cycles elapse for permutation to complete
    Then "ready" should eventually become 1

  @throughput @timing
  Formal Scenario: Permutation does not overwrite buffer during computation
    Given "full" is 1 at cycle T signaling permutation start
    And the permutation module is actively computing between cycle T
      and cycle T plus N, where N is the fixed number of rounds cycles
    When "valid" is 1 and new "data_in" arrives during this interval
    Then the padding module should buffer the new input independently
    And the in-progress permutation state should remain unaffected by
      the new input until permutation completes

  @width_dependent @padding
  Formal Scenario: Zero-length final block is required on exact multiple length
    Given "reset" is deasserted
    And the total message length is an exact multiple of W bits
    And "is_last" is 0 for all prior blocks
    When an additional block is provided with "in_len" equal to 0 and
      "is_last" equal to 1
    Then the padding module should treat this as the final empty block
    And the resulting padded length should still be a multiple of 576 bits