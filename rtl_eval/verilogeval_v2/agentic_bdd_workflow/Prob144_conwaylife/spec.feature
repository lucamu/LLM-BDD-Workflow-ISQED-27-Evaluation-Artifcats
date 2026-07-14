Feature: 16x16 Toroidal Conway's Game of Life

  As a hardware designer
  I want to verify the TopModule implements Conway's Game of Life
  on a 16x16 toroidal grid with synchronous load
  So that state transitions and neighbor wraparound are correct

  Background:
    Given a synchronous design with input clk
    And input load
    And input data of width 256 bits representing a 16x16 grid where row r occupies bits [16r+15 : 16r]
    And output q of width 256 bits representing the current 16x16 grid state with the same encoding
    And all sequential updates occur on the positive edge of clk
    And row index r ranges from 0 to 15
    And column index c ranges from 0 to 15
    And neighbor row indices are defined as north equal to (r + 15) mod 16 and south equal to (r + 1) mod 16
    And neighbor column indices are defined as west equal to (c + 15) mod 16 and east equal to (c + 1) mod 16
    And the cell at row r column c is bit q[16*r + c]

  @load @synchronous
  Formal Scenario: Loading data overrides current state on next clock edge
    Given load is 1
    And data is value D
    And q is any current state
    When a positive clock edge occurs
    Then q should equal D

  @load @priority
  Formal Scenario: Load has priority over game evolution
    Given load is 1
    And data is value D
    And q is any current state S where at least one cell would change under game rules
    When a positive clock edge occurs
    Then q should equal D
    And q should not depend on S

  @hold @no-load
  Formal Scenario: Game evolves according to neighbor count when load is inactive
    Given load is 0
    And q is current state S
    And cell (r, c) has live neighbor count N, computed as the sum of the 8 toroidal neighbor bits of S at row r column c
    When a positive clock edge occurs
    Then the next value of q[16*r + c] should equal 1 if N equals 3
    And the next value of q[16*r + c] should equal S[16*r + c] if N equals 2
    And the next value of q[16*r + c] should equal 0 if N is less than 2
    And the next value of q[16*r + c] should equal 0 if N is greater than 3

  @underpopulation
  Formal Scenario: Cell with 0 or 1 live neighbors dies
    Given load is 0
    And q is current state S
    And cell (r, c) has live neighbor count N where N equals 0 or N equals 1
    When a positive clock edge occurs
    Then the next value of q[16*r + c] should equal 0

  @survival
  Formal Scenario: Cell with exactly 2 live neighbors retains its state
    Given load is 0
    And q is current state S
    And cell (r, c) has live neighbor count N where N equals 2
    When a positive clock edge occurs
    Then the next value of q[16*r + c] should equal S[16*r + c]

  @reproduction
  Formal Scenario: Dead or alive cell with exactly 3 live neighbors becomes alive
    Given load is 0
    And q is current state S
    And cell (r, c) has live neighbor count N where N equals 3
    When a positive clock edge occurs
    Then the next value of q[16*r + c] should equal 1

  @overpopulation
  Formal Scenario: Cell with 4 or more live neighbors dies
    Given load is 0
    And q is current state S
    And cell (r, c) has live neighbor count N where N is greater than or equal to 4
    When a positive clock edge occurs
    Then the next value of q[16*r + c] should equal 0

  @toroid @corner
  Formal Scenario: Corner cell (0,0) wraps around on all sides
    Given load is 0
    And q is current state S
    And the 8 neighbors of cell (0, 0) are S[16*15 + 1], S[16*15 + 0], S[16*15 + 15], S[16*0 + 1], S[16*0 + 15], S[16*1 + 1], S[16*1 + 0], S[16*1 + 15]
    And N is the sum of these 8 neighbor bits
    When a positive clock edge occurs
    Then the next value of q[0] should equal 1 if N equals 3
    And the next value of q[0] should equal S[0] if N equals 2
    And the next value of q[0] should equal 0 if N is less than 2
    And the next value of q[0] should equal 0 if N is greater than 3

  @toroid @edge
  Formal Scenario: Top-edge cell wraps vertically to bottom row
    Given load is 0
    And q is current state S
    And column c is any value from 0 to 15
    And the north row for cell (0, c) is row 15 due to toroidal wraparound
    And the 8 neighbors of cell (0, c) include S[16*15 + west], S[16*15 + c], S[16*15 + east], S[16*0 + west], S[16*0 + east], S[16*1 + west], S[16*1 + c], S[16*1 + east]
    And N is the sum of these 8 neighbor bits
    When a positive clock edge occurs
    Then the next value of q[16*0 + c] should equal 1 if N equals 3
    And the next value of q[16*0 + c] should equal S[16*0 + c] if N equals 2
    And the next value of q[16*0 + c] should equal 0 if N is less than 2
    And the next value of q[16*0 + c] should equal 0 if N is greater than 3

  @toroid @edge
  Formal Scenario: Left-edge cell wraps horizontally to rightmost column
    Given load is 0
    And q is current state S
    And row r is any value from 0 to 15
    And the west column for cell (r, 0) is column 15 due to toroidal wraparound
    And the 8 neighbors of cell (r, 0) include S[16*north + 15], S[16*north + 0], S[16*north + 1], S[16*r + 15], S[16*r + 1], S[16*south + 15], S[16*south + 0], S[16*south + 1]
    And N is the sum of these 8 neighbor bits
    When a positive clock edge occurs
    Then the next value of q[16*r + 0] should equal 1 if N equals 3
    And the next value of q[16*r + 0] should equal S[16*r + 0] if N equals 2
    And the next value of q[16*r + 0] should equal 0 if N is less than 2
    And the next value of q[16*r + 0] should equal 0 if N is greater than 3

  @stability @no-load
  Formal Scenario: All-dead grid remains all-dead
    Given load is 0
    And q is current state S where every bit of S equals 0
    When a positive clock edge occurs
    Then q should equal 256'b0

  @determinism
  Formal Scenario: Next state depends only on current state and load, not on data when load is 0
    Given load is 0
    And q is current state S
    And data is any value D1
    When a positive clock edge occurs
    Then the next value of q should be independent of D1
    And the next value of q should be a function of S only, following the neighbor count rules