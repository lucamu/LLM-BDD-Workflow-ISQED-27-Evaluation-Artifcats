Feature: Fast-to-Slow Clock Domain Pulse Synchronizer

  As a hardware designer
  I want a single-cycle pulse detected on clk_fast to be re-synchronized
  and re-emitted as a single-cycle pulse on clk_slow
  So that pulse information safely crosses clock domains without loss or duplication

  Background:
    Given a module TopModule with input clk_fast, input clk_slow, input rst_n, input data_in, output data_out
    And clk_fast is a free-running clock whose frequency is 10 times the frequency of clk_slow
    And rst_n is an active-low asynchronous reset
    And all sequential logic is triggered on the positive edge of its respective clock
    And pulses on data_in are spaced far enough apart that no two pulses overlap in the synchronization pipeline

  @reset
  Formal Scenario: Asynchronous reset forces output low regardless of clock edges
    Given rst_n is deasserted to 0
    When any rising edge of clk_fast occurs
    And any rising edge of clk_slow occurs
    Then data_out should be 0

  @reset
  Formal Scenario: Reset deassertion clears any pending pulse activity
    Given rst_n is deasserted to 0 for at least one clk_fast cycle and one clk_slow cycle
    When rst_n is asserted back to 1
    And no data_in pulse has occurred since rst_n was asserted
    Then data_out should be 0 on every subsequent clk_slow rising edge until a new data_in pulse is detected

  @reset
  Formal Scenario: Reset asserted during an active output pulse immediately clears it
    Given rst_n is 1 and data_out is currently 1 due to a previously detected data_in pulse
    When rst_n is asynchronously deasserted to 0
    Then data_out should become 0 regardless of clk_fast or clk_slow edges

  @pulse_detect
  Formal Scenario: A single-cycle input pulse produces exactly one output pulse
    Given rst_n is asserted to 1
    And data_in is 0 for at least one clk_fast cycle before the pulse
    When data_in rises to 1 for exactly one clk_fast cycle and then returns to 0
    Then data_out should assert to 1 for exactly one clk_slow cycle within a bounded number of subsequent clk_slow cycles
    And data_out should be 0 on all other clk_slow cycles in that window

  @no_glitch
  Formal Scenario: No output pulse occurs when data_in never produces a pulse
    Given rst_n is asserted to 1
    And data_in remains constant at value X with no rising transition
    When any number of clk_fast cycles and clk_slow cycles elapse
    Then data_out should remain 0 throughout

  @pulse_width
  Formal Scenario: Output pulse width is exactly one clk_slow cycle
    Given rst_n is asserted to 1
    And data_out transitions to 1 at some clk_slow rising edge as a result of a detected data_in pulse
    When the next clk_slow rising edge occurs
    Then data_out should be 0

  @multiple_pulses
  Formal Scenario: Two sequential input pulses produce two sequential output pulses in order
    Given rst_n is asserted to 1
    And data_in produces a first single-cycle pulse on clk_fast
    And the corresponding output pulse for the first input pulse completes on clk_slow
    And data_in subsequently produces a second single-cycle pulse on clk_fast
    When a bounded number of clk_slow cycles elapse after the second input pulse
    Then data_out should produce a second single-cycle pulse
    And the second output pulse should occur strictly after the first output pulse completes

  @cdc_latency
  Formal Scenario: Output pulse latency is bounded by the synchronizer depth
    Given rst_n is asserted to 1
    And data_in produces a single-cycle pulse on clk_fast at some clk_fast cycle N
    When at least a fixed bounded number of clk_slow rising edges occur after cycle N
    Then data_out should have asserted exactly one single-cycle pulse by that time

  @no_double_pulse
  Formal Scenario: A single input pulse never produces more than one output pulse
    Given rst_n is asserted to 1
    And data_in produces exactly one single-cycle pulse on clk_fast
    And no further data_in pulses occur afterward
    When any number of subsequent clk_slow cycles elapse
    Then data_out should assert to 1 exactly once and remain 0 for all other cycles