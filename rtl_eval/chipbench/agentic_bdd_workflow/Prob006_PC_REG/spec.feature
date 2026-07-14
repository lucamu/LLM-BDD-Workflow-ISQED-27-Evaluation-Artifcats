# ── module: CeGenerator ──
Feature: Chip-Enable (Instruction-Fetch-Enable) Generator

  Formal verification of a synchronous reset-controlled chip-enable
  signal generator. The output ce is a purely registered signal with
  no combinational bypass: it is driven exclusively by rst, sampled
  on the rising edge of clk.

  Background:
    Given a clock signal clk with rising-edge-triggered sampling
    And a synchronous reset signal rst
    And a registered output signal ce
    And on the rising edge of clk, ce is updated based on rst

  @reset @synchronous
  Formal Scenario: ce is cleared when rst is asserted
    Given rst is 1
    When a rising edge of clk occurs
    Then ce should be 0 on the next clock cycle

  @enable @synchronous
  Formal Scenario: ce is set when rst is deasserted
    Given rst is 0
    When a rising edge of clk occurs
    Then ce should be 1 on the next clock cycle

  @no_combinational_bypass
  Formal Scenario: ce does not change combinationally with rst
    Given rst transitions to a new value X between clock edges
    When no rising edge of clk has occurred yet
    Then ce should retain its previous registered value
    And ce should not equal a function of X until the next rising edge of clk

  @functional_equivalence
  Formal Scenario: ce equals logical negation of rst after each clock edge
    Given rst holds a value R at the rising edge of clk
    When the rising edge of clk occurs
    Then ce should equal NOT R on the next clock cycle

  @stability
  Formal Scenario: ce remains stable when rst is held constant
    Given rst is held at a constant value R for two consecutive rising edges of clk
    When both rising edges of clk have occurred
    Then ce should equal NOT R after the first edge
    And ce should remain equal to NOT R after the second edge

  @toggle_response
  Formal Scenario: ce responds correctly to rst toggling between cycles
    Given rst is 1 at the first rising edge of clk
    And rst is 0 at the second rising edge of clk
    When the first rising edge of clk occurs
    Then ce should be 0 after the first edge
    When the second rising edge of clk occurs
    Then ce should be 1 after the second edge

  @initial_state
  Formal Scenario: ce initializes correctly on power-up reset
    Given the design is in its initial state with rst asserted at the first rising edge of clk
    When the first rising edge of clk occurs
    Then ce should be 0 immediately after the first edge

# ── module: PcController ──
Feature: 32-bit Program Counter Register Update Logic

  Verifies the synchronous update of the 32-bit program counter (pc) register
  based on a fixed priority order among rst, ce, flush, branch_flag_i, and
  stall[0], and confirms the pc output mirrors the internally held register.

  Background:
    Given a synchronous design clocked on the positive edge of clk
    And an active-high synchronous reset signal rst
    And a 32-bit register pc holding the current program counter value
    And a 1-bit clock enable signal ce
    And a 2-bit (or wider) stall signal where bit 0 is stall[0]
    And a 1-bit flush signal
    And a 1-bit branch_flag_i signal
    And a 32-bit new_pc value used for flush redirection
    And a 32-bit branch_target_address_i value used for branch redirection
    And the output pc_o is always equal to the internally held pc register

  @reset @priority_highest
  Formal Scenario: Reset forces pc to zero regardless of other control signals
    Given rst is asserted (1)
    And ce holds any value
    And stall holds any value
    And flush holds any value
    And branch_flag_i holds any value
    And new_pc holds any value X_NEW
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become 32'h00000000
    And pc_o should equal pc

  @ce_disabled @priority_second
  Formal Scenario: Clock enable deasserted forces pc to zero when not in reset
    Given rst is deasserted (0)
    And ce is 0
    And stall holds any value
    And flush holds any value
    And branch_flag_i holds any value
    And new_pc holds any value X_NEW
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become 32'h00000000
    And pc_o should equal pc

  @flush @priority_third
  Formal Scenario: Flush redirects pc to new_pc when ce is enabled and not in reset
    Given rst is deasserted (0)
    And ce is 1
    And flush is 1
    And branch_flag_i holds any value
    And stall holds any value
    And new_pc holds any value X_NEW
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become X_NEW
    And pc_o should equal pc

  @branch @priority_fourth
  Formal Scenario: Branch resolution redirects pc to branch_target_address_i when flush is not asserted
    Given rst is deasserted (0)
    And ce is 1
    And flush is 0
    And branch_flag_i is 1
    And stall holds any value
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become X_BRANCH
    And pc_o should equal pc

  @stall @priority_fifth
  Formal Scenario: Stall bit 0 holds pc value when flush and branch are not asserted
    Given rst is deasserted (0)
    And ce is 1
    And flush is 0
    And branch_flag_i is 0
    And stall[0] is 1
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become X_PC
    And pc_o should equal pc

  @sequential @priority_lowest
  Formal Scenario: Sequential advance increments pc by 4 when no override condition is active
    Given rst is deasserted (0)
    And ce is 1
    And flush is 0
    And branch_flag_i is 0
    And stall[0] is 0
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become X_PC + 32'd4
    And pc_o should equal pc

  @output_mirror
  Formal Scenario: Output pc_o always mirrors the internal pc register combinationally
    Given pc currently holds any value X_PC
    Then pc_o should equal X_PC

  @priority_check @flush_over_branch
  Formal Scenario: Flush takes precedence over branch when both are asserted simultaneously
    Given rst is deasserted (0)
    And ce is 1
    And flush is 1
    And branch_flag_i is 1
    And stall holds any value
    And new_pc holds any value X_NEW
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become X_NEW
    And pc_o should equal pc

  @priority_check @branch_over_stall
  Formal Scenario: Branch takes precedence over stall when both are asserted simultaneously
    Given rst is deasserted (0)
    And ce is 1
    And flush is 0
    And branch_flag_i is 1
    And stall[0] is 1
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become X_BRANCH
    And pc_o should equal pc

  @priority_check @ce_over_all
  Formal Scenario: Clock enable deasserted overrides flush, branch, and stall simultaneously
    Given rst is deasserted (0)
    And ce is 0
    And flush is 1
    And branch_flag_i is 1
    And stall[0] is 1
    And new_pc holds any value X_NEW
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become 32'h00000000
    And pc_o should equal pc

  @priority_check @rst_over_all
  Formal Scenario: Reset overrides ce, flush, branch, and stall simultaneously
    Given rst is asserted (1)
    And ce is 0
    And flush is 1
    And branch_flag_i is 1
    And stall[0] is 1
    And new_pc holds any value X_NEW
    And branch_target_address_i holds any value X_BRANCH
    And pc currently holds any value X_PC
    When a positive clock edge occurs
    Then pc should become 32'h00000000
    And pc_o should equal pc

