Feature: Lemmings Finite State Machine Control Logic

  As a hardware designer
  I want to verify the Lemmings walking/falling/digging FSM
  So that direction changes, falling, and digging obey the specified priority rules

  Background:
    Given a clock "clk" with rising-edge-triggered sequential logic
    And an asynchronous active-high reset "areset"
    And the signals "bump_left", "bump_right", "ground", "dig" are inputs
    And the signals "walk_left", "walk_right", "aaah", "digging" are Moore outputs
    And at most one of "walk_left", "walk_right", "aaah", "digging" is 1 in any cycle

  @reset @async
  Formal Scenario: Asynchronous reset forces walk-left state
    Given any value of bump_left, bump_right, ground, dig
    And any current state of walk_left, walk_right, aaah, digging
    When areset is asserted asynchronously
    Then walk_left should become 1 immediately, independent of clk edge
    And walk_right should become 0 immediately
    And aaah should become 0 immediately
    And digging should become 0 immediately

  @reset @sync
  Formal Scenario: Reset holds walk-left while asserted across clock edges
    Given areset is held at 1
    And any values of bump_left, bump_right, ground, dig
    When a rising edge of clk occurs
    Then walk_left should remain 1
    And walk_right should remain 0
    And aaah should remain 0
    And digging should remain 0

  @walk @bump_left
  Formal Scenario: Walking left switches to walking right on left bump only
    Given areset is 0
    And walk_left is 1 and walk_right is 0 and aaah is 0 and digging is 0
    And ground is 1
    And bump_left is 1 and bump_right is 0
    And dig is 0
    When a rising edge of clk occurs
    Then walk_right should become 1
    And walk_left should become 0
    And aaah should become 0
    And digging should become 0

  @walk @bump_right
  Formal Scenario: Walking left stays walking left on right bump only
    Given areset is 0
    And walk_left is 1 and walk_right is 0 and aaah is 0 and digging is 0
    And ground is 1
    And bump_left is 0 and bump_right is 1
    And dig is 0
    When a rising edge of clk occurs
    Then walk_left should remain 1
    And walk_right should remain 0
    And aaah should remain 0
    And digging should remain 0

  @walk @bump_both
  Formal Scenario: Walking left toggles to walking right when bumped on both sides
    Given areset is 0
    And walk_left is 1 and walk_right is 0 and aaah is 0 and digging is 0
    And ground is 1
    And bump_left is 1 and bump_right is 1
    And dig is 0
    When a rising edge of clk occurs
    Then walk_right should become 1
    And walk_left should become 0

  @walk @bump_right
  Formal Scenario: Walking right switches to walking left on right bump only
    Given areset is 0
    And walk_right is 1 and walk_left is 0 and aaah is 0 and digging is 0
    And ground is 1
    And bump_right is 1 and bump_left is 0
    And dig is 0
    When a rising edge of clk occurs
    Then walk_left should become 1
    And walk_right should become 0

  @walk @bump_left
  Formal Scenario: Walking right stays walking right on left bump only
    Given areset is 0
    And walk_right is 1 and walk_left is 0 and aaah is 0 and digging is 0
    And ground is 1
    And bump_left is 1 and bump_right is 0
    And dig is 0
    When a rising edge of clk occurs
    Then walk_right should remain 1
    And walk_left should remain 0

  @walk @bump_both
  Formal Scenario: Walking right toggles to walking left when bumped on both sides
    Given areset is 0
    And walk_right is 1 and walk_left is 0 and aaah is 0 and digging is 0
    And ground is 1
    And bump_left is 1 and bump_right is 1
    And dig is 0
    When a rising edge of clk occurs
    Then walk_left should become 1
    And walk_right should become 0

  @fall @ground_loss
  Formal Scenario: Walking Lemming falls when ground disappears
    Given areset is 0
    And exactly one of walk_left or walk_right is 1
    And ground is 0
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then aaah should become 1
    And walk_left should become 0
    And walk_right should become 0
    And digging should become 0

  @fall @bump_ignored
  Formal Scenario: Bumps while falling do not change stored direction
    Given areset is 0
    And aaah is 1
    And ground is 0
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then aaah should remain 1
    And walk_left should remain 0
    And walk_right should remain 0

  @fall @resume_left
  Formal Scenario: Falling Lemming resumes walking left when ground reappears
    Given areset is 0
    And walk_left was 1 immediately before falling began
    And aaah is 1
    And ground is 1
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then walk_left should become 1
    And walk_right should become 0
    And aaah should become 0

  @fall @resume_right
  Formal Scenario: Falling Lemming resumes walking right when ground reappears
    Given areset is 0
    And walk_right was 1 immediately before falling began
    And aaah is 1
    And ground is 1
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then walk_right should become 1
    And walk_left should become 0
    And aaah should become 0

  @fall @same_cycle_bump
  Formal Scenario: Bump in the same cycle ground disappears does not affect stored direction
    Given areset is 0
    And walk_left is 1 and walk_right is 0 and aaah is 0 and digging is 0
    And ground transitions from 1 to 0 in this cycle
    And bump_left is 1 or bump_right is 1
    And dig is 0
    When a rising edge of clk occurs
    Then aaah should become 1
    And walk_left should become 0
    And walk_right should become 0
    And when ground later returns to 1 with no further bumps, walk_left should become 1

  @dig @start
  Formal Scenario: Walking Lemming on ground starts digging when told to dig
    Given areset is 0
    And exactly one of walk_left or walk_right is 1
    And ground is 1
    And dig is 1
    And any values of bump_left, bump_right
    When a rising edge of clk occurs
    Then digging should become 1
    And aaah should become 0
    And walk_left should become 0
    And walk_right should become 0

  @dig @continue
  Formal Scenario: Digging continues while ground remains present
    Given areset is 0
    And digging is 1
    And ground is 1
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then digging should remain 1
    And aaah should remain 0

  @dig @fall_transition
  Formal Scenario: Digging Lemming falls when ground disappears beneath it
    Given areset is 0
    And digging is 1
    And ground is 0
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then aaah should become 1
    And digging should become 0
    And walk_left should become 0
    And walk_right should become 0

  @dig @resume_left
  Formal Scenario: Lemming resumes walking left after falling out of a dig
    Given areset is 0
    And walk_left was 1 immediately before digging began
    And digging transitioned to falling due to loss of ground
    And aaah is 1
    And ground is 1
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then walk_left should become 1
    And walk_right should become 0
    And aaah should become 0

  @dig @resume_right
  Formal Scenario: Lemming resumes walking right after falling out of a dig
    Given areset is 0
    And walk_right was 1 immediately before digging began
    And digging transitioned to falling due to loss of ground
    And aaah is 1
    And ground is 1
    And any values of bump_left, bump_right, dig
    When a rising edge of clk occurs
    Then walk_right should become 1
    And walk_left should become 0
    And aaah should become 0

  @dig @bump_ignored
  Formal Scenario: Bumps while digging have no effect on digging state
    Given areset is 0
    And digging is 1
    And ground is 1
    And bump_left is 1 or bump_right is 1
    And any value of dig
    When a rising edge of clk occurs
    Then digging should remain 1
    And walk_left should remain 0
    And walk_right should remain 0

  @dig @ignored_while_falling
  Formal Scenario: Dig request while falling is ignored
    Given areset is 0
    And aaah is 1
    And ground is 0
    And dig is 1
    And any values of bump_left, bump_right
    When a rising edge of clk occurs
    Then aaah should remain 1
    And digging should remain 0

  @dig @ignored_without_ground
  Formal Scenario: Dig request while walking with no ground causes fall, not dig
    Given areset is 0
    And exactly one of walk_left or walk_right is 1
    And ground is 0
    And dig is 1
    And any values of bump_left, bump_right
    When a rising edge of clk occurs
    Then aaah should become 1
    And digging should become 0

  @priority @fall_over_dig
  Formal Scenario: Fall takes precedence over dig when both conditions occur
    Given areset is 0
    And exactly one of walk_left or walk_right is 1
    And ground is 0
    And dig is 1
    And any values of bump_left, bump_right
    When a rising edge of clk occurs
    Then aaah should become 1
    And digging should become 0

  @priority @dig_over_bump
  Formal Scenario: Dig takes precedence over direction switch when both conditions occur
    Given areset is 0
    And exactly one of walk_left or walk_right is 1
    And ground is 1
    And dig is 1
    And bump_left is 1 or bump_right is 1
    When a rising edge of clk occurs
    Then digging should become 1
    And walk_left should become 0
    And walk_right should become 0

  @invariant @mutual_exclusion
  Formal Scenario: Output states are mutually exclusive in every reachable cycle
    Given areset is 0
    And any legal combination of bump_left, bump_right, ground, dig
    When a rising edge of clk occurs
    Then at most one of walk_left, walk_right, aaah, digging should be 1

  @invariant @no_dig_without_ground
  Formal Scenario: Digging output is never asserted when ground is absent
    Given areset is 0
    And ground is 0
    When a rising edge of clk occurs
    Then digging should be 0