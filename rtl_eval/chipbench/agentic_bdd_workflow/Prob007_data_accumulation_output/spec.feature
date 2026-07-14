Feature: Serial Data Accumulation Circuit with Valid-Ready Handshake

  The TopModule accumulates four consecutive 8-bit input values received
  through a valid/ready handshake on the input side, and produces their
  10-bit sum through a valid/ready handshake on the output side. The
  circuit must support back-pressure on both sides and must not introduce
  bubbles when both the input source and the output sink are always
  ready.

  Background:
    Given clk is the synchronous rising-edge clock
    And rst_n is the active-low synchronous reset
    And all internal state (accumulated sum and accepted-input count) is cleared when rst_n is 0
    And the internal signal accumulated_sum holds the running sum of accepted inputs since the last output handshake (or reset)
    And the internal signal input_count holds the number of input handshakes completed since the last output handshake (or reset)
    And ready_a is computed as the negation of (valid_b AND NOT ready_b)
    And an input handshake completes on a clock edge only when valid_a is 1 and ready_a is 1
    And an output handshake completes on a clock edge only when valid_b is 1 and ready_b is 1
    And BYTE_MAX is defined as 2^8 - 1
    And SUM_MAX is defined as 4 * BYTE_MAX
    And OUT_MAX is defined as 2^10 - 1

  @reset
  Formal Scenario: Reset drives the interface to a known idle state
    Given rst_n is 0
    When a rising clock edge occurs
    Then ready_a should be 1
    And valid_b should be 0
    And data_out should be 0

  @ready_a-formula
  Formal Scenario: ready_a reflects absence of a stalled pending output
    Given the module is out of reset
    And valid_b is 1
    And ready_b is 0
    Then ready_a should be 0

  @ready_a-formula-release
  Formal Scenario: ready_a is asserted whenever no output is pending or it is being consumed
    Given the module is out of reset
    And valid_b is 0
    Then ready_a should be 1

  @ready_a-formula-release2
  Formal Scenario: ready_a is asserted when a pending output is being accepted
    Given the module is out of reset
    And valid_b is 1
    And ready_b is 1
    Then ready_a should be 1

  @output-stability
  Formal Scenario: Pending output remains stable until acknowledged
    Given the module is out of reset
    And valid_b is 1
    And ready_b is 0
    And data_out equals value S in the current cycle
    When a rising clock edge occurs
    Then valid_b should remain 1
    And data_out should remain equal to S

  @input-ignored-when-invalid
  Formal Scenario: Input is not consumed when valid_a is deasserted
    Given the module is out of reset
    And valid_a is 0
    And the current accumulated partial sum equals value P
    And the current accepted-input count equals value C
    When a rising clock edge occurs
    Then the accumulated partial sum should remain equal to P
    And the accepted-input count should remain equal to C
    And valid_b should remain unchanged
    And data_out should remain unchanged

  @accumulation-correctness
  Formal Scenario: Correct sum after four consecutive accepted inputs
    Given the module is out of reset
    And no output is pending at the start (valid_b is 0)
    And ready_b is held at 1 for the entire scenario
    And ready_a is 1 in every cycle of the scenario
    And an input handshake completes with data_in equal to D0
    And on the next cycle an input handshake completes with data_in equal to D1
    And on the next cycle an input handshake completes with data_in equal to D2
    And on the next cycle an input handshake completes with data_in equal to D3
    When the fourth input handshake completes
    Then on the following clock edge valid_b should be 1
    And data_out should equal D0 + D1 + D2 + D3

  @no-spurious-valid
  Formal Scenario: valid_b stays deasserted before the fourth input is accepted
    Given the module is out of reset
    And the internal signal input_count is less than 4 since the last output handshake (or since reset)
    Then valid_b should be 0

  @no-overflow
  Formal Scenario: Accumulated sum of four bytes never overflows the 10-bit output
    Given the module accumulates four input values D0, D1, D2, D3
    And each of D0, D1, D2, D3 is in the range 0 to BYTE_MAX
    When valid_b becomes 1 after the fourth accepted input
    Then data_out should equal the full-precision symbolic sum D0 + D1 + D2 + D3 with no truncation
    And data_out should be less than or equal to SUM_MAX
    And SUM_MAX should be less than or equal to OUT_MAX

  @full-throughput
  Formal Scenario: No bubbles when both sides are always ready
    Given the module is out of reset
    And valid_a is held at 1 for the entire scenario
    And ready_b is held at 1 for the entire scenario
    Then ready_a should be 1 in every cycle
    And an input handshake should complete in every cycle
    And exactly one output handshake should complete every four input handshakes
    And no cycle should occur where valid_a is 1, ready_a is 1, and no input is accepted

  @independent-batches
  Formal Scenario: Each output batch depends only on its own four inputs
    Given the module is out of reset
    And ready_b is held at 1 for the entire scenario
    And ready_a is 1 in every cycle of the scenario
    And a first batch of accepted inputs D0, D1, D2, D3 produces data_out equal to S1 with valid_b equal to 1
    And after S1 is acknowledged, a second batch of accepted inputs D4, D5, D6, D7 is received
    When the second batch completes
    Then data_out should equal D4 + D5 + D6 + D7

  @backpressure-holds-partial-state
  Formal Scenario: Partial accumulation is preserved while output is stalled
    Given the module is out of reset
    And two input handshakes have completed with data_in equal to D0 then D1
    And the internal signal accumulated_sum equals D0 + D1
    And the internal signal input_count equals 2
    And valid_b is 1 due to an unrelated pending previous output
    And ready_b is 0
    When a rising clock edge occurs
    Then the internal signal accumulated_sum should remain equal to D0 + D1
    And the internal signal input_count should remain equal to 2
    And no input handshake should complete while ready_a is 0
    And when ready_b is subsequently asserted and two more input handshakes complete with data_in equal to D2 then D3
    And within 1 cycle after the fourth input handshake completes, data_out should equal D0 + D1 + D2 + D3