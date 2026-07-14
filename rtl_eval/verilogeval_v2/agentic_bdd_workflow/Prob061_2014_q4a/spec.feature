Feature: Single-Stage Shift Register with Load and Enable
  As a hardware designer
  I want a shift register stage that supports synchronous load and shift-enable
  So that it can be chained into an n-bit shift register circuit

  The module TopModule has the following behavior on each positive clock edge:
    - If L is asserted, Q loads the value of R (load has priority over shift)
    - Else if E is asserted, Q takes the value of w (shift in from previous stage)
    - Else Q holds its previous value

  Background:
    Given a signal clk that toggles as the system clock
    And a signal w representing the previous stage's output
    And a signal R representing the load value
    And a signal E representing the shift enable
    And a signal L representing the load enable
    And an output Q representing the current stage's stored value
    And all sequential updates occur on the positive edge of clk

  @load @priority
  Formal Scenario: Load takes priority over shift when both L and E are asserted
    Given L is 1
    And E is 1
    And R holds value load_val
    And w holds value shift_val
    When a positive edge of clk occurs
    Then Q should equal load_val

  @load
  Formal Scenario: Load value R into Q when L is asserted and E is deasserted
    Given L is 1
    And E is 0
    And R holds value load_val
    When a positive edge of clk occurs
    Then Q should equal load_val

  @shift
  Formal Scenario: Shift in w when E is asserted and L is deasserted
    Given L is 0
    And E is 1
    And w holds value shift_val
    When a positive edge of clk occurs
    Then Q should equal shift_val

  @hold
  Formal Scenario: Hold current value when neither L nor E is asserted
    Given L is 0
    And E is 0
    And Q currently holds value prev_val
    When a positive edge of clk occurs
    Then Q should equal prev_val

  @load @independence
  Formal Scenario: Loaded value does not depend on w
    Given L is 1
    And E is any value
    And R holds value load_val
    And w holds any value
    When a positive edge of clk occurs
    Then Q should equal load_val

  @shift @independence
  Formal Scenario: Shifted value does not depend on R when L is deasserted
    Given L is 0
    And E is 1
    And R holds any value
    And w holds value shift_val
    When a positive edge of clk occurs
    Then Q should equal shift_val

  @stability
  Formal Scenario: Q remains stable between clock edges
    Given Q currently holds value stable_val
    And no positive edge of clk occurs
    Then Q should equal stable_val

  @combinational
  Formal Scenario: Q does not change combinationally with L, E, R, or w before a clock edge
    Given Q currently holds value current_val
    When L changes to any value
    And E changes to any value
    And R changes to any value
    And w changes to any value
    But no positive edge of clk occurs
    Then Q should equal current_val