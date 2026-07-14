Feature: 100-bit Rotator with Synchronous Load and Bidirectional Rotate Enable

  As a hardware designer
  I want a 100-bit register that synchronously loads or rotates left/right
  So that data can be shifted circularly without loss of bits

  Background:
    Given a design "TopModule" with inputs "clk, load, ena[1:0], data[99:0]" and output "q[99:0]"
    And the rising edge of "clk" is the only point at which state updates
    And "q" holds the current 100-bit register value before the active clock edge
    And all sequential behavior is evaluated with respect to consecutive clock cycles
    And symbolic values (Q, D, E) represent universally-quantified free variables constrained only by their stated bit-widths, translatable to "assume" statements in a formal harness
    And any input described as "held for N consecutive clock cycles" represents an assumption that the input remains constant across those cycles, translatable to a conjunction of per-cycle "assume" statements
    And any scenario spanning more than one clock cycle (e.g., round-trip and full-period scenarios) is intended to be proven via k-induction or bounded unrolling of the design over the stated number of cycles, rather than via a single-cycle assertion

  @load @priority
  Formal Scenario: Synchronous load overrides rotation regardless of ena
    Given the current register value is Q
    And "load" is 1
    And "ena" is any value E, universally quantified over all 2-bit encodings
    And "data" is value D
    When a rising edge of "clk" occurs
    Then "q" should equal D on the next cycle

  @rotate-right
  Formal Scenario: Rotate right by one bit when ena is 2'b01
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b01
    When a rising edge of "clk" occurs
    Then bit 99 of "q" on the next cycle should equal bit 0 of Q
    And bits 98 downto 0 of "q" on the next cycle should equal bits 99 downto 1 of Q

  @rotate-left
  Formal Scenario: Rotate left by one bit when ena is 2'b10
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b10
    When a rising edge of "clk" occurs
    Then bit 0 of "q" on the next cycle should equal bit 99 of Q
    And bits 99 downto 1 of "q" on the next cycle should equal bits 98 downto 0 of Q

  @no-rotate
  Formal Scenario: No rotation occurs when ena is 2'b00
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b00
    When a rising edge of "clk" occurs
    Then "q" on the next cycle should equal Q

  @no-rotate
  Formal Scenario: No rotation occurs when ena is 2'b11
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b11
    When a rising edge of "clk" occurs
    Then "q" on the next cycle should equal Q

  @load-and-rotate-right @priority
  Formal Scenario: Load takes precedence over right rotate request
    Given the current register value is Q
    And "load" is 1
    And "ena" is 2'b01
    And "data" is value D
    When a rising edge of "clk" occurs
    Then "q" on the next cycle should equal D

  @load-and-rotate-left @priority
  Formal Scenario: Load takes precedence over left rotate request
    Given the current register value is Q
    And "load" is 1
    And "ena" is 2'b10
    And "data" is value D
    When a rising edge of "clk" occurs
    Then "q" on the next cycle should equal D

  @cover @load-and-rotate-right @priority
  Formal Scenario: Cover that load with ena=2'b01 can produce a result differing from a right rotation
    Given the current register value is Q
    And "load" is 1
    And "ena" is 2'b01
    And "data" is value D
    When a rising edge of "clk" occurs
    Then it should be possible (cover) that "q" on the next cycle does not equal the right-rotation of Q

  @cover @load-and-rotate-left @priority
  Formal Scenario: Cover that load with ena=2'b10 can produce a result differing from a left rotation
    Given the current register value is Q
    And "load" is 1
    And "ena" is 2'b10
    And "data" is value D
    When a rising edge of "clk" occurs
    Then it should be possible (cover) that "q" on the next cycle does not equal the left-rotation of Q

  @bit-conservation @rotate-right
  Formal Scenario: Right rotation preserves the multiset of bits
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b01
    When a rising edge of "clk" occurs
    Then the population count of "q" on the next cycle should equal the population count of Q

  @bit-conservation @rotate-left
  Formal Scenario: Left rotation preserves the multiset of bits
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b10
    When a rising edge of "clk" occurs
    Then the population count of "q" on the next cycle should equal the population count of Q

  @round-trip @multi-cycle
  Formal Scenario: Rotating right then left returns to the original value
    # Proof strategy: bounded unrolling over 2 cycles (or k-induction with k>=2)
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b01
    When a rising edge of "clk" occurs
    And "ena" becomes 2'b10
    And a rising edge of "clk" occurs
    Then "q" on the second next cycle should equal Q

  @round-trip @multi-cycle
  Formal Scenario: Rotating left then right returns to the original value
    # Proof strategy: bounded unrolling over 2 cycles (or k-induction with k>=2)
    Given the current register value is Q
    And "load" is 0
    And "ena" is 2'b10
    When a rising edge of "clk" occurs
    And "ena" becomes 2'b01
    And a rising edge of "clk" occurs
    Then "q" on the second next cycle should equal Q

  @full-period @multi-cycle @k-induction
  Formal Scenario: Rotating right 100 times returns to the original value
    # Proof strategy: this property spans 100 clock cycles and is intended to be
    # established via k-induction (with induction depth >= 1 over the rotation
    # invariant) or via bounded model checking with full unrolling to 100 cycles,
    # not via a single-cycle assertion.
    Given the current register value is Q
    And "load" is 0
    And "ena" is held at 2'b01 for 100 consecutive clock cycles, assumed constant across all 100 cycles
    When the 100 rising edges of "clk" occur
    Then "q" after the 100th cycle should equal Q

  @full-period @multi-cycle @k-induction
  Formal Scenario: Rotating left 100 times returns to the original value
    # Proof strategy: this property spans 100 clock cycles and is intended to be
    # established via k-induction (with induction depth >= 1 over the rotation
    # invariant) or via bounded model checking with full unrolling to 100 cycles,
    # not via a single-cycle assertion.
    Given the current register value is Q
    And "load" is 0
    And "ena" is held at 2'b10 for 100 consecutive clock cycles, assumed constant across all 100 cycles
    When the 100 rising edges of "clk" occur
    Then "q" after the 100th cycle should equal Q