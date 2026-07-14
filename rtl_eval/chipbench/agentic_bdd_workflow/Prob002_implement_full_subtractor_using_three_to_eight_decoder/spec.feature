# ── module: subtractor_logic ──
Feature: Full-Subtractor Output Logic from Active-Low Decoder Outputs

  Combinational logic that reconstructs the full-subtractor outputs D
  (difference) and Co (borrow-out) from the eight active-low decoder
  outputs Y0n..Y7n, where the decoder inputs are address bits
  {A2=Ci, A1=B, A0=A}. The module contains only NAND/OR gate logic and
  does not instantiate the decoder itself.

  Background:
    Given the design is purely combinational with no clock or reset
    And the decoder output signals Y0n, Y1n, Y2n, Y3n, Y4n, Y5n, Y6n, Y7n are active-low
    And exactly one of Y0n..Y7n is 0 for any valid address combination {A, B, Ci}
    And D is computed as NOT (Y1n AND Y2n AND Y4n AND Y7n)
    And Co is computed as NOT (Y2n AND Y4n AND Y6n AND Y7n)

  @combinational @difference_output
  Formal Scenario: Difference output asserted when any active-low D-minterm is active
    Given active-low decoder outputs Y1n, Y2n, Y4n, Y7n
    When Y1n is 0 or Y2n is 0 or Y4n is 0 or Y7n is 0
    Then D should be 1

  @combinational @difference_output
  Formal Scenario: Difference output deasserted when all D-minterms are inactive
    Given active-low decoder outputs Y1n, Y2n, Y4n, Y7n
    When Y1n is 1 and Y2n is 1 and Y4n is 1 and Y7n is 1
    Then D should be 0

  @combinational @borrow_output
  Formal Scenario: Borrow-out asserted when any active-low Co-minterm is active
    Given active-low decoder outputs Y2n, Y4n, Y6n, Y7n
    When Y2n is 0 or Y4n is 0 or Y6n is 0 or Y7n is 0
    Then Co should be 1

  @combinational @borrow_output
  Formal Scenario: Borrow-out deasserted when all Co-minterms are inactive
    Given active-low decoder outputs Y2n, Y4n, Y6n, Y7n
    When Y2n is 1 and Y4n is 1 and Y6n is 1 and Y7n is 1
    Then Co should be 0

  @combinational @functional_equivalence
  Formal Scenario: Difference output matches full-subtractor truth table via one-hot decoder activation
    Given a one-hot active-low decoder output pattern corresponding to address {A, B, Ci}
    And Yn(index) is 0 only when index equals the decimal value of {Ci, B, A} and 1 otherwise
    When the decoder output pattern is applied to the logic
    Then D should equal A XOR B XOR Ci

  @combinational @functional_equivalence
  Formal Scenario: Borrow-out output matches full-subtractor truth table via one-hot decoder activation
    Given a one-hot active-low decoder output pattern corresponding to address {A, B, Ci}
    And Yn(index) is 0 only when index equals the decimal value of {Ci, B, A} and 1 otherwise
    When the decoder output pattern is applied to the logic
    Then Co should equal (NOT A AND B) OR (NOT A AND Ci) OR (B AND Ci)

  @combinational @independence
  Formal Scenario: Difference output is independent of non-contributing decoder outputs
    Given active-low decoder outputs Y0n, Y3n, Y5n, Y6n
    And active-low decoder outputs Y1n, Y2n, Y4n, Y7n held at a fixed symbolic value
    When Y0n, Y3n, Y5n, Y6n take any combination of values
    Then D should remain unchanged for any value of Y0n, Y3n, Y5n, Y6n

  @combinational @independence
  Formal Scenario: Borrow-out output is independent of non-contributing decoder outputs
    Given active-low decoder outputs Y0n, Y1n, Y3n, Y5n
    And active-low decoder outputs Y2n, Y4n, Y6n, Y7n held at a fixed symbolic value
    When Y0n, Y1n, Y3n, Y5n take any combination of values
    Then Co should remain unchanged for any value of Y0n, Y1n, Y3n, Y5n

  @combinational @no_state
  Formal Scenario: Outputs are purely combinational functions of current decoder inputs
    Given any two evaluation instants where Y0n..Y7n are identical
    When the logic is evaluated at both instants
    Then D should be identical at both instants
    And Co should be identical at both instants

