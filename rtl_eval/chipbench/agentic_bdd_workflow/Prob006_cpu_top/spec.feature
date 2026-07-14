# ── module: Control ──
Feature: MIPS-style Combinational Control Decoder Verification
  Formal verification of the fixed, combinational control-signal decoder module.
  The decoder maps a 4-bit opcode and 6-bit func field to all datapath control
  signals (RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp[3:0], MemWrite,
  ALUSrc, RegWrite, OpenPort) exactly as specified by the given logic equations.
  The module itself is purely combinational; it is embedded in a synchronous
  system with clock and reset, but its outputs must be an immediate function
  of its current inputs, independent of clock edges or reset state.

  Background:
    Given the decoder module is instantiated exactly as specified, unmodified
    And opcode is a 4-bit input signal
    And func is a 6-bit input signal
    And the system clock toggles freely and reset may be asserted or deasserted at any time
    And all control outputs are combinational functions of opcode and func only

  @combinational @no_clock_dependency
  Formal Scenario: Outputs depend only on opcode and func, not on clock or reset
    Given opcode holds value OP and func holds value FUNC
    And the clock transitions through an arbitrary number of edges
    And reset is asserted or deasserted arbitrarily during those edges
    When opcode remains OP and func remains FUNC throughout
    Then RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, and OpenPort
      should remain constant and equal to the values determined solely by OP and FUNC

  @rtype_decode
  Formal Scenario: R-type instruction decode (opcode 4'b0000)
    Given opcode equals 4'b0000
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 1
    And ALUSrc should equal 0
    And MemtoReg should equal 0
    And RegWrite should equal 1
    And MemRead should equal 0
    And MemWrite should equal 0
    And Branch should equal 0
    And Jump should equal 0
    And OpenPort should equal 0
    And ALUOp should equal the R-type function-derived code corresponding to FUNC
      (4'b0010 if FUNC equals 6'b100000, 4'b0110 if FUNC equals 6'b100010,
       4'b0000 if FUNC equals 6'b100100, 4'b0001 if FUNC equals 6'b100101,
       4'b0111 if FUNC equals 6'b101010)

  @lw_decode
  Formal Scenario: Load word instruction decode (opcode 4'b0001)
    Given opcode equals 4'b0001
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 0
    And ALUSrc should equal 1
    And MemtoReg should equal 1
    And RegWrite should equal 1
    And MemRead should equal 1
    And MemWrite should equal 0
    And Branch should equal 0
    And Jump should equal 0
    And OpenPort should equal 0
    And ALUOp should equal 4'b0010

  @sw_decode
  Formal Scenario: Store word instruction decode (opcode 4'b0010)
    Given opcode equals 4'b0010
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 0 (don't-care encoded as 0)
    And ALUSrc should equal 1
    And MemtoReg should equal 0 (don't-care encoded as 0)
    And RegWrite should equal 0
    And MemRead should equal 0
    And MemWrite should equal 1
    And Branch should equal 0
    And Jump should equal 0
    And OpenPort should equal 0
    And ALUOp should equal 4'b0010

  @beq_decode
  Formal Scenario: Branch-equal instruction decode (opcode 4'b0011)
    Given opcode equals 4'b0011
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 0 (don't-care encoded as 0)
    And ALUSrc should equal 0
    And MemtoReg should equal 0 (don't-care encoded as 0)
    And RegWrite should equal 0
    And MemRead should equal 0
    And MemWrite should equal 0
    And Branch should equal 1
    And Jump should equal 0
    And OpenPort should equal 0
    And ALUOp should equal 4'b0110

  @jump_decode
  Formal Scenario: Jump instruction decode (opcode 4'b0100)
    Given opcode equals 4'b0100
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 0 (don't-care encoded as 0)
    And ALUSrc should equal 0 (don't-care encoded as 0)
    And MemtoReg should equal 0 (don't-care encoded as 0)
    And RegWrite should equal 0
    And MemRead should equal 0
    And MemWrite should equal 0
    And Branch should equal 0
    And Jump should equal 1
    And OpenPort should equal 0
    And ALUOp should equal 4'b0000

  @openport_decode
  Formal Scenario: Special OpenPort instruction decode (opcode 4'b1111)
    Given opcode equals 4'b1111
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 0
    And ALUSrc should equal 0
    And MemtoReg should equal 0
    And RegWrite should equal 0
    And MemRead should equal 0
    And MemWrite should equal 0
    And Branch should equal 0
    And Jump should equal 0
    And OpenPort should equal 1
    And ALUOp should equal 4'b0000

  @reserved_opcode_safe_default
  Formal Scenario: Reserved or undefined opcode yields a safe inactive control state
    Given opcode equals any value not in the set
      {4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b1111}
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegDst should equal 0
    And Jump should equal 0
    And Branch should equal 0
    And MemRead should equal 0
    And MemtoReg should equal 0
    And MemWrite should equal 0
    And ALUSrc should equal 0
    And RegWrite should equal 0
    And OpenPort should equal 0
    And ALUOp should equal 4'b0000

  @mutual_exclusivity
  Formal Scenario: MemRead and MemWrite are never simultaneously asserted
    Given opcode holds an arbitrary 4-bit value OP
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then MemRead and MemWrite should not both equal 1

  @mutual_exclusivity_control
  Formal Scenario: RegWrite is never asserted together with MemWrite
    Given opcode holds an arbitrary 4-bit value OP
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then RegWrite and MemWrite should not both equal 1

  @jump_branch_exclusivity
  Formal Scenario: Jump and Branch are never simultaneously asserted
    Given opcode holds an arbitrary 4-bit value OP
    And func holds an arbitrary 6-bit value FUNC
    When the decoder combinationally evaluates the control outputs
    Then Jump and Branch should not both equal 1

# ── module: SignExtend ──
Feature: 8-bit to 16-bit Sign Extension Unit

  As a hardware designer
  I want to verify that the sign-extension unit correctly produces a 16-bit
  signed value from an 8-bit immediate field, replicating bit 7 into the
  upper byte, and that this behavior is purely combinational (independent of
  clock edges and reset state).

  Background:
    Given a clock signal "clk"
    And a reset signal "rst"
    And an 8-bit input "imm" representing the low byte of the instruction
    And a 16-bit output "ext_imm" representing the sign-extended result
    And the design is purely combinational with no internal state

  @combinational @core-function
  Formal Scenario: Output equals sign-extension of imm for any input value
    Given an 8-bit value "imm"
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal the concatenation of imm[7] replicated 8 times and imm
    And "ext_imm"[7:0] should equal imm[7:0]
    And "ext_imm"[15:8] should equal {8{imm[7]}}

  @combinational @positive-sign
  Formal Scenario: Positive immediate is zero-extended
    Given an 8-bit value "imm" such that imm[7] equals 0
    When the sign-extension unit evaluates "imm"
    Then "ext_imm"[15:8] should equal 8'b00000000
    And "ext_imm"[7:0] should equal imm

  @combinational @negative-sign
  Formal Scenario: Negative immediate is one-extended
    Given an 8-bit value "imm" such that imm[7] equals 1
    When the sign-extension unit evaluates "imm"
    Then "ext_imm"[15:8] should equal 8'b11111111
    And "ext_imm"[7:0] should equal imm

  @boundary @zero-value
  Formal Scenario: All-zero immediate produces all-zero output
    Given the constant value "imm" equal to 8'b00000000
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal 16'b0000000000000000

  @boundary @all-ones
  Formal Scenario: All-one immediate produces all-one output
    Given the constant value "imm" equal to 8'b11111111
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal 16'b1111111111111111

  @boundary @msb-only
  Formal Scenario: Only sign bit set produces minimum negative value
    Given the constant value "imm" equal to 8'b10000000
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal 16'b1111111110000000

  @boundary @lsb-pattern
  Formal Scenario: Sign bit clear with lower bits set produces matching positive value
    Given the constant value "imm" equal to 8'b01111111
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal 16'b0000000001111111

  @combinational @bit-preservation
  Formal Scenario: Lower 8 bits of output always match input bits exactly
    Given an 8-bit value "imm"
    When the sign-extension unit evaluates "imm"
    Then for each bit index i from 0 to 7, "ext_imm"[i] should equal imm[i]

  @combinational @upper-bit-replication
  Formal Scenario: Upper 8 bits of output always equal replicated sign bit
    Given an 8-bit value "imm"
    When the sign-extension unit evaluates "imm"
    Then for each bit index j from 8 to 15, "ext_imm"[j] should equal imm[7]

  @clock-independence
  Formal Scenario: Output equals sign-extension of imm regardless of clock value
    Given an 8-bit value "imm"
    And an arbitrary value of "clk"
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal {8{imm[7]}, imm} regardless of the value of "clk"

  @reset-independence
  Formal Scenario: Output equals sign-extension of imm regardless of reset value
    Given an 8-bit value "imm"
    And an arbitrary value of "rst"
    When the sign-extension unit evaluates "imm"
    Then "ext_imm" should equal {8{imm[7]}, imm} regardless of the value of "rst"

  @stability
  Formal Scenario: Output remains stable when input is held constant
    Given an 8-bit value "imm" held constant across consecutive cycles
    When two consecutive evaluations of the sign-extension unit occur
    Then "ext_imm" should be identical in both evaluations

# ── module: PCUnit ──
Feature: Program Counter Register with Next-PC Combinational Logic

  As a hardware designer
  I want the PC register to correctly compute and update the next program counter
  So that instruction fetch and control flow (jump/branch/sequential) behave correctly

  Background:
    Given a synchronous design clocked on the rising edge of clk
    And an active-low synchronous reset reset_n
    And a 16-bit current PC register value PC
    And a 16-bit instruction input
    And a Jump control input
    And a Branch control input
    And a bcond input
    And a 16-bit sign-extended immediate value sext_imm
    And a pc_write control input
    And a combinationally computed nextPC value

  @reset
  Formal Scenario: Reset forces PC to zero on next clock edge
    Given reset_n is deasserted (0)
    When a rising clk edge occurs
    Then PC should be 16'h0000

  @reset @priority
  Formal Scenario: Reset takes priority over pc_write
    Given reset_n is deasserted (0)
    And pc_write is asserted (1)
    And Jump is asserted (1)
    And instruction has any value INSTR
    When a rising clk edge occurs
    Then PC should be 16'h0000

  @nextpc @jump
  Formal Scenario: NextPC computes jump target when Jump is asserted
    Given reset_n is asserted (1)
    And PC has any value P
    And instruction has any value INSTR
    And Jump is asserted (1)
    Then nextPC should equal the concatenation of P[15:12] and INSTR[11:0]

  @nextpc @branch @taken
  Formal Scenario: NextPC computes branch target when Branch is asserted and bcond is high
    Given reset_n is asserted (1)
    And PC has any value P
    And sext_imm has any value IMM
    And Jump is deasserted (0)
    And Branch is asserted (1)
    And bcond is asserted (1)
    Then nextPC should equal P + IMM

  @nextpc @branch @not_taken
  Formal Scenario: NextPC falls back to sequential increment when Branch is asserted but bcond is low
    Given reset_n is asserted (1)
    And PC has any value P
    And sext_imm has any value IMM
    And Jump is deasserted (0)
    And Branch is asserted (1)
    And bcond is deasserted (0)
    Then nextPC should equal P + 1

  @nextpc @sequential
  Formal Scenario: NextPC defaults to PC plus one when neither Jump nor Branch is asserted
    Given reset_n is asserted (1)
    And PC has any value P
    And Jump is deasserted (0)
    And Branch is deasserted (0)
    Then nextPC should equal P + 1

  @nextpc @priority
  Formal Scenario: Jump takes priority over Branch when both are asserted
    Given reset_n is asserted (1)
    And PC has any value P
    And instruction has any value INSTR
    And sext_imm has any value IMM
    And Jump is asserted (1)
    And Branch is asserted (1)
    And bcond is asserted (1)
    Then nextPC should equal the concatenation of P[15:12] and INSTR[11:0]

  @update @enabled
  Formal Scenario: PC updates to nextPC on rising clock edge when pc_write is asserted
    Given reset_n is asserted (1)
    And PC has any value P
    And Jump has any value J
    And Branch has any value B
    And bcond has any value C
    And instruction has any value INSTR
    And sext_imm has any value IMM
    And pc_write is asserted (1)
    When a rising clk edge occurs
    Then PC should equal the value of nextPC computed from P, J, B, C, INSTR, IMM in the prior cycle

  @update @disabled @hold
  Formal Scenario: PC holds its value when pc_write is deasserted
    Given reset_n is asserted (1)
    And PC has any value P
    And pc_write is deasserted (0)
    When a rising clk edge occurs
    Then PC should remain equal to P

  @stability
  Formal Scenario: PC never changes without a rising clock edge
    Given reset_n is asserted (1)
    And PC has any value P
    And no rising clk edge occurs
    Then PC should remain equal to P

# ── module: IRReg ──
Feature: Instruction Fetch Register (IR)

  A 16-bit synchronous register that captures the instruction word from the
  data bus on the rising clock edge when ir_write is asserted, and resets
  synchronously to 0 when reset_n is low. Holds the instruction stable
  for use by Control, RF, SignExtend, and PCUnit until the next fetch.

  Background:
    Given a synchronous design clocked on the rising edge of clk
    And an active-low synchronous reset signal reset_n
    And a 16-bit data input bus data_in
    And a write enable signal ir_write
    And a 16-bit registered output instruction_out

  @reset
  Formal Scenario: Synchronous reset forces instruction register to zero
    Given reset_n is 0
    And data_in holds any value D
    And ir_write holds any value W
    When a rising clk edge occurs
    Then instruction_out should be 16'h0000

  @reset
  Formal Scenario: Reset takes priority over ir_write
    Given reset_n is 0
    And ir_write is 1
    And data_in holds any value D
    When a rising clk edge occurs
    Then instruction_out should be 16'h0000

  @load
  Formal Scenario: Latch data bus value when ir_write asserted
    Given reset_n is 1
    And ir_write is 1
    And data_in holds any value D
    When a rising clk edge occurs
    Then instruction_out should be D

  @hold
  Formal Scenario: Hold previous value when ir_write deasserted
    Given reset_n is 1
    And ir_write is 0
    And instruction_out currently holds any value Q
    And data_in holds any value D
    When a rising clk edge occurs
    Then instruction_out should remain Q

  @stability
  Formal Scenario: Instruction register does not change combinationally
    Given reset_n is 1
    And ir_write is 0
    And instruction_out currently holds any value Q
    And data_in transitions to any value D
    When no clk edge occurs
    Then instruction_out should remain Q

  @stability
  Formal Scenario: Instruction remains stable across decode/execute/mem/writeback until next fetch
    Given reset_n is 1
    And instruction_out currently holds any value Q
    And ir_write remains 0 for N consecutive clk cycles
    When N rising clk edges occur
    Then instruction_out should remain Q after each edge

  @recovery
  Formal Scenario: Register resumes normal capture after reset deasserted
    Given reset_n transitions from 0 to 1
    And ir_write is 1
    And data_in holds any value D
    When a rising clk edge occurs after reset_n is 1
    Then instruction_out should be D

  @determinism
  Formal Scenario: Next state depends only on reset_n, ir_write, and data_in
    Given reset_n holds any value R
    And ir_write holds any value W
    And data_in holds any value D
    And instruction_out currently holds any value Q
    When a rising clk edge occurs
    Then instruction_out should be 16'h0000 if R equals 0
    And instruction_out should be D if R equals 1 and W equals 1
    And instruction_out should remain Q if R equals 1 and W equals 0

# ── module: DataMemReg ──
Feature: 16-bit Memory Data Register (LWD Write-Back Latch)
  This register captures the 16-bit value read from the data bus during a
  LWD memory access when dr_write is asserted on the rising clk edge.
  The output feeds the MemtoReg write-back mux for the register file.

  Background:
    Given a synchronous design with clock "clk" and active-low reset "reset_n"
    And a 16-bit input "data_bus"
    And a control signal "dr_write"
    And a 16-bit registered output "dr_out"
    And all state updates occur only on the rising edge of "clk"

  @reset @async_or_sync
  Formal Scenario: Reset forces the register output to zero
    Given reset_n is deasserted (0)
    And data_bus holds any value D
    And dr_write holds any value W
    When a rising clk edge occurs
    Then dr_out should be 16'h0000

  @reset_priority
  Formal Scenario: Reset takes priority over dr_write
    Given reset_n is deasserted (0)
    And dr_write is asserted (1)
    And data_bus holds any value D
    When a rising clk edge occurs
    Then dr_out should be 16'h0000
    And dr_out should not equal D unless D is 16'h0000

  @capture
  Formal Scenario: Register captures data_bus when dr_write is asserted
    Given reset_n is asserted (1)
    And dr_write is asserted (1)
    And data_bus holds any value D
    When a rising clk edge occurs
    Then dr_out should equal D

  @hold
  Formal Scenario: Register holds its value when dr_write is deasserted
    Given reset_n is asserted (1)
    And dr_write is deasserted (0)
    And dr_out currently holds any value Q
    And data_bus holds any value D
    When a rising clk edge occurs
    Then dr_out should equal Q
    And dr_out should not change regardless of D

  @sequential_capture
  Formal Scenario: Consecutive writes update the register to the latest value
    Given reset_n is asserted (1)
    And dr_write is asserted (1)
    And data_bus holds value D1
    When a rising clk edge occurs
    Then dr_out should equal D1
    Given dr_write remains asserted (1)
    And data_bus holds value D2
    When a subsequent rising clk edge occurs
    Then dr_out should equal D2

  @stability
  Formal Scenario: Output remains stable between clock edges
    Given reset_n is asserted (1)
    And dr_out currently holds any value Q
    When no rising clk edge occurs
    Then dr_out should remain equal to Q

  @writeback_interface
  Formal Scenario: dr_out correctly registers the captured value at the DUT output boundary
    Given reset_n was asserted (1) at the previous rising clk edge
    And dr_write was asserted (1) at that previous rising clk edge
    And data_bus held value D at that previous rising clk edge
    When the current rising clk edge occurs
    Then dr_out should equal the value of D sampled at the previous rising clk edge
    And dr_out should remain stable and available for downstream consumption until the next rising clk edge

  @no_dontcare_propagation
  Formal Scenario: Undriven data_bus values do not affect dr_out when not writing
    Given reset_n is asserted (1)
    And dr_write is deasserted (0)
    And dr_out currently holds any value Q
    And data_bus holds an arbitrary or unknown value D
    When a rising clk edge occurs
    Then dr_out should equal the value of dr_out sampled at the previous rising clk edge
    And dr_out should not equal D unless D equals the previous value of dr_out

# ── module: InstCounter ──
Feature: 16-bit Synchronous Up-Counter for Instruction Retirement Count (num_inst)

  As a CPU verification engineer
  I want to formally verify the 16-bit instruction counter
  So that num_inst correctly reflects the number of retired instructions

  Background:
    Given a synchronous design with clock "clk" and active-low reset "reset_n"
    And an internal 16-bit register "count" initialized to an arbitrary value X
    And a single-cycle pulse input "inc" that is asserted once per completed instruction
    And the output port "num_inst" is continuously driven by "count"
    And all state changes occur only on the rising edge of "clk"

  @reset @formal
  Formal Scenario: Reset forces counter to zero
    Given the counter holds any current value Q
    And "reset_n" is deasserted (logic 0)
    When a rising edge of "clk" occurs
    Then "count" should become 16'h0000
    And "num_inst" should equal 16'h0000

  @reset_priority @formal
  Formal Scenario: Reset takes priority over increment
    Given the counter holds any current value Q
    And "reset_n" is deasserted (logic 0)
    And "inc" is asserted (logic 1)
    When a rising edge of "clk" occurs
    Then "count" should become 16'h0000
    And "num_inst" should equal 16'h0000

  @increment @formal
  Formal Scenario: Counter increments by one when inc pulses high
    Given "reset_n" is asserted (logic 1)
    And the counter holds any current value Q
    And "inc" is asserted (logic 1)
    When a rising edge of "clk" occurs
    Then "count" should become Q + 1
    And "num_inst" should equal Q + 1

  @hold @formal
  Formal Scenario: Counter holds value when inc is not asserted
    Given "reset_n" is asserted (logic 1)
    And the counter holds any current value Q
    And "inc" is deasserted (logic 0)
    When a rising edge of "clk" occurs
    Then "count" should remain Q
    And "num_inst" should equal Q

  @wraparound @formal
  Formal Scenario: Counter wraps around from maximum value to zero
    Given "reset_n" is asserted (logic 1)
    And the counter holds the maximum value 16'hFFFF
    And "inc" is asserted (logic 1)
    When a rising edge of "clk" occurs
    Then "count" should become 16'h0000
    And "num_inst" should equal 16'h0000

  @output_binding @formal
  Formal Scenario: num_inst always mirrors the internal counter value
    Given "reset_n" is asserted (logic 1)
    And the counter holds any current value Q
    And "inc" holds any value
    When a rising edge of "clk" occurs
    Then "num_inst" should equal "count" at all times, both before and after the clock edge

  @single_pulse_increment @formal
  Formal Scenario: A single-cycle inc pulse causes exactly one increment
    Given "reset_n" is asserted (logic 1)
    And the counter holds any current value Q
    And "inc" is asserted (logic 1) for exactly one clock cycle
    And "inc" is deasserted (logic 0) on the following cycle
    When two consecutive rising edges of "clk" occur
    Then "count" should become Q + 1 after the first edge
    And "count" should remain Q + 1 after the second edge

  @accumulation @formal
  Formal Scenario: Counter accumulates correctly over multiple increment pulses
    Given "reset_n" is asserted (logic 1)
    And the counter holds any current value Q
    And "inc" is asserted (logic 1) for N consecutive clock cycles, where N is any non-negative integer such that Q + N does not exceed 16'hFFFF
    When N rising edges of "clk" occur consecutively with "inc" held high
    Then "count" should equal Q + N
    And "num_inst" should equal Q + N

  @no_spurious_increment @formal
  Formal Scenario: Counter never changes without a rising clock edge
    Given "reset_n" is asserted (logic 1)
    And the counter holds any current value Q
    And "inc" toggles arbitrarily between clock edges
    When no rising edge of "clk" occurs
    Then "count" should remain Q
    And "num_inst" should remain Q

# ── module: FSMController ──
Feature: CPU Multi-Cycle Sequencing Finite-State Machine

  As a hardware verification engineer
  I want to formally verify the multi-cycle FSM controlling FETCH, DECODE_EXEC,
  MEM_ACCESS, and WRITEBACK/PC_UPDATE stages
  So that instruction sequencing, memory bus control, and register/PC updates
  are provably correct across all reachable states

  Background:
    Given a synchronous design with clock signal clk and active-low reset reset_n
    And all state transitions occur on the rising edge of clk
    And the FSM state register "state" takes one of the values FETCH, DECODE_EXEC, MEM_ACCESS, WRITEBACK
    And address_sel indicates whether address is driven from PC or from ALUResult

  @reset @safety
  Formal Scenario: Reset forces the FSM into FETCH state
    Given reset_n is deasserted (low)
    When a rising clock edge occurs
    Then state should be FETCH
    And readM should be 1
    And writeM should be 0
    And address_sel should select PC as the address source

  @fetch @combinational
  Formal Scenario: FETCH state drives address from PC and asserts readM
    Given reset_n is asserted (high)
    And state is FETCH
    And PC holds value program_counter
    When evaluating combinational outputs in the current cycle
    Then readM should be 1
    And writeM should be 0
    And address_sel should select PC as the address source
    And the driven address should equal program_counter

  @fetch @stall
  Formal Scenario: FETCH remains in FETCH while inputReady is deasserted
    Given reset_n is asserted (high)
    And state is FETCH
    And inputReady is 0
    When a rising clock edge occurs
    Then the next state should be FETCH
    And ir_write should be 0

  @fetch @transition
  Formal Scenario: FETCH pulses ir_write and advances to DECODE_EXEC when inputReady asserts
    Given reset_n is asserted (high)
    And state is FETCH
    And inputReady is 1
    When a rising clock edge occurs
    Then ir_write should be asserted for exactly this cycle
    And the next state should be DECODE_EXEC

  @decode_exec @combinational
  Formal Scenario: DECODE_EXEC produces combinational Control, RF, and ALU outputs without bus activity
    Given reset_n is asserted (high)
    And state is DECODE_EXEC
    And the latched instruction holds value instr_word
    When evaluating combinational outputs in the current cycle
    Then readM should be 0
    And writeM should be 0
    And Control, RF, and ALU outputs should be pure functions of instr_word and register file contents

  @decode_exec @transition
  Formal Scenario: DECODE_EXEC advances to MEM_ACCESS when a memory operation is required
    Given reset_n is asserted (high)
    And state is DECODE_EXEC
    And MemRead is value mem_read_flag
    And MemWrite is value mem_write_flag
    And mem_read_flag is 1 or mem_write_flag is 1
    When a rising clock edge occurs
    Then the next state should be MEM_ACCESS

  @decode_exec @transition
  Formal Scenario: DECODE_EXEC advances directly to WRITEBACK when no memory operation is required
    Given reset_n is asserted (high)
    And state is DECODE_EXEC
    And MemRead is 0
    And MemWrite is 0
    When a rising clock edge occurs
    Then the next state should be WRITEBACK

  @mem_access @load @combinational
  Formal Scenario: MEM_ACCESS drives ALU address and asserts readM for a load
    Given reset_n is asserted (high)
    And state is MEM_ACCESS
    And MemRead is 1
    And ALUResult holds value alu_address
    When evaluating combinational outputs in the current cycle
    Then address_sel should select ALUResult as the address source
    And the driven address should equal alu_address
    And readM should be 1
    And writeM should be 0

  @mem_access @load @transition
  Formal Scenario: MEM_ACCESS pulses dr_write and advances to WRITEBACK on inputReady for a load
    Given reset_n is asserted (high)
    And state is MEM_ACCESS
    And MemRead is 1
    And inputReady is 1
    When a rising clock edge occurs
    Then dr_write should be asserted for exactly this cycle
    And the next state should be WRITEBACK

  @mem_access @store @combinational
  Formal Scenario: MEM_ACCESS drives ALU address and asserts writeM for a store
    Given reset_n is asserted (high)
    And state is MEM_ACCESS
    And MemWrite is 1
    And ALUResult holds value alu_address
    When evaluating combinational outputs in the current cycle
    Then address_sel should select ALUResult as the address source
    And the driven address should equal alu_address
    And writeM should be 1
    And readM should be 0

  @mem_access @store @transition
  Formal Scenario: MEM_ACCESS does not pulse dr_write during a store and advances to WRITEBACK
    Given reset_n is asserted (high)
    And state is MEM_ACCESS
    And MemWrite is 1
    And inputReady is 1
    When a rising clock edge occurs
    Then dr_write should be 0
    And the next state should be WRITEBACK

  @mem_access @store
  Formal Scenario: Top module drives the data bus with ReadData2 during a store
    Given reset_n is asserted (high)
    And state is MEM_ACCESS
    And MemWrite is 1
    And ReadData2 holds value store_data
    When evaluating combinational outputs in the current cycle
    Then writeM should be 1
    And the driven data bus value should equal store_data

  @mem_access @stall
  Formal Scenario: MEM_ACCESS stalls while inputReady is deasserted
    Given reset_n is asserted (high)
    And state is MEM_ACCESS
    And inputReady is 0
    And MemRead is 1 or MemWrite is 1
    When a rising clock edge occurs
    Then the next state should be MEM_ACCESS
    And dr_write should be 0

  @writeback @regwrite
  Formal Scenario: WRITEBACK pulses rf_write when RegWrite is asserted
    Given reset_n is asserted (high)
    And state is WRITEBACK
    And RegWrite is 1
    When a rising clock edge occurs
    Then rf_write should be asserted for exactly this cycle

  @writeback @regwrite
  Formal Scenario: WRITEBACK does not pulse rf_write when RegWrite is deasserted
    Given reset_n is asserted (high)
    And state is WRITEBACK
    And RegWrite is 0
    When a rising clock edge occurs
    Then rf_write should be 0

  @writeback @pc_update
  Formal Scenario: WRITEBACK pulses pc_write and loads the computed nextPC into PCUnit
    Given reset_n is asserted (high)
    And state is WRITEBACK
    And nextPC holds value computed_next_pc
    When a rising clock edge occurs
    Then pc_write should be asserted for exactly this cycle
    And PCUnit should latch value computed_next_pc

  @writeback @counter
  Formal Scenario: WRITEBACK pulses inc and increments InstCounter by one
    Given reset_n is asserted (high)
    And state is WRITEBACK
    And InstCounter holds value counter_value
    When a rising clock edge occurs
    Then inc should be asserted for exactly this cycle
    And InstCounter should equal counter_value plus 1

  @writeback @transition
  Formal Scenario: WRITEBACK unconditionally returns to FETCH
    Given reset_n is asserted (high)
    And state is WRITEBACK
    When a rising clock edge occurs
    Then the next state should be FETCH

  @safety @bus_control
  Formal Scenario: readM and writeM are never simultaneously asserted
    Given reset_n is asserted (high)
    And state holds any reachable value
    When evaluating combinational outputs in the current cycle
    Then readM and writeM should not both equal 1

  @safety @address_sel
  Formal Scenario: address_sel selects PC only during FETCH and ALUResult only during MEM_ACCESS
    Given reset_n is asserted (high)
    And state holds any reachable value
    When evaluating combinational outputs in the current cycle
    Then address_sel should select PC as the address source if and only if state equals FETCH
    And address_sel should select ALUResult as the address source if and only if state equals MEM_ACCESS

  @safety @pulse_discipline
  Formal Scenario: All control pulses are asserted for exactly one clock cycle
    Given reset_n is asserted (high)
    And a control pulse signal among ir_write, dr_write, rf_write, pc_write, inc is asserted in the current cycle
    When a rising clock edge occurs with no re-triggering condition present
    Then that control pulse signal should be deasserted in the following cycle

  @safety @no_spurious_writes
  Formal Scenario: Memory-related pulses only occur in their designated states
    Given reset_n is asserted (high)
    And state holds any reachable value
    When evaluating combinational outputs in the current cycle
    Then ir_write should be 0 unless state equals FETCH
    And dr_write should be 0 unless state equals MEM_ACCESS
    And rf_write should be 0 unless state equals WRITEBACK
    And pc_write should be 0 unless state equals WRITEBACK
    And inc should be 0 unless state equals WRITEBACK

# ── module: TopModule ──
Feature: TopModule 16-bit CPU Formal Verification

  This feature specifies formally verifiable properties of a simplified
  16-bit CPU (TopModule) covering instruction fetch, decode, execute,
  memory access, write-back, PC update, and output port behavior.

  Background:
    Given a synchronous design with clock signal "clk"
    And an active-low asynchronous reset signal "reset_n"
    And the module "TopModule" has output "readM"
    And the module "TopModule" has output "address" of 16 bits
    And the module "TopModule" has inout "data" of 16 bits
    And the module "TopModule" has input "inputReady"
    And the module "TopModule" has output "num_inst" of 16 bits
    And the module "TopModule" has output "output_port" of 16 bits
    And all registers are driven by "clk" posedge and "reset_n" negedge

  @reset
  Formal Scenario: Asynchronous reset clears internal state
    Given reset_n is deasserted (reset_n = 0)
    When a clock edge occurs
    Then the internal PC register should be 0
    And num_inst should be 0
    And all registers in the RF module should be 0
    And readM should reflect the fetch of address 0 on the next cycle after reset deassertion

  @fetch
  Formal Scenario: Instruction fetch asserts readM and sets address to PC
    Given reset_n is asserted (reset_n = 1)
    And the internal PC register holds value P
    And the CPU is in the instruction fetch stage
    Then readM should be 1
    And address should equal P

  @fetch
  Formal Scenario: Instruction fetch waits for inputReady before latching instruction
    Given reset_n is asserted (reset_n = 1)
    And the CPU is in the instruction fetch stage with address set to P
    And inputReady is 0
    When a clock edge occurs
    Then the CPU should remain in the instruction fetch stage
    And the internal instruction register should not update

  @fetch
  Formal Scenario: Instruction fetch latches instruction when inputReady is asserted
    Given reset_n is asserted (reset_n = 1)
    And the CPU is in the instruction fetch stage with address set to P
    And inputReady is 1
    And data bus carries value INSTR
    When a clock edge occurs
    Then the internal instruction register should equal INSTR
    And the CPU should transition to the decode stage

  @decode
  Formal Scenario: Decode extracts opcode and function fields correctly
    Given an instruction register holds value INSTR
    When the CPU is in the decode stage
    Then the opcode should equal INSTR bits [15:12]
    And the function field should equal INSTR bits [5:0]

  @decode
  Formal Scenario: Control module generates RegDst signal correctly for R-type
    Given opcode equals 4'b1111 (OPCODE_R)
    When the Control module evaluates control signals
    Then RegDst should be 1

  @decode
  Formal Scenario: Control module generates RegDst signal correctly for non-R-type
    Given opcode X is not equal to 4'b1111 (OPCODE_R)
    When the Control module evaluates control signals
    Then RegDst should be 0

  @execute @rtype
  Formal Scenario: R-type ADD computes correct sum
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd0 (FUNC_ADD)
    And ReadData1 equals A
    And ReadData2 equals B
    When the ALU executes with ALUOp 0
    Then the ALU result C should equal A + B

  @execute @rtype
  Formal Scenario: R-type SUB computes correct difference
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd1 (FUNC_SUB)
    And ReadData1 equals A
    And ReadData2 equals B
    When the ALU executes with ALUOp 1
    Then the ALU result C should equal A - B

  @execute @rtype
  Formal Scenario: R-type AND computes correct bitwise AND
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd2 (FUNC_AND)
    And ReadData1 equals A
    And ReadData2 equals B
    When the ALU executes with ALUOp 2
    Then the ALU result C should equal (A & B)

  @execute @rtype
  Formal Scenario: R-type ORR computes correct bitwise OR
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd3 (FUNC_ORR)
    And ReadData1 equals A
    And ReadData2 equals B
    When the ALU executes with ALUOp 3
    Then the ALU result C should equal (A | B)

  @execute @rtype
  Formal Scenario: R-type NOT computes correct bitwise complement
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd4 (FUNC_NOT)
    And ReadData1 equals A
    When the ALU executes with ALUOp 4
    Then the ALU result C should equal (~A)

  @execute @rtype
  Formal Scenario: R-type TCP computes correct two's complement
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd5 (FUNC_TCP)
    And ReadData1 equals A
    When the ALU executes with ALUOp 5
    Then the ALU result C should equal (~A + 1)

  @execute @rtype
  Formal Scenario: R-type SHL computes correct left shift
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd6 (FUNC_SHL)
    And ReadData1 equals A
    When the ALU executes with ALUOp 6
    Then the ALU result C should equal (A << 1)

  @execute @rtype
  Formal Scenario: R-type SHR computes correct arithmetic right shift
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd7 (FUNC_SHR)
    And ReadData1 equals A
    When the ALU executes with ALUOp 7
    Then the ALU result C should equal (A >>> 1)

  @execute @itype
  Formal Scenario: ADI computes rs plus sign-extended immediate
    Given opcode equals 4'd4 (OPCODE_ADI)
    And ReadData1 equals A
    And the sign-extended immediate equals IMM
    When the ALU executes with ALUOp 0
    Then the ALU result C should equal A + IMM

  @execute @itype
  Formal Scenario: ORI computes rs OR sign-extended immediate
    Given opcode equals 4'd5 (OPCODE_ORI)
    And ReadData1 equals A
    And the sign-extended immediate equals IMM
    When the ALU executes with ALUOp 3
    Then the ALU result C should equal (A | IMM)

  @execute @itype
  Formal Scenario: LHI loads immediate into high 8 bits
    Given opcode equals 4'd6 (OPCODE_LHI)
    And the immediate field equals IMM8
    When the ALU executes with ALUOp 8
    Then the ALU result C should equal {IMM8[7:0], 8'b0}

  @execute @itype
  Formal Scenario: LWD computes effective memory address
    Given opcode equals 4'd7 (OPCODE_LWD)
    And ReadData1 equals A
    And the sign-extended immediate equals IMM
    When the ALU executes with ALUOp 0
    Then the ALU result C should equal A + IMM

  @execute @itype
  Formal Scenario: SWD computes effective memory address
    Given opcode equals 4'd8 (OPCODE_SWD)
    And ReadData1 equals A
    And the sign-extended immediate equals IMM
    When the ALU executes with ALUOp 0
    Then the ALU result C should equal A + IMM

  @execute @branch
  Formal Scenario: BNE sets bcond when operands differ
    Given opcode equals 4'd0 (OPCODE_BNE)
    And ReadData1 equals A
    And ReadData2 equals B
    When the ALU executes with ALUOp 9
    Then bcond should be 1 if A is not equal to B
    And bcond should be 0 if A equals B

  @execute @branch
  Formal Scenario: BEQ sets bcond when operands are equal
    Given opcode equals 4'd1 (OPCODE_BEQ)
    And ReadData1 equals A
    And ReadData2 equals B
    When the ALU executes with ALUOp 10
    Then bcond should be 1 if A equals B
    And bcond should be 0 if A is not equal to B

  @execute @branch
  Formal Scenario: BGZ sets bcond when rs is greater than zero
    Given opcode equals 4'd2 (OPCODE_BGZ)
    And ReadData1 equals A
    When the ALU executes with ALUOp 11
    Then bcond should be 1 if A is greater than 0
    And bcond should be 0 if A is less than or equal to 0

  @execute @branch
  Formal Scenario: BLZ sets bcond when rs is less than zero
    Given opcode equals 4'd3 (OPCODE_BLZ)
    And ReadData1 equals A
    When the ALU executes with ALUOp 12
    Then bcond should be 1 if A is less than 0
    And bcond should be 0 if A is greater than or equal to 0

  @memory
  Formal Scenario: LWD asserts readM and sets address to computed ALU result
    Given opcode equals 4'd7 (OPCODE_LWD)
    And the ALU result equals ADDR
    And the CPU is in the memory access stage
    Then readM should be 1
    And address should equal ADDR

  @memory
  Formal Scenario: LWD latches memory data when inputReady is asserted
    Given opcode equals 4'd7 (OPCODE_LWD)
    And the CPU is in the memory access stage
    And inputReady is 1
    And data bus carries value MEMDATA
    When a clock edge occurs
    Then the internal dataReg should equal MEMDATA

  @memory
  Formal Scenario: SWD asserts MemWrite and drives data bus with ReadData2
    Given opcode equals 4'd8 (OPCODE_SWD)
    And the ALU result equals ADDR
    And ReadData2 equals STOREVAL
    And the CPU is in the memory access stage
    Then MemWrite should be 1
    And address should equal ADDR
    And data should equal STOREVAL

  @memory
  Formal Scenario: SWD waits for inputReady before completing memory write
    Given opcode equals 4'd8 (OPCODE_SWD)
    And the CPU is in the memory access stage
    And inputReady is 0
    When a clock edge occurs
    Then the CPU should remain in the memory access stage

  @writeback
  Formal Scenario: RegWrite writes ALU result to destination register for R-type
    Given opcode equals 4'b1111 (OPCODE_R)
    And function is not equal to 6'd28 (FUNC_WWD)
    And RegWrite is 1
    And RegDst is 1
    And the ALU result equals RESULT
    And destination register field equals RD
    When a clock edge occurs in the write-back stage
    Then the register at address RD should equal RESULT on the next cycle

  @writeback
  Formal Scenario: RegWrite writes ALU result to rt for I-type non-LWD instructions
    Given opcode X is one of ADI, ORI, LHI
    And RegWrite is 1
    And RegDst is 0
    And the ALU result equals RESULT
    And destination register field equals RT
    When a clock edge occurs in the write-back stage
    Then the register at address RT should equal RESULT on the next cycle

  @writeback
  Formal Scenario: LWD writes dataReg to destination register
    Given opcode equals 4'd7 (OPCODE_LWD)
    And RegWrite is 1
    And MemtoReg is 1
    And the internal dataReg equals MEMDATA
    And destination register field equals RT
    When a clock edge occurs in the write-back stage
    Then the register at address RT should equal MEMDATA on the next cycle

  @writeback
  Formal Scenario: No register write occurs when RegWrite is 0
    Given RegWrite is 0
    And the register at address RD currently holds value OLD
    When a clock edge occurs in the write-back stage
    Then the register at address RD should still equal OLD on the next cycle

  @writeback
  Formal Scenario: WWD instruction does not write to register file
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd28 (FUNC_WWD)
    Then RegWrite should be 0

  @pcupdate @jump
  Formal Scenario: JMP sets next PC using jump target
    Given opcode equals 4'd9 (OPCODE_JMP)
    And the current PC equals P
    And instruction bits [11:0] equal TARGET
    When PC update occurs
    Then the next PC should equal {P[15:12], TARGET}

  @pcupdate @jump
  Formal Scenario: JAL sets next PC to jump target and writes return address to R3
    Given opcode equals 4'd10 (OPCODE_JAL)
    And the current PC equals P
    And instruction bits [11:0] equal TARGET
    When PC update occurs
    Then the next PC should equal {P[15:12], TARGET}
    And the register at address 2'b11 should equal P + 1 on the next cycle

  @pcupdate @branch
  Formal Scenario: Branch instruction with true condition updates PC with offset
    Given Branch is 1
    And bcond is 1
    And the current PC equals P
    And the sign-extended immediate equals IMM
    When PC update occurs
    Then the next PC should equal P + IMM

  @pcupdate @branch
  Formal Scenario: Branch instruction with false condition increments PC by 1
    Given Branch is 1
    And bcond is 0
    And the current PC equals P
    When PC update occurs
    Then the next PC should equal P + 1

  @pcupdate @sequential
  Formal Scenario: Non-jump non-branch instruction increments PC by 1
    Given Jump is 0
    And Branch is 0
    And the current PC equals P
    When PC update occurs
    Then the next PC should equal P + 1

  @pcupdate @rtype
  Formal Scenario: JPR sets PC to register value
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd25 (FUNC_JPR)
    And ReadData1 equals A
    When PC update occurs
    Then the next PC should equal A

  @pcupdate @rtype
  Formal Scenario: JRL sets PC to register value and saves return address
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd26 (FUNC_JRL)
    And ReadData1 equals A
    And the current PC equals P
    And destination register field equals RD
    When PC update occurs
    Then the next PC should equal A
    And the register at address RD should equal P + 1 on the next cycle

  @io @rtype
  Formal Scenario: RWD reads input port value into register
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd27 (FUNC_RWD)
    And input port value equals INVAL
    And destination register field equals RD
    When a clock edge occurs in the write-back stage
    Then the register at address RD should equal INVAL on the next cycle

  @io @rtype @output
  Formal Scenario: WWD drives output_port with ReadData1 value
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd28 (FUNC_WWD)
    And ReadData1 equals A
    Then OpenPort should be 1
    And output_port should equal A

  @io @rtype @output
  Formal Scenario: output_port is high-impedance when OpenPort is 0
    Given OpenPort is 0
    Then output_port should be 16'bz

  @control @rtype
  Formal Scenario: HLT instruction halts CPU execution
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd29 (FUNC_HLT)
    When a clock edge occurs
    Then the CPU should stop updating PC
    And RegWrite should be 0

  @control @rtype
  Formal Scenario: ENI instruction enables interrupt without register write
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd30 (FUNC_ENI)
    Then RegWrite should be 0

  @control @rtype
  Formal Scenario: DSI instruction disables interrupt without register write
    Given opcode equals 4'b1111 (OPCODE_R)
    And function equals 6'd31 (FUNC_DSI)
    Then RegWrite should be 0

  @instcount
  Formal Scenario: num_inst increments by 1 upon each completed instruction
    Given reset_n is asserted (reset_n = 1)
    And num_inst currently equals N
    And an instruction completes its write-back or final stage this cycle
    When a clock edge occurs
    Then num_inst should equal N + 1

  @instcount
  Formal Scenario: num_inst does not increment while instruction is stalled awaiting inputReady
    Given reset_n is asserted (reset_n = 1)
    And num_inst currently equals N
    And inputReady is 0
    And the CPU is stalled in fetch or memory access stage
    When a clock edge occurs
    Then num_inst should equal N

  @control
  Formal Scenario: ALUSrc selects immediate for non-R-type non-branch-equal instructions
    Given opcode X is not equal to 4'b1111 (OPCODE_R)
    And opcode X is not equal to 4'd0 (OPCODE_BNE)
    And opcode X is not equal to 4'd1 (OPCODE_BEQ)
    Then ALUSrc should be 1

  @control
  Formal Scenario: ALUSrc selects register data for R-type and equality-branch instructions
    Given opcode X is 4'b1111 (OPCODE_R) or 4'd0 (OPCODE_BNE) or 4'd1 (OPCODE_BEQ)
    Then ALUSrc should be 0