Feature: Down-Counter Timer with Terminal Count Output

  As a hardware designer
  I want a synchronous down-counter timer
  So that it asserts a terminal count signal when the loaded duration has elapsed

  Background:
    Given a positive-edge triggered clock clk
    And the design has no explicit reset signal
    And input load is 1 bit
    And input data is a 10-bit vector representing the countdown duration
    And output tc is 1 bit
    And the module contains an internal 10-bit register, the counter, that holds the current countdown value
    And tc is asserted whenever the counter register equals 0

  @load @basic
  Formal Scenario: Loading the counter captures the input data value
    Given load is 1
    And data is value D
    And the counter currently holds value N
    When a rising edge of clk occurs
    Then the counter should equal D on the next clock cycle
    And tc should equal 1 if D equals 0, otherwise tc should equal 0

  @decrement @basic
  Formal Scenario: Counter decrements by one when not loading and not at zero
    Given load is 0
    And the counter currently holds value N
    And N is not equal to 0
    When a rising edge of clk occurs
    Then the counter should equal N minus 1 on the next clock cycle
    And tc should equal 1 if (N minus 1) equals 0, otherwise tc should equal 0

  @terminal_count @hold
  Formal Scenario: Counter holds at zero once terminal count is reached
    Given load is 0
    And the counter currently holds value 0
    When a rising edge of clk occurs
    Then the counter should remain equal to 0 on the next clock cycle
    And tc should equal 1

  @load @priority
  Formal Scenario: Loading overrides counting even while counter has not reached zero
    Given load is 1
    And data is value D
    And the counter currently holds value N
    And N is not equal to 0
    When a rising edge of clk occurs
    Then the counter should equal D on the next clock cycle, regardless of N
    And the counter should not equal N minus 1 on the next clock cycle unless D equals N minus 1
    And tc should equal 1 if D equals 0, otherwise tc should equal 0

  @load @edge_case
  Formal Scenario: Loading a zero duration asserts terminal count immediately on next cycle
    Given load is 1
    And data is value 0
    When a rising edge of clk occurs
    Then the counter should equal 0 on the next clock cycle
    And tc should equal 1

  @combinational @tc
  Formal Scenario: Terminal count output is a direct function of the counter state
    Given the counter currently holds value N
    Then tc should equal 1 if N equals 0
    And tc should equal 0 if N is not equal to 0

  @load @no_underflow
  Formal Scenario: Counter never decrements below zero when not reloaded
    Given load is 0
    And the counter currently holds value 0
    When a rising edge of clk occurs
    Then the counter should not underflow to a nonzero value
    And the counter should equal 0 on the next clock cycle

  @sequence @multi_cycle @invariant
  Formal Scenario: Counter value and terminal count follow an inductive invariant for n cycles elapsed since load
    Given load is 1
    And data is value D
    And a rising edge of clk occurs to perform the load
    And load is held at 0 for all subsequent cycles until otherwise specified
    And n is the number of subsequent rising clock edges that have occurred since the load, with n less than or equal to D
    Then the counter should equal D minus n at the cycle corresponding to n elapsed edges
    And tc should equal 1 if and only if n equals D
    And for all n strictly less than D, tc should equal 0 at the cycle corresponding to n elapsed edges
    And once n equals D, the counter should remain equal to 0 and tc should remain equal to 1 for all further cycles with load held at 0

  @load @zero_data @multi_cycle
  Formal Scenario: Loading with D equal to zero satisfies the invariant with n equal to zero
    Given load is 1
    And data is value 0
    And a rising edge of clk occurs to perform the load
    Then n equals 0 immediately after the load
    And the counter should equal 0
    And tc should equal 1