# ── module: TopModule ──
Feature: Full Subtractor Implemented Using 3-to-8 Decoder

  As a hardware designer
  I want to verify a full subtractor built from a 3-to-8 decoder and gates
  So that the difference (D) and borrow-out (Co) outputs are correct for
  all combinations of minuend (A), subtrahend (B), and borrow-in (Ci)

  Background:
    Given the design TopModule is purely combinational
    And there is no clock or reset signal
    And the internal decoder_38 instance has its enable input E tied to 1
    And A0, A1, A2 of the decoder are connected to Ci, B, A respectively

  @core_logic @symbolic
  Formal Scenario: Difference output follows XOR relationship
    Given A is an arbitrary single-bit value
    And B is an arbitrary single-bit value
    And Ci is an arbitrary single-bit value
    When the circuit evaluates combinationally
    Then D should equal A ^ B ^ Ci

  @core_logic @symbolic
  Formal Scenario: Borrow output follows subtractor borrow equation
    Given A is an arbitrary single-bit value
    And B is an arbitrary single-bit value
    And Ci is an arbitrary single-bit value
    When the circuit evaluates combinationally
    Then Co should equal ((~A & B) | (~A & Ci) | (B & Ci))

  @decoder_property
  Formal Scenario: Decoder activates exactly one output line per input combination
    Given A is an arbitrary single-bit value
    And B is an arbitrary single-bit value
    And Ci is an arbitrary single-bit value
    And the decoder enable E is 1
    When the address {A2,A1,A0} is driven by {A,B,Ci}
    Then exactly one of Y0n, Y1n, Y2n, Y3n, Y4n, Y5n, Y6n, Y7n should be 0
    And all remaining decoder outputs should be 1
    And the index of the active-low output should equal the binary value of {A,B,Ci}

  @corner_case
  Formal Scenario: No borrow condition when all inputs are zero
    Given A = 1'b0
    And B = 1'b0
    And Ci = 1'b0
    When the circuit evaluates combinationally
    Then D should be 1'b0
    And Co should be 1'b0

  @corner_case
  Formal Scenario: Borrow-in only produces borrow and difference
    Given A = 1'b0
    And B = 1'b0
    And Ci = 1'b1
    When the circuit evaluates combinationally
    Then D should be 1'b1
    And Co should be 1'b1

  @corner_case
  Formal Scenario: Subtrahend only produces borrow and difference
    Given A = 1'b0
    And B = 1'b1
    And Ci = 1'b0
    When the circuit evaluates combinationally
    Then D should be 1'b1
    And Co should be 1'b1

  @corner_case
  Formal Scenario: Subtrahend and borrow-in cancel to no difference but still borrow
    Given A = 1'b0
    And B = 1'b1
    And Ci = 1'b1
    When the circuit evaluates combinationally
    Then D should be 1'b0
    And Co should be 1'b1

  @corner_case
  Formal Scenario: Minuend alone produces difference without borrow
    Given A = 1'b1
    And B = 1'b0
    And Ci = 1'b0
    When the circuit evaluates combinationally
    Then D should be 1'b1
    And Co should be 1'b0

  @corner_case
  Formal Scenario: Minuend and borrow-in cancel to no difference and no borrow
    Given A = 1'b1
    And B = 1'b0
    And Ci = 1'b1
    When the circuit evaluates combinationally
    Then D should be 1'b0
    And Co should be 1'b0

  @corner_case
  Formal Scenario: Minuend and subtrahend equal produces no difference or borrow
    Given A = 1'b1
    And B = 1'b1
    And Ci = 1'b0
    When the circuit evaluates combinationally
    Then D should be 1'b0
    And Co should be 1'b0

  @corner_case
  Formal Scenario: All inputs asserted produce difference and borrow
    Given A = 1'b1
    And B = 1'b1
    And Ci = 1'b1
    When the circuit evaluates combinationally
    Then D should be 1'b1
    And Co should be 1'b1

  @consistency
  Formal Scenario: Output ports are single bit and fully determined by inputs
    Given A is an arbitrary single-bit value
    And B is an arbitrary single-bit value
    And Ci is an arbitrary single-bit value
    When the circuit evaluates combinationally
    Then D should be a deterministic function of A, B, and Ci only
    And Co should be a deterministic function of A, B, and Ci only
    And no other input signals should affect D or Co