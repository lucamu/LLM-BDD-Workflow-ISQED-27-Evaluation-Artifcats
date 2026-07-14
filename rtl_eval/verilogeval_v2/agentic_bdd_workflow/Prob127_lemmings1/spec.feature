Feature: Lemmings Walking Direction Finite State Machine

  As a hardware designer
  I want a two-state Moore machine that tracks Lemming walking direction
  So that the Lemming switches direction whenever it is bumped on a wall

  Background:
    Given a design named "TopModule"
    And an input "clk"
    And an input "areset"
    And an input "bump_left"
    And an input "bump_right"
    And an output "walk_left"
    And an output "walk_right"
    And all sequential logic is triggered on the positive edge of "clk"
    And "areset" is an asynchronous, active-high, positive-edge-triggered reset
    And the outputs "walk_left" and "walk_right" are mutually exclusive at all times
    And exactly one of "walk_left" or "walk_right" is 1 at all times

  @reset @async
  Formal Scenario: Asynchronous reset forces walk_left state regardless of clock
    Given "areset" is asserted to 1 at an arbitrary point in time
    And "bump_left" is any value
    And "bump_right" is any value
    When "areset" transitions from 0 to 1
    Then "walk_left" should become 1 immediately without waiting for a clock edge
    And "walk_right" should become 0 immediately without waiting for a clock edge

  @reset @hold
  Formal Scenario: State remains walk_left while areset is held high
    Given "areset" is 1
    And "bump_left" is any value
    And "bump_right" is any value
    When a rising edge occurs on "clk"
    Then "walk_left" should be 1
    And "walk_right" should be 0

  @reset @initial
  Formal Scenario: After reset deassertion the machine starts in walk_left
    Given "areset" was 1 and is deasserted to 0
    And "bump_left" is 0
    And "bump_right" is 0
    When a rising edge occurs on "clk" with "areset" equal to 0
    Then "walk_left" should be 1
    And "walk_right" should be 0

  @transition @bump_left
  Formal Scenario: Walking left switches to walking right when bumped on the left only
    Given "areset" is 0
    And the current state is walk_left ("walk_left" is 1 and "walk_right" is 0)
    And "bump_left" is 1
    And "bump_right" is 0
    When a rising edge occurs on "clk"
    Then "walk_right" should become 1
    And "walk_left" should become 0

  @transition @bump_right
  Formal Scenario: Walking right switches to walking left when bumped on the right only
    Given "areset" is 0
    And the current state is walk_right ("walk_right" is 1 and "walk_left" is 0)
    And "bump_right" is 1
    And "bump_left" is 0
    When a rising edge occurs on "clk"
    Then "walk_left" should become 1
    And "walk_right" should become 0

  @transition @bump_both
  Formal Scenario: Walking left switches to walking right when bumped on both sides
    Given "areset" is 0
    And the current state is walk_left ("walk_left" is 1 and "walk_right" is 0)
    And "bump_left" is 1
    And "bump_right" is 1
    When a rising edge occurs on "clk"
    Then "walk_right" should become 1
    And "walk_left" should become 0

  @transition @bump_both
  Formal Scenario: Walking right switches to walking left when bumped on both sides
    Given "areset" is 0
    And the current state is walk_right ("walk_right" is 1 and "walk_left" is 0)
    And "bump_left" is 1
    And "bump_right" is 1
    When a rising edge occurs on "clk"
    Then "walk_left" should become 1
    And "walk_right" should become 0

  @stability @no_bump
  Formal Scenario: Walking left remains walking left when not bumped
    Given "areset" is 0
    And the current state is walk_left ("walk_left" is 1 and "walk_right" is 0)
    And "bump_left" is 0
    And "bump_right" is 0
    When a rising edge occurs on "clk"
    Then "walk_left" should remain 1
    And "walk_right" should remain 0

  @stability @no_bump
  Formal Scenario: Walking right remains walking right when not bumped
    Given "areset" is 0
    And the current state is walk_right ("walk_right" is 1 and "walk_left" is 0)
    And "bump_left" is 0
    And "bump_right" is 0
    When a rising edge occurs on "clk"
    Then "walk_right" should remain 1
    And "walk_left" should remain 0

  @stability @bump_right_while_left_ignored
  Formal Scenario: Walking left is unaffected by a right-only bump combined with no left bump
    Given "areset" is 0
    And the current state is walk_left ("walk_left" is 1 and "walk_right" is 0)
    And "bump_left" is 0
    And "bump_right" is 1
    When a rising edge occurs on "clk"
    Then "walk_right" should become 1
    And "walk_left" should become 0

  @stability @bump_left_while_right_ignored
  Formal Scenario: Walking right is unaffected by a left-only bump combined with no right bump
    Given "areset" is 0
    And the current state is walk_right ("walk_right" is 1 and "walk_left" is 0)
    And "bump_left" is 1
    And "bump_right" is 0
    When a rising edge occurs on "clk"
    Then "walk_left" should become 1
    And "walk_right" should become 0

  @invariant @mutual_exclusion
  Formal Scenario: Outputs are always mutually exclusive and one-hot across any inputs
    Given "areset" is any value
    And "bump_left" is any value
    And "bump_right" is any value
    When a rising edge occurs on "clk"
    Then exactly one of "walk_left" and "walk_right" should be 1
    And "walk_left" XOR "walk_right" should equal 1