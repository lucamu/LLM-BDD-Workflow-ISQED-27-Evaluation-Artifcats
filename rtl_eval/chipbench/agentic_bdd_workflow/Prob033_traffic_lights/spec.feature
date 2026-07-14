Feature: Traffic Light Controller with Pedestrian Request

  The TopModule implements a traffic light controller that cycles through
  red (10 cycles), green (60 cycles, or 10 cycles under pedestrian request
  if remaining time exceeds 10), and yellow (5 cycles) states, with an
  active-low asynchronous reset that forces the red state.

  Background:
    Given the design is TopModule
    And clk is the system clock
    And rst_n is the active-low asynchronous reset
    And pass_request is the pedestrian request input
    And clock is the 8-bit countdown timer output
    And red, yellow, and green are the mutually exclusive light outputs
    And all sequential behavior is evaluated on the rising edge of clk
    And rst_n asynchronously overrides all sequential updates when deasserted

  Formal Scenario: Asynchronous reset forces red state
    @reset
    Given rst_n is deasserted to 0
    Then red should be 1
    And yellow should be 0
    And green should be 0
    And clock should be 8'd10

  Formal Scenario: Reset takes effect regardless of clock edge
    @reset_async
    Given rst_n is deasserted to 0
    And any prior state of red, yellow, green, and clock
    When rst_n remains 0 at a rising edge of clk
    Then red should be 1
    And yellow should be 0
    And green should be 0
    And clock should be 8'd10

  Formal Scenario: Red light counts down while active
    @red_countdown
    Given rst_n is asserted to 1
    And red is 1
    And clock is value C where C is greater than 8'd1 and C is less than or equal to 8'd10
    When a rising edge of clk occurs
    Then red should remain 1
    And yellow should be 0
    And green should be 0
    And clock should be C - 8'd1

  Formal Scenario: Red light transitions to green when countdown expires
    @red_to_green
    Given rst_n is asserted to 1
    And red is 1
    And clock is 8'd1
    When a rising edge of clk occurs
    Then green should be 1
    And red should be 0
    And yellow should be 0
    And clock should be 8'd60

  Formal Scenario: Green light counts down without pedestrian request
    @green_countdown
    Given rst_n is asserted to 1
    And green is 1
    And clock is value C where C is greater than 8'd1 and C is less than or equal to 8'd60
    And pass_request is 0
    When a rising edge of clk occurs
    Then green should remain 1
    And red should be 0
    And yellow should be 0
    And clock should be C - 8'd1

  Formal Scenario: Green light transitions to yellow when countdown expires
    @green_to_yellow
    Given rst_n is asserted to 1
    And green is 1
    And clock is 8'd1
    When a rising edge of clk occurs
    Then yellow should be 1
    And red should be 0
    And green should be 0
    And clock should be 8'd5

  Formal Scenario: Pedestrian request shortens green time when remaining time exceeds 10
    @pedestrian_shorten
    Given rst_n is asserted to 1
    And green is 1
    And clock is value C where C is greater than 8'd10 and C is less than or equal to 8'd60
    And pass_request is 1
    When a rising edge of clk occurs
    Then green should remain 1
    And clock should be 8'd10

  Formal Scenario: Pedestrian request has no effect when remaining green time is 10 or less
    @pedestrian_no_effect_green
    Given rst_n is asserted to 1
    And green is 1
    And clock is value C where C is greater than 8'd1 and C is less than or equal to 8'd10
    And pass_request is 1
    When a rising edge of clk occurs
    Then green should remain 1
    And clock should be C - 8'd1

  Formal Scenario: Pedestrian request has no effect during red state
    @pedestrian_no_effect_red
    Given rst_n is asserted to 1
    And red is 1
    And clock is value C where C is greater than 8'd1 and C is less than or equal to 8'd10
    And pass_request is 1
    When a rising edge of clk occurs
    Then red should remain 1
    And clock should be C - 8'd1

  Formal Scenario: Pedestrian request has no effect during yellow state
    @pedestrian_no_effect_yellow
    Given rst_n is asserted to 1
    And yellow is 1
    And clock is value C where C is greater than 8'd1 and C is less than or equal to 8'd5
    And pass_request is 1
    When a rising edge of clk occurs
    Then yellow should remain 1
    And clock should be C - 8'd1

  Formal Scenario: Yellow light counts down while active
    @yellow_countdown
    Given rst_n is asserted to 1
    And yellow is 1
    And clock is value C where C is greater than 8'd1 and C is less than or equal to 8'd5
    When a rising edge of clk occurs
    Then yellow should remain 1
    And red should be 0
    And green should be 0
    And clock should be C - 8'd1

  Formal Scenario: Yellow light transitions to red when countdown expires
    @yellow_to_red
    Given rst_n is asserted to 1
    And yellow is 1
    And clock is 8'd1
    When a rising edge of clk occurs
    Then red should be 1
    And yellow should be 0
    And green should be 0
    And clock should be 8'd10

  Formal Scenario: Exactly one light is active at any time
    @one_hot
    Given rst_n is asserted to 1
    Then the sum of red, yellow, and green should equal 1

  Formal Scenario: Clock counter is always within valid bounds
    @clock_bounds
    Given rst_n is asserted to 1
    Then clock should be greater than 8'd0
    And clock should be less than or equal to 8'd60

  Formal Scenario: Clock value bounded by 10 while red is active
    @clock_bound_red
    Given rst_n is asserted to 1
    And red is 1
    Then clock should be greater than 8'd0
    And clock should be less than or equal to 8'd10

  Formal Scenario: Clock value bounded by 60 while green is active
    @clock_bound_green
    Given rst_n is asserted to 1
    And green is 1
    Then clock should be greater than 8'd0
    And clock should be less than or equal to 8'd60

  Formal Scenario: Clock value bounded by 5 while yellow is active
    @clock_bound_yellow
    Given rst_n is asserted to 1
    And yellow is 1
    Then clock should be greater than 8'd0
    And clock should be less than or equal to 8'd5