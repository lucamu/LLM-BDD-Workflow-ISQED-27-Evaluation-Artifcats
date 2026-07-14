Feature: 4-bit Shift Register with Asynchronous Reset, Load, and Enable

  As a hardware designer
  I want a 4-bit right shift register with async reset, synchronous load and enable
  So that data can be loaded or shifted with load having priority over enable

  Background:
    Given a design "TopModule" with inputs "clk, areset, load, ena, data[3:0]" and output "q[3:0]"
    And the clock "clk" toggles every cycle to drive positive edge triggered logic
    And "areset" is asynchronous and positive edge triggered
    And "load" and "ena" are synchronous active-high control signals
    And "data" is a 4-bit input bus
    And "q" is the 4-bit registered output of the shift register

  @reset @async
  Formal Scenario: Asynchronous reset forces output to zero immediately
    Given areset is asserted to 1 asynchronously, independent of clk edge
    When any time passes, regardless of load, ena, or data values
    Then q should become 4'b0000 immediately without waiting for a clock edge

  @reset @recovery
  Formal Scenario: Deassertion of reset allows normal operation on next clock edge
    Given areset is deasserted to 0
    And load is set to symbolic value L
    And ena is set to symbolic value E
    And data is set to symbolic value D
    When a rising edge of clk occurs
    Then q should update according to load and ena priority as defined by load, ena, D, and previous q

  @load @priority
  Formal Scenario: Load takes priority over enable when both asserted
    Given areset is deasserted to 0
    And load is asserted to 1
    And ena is asserted to 1
    And data is set to symbolic value D
    When a rising edge of clk occurs
    Then q should become D
    And q should not reflect a shifted version of the previous q

  @load
  Formal Scenario: Load overwrites register with data when ena is deasserted
    Given areset is deasserted to 0
    And load is asserted to 1
    And ena is deasserted to 0
    And data is set to symbolic value D
    When a rising edge of clk occurs
    Then q should become D

  @shift
  Formal Scenario: Enable causes right shift with zero fill when load is deasserted
    Given areset is deasserted to 0
    And load is deasserted to 0
    And ena is asserted to 1
    And q holds a symbolic previous value Q_prev
    When a rising edge of clk occurs
    Then q[3] should become 0
    And q[2] should become Q_prev[3]
    And q[1] should become Q_prev[2]
    And q[0] should become Q_prev[1]

  @hold
  Formal Scenario: Register holds its value when both load and ena are deasserted
    Given areset is deasserted to 0
    And load is deasserted to 0
    And ena is deasserted to 0
    And q holds a symbolic previous value Q_prev
    When a rising edge of clk occurs
    Then q should remain equal to Q_prev

  @shift @bitloss
  Formal Scenario: Shifted-out bit is discarded and not observable in q
    Given areset is deasserted to 0
    And load is deasserted to 0
    And ena is asserted to 1
    And q holds a symbolic previous value Q_prev with q[0] equal to symbolic bit B
    When a rising edge of clk occurs
    Then q should not depend on B in any bit position
    And q[3] should become 0

  @reset @priority
  Formal Scenario: Asynchronous reset overrides load and enable at any time
    Given areset is asserted to 1
    And load is set to symbolic value L
    And ena is set to symbolic value E
    And data is set to symbolic value D
    When a rising edge of clk occurs
    Then q should become 4'b0000 regardless of L, E, and D