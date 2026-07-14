Feature: Lemmings Walking Direction Finite State Machine

  As a hardware designer
  I want to verify the Lemmings FSM controller
  So that walk_left, walk_right, and aaah are always correctly derived from bump_left, bump_right, and ground history

  Background:
    Given a clock "clk" with positive edge triggering all sequential logic
    And an asynchronous active-high reset "areset"
    And inputs "bump_left", "bump_right", "ground"
    And outputs "walk_left", "walk_right", "aaah"
    And the design implements a Moore state machine with states WALK_LEFT, WALK_RIGHT, FALL_LEFT, FALL_RIGHT
    And exactly one of "walk_left", "walk_right", "aaah" is 1 at any time

  @reset
  Formal Scenario: Asynchronous reset forces walk_left state
    Given any current state
    When areset is asserted asynchronously
    Then walk_left should become 1
    And walk_right should become 0
    And aaah should become 0

  @reset
  Formal Scenario: Reset holds walk_left regardless of inputs
    Given areset is held at 1
    And bump_left, bump_right, and ground are any values
    When a positive clock edge occurs
    Then walk_left should remain 1
    And walk_right should remain 0
    And aaah should remain 0

  @walking
  Formal Scenario: Walking left continues when no bump and ground present
    Given areset is deasserted
    And the current state is WALK_LEFT
    And ground is 1
    And bump_left is 0
    When a positive clock edge occurs
    Then the next state should be WALK_LEFT
    And walk_left should be 1
    And walk_right should be 0
    And aaah should be 0

  @walking
  Formal Scenario: Walking right continues when no bump and ground present
    Given areset is deasserted
    And the current state is WALK_RIGHT
    And ground is 1
    And bump_right is 0
    When a positive clock edge occurs
    Then the next state should be WALK_RIGHT
    And walk_left should be 0
    And walk_right should be 1
    And aaah should be 0

  @bump
  Formal Scenario: Bump on left while walking left switches to walking right
    Given areset is deasserted
    And the current state is WALK_LEFT
    And ground is 1
    And bump_left is 1
    When a positive clock edge occurs
    Then the next state should be WALK_RIGHT
    And walk_right should be 1
    And walk_left should be 0
    And aaah should be 0

  @bump
  Formal Scenario: Bump on right while walking right switches to walking left
    Given areset is deasserted
    And the current state is WALK_RIGHT
    And ground is 1
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be WALK_LEFT
    And walk_left should be 1
    And walk_right should be 0
    And aaah should be 0

  @bump
  Formal Scenario: Simultaneous bump on both sides while walking left still switches direction
    Given areset is deasserted
    And the current state is WALK_LEFT
    And ground is 1
    And bump_left is 1
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be WALK_RIGHT
    And walk_right should be 1
    And walk_left should be 0

  @bump
  Formal Scenario: Simultaneous bump on both sides while walking right still switches direction
    Given areset is deasserted
    And the current state is WALK_RIGHT
    And ground is 1
    And bump_left is 1
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be WALK_LEFT
    And walk_left should be 1
    And walk_right should be 0

  @bump
  Formal Scenario: Bump on right while walking left has no effect on direction
    Given areset is deasserted
    And the current state is WALK_LEFT
    And ground is 1
    And bump_left is 0
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be WALK_LEFT
    And walk_left should be 1
    And walk_right should be 0

  @bump
  Formal Scenario: Bump on left while walking right has no effect on direction
    Given areset is deasserted
    And the current state is WALK_RIGHT
    And ground is 1
    And bump_left is 1
    And bump_right is 0
    When a positive clock edge occurs
    Then the next state should be WALK_RIGHT
    And walk_right should be 1
    And walk_left should be 0

  @falling
  Formal Scenario: Losing ground while walking left transitions to falling and asserts aaah
    Given areset is deasserted
    And the current state is WALK_LEFT
    And ground is 0
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be FALL_LEFT
    And aaah should be 1
    And walk_left should be 0
    And walk_right should be 0

  @falling
  Formal Scenario: Losing ground while walking right transitions to falling and asserts aaah
    Given areset is deasserted
    And the current state is WALK_RIGHT
    And ground is 0
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be FALL_RIGHT
    And aaah should be 1
    And walk_left should be 0
    And walk_right should be 0

  @falling
  Formal Scenario: Remaining airborne while falling left continues to assert aaah
    Given areset is deasserted
    And the current state is FALL_LEFT
    And ground is 0
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be FALL_LEFT
    And aaah should be 1
    And walk_left should be 0
    And walk_right should be 0

  @falling
  Formal Scenario: Remaining airborne while falling right continues to assert aaah
    Given areset is deasserted
    And the current state is FALL_RIGHT
    And ground is 0
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be FALL_RIGHT
    And aaah should be 1
    And walk_left should be 0
    And walk_right should be 0

  @falling
  Formal Scenario: Bumping during a leftward fall does not affect resumed direction
    Given areset is deasserted
    And the current state is FALL_LEFT
    And ground is 0
    And bump_left is 1
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be FALL_LEFT
    And aaah should be 1

  @falling
  Formal Scenario: Bumping during a rightward fall does not affect resumed direction
    Given areset is deasserted
    And the current state is FALL_RIGHT
    And ground is 0
    And bump_left is 1
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be FALL_RIGHT
    And aaah should be 1

  @falling @resume
  Formal Scenario: Ground reappears while falling left resumes walking left
    Given areset is deasserted
    And the current state is FALL_LEFT
    And ground is 1
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be WALK_LEFT
    And walk_left should be 1
    And walk_right should be 0
    And aaah should be 0

  @falling @resume
  Formal Scenario: Ground reappears while falling right resumes walking right
    Given areset is deasserted
    And the current state is FALL_RIGHT
    And ground is 1
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be WALK_RIGHT
    And walk_left should be 0
    And walk_right should be 1
    And aaah should be 0

  @falling @edge
  Formal Scenario: Bump concurrent with ground loss while walking left still transitions to falling left
    Given areset is deasserted
    And the current state is WALK_LEFT
    And ground is 0
    And bump_left is 1
    When a positive clock edge occurs
    Then the next state should be FALL_LEFT
    And aaah should be 1

  @falling @edge
  Formal Scenario: Ground reappearing after a bump-concurrent leftward fall resumes walking left
    Given areset is deasserted
    And the current state is FALL_LEFT
    And ground is 1
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be WALK_LEFT
    And walk_left should be 1

  @falling @edge
  Formal Scenario: Bump concurrent with ground loss while walking right still transitions to falling right
    Given areset is deasserted
    And the current state is WALK_RIGHT
    And ground is 0
    And bump_right is 1
    When a positive clock edge occurs
    Then the next state should be FALL_RIGHT
    And aaah should be 1

  @falling @edge
  Formal Scenario: Ground reappearing after a bump-concurrent rightward fall resumes walking right
    Given areset is deasserted
    And the current state is FALL_RIGHT
    And ground is 1
    And bump_left and bump_right are any values
    When a positive clock edge occurs
    Then the next state should be WALK_RIGHT
    And walk_right should be 1

  @invariant
  Formal Scenario: Aaah is asserted if and only if the current state is a falling state
    Given areset is deasserted
    And the current state is any valid state
    Then aaah should be 1 if and only if the current state is FALL_LEFT or FALL_RIGHT

  @invariant
  Formal Scenario: Walk outputs are mutually exclusive with aaah
    Given areset is deasserted
    And the current state is any valid state
    When a positive clock edge occurs
    Then walk_left AND walk_right should never both be 1
    And aaah AND walk_left should never both be 1
    And aaah AND walk_right should never both be 1