# ── module: TopModule ──
Feature: Program Counter (PC) Update Module

  As a CPU pipeline control unit
  I want the PC module to correctly update the program counter
  So that instruction fetch address is managed correctly during reset, stall, flush, and branch conditions

  Background:
    Given the design is a synchronous module with clock clk and reset rst
    And all state updates occur on the positive edge of clk
    And ce is the chip enable output
    And pc is the 32-bit program counter output

  @reset @ce
  Formal Scenario: Chip enable is disabled during reset
    Given rst is 1
    When a rising clock edge occurs
    Then ce should be 0

  @reset @ce
  Formal Scenario: Chip enable is enabled after reset deasserts
    Given rst is 0
    When a rising clock edge occurs
    Then ce should be 1

  @reset @pc
  Formal Scenario: PC is cleared when chip enable is disabled
    Given ce is 0
    When a rising clock edge occurs
    Then pc should be 0

  @stall @pc
  Formal Scenario: PC holds its value when stall[0] is asserted
    Given ce is 1
    And stall bit 0 is 1
    And pc currently holds value P
    When a rising clock edge occurs
    Then pc should remain P

  @flush @pc
  Formal Scenario: PC updates to new_pc when flush is asserted and not stalled
    Given ce is 1
    And stall bit 0 is 0
    And flush is 1
    And new_pc is value N
    When a rising clock edge occurs
    Then pc should be N

  @branch @pc
  Formal Scenario: PC updates to branch target when branch_flag_i is asserted, flush is not asserted, and not stalled
    Given ce is 1
    And stall bit 0 is 0
    And flush is 0
    And branch_flag_i is 1
    And branch_target_address_i is value B
    When a rising clock edge occurs
    Then pc should be B

  @increment @pc
  Formal Scenario: PC increments by 4 when no stall, flush, or branch occurs
    Given ce is 1
    And stall bit 0 is 0
    And flush is 0
    And branch_flag_i is 0
    And pc currently holds value P
    When a rising clock edge occurs
    Then pc should be P + 4

  @priority @flush_over_branch
  Formal Scenario: Flush takes priority over branch when both are asserted and not stalled
    Given ce is 1
    And stall bit 0 is 0
    And flush is 1
    And branch_flag_i is 1
    And new_pc is value N
    And branch_target_address_i is value B
    When a rising clock edge occurs
    Then pc should be N

  @priority @stall_over_flush
  Formal Scenario: Stall takes priority over flush when both are asserted
    Given ce is 1
    And stall bit 0 is 1
    And flush is 1
    And new_pc is value N
    And pc currently holds value P
    When a rising clock edge occurs
    Then pc should remain P

  @priority @stall_over_branch
  Formal Scenario: Stall takes priority over branch when both are asserted
    Given ce is 1
    And stall bit 0 is 1
    And branch_flag_i is 1
    And branch_target_address_i is value B
    And pc currently holds value P
    When a rising clock edge occurs
    Then pc should remain P

  @ce_over_all
  Formal Scenario: Chip disable forces PC to zero regardless of stall, flush, or branch
    Given ce is 0
    And stall bit 0 is any value
    And flush is any value
    And branch_flag_i is any value
    When a rising clock edge occurs
    Then pc should be 0