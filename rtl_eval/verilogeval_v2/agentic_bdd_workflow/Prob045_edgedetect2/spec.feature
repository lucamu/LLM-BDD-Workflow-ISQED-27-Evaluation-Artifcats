Feature: Any-Edge Detector for 8-bit Input Vector

  As a hardware designer
  I want each bit of an 8-bit output vector to indicate whether the
  corresponding input bit changed value on the previous clock edge
  So that any 0-to-1 or 1-to-0 transition is flagged exactly one cycle later

  Background:
    Given a synchronous design with input "clk"
    And an 8-bit input vector "in"
    And an 8-bit output vector "anyedge"
    And all sequential logic is triggered on the positive edge of "clk"

  @edge_detect @rising
  Formal Scenario: Detect a 0-to-1 transition on a single bit
    Given in previous cycle "in" bit i holds value 0
    And in current cycle "in" bit i holds value 1
    When the next positive edge of clk occurs
    Then anyedge bit i should be 1 in the following cycle

  @edge_detect @falling
  Formal Scenario: Detect a 1-to-0 transition on a single bit
    Given in previous cycle "in" bit i holds value 1
    And in current cycle "in" bit i holds value 0
    When the next positive edge of clk occurs
    Then anyedge bit i should be 1 in the following cycle

  @edge_detect @stable
  Formal Scenario: No edge reported when a bit remains stable
    Given in previous cycle "in" bit i holds value X
    And in current cycle "in" bit i holds value X
    When the next positive edge of clk occurs
    Then anyedge bit i should be 0 in the following cycle

  @edge_detect @xor_relation
  Formal Scenario: Anyedge output equals XOR of consecutive input samples
    Given in previous cycle "in" bit i holds value A
    And in current cycle "in" bit i holds value B
    When the next positive edge of clk occurs
    Then anyedge bit i should be A xor B in the following cycle

  @edge_detect @per_bit_independence
  Formal Scenario: Each bit of anyedge depends only on the corresponding bit of in
    Given in previous cycle "in" bit i holds value A_i
    And in current cycle "in" bit i holds value B_i
    And in previous cycle "in" bit j holds value A_j where j is not equal to i
    And in current cycle "in" bit j holds value B_j where j is not equal to i
    When the next positive edge of clk occurs
    Then anyedge bit i should be A_i xor B_i in the following cycle
    And anyedge bit j should be A_j xor B_j in the following cycle
    And anyedge bit i should not depend on A_j or B_j
    And anyedge bit j should not depend on A_i or B_i

  @edge_detect @full_vector
  Formal Scenario: Full 8-bit anyedge vector equals bitwise XOR of consecutive samples
    Given in previous cycle "in" holds value VecA (8 bits)
    And in current cycle "in" holds value VecB (8 bits)
    When the next positive edge of clk occurs
    Then anyedge should equal VecA xor VecB in the following cycle

  @edge_detect @multi_bit_toggle
  Formal Scenario: Multiple simultaneous bit transitions are all detected
    Given in previous cycle "in" holds value VecA (8 bits)
    And in current cycle "in" holds value VecB (8 bits) where VecB differs from VecA in more than one bit
    When the next positive edge of clk occurs
    Then anyedge should equal VecA xor VecB in the following cycle
    And every bit position where VecA differs from VecB should have anyedge equal to 1
    And every bit position where VecA equals VecB should have anyedge equal to 0

  @edge_detect @no_false_positive
  Formal Scenario: No edge is ever asserted when the entire vector is unchanged
    Given in previous cycle "in" holds value Vec (8 bits)
    And in current cycle "in" holds value Vec (8 bits)
    When the next positive edge of clk occurs
    Then anyedge should equal 8'b00000000 in the following cycle