Feature: Single-Stage Inverting Flip-Flop

  The TopModule captures the input `a` at each rising clock edge and
  produces an output `q` that equals the logical NOT of the value `a`
  held at the immediately preceding rising clock edge. There is no
  reset; the one-cycle inverting latency must hold in steady state
  for any sequence of input values.

  Background:
    Given a clock signal "clk" that triggers all sequential logic on its positive edge
    And no reset signal exists for this design
    And the output "q" is only formally defined once at least one rising clock edge has occurred since power-up

  @core_behavior
  Formal Scenario: Output equals NOT of input sampled one clock edge earlier
    Given the input "a" holds a symbolic value A at rising clock edge N
    And at least one rising clock edge has already occurred prior to edge N
    When one rising clock edge elapses since "a" held value A
    Then the output "q" should equal the logical NOT of A

  @stable_input
  Formal Scenario: Output stays at inverted value while input remains constant
    Given the input "a" holds a constant symbolic value A for at least two consecutive rising clock edges
    And the one-cycle inverting latency has already elapsed since "a" first became A
    When an additional rising clock edge occurs while "a" remains equal to A
    Then the output "q" should equal the logical NOT of A

  @input_transition
  Formal Scenario: Output reflects old value immediately after an input change, then updates
    Given the input "a" holds a symbolic value A at rising clock edge N
    And the input "a" changes to a different symbolic value B at rising clock edge N plus one
    And the one-cycle inverting latency has already elapsed for value A prior to the change
    When one rising clock edge occurs after the change to B
    Then the output "q" should equal the logical NOT of B

  @toggling_input
  Formal Scenario: Output tracks alternating input values with fixed one-cycle delay
    Given the input "a" alternates between symbolic values A and B on successive rising clock edges
    And the one-cycle inverting latency has already elapsed since the alternation began
    When the current rising clock edge samples "a" as value A
    Then the output "q" one clock edge later should equal the logical NOT of A
    When the current rising clock edge samples "a" as value B
    Then the output "q" one clock edge later should equal the logical NOT of B

  @undefined_initial_state
  Formal Scenario: Output is unconstrained before the first rising clock edge
    Given no rising clock edge has occurred since power-up
    When the output "q" is observed at this time
    Then the value of "q" is not formally constrained by any value of "a"