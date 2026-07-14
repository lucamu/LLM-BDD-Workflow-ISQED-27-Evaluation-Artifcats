Feature: Lemmings Finite State Machine Controller

  As a hardware designer
  I want to verify the Lemmings FSM behavior
  So that walking, falling, digging, direction-switching, and splattering are correctly modeled

  Background:
    Given the design is TopModule
    And clk is the sequential clock with rising edge triggering
    And areset is an asynchronous active-high reset
    And when areset is 1, the state becomes walk_left on the next clock edge regardless of other inputs
    And the outputs walk_left, walk_right, aaah, and digging are mutually exclusive in every state except the splattered state, where all four are 0
    And bump_left, bump_right, ground, and dig are free inputs that may take any value each cycle unless constrained by a scenario

  @reset
  Formal Scenario: Asynchronous reset forces walk_left state
    Given any current state of the FSM
    And any values of bump_left, bump_right, ground, and dig
    When areset is asserted to 1
    Then walk_left should become 1
    And walk_right should be 0
    And aaah should be 0
    And digging should be 0

  @reset
  Formal Scenario: After reset deassertion FSM continues from walk_left
    Given areset was 1 in the previous cycle
    And areset is deasserted to 0
    And ground is 1
    And bump_left is 0
    And bump_right is 0
    And dig is 0
    When a rising clock edge occurs
    Then walk_left should remain 1
    And walk_right should be 0
    And aaah should be 0
    And digging should be 0

  @walking @direction
  Formal Scenario: Walking left switches to walking right when bumped on the left
    Given the FSM is in the walk_left state
    And ground is 1
    And bump_left is 1
    And bump_right is 0
    And dig is 0
    When a rising clock edge occurs
    Then walk_right should become 1
    And walk_left should be 0
    And aaah should be 0
    And digging should be 0

  @walking @direction
  Formal Scenario: Walking right switches to walking left when bumped on the right
    Given the FSM is in the walk_right state
    And ground is 1
    And bump_left is 0
    And bump_right is 1
    And dig is 0
    When a rising clock edge occurs
    Then walk_left should become 1
    And walk_right should be 0
    And aaah should be 0
    And digging should be 0

  @walking @direction
  Formal Scenario: Being bumped on both sides while walking left still switches direction
    Given the FSM is in the walk_left state
    And ground is 1
    And bump_left is 1
    And bump_right is 1
    And dig is 0
    When a rising clock edge occurs
    Then walk_right should become 1
    And walk_left should be 0

  @walking @direction
  Formal Scenario: Being bumped on both sides while walking right still switches direction
    Given the FSM is in the walk_right state
    And ground is 1
    And bump_left is 1
    And bump_right is 1
    And dig is 0
    When a rising clock edge occurs
    Then walk_left should become 1
    And walk_right should be 0

  @falling
  Formal Scenario: Ground disappearing while walking causes falling with aaah
    Given the FSM is in the walk_left state or the walk_right state
    And ground is 0
    When a rising clock edge occurs
    Then aaah should become 1
    And walk_left should be 0
    And walk_right should be 0
    And digging should be 0

  @falling
  Formal Scenario: Falling resumes walking left when ground reappears within splatter threshold
    Given the FSM is in a falling state that originated from walk_left
    And the fall duration so far is less than or equal to 20 cycles
    And ground is 1
    When a rising clock edge occurs
    Then walk_left should become 1
    And walk_right should be 0
    And aaah should be 0
    And digging should be 0

  @falling
  Formal Scenario: Falling resumes walking right when ground reappears within splatter threshold
    Given the FSM is in a falling state that originated from walk_right
    And the fall duration so far is less than or equal to 20 cycles
    And ground is 1
    When a rising clock edge occurs
    Then walk_right should become 1
    And walk_left should be 0
    And aaah should be 0
    And digging should be 0

  @falling @direction
  Formal Scenario: Bump inputs have no effect on direction while falling
    Given the FSM is in a falling state that originated from walk_left
    And ground is 0
    And bump_left is any value
    And bump_right is any value
    When a rising clock edge occurs
    Then aaah should remain 1
    And walk_left should be 0
    And walk_right should be 0
    And the remembered original direction should stay walk_left for the eventual resumption

  @falling @direction
  Formal Scenario: Bump in the same cycle ground disappears does not affect resumed direction
    Given the FSM is in the walk_right state
    And ground transitions from 1 to 0 in this cycle
    And bump_left is 1
    When a rising clock edge occurs
    Then aaah should become 1
    And when ground later returns to 1 within the splatter threshold
    Then walk_right should become 1
    And walk_left should be 0

  @digging
  Formal Scenario: Digging starts when walking on ground and dig is asserted
    Given the FSM is in the walk_left state or the walk_right state
    And ground is 1
    And dig is 1
    When a rising clock edge occurs
    Then digging should become 1
    And walk_left should be 0
    And walk_right should be 0
    And aaah should be 0

  @digging
  Formal Scenario: Digging continues while ground remains present
    Given the FSM is in the digging state
    And ground is 1
    When a rising clock edge occurs
    Then digging should remain 1
    And walk_left should be 0
    And walk_right should be 0
    And aaah should be 0

  @digging @falling
  Formal Scenario: Digging transitions to falling when ground disappears
    Given the FSM is in the digging state
    And ground is 0
    When a rising clock edge occurs
    Then aaah should become 1
    And digging should be 0
    And walk_left should be 0
    And walk_right should be 0

  @digging @direction
  Formal Scenario: After digging through the ground, Lemming resumes original walking direction
    Given the FSM entered digging from the walk_left state
    And digging then transitioned to falling because ground became 0
    And the fall duration is less than or equal to 20 cycles
    And ground becomes 1
    When a rising clock edge occurs
    Then walk_left should become 1
    And walk_right should be 0
    And aaah should be 0
    And digging should be 0

  @digging @precedence
  Formal Scenario: Being bumped while digging has no effect
    Given the FSM is in the digging state
    And ground is 1
    And bump_left is any value
    And bump_right is any value
    When a rising clock edge occurs
    Then digging should remain 1
    And walk_left should be 0
    And walk_right should be 0

  @digging @precedence
  Formal Scenario: Dig request ignored while falling
    Given the FSM is in a falling state
    And ground is 0
    And dig is 1
    When a rising clock edge occurs
    Then aaah should remain 1
    And digging should be 0

  @digging @precedence
  Formal Scenario: Dig request ignored when there is no ground while walking
    Given the FSM is in the walk_left state or the walk_right state
    And ground is 0
    And dig is 1
    When a rising clock edge occurs
    Then aaah should become 1
    And digging should be 0

  @precedence
  Formal Scenario: Fall takes precedence over dig when both conditions occur simultaneously
    Given the FSM is in the walk_left state or the walk_right state
    And ground is 0
    And dig is 1
    When a rising clock edge occurs
    Then aaah should become 1
    And digging should be 0
    And walk_left should be 0
    And walk_right should be 0

  @precedence
  Formal Scenario: Dig takes precedence over direction switch when both conditions occur simultaneously
    Given the FSM is in the walk_left state or the walk_right state
    And ground is 1
    And dig is 1
    And bump_left is any value
    And bump_right is any value
    When a rising clock edge occurs
    Then digging should become 1
    And walk_left should be 0
    And walk_right should be 0
    And aaah should be 0

  @splatter
  Formal Scenario: Lemming splatters after falling more than 20 cycles then hitting ground
    Given the FSM enters a falling state at some cycle
    And ground remains 0 for more than 20 consecutive cycles thereafter
    And ground then becomes 1
    When a rising clock edge occurs
    Then walk_left should become 0
    And walk_right should become 0
    And aaah should become 0
    And digging should become 0
    And the FSM should be in the splattered state

  @splatter
  Formal Scenario: Lemming does not splatter if fall duration is at most 20 cycles
    Given the FSM enters a falling state at some cycle
    And ground remains 0 for at most 20 consecutive cycles thereafter
    And ground then becomes 1
    When a rising clock edge occurs
    Then the FSM should resume walking in the original pre-fall direction
    And the FSM should not be in the splattered state

  @splatter
  Formal Scenario: Lemming does not splatter while still falling in mid-air
    Given the FSM is falling
    And ground remains 0 for any number of consecutive cycles
    When a rising clock edge occurs
    Then aaah should remain 1
    And the FSM should not be in the splattered state

  @splatter @persistence
  Formal Scenario: Splattered state persists forever until reset
    Given the FSM is in the splattered state
    And bump_left is any value
    And bump_right is any value
    And ground is any value
    And dig is any value
    And areset is 0
    When a rising clock edge occurs
    Then walk_left should remain 0
    And walk_right should remain 0
    And aaah should remain 0
    And digging should remain 0
    And the FSM should remain in the splattered state

  @splatter @reset
  Formal Scenario: Asynchronous reset recovers the Lemming from splattered state
    Given the FSM is in the splattered state
    When areset is asserted to 1
    Then walk_left should become 1
    And walk_right should be 0
    And aaah should be 0
    And digging should be 0

  @output_consistency
  Formal Scenario: Exactly one output or none is asserted at any time
    Given any reachable state of the FSM
    Then at most one of walk_left, walk_right, aaah, digging should be 1
    And if the FSM is in the splattered state then all four outputs should be 0