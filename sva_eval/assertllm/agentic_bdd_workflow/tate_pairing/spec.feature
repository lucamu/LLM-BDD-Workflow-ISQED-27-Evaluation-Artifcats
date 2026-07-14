Feature: Tate Bilinear Pairing Core Formal Specification
  Formal verification of the Tate Bilinear Pairing core, which computes
  a Tate bilinear pairing over a Galois field GF(3^m) given two elliptic
  curve points (x1,y1) and (x2,y2), following a synchronous interface
  with active-high synchronous reset, fixed-latency computation, and
  flip-flop-registered output.

  Background:
    Given the design is synchronous to the rising edge of "clk"
    And "reset" is an active-high synchronous reset signal
    And "x1", "y1", "x2", "y2" are 194-bit input signals
    And "done" is a 1-bit registered output signal
    And "out" is a 1164-bit registered output signal
    And "x1_reg", "y1_reg", "x2_reg", "y2_reg" are the internal input-capture
      registers that latch "x1", "y1", "x2", "y2" respectively on the rising
      edge of "clk" when "reset" is 1
    And "dl_state" is the internal state register set of the Duursma-Lee
      algorithm module (Stage 1)
    And "power_state" is the internal state register set of the
      power-computation module (Stage 2)
    And "cycle_count" is an internal counter that tracks the number of
      elapsed clock cycles since the most recent input capture
    And the core computes a fixed function TatePairing(x1, y1, x2, y2)
    And the computation requires a fixed latency of L clock cycles after input capture
    And L equals 75839

  @reset @synchronous
  Formal Scenario: Synchronous reset forces done low
    Given "reset" is 1 at the current rising clock edge
    When the clock advances by one rising edge
    Then "done" should be 0 in the next cycle

  @reset @capture
  Formal Scenario: Input data is captured when reset is asserted
    Given "reset" is 1 at the current rising clock edge
    And "x1" holds symbolic value X1
    And "y1" holds symbolic value Y1
    And "x2" holds symbolic value X2
    And "y2" holds symbolic value Y2
    When the clock advances by one rising edge
    Then "x1_reg" should equal X1
    And "y1_reg" should equal Y1
    And "x2_reg" should equal X2
    And "y2_reg" should equal Y2

  @reset @output
  Formal Scenario: Output is inactive immediately after reset
    Given "reset" is 1 at the current rising clock edge
    When the clock advances by one rising edge
    Then "done" should be 0
    And "out" is unconstrained (don't-care) at this cycle
    And no correctness property is asserted on "out" until "done" becomes 1

  @latency @done
  Formal Scenario: Done remains low before computation latency elapses
    Given "reset" was asserted exactly once at cycle 0 with captured inputs X1, Y1, X2, Y2
    And "reset" is 0 for all cycles after cycle 0
    And the current cycle count C since capture satisfies C < L
    Then "done" should be 0

  @latency @done
  Formal Scenario: Done asserts exactly at the fixed latency cycle
    Given "reset" was asserted exactly once at cycle 0 with captured inputs X1, Y1, X2, Y2
    And "reset" is 0 for all cycles after cycle 0
    And the current cycle count C since capture equals L
    Then "done" should be 1

  @latency @done
  Formal Scenario: Done deasserts after the completion cycle unless reset again
    Given "reset" was asserted exactly once at cycle 0 with captured inputs X1, Y1, X2, Y2
    And "reset" is 0 for all cycles after cycle 0
    And "done" was 1 at cycle L
    And no new "reset" assertion occurs after cycle L
    When the clock advances by one rising edge
    Then "done" should be 0

  @output @correctness
  Formal Scenario: Output equals the Tate pairing function when done is asserted
    Given "reset" was asserted exactly once at cycle 0 with captured inputs X1, Y1, X2, Y2
    And "reset" is 0 for all cycles after cycle 0
    And "done" is 1 at the current cycle
    Then "out" should equal TatePairing(X1, Y1, X2, Y2)

  @output @stability
  Formal Scenario: Output remains stable while done stays asserted
    Given "done" is 1 at the current cycle with "out" equal to result R
    And "reset" is 0 at the next rising clock edge
    And "done" remains 1 at the next cycle
    When the clock advances by one rising edge
    Then "out" should still equal R

  @output @registered
  Formal Scenario: Output changes only on a clock edge, not combinationally
    Given "out" holds value R at the current cycle
    And no rising clock edge has occurred since the current cycle
    And any input signal x1, y1, x2, y2 changes value
    Then "out" should still equal R

  @reset @restart
  Formal Scenario: Reassertion of reset mid-computation restarts capture and computation
    Given "reset" was asserted exactly once at cycle 0 with captured inputs X1, Y1, X2, Y2
    And "reset" is 0 for cycles 1 through K where 0 < K < L
    And "reset" becomes 1 again at cycle K+1 with new inputs X1p, Y1p, X2p, Y2p
    When the clock advances by one rising edge
    Then "done" should be 0
    And "x1_reg" should equal X1p
    And "y1_reg" should equal Y1p
    And "x2_reg" should equal X2p
    And "y2_reg" should equal Y2p

  @input @stability
  Formal Scenario: Internal computation state is a deterministic function of captured inputs
    Given "reset" was asserted exactly once at cycle 0 with captured inputs X1, Y1, X2, Y2
    And "reset" is 0 for all cycles after cycle 0
    And the current cycle count C since capture satisfies 0 <= C < L
    And "x1_reg" equals X1, "y1_reg" equals Y1, "x2_reg" equals X2, "y2_reg" equals Y2
      for all such cycles
    Then "dl_state" at cycle C should equal DLState(X1, Y1, X2, Y2, C)
    And "power_state" at cycle C should equal PowerState(X1, Y1, X2, Y2, C)

  @input @determinism
  Formal Scenario: Computation is a pure function of captured inputs across independent runs
    Given two independent symbolic runs, Run A and Run B, of the core
    And in Run A, "reset" was asserted exactly once at cycle 0 with captured inputs
      X1, Y1, X2, Y2, yielding "x1_reg" = X1, "y1_reg" = Y1, "x2_reg" = X2, "y2_reg" = Y2
    And in Run B, "reset" was asserted exactly once at cycle 0 with captured inputs
      X1, Y1, X2, Y2, yielding "x1_reg" = X1, "y1_reg" = Y1, "x2_reg" = X2, "y2_reg" = Y2
    And "reset" is 0 for all cycles after cycle 0 in both Run A and Run B
    And the current cycle count C since capture satisfies 0 <= C <= L in both runs
    Then "dl_state" in Run A at cycle C should equal "dl_state" in Run B at cycle C
    And "power_state" in Run A at cycle C should equal "power_state" in Run B at cycle C
    And "out" in Run A at cycle L should equal "out" in Run B at cycle L

  @done @idle
  Formal Scenario: Done never asserts without a prior reset-triggered capture
    Given no "reset" assertion has ever occurred since power-up
    Then "done" should be 0 at every cycle