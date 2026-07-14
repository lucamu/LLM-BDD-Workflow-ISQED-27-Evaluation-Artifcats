Feature: SHA3-512 Core Formal Properties
  Verify the synchronous behavior of the SHA-3 512 hash core, covering
  reset, input handshaking, padding buffer control, and output stability
  as required by the SHA3 Core Specification (Rev 0.1).

  Background:
    Given a synchronous clock "clk"
    And a synchronous active-high reset "rst"
    And an input data port "din"
    And an input byte-length port "din_size"
    And an input valid signal "in_valid"
    And an input last-block signal "is_last"
    And an output buffer-full signal "buf_full"
    And a 512-bit output port "hash"
    And an output valid signal "hash_valid"
    And an internal 576-bit buffer register "buffer_reg"
    And an internal buffer write-position pointer "buffer_write_ptr"
    And an internal last-block flag register "last_flag_reg"
    And an internal single-cycle permutation-start pulse signal "perm_start"
    And a symbolic constant "RATE_BYTES" representing 576/8
    And a symbolic pad byte "PAD_FIRST" representing the constant 0x06
    And a symbolic pad byte "PAD_LAST" representing the constant 0x80
    And a symbolic function "compute_permutation(state)" representing the Keccak permutation applied to a 576-bit absorbed state
    And all outputs "buf_full", "hash", "hash_valid" are registered and change only on the rising edge of "clk"
    And all internal registers "buffer_reg", "buffer_write_ptr", "last_flag_reg", "perm_start" change only on the rising edge of "clk"

  @reset
  Formal Scenario: Reset clears buffer-full and hash-valid outputs
    Given at cycle T the core is in an arbitrary state
    When "rst" is asserted at cycle T
    Then "buf_full" should equal 0 at cycle T+1
    And "hash_valid" should equal 0 at cycle T+1

  @reset
  Formal Scenario: Reset does not depend on input signals
    Given at cycle T "din" holds value D
    And at cycle T "din_size" holds value S
    And at cycle T "in_valid" holds value V
    And at cycle T "is_last" holds value L
    When "rst" is asserted at cycle T
    Then "buf_full" should equal 0 at cycle T+1
    And "hash_valid" should equal 0 at cycle T+1

  @input-handshake
  Formal Scenario: Input is absorbed only when not full and valid
    Given at cycle T "rst" is 0
    And at cycle T "buf_full" is 0
    And at cycle T "in_valid" is 1
    And at cycle T "din" holds value D
    And at cycle T "din_size" holds value S
    And at cycle T "buffer_write_ptr" holds value P
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "buffer_reg" at cycle T+1 should incorporate value D of size S at write position P

  @input-handshake
  Formal Scenario: Input is not absorbed when buffer is full
    Given at cycle T "rst" is 0
    And at cycle T "buf_full" is 1
    And at cycle T "in_valid" is 1
    And at cycle T "din" holds value D
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "buffer_reg" at cycle T+1 should equal "buffer_reg" at cycle T

  @input-handshake
  Formal Scenario: Input is not absorbed when not valid
    Given at cycle T "rst" is 0
    And at cycle T "buf_full" is 0
    And at cycle T "in_valid" is 0
    And at cycle T "din" holds value D
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "buffer_reg" at cycle T+1 should equal "buffer_reg" at cycle T

  @input-stability
  Formal Scenario: Input value must remain stable until it is accepted
    Given at cycle T "rst" is 0
    And at cycle T "din" holds value D
    And at cycle T the core did not accept the input because "buf_full" was 1 or "in_valid" was 0
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "din" at cycle T+1 should equal D

  @is-last
  Formal Scenario: is_last takes effect only when in_valid is asserted
    Given at cycle T "rst" is 0
    And at cycle T "in_valid" is 0
    And at cycle T "is_last" holds value L
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "last_flag_reg" at cycle T+1 should equal "last_flag_reg" at cycle T

  @is-last
  Formal Scenario: is_last is captured when input is accepted
    Given at cycle T "rst" is 0
    And at cycle T "buf_full" is 0
    And at cycle T "in_valid" is 1
    And at cycle T "is_last" holds value L
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "last_flag_reg" at cycle T+1 should equal L

  @padding-alignment
  Formal Scenario: Partial final input is aligned to the most significant bits
    Given at cycle T "rst" is 0
    And at cycle T "buf_full" is 0
    And at cycle T "in_valid" is 1
    And at cycle T "is_last" is 1
    And at cycle T "din_size" holds value S less than the full byte width of "din"
    And at cycle T "din" holds value D
    And at cycle T "buffer_write_ptr" holds value P
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "buffer_reg"[P*8 +: S*8] at cycle T+1 should equal the most significant S*8 bits of D
    And "buffer_reg"[(P+S)*8 +: 8] at cycle T+1 should equal "PAD_FIRST"
    And "buffer_reg"[RATE_BYTES*8-8 +: 8] at cycle T+1 should equal "PAD_LAST"

  @buffer-full-triggers-permutation
  Formal Scenario: Buffer full asserts and triggers permutation start
    Given at cycle T "rst" is 0
    And at cycle T "buffer_write_ptr" equals "RATE_BYTES"
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "buf_full" should equal 1 at cycle T+1
    And "perm_start" should be asserted (equal to 1) at cycle T+1

  @buffer-full-triggers-permutation
  Formal Scenario: perm_start is a single-cycle pulse
    Given at cycle T+1 "perm_start" is asserted (equal to 1)
    When a rising edge of "clk" occurs from cycle T+1 to cycle T+2
    Then "perm_start" should equal 0 at cycle T+2

  @buffer-full-triggers-permutation
  Formal Scenario: Buffer is cleared one cycle after permutation start
    Given at cycle T+1 "perm_start" is asserted (equal to 1)
    When a rising edge of "clk" occurs from cycle T+1 to cycle T+2
    Then "buffer_reg" at cycle T+2 should equal all zeros
    And "buffer_write_ptr" at cycle T+2 should equal 0

  @output-stability
  Formal Scenario: Hash output remains unchanged after becoming valid until next reset
    Given at cycle T "rst" is 0
    And at cycle T "hash_valid" is 1
    And at cycle T "hash" holds value H
    When a rising edge of "clk" occurs from cycle T to cycle T+1 without "rst" being asserted
    Then "hash" at cycle T+1 should equal H
    And "hash_valid" at cycle T+1 should equal 1

  @output-stability
  Formal Scenario: Hash output update is deterministically tied to perm_start
    Given at cycle T "buffer_reg" holds value B
    And at cycle T "perm_start" holds value PS
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "hash" at cycle T+1 should equal "compute_permutation"(B) when PS equals 1
    And "hash" at cycle T+1 should equal "hash" at cycle T when PS equals 0

  @output-registered
  Formal Scenario: Outputs at T are independent of inputs sampled at T
    Given at cycle T "rst" is 0
    And at cycle T "din", "din_size", "in_valid", "is_last" hold arbitrary values
    And at cycle T-1 the registered state of "buf_full", "hash", "hash_valid" is fixed
    Then "buf_full" at cycle T should be independent of "din", "in_valid", "is_last", "din_size" sampled at cycle T
    And "hash" at cycle T should be independent of "din", "in_valid", "is_last", "din_size" sampled at cycle T
    And "hash_valid" at cycle T should be independent of "din", "in_valid", "is_last", "din_size" sampled at cycle T

  @reset-priority
  Formal Scenario: Reset has priority over any concurrent valid input
    Given at cycle T "rst" is 1
    And at cycle T "in_valid" is 1
    And at cycle T "buf_full" is 0
    And at cycle T "din" holds value D
    When a rising edge of "clk" occurs from cycle T to cycle T+1
    Then "buffer_reg" at cycle T+1 should equal "buffer_reg" at cycle T
    And "buf_full" at cycle T+1 should equal 0
    And "hash_valid" at cycle T+1 should equal 0