Feature: 4-bit Full Adder with Overflow

  As a hardware designer
  I want to verify a 4-bit adder built from full adders
  So that the sum output correctly represents the arithmetic sum including carry-out/overflow

  Background:
    Given the design is a combinational module named TopModule
    And the module has input x of width 4 bits
    And the module has input y of width 4 bits
    And the module has output sum of width 5 bits
    And there is no clock or reset signal
    And sum is evaluated purely as a function of x and y

  @arithmetic @core
  Formal Scenario: Sum equals arithmetic addition of operands
    Given x is any value X
    And y is any value Y
    When the combinational logic evaluates
    Then sum should equal X + Y

  @overflow @msb
  Formal Scenario: Overflow bit reflects carry-out of 4-bit addition
    Given x is any value X
    And y is any value Y
    When the combinational logic evaluates
    Then sum[4] should equal 1 if X + Y is greater than or equal to 16
    And sum[4] should equal 0 if X + Y is less than 16

  @lowerbits
  Formal Scenario: Lower 4 bits of sum equal modular addition
    Given x is any value X
    And y is any value Y
    When the combinational logic evaluates
    Then sum[3:0] should equal (X + Y) mod 16

  @zero
  Formal Scenario: Sum is zero only when both operands are zero
    Given x is any value X
    And y is any value Y
    When the combinational logic evaluates
    Then sum should equal 0 if X equals 0 and Y equals 0

  @identity
  Formal Scenario: Adding zero preserves the other operand
    Given x is any value X
    And y is 4'b0000
    When the combinational logic evaluates
    Then sum should equal X

  @identity
  Formal Scenario: Adding zero as first operand preserves the second operand
    Given x is 4'b0000
    And y is any value Y
    When the combinational logic evaluates
    Then sum should equal Y

  @commutative
  Formal Scenario: Addition is commutative
    Given x is any value X
    And y is any value Y
    When the combinational logic evaluates with operands X and Y
    And the combinational logic evaluates again with operands Y and X
    Then both evaluations should produce the same sum

  @maxvalue
  Formal Scenario: Maximum operand values produce correct sum and overflow
    Given x is 4'b1111
    And y is 4'b1111
    When the combinational logic evaluates
    Then sum should equal 5'b11110
    And sum[4] should equal 1

  @nooverflow
  Formal Scenario: Small operand values never set the overflow bit
    Given x is any value X
    And y is any value Y
    And X + Y is less than 16
    When the combinational logic evaluates
    Then sum[4] should equal 0
    And sum[3:0] should equal X + Y