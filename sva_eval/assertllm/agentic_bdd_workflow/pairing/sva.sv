// =====================================================================
// Local declarations required for the assertions below.
// fsm_state, need_src2, more_instr, output_addr, R0, R1, R2,
// add_sub_out, cubic_out, mult_out, pe_result_valid, op_add_sub,
// op_cubic, op_mult and the internal RAM storage array "mem" are
// assumed to be internal DUT signals made visible to this checker
// (e.g. via bind / hierarchical reference) as described in the
// specification background.
//
// NOTE: The golden RTL (const.v) uses "const" as an identifier which
// conflicts with the SystemVerilog reserved keyword. This checker
// avoids `disable iff` constructs entirely; the reset condition is
// instead folded directly into each property's antecedent expression.
// =====================================================================

// FSM state encoding
localparam [2:0] ST_START     = 3'd0,
                 ST_READ_SRC1 = 3'd1,
                 ST_READ_SRC2 = 3'd2,
                 ST_CALC      = 3'd3,
                 ST_WAIT      = 3'd4,
                 ST_WRITE     = 3'd5,
                 ST_DONE      = 3'd6;

// Symbolic (formal) constants representing arbitrary but fixed
// addresses / values used throughout the RAM scenarios.
wire [5:0]   ADDR_A = $anyconst;
wire [5:0]   ADDR_B = $anyconst;
wire [197:0] VAL_V  = $anyconst;
wire [197:0] VAL_W  = $anyconst;

// Constrain the two symbolic addresses to be distinct, as required
// by the isolation / no-corruption scenarios.
property p_addr_distinct;
  @(posedge clk)
  (ADDR_A != ADDR_B);
endproperty
assume property (p_addr_distinct);

// =====================================================================
// Reset behavior
// =====================================================================

// Scenario: Reset forces done inactive
property p_reset_done_inactive;
  @(posedge clk)
  reset |=> (done == 1'b0);
endproperty
assert property (p_reset_done_inactive);

// Scenario: Reset forces control unit into START state
property p_reset_fsm_start;
  @(posedge clk)
  reset |=> (fsm_state == ST_START);
endproperty
assert property (p_reset_fsm_start);

// Scenario: Done remains inactive while reset is held
property p_done_low_during_reset;
  @(posedge clk)
  reset |-> (done == 1'b0);
endproperty
assert property (p_done_low_during_reset);

// =====================================================================
// done signal stability
// =====================================================================

// Scenario: Done stays asserted once the computation completes until next reset
property p_done_sticky;
  @(posedge clk)
  (!reset && done) |=> done;
endproperty
assert property (p_done_sticky);

// =====================================================================
// RAM write / read protocol (external interface)
// =====================================================================

// Scenario: A serial write to RAM address A with value V is accepted only when ready is asserted
property p_ram_write_accepted;
  @(posedge clk)
  (!reset && sel && w && ready && update && (addr == ADDR_A) && (reg_in == VAL_V))
    |=> (mem[ADDR_A] == VAL_V);
endproperty
assert property (p_ram_write_accepted);

// Scenario: Writes to RAM are ignored while ready is deasserted
property p_ram_write_ignored_when_not_ready;
  @(posedge clk)
  (!reset && sel && w && !ready && update && (addr == ADDR_A))
    |=> (mem[ADDR_A] == $past(mem[ADDR_A]));
endproperty
assert property (p_ram_write_ignored_when_not_ready);

// Scenario: A read from RAM address A returns the value previously written to A
property p_ram_read_returns_value;
  @(posedge clk)
  (!reset && sel && !w && ready && update && (addr == ADDR_A) && (mem[ADDR_A] == VAL_V))
    |=> (out == VAL_V);
endproperty
assert property (p_ram_read_returns_value);

// Scenario: Reading from RAM does not modify the stored value
property p_ram_read_no_modify;
  @(posedge clk)
  (!reset && sel && !w && ready && update && (addr == ADDR_A) && (mem[ADDR_A] == VAL_V))
    |=> (mem[ADDR_A] == VAL_V);
endproperty
assert property (p_ram_read_no_modify);

// Scenario: Writing to one RAM address does not affect a different address
property p_ram_write_isolation;
  @(posedge clk)
  (!reset && sel && w && ready && update && (addr == ADDR_A) && (ADDR_A != ADDR_B) &&
   (mem[ADDR_B] == VAL_W))
    |=> (mem[ADDR_B] == VAL_W);
endproperty
assert property (p_ram_write_isolation);

// Scenario: External RAM access requires sel asserted
property p_ram_requires_sel;
  @(posedge clk)
  (!reset && !sel && update) |=> (mem[ADDR_A] == $past(mem[ADDR_A]));
endproperty
assert property (p_ram_requires_sel);

// Scenario: RAM address must remain stable throughout a single write transaction
property p_ram_write_addr_stability;
  @(posedge clk)
  (!reset && ((sel && w && ready && (addr == ADDR_A)) ##1 (sel && (addr != ADDR_A))))
    |-> (mem[ADDR_A] == $past(mem[ADDR_A],2));
endproperty
assert property (p_ram_write_addr_stability);

property p_ram_write_addr_stability_no_corrupt;
  @(posedge clk)
  (!reset && ((sel && w && ready && (addr == ADDR_A)) ##1
   (sel && w && ready && (addr == ADDR_B) && (ADDR_B != ADDR_A))))
    |-> (mem[ADDR_B] == $past(mem[ADDR_B],2));
endproperty
assert property (p_ram_write_addr_stability_no_corrupt);

// Scenario: RAM address must remain stable throughout a single read transaction
property p_ram_read_addr_stability;
  @(posedge clk)
  (!reset && sel && !w && ready) |-> (out == mem[addr]);
endproperty
assert property (p_ram_read_addr_stability);

// =====================================================================
// Control unit FSM
// =====================================================================

// Scenario: START state always transitions to READ_SRC1
property p_fsm_start_to_read1;
  @(posedge clk)
  (!reset && (fsm_state == ST_START)) |=> (fsm_state == ST_READ_SRC1);
endproperty
assert property (p_fsm_start_to_read1);

// Scenario: READ_SRC1 transitions to READ_SRC2 when a second operand is required
property p_fsm_read1_to_read2;
  @(posedge clk)
  (!reset && (fsm_state == ST_READ_SRC1) && need_src2) |=> (fsm_state == ST_READ_SRC2);
endproperty
assert property (p_fsm_read1_to_read2);

// Scenario: READ_SRC1 transitions to CALC when no second operand is required
property p_fsm_read1_to_calc;
  @(posedge clk)
  (!reset && (fsm_state == ST_READ_SRC1) && !need_src2 && more_instr) |=> (fsm_state == ST_CALC);
endproperty
assert property (p_fsm_read1_to_calc);

// Scenario: CALC transitions to WAIT while the arithmetic operation is in progress
property p_fsm_calc_to_wait;
  @(posedge clk)
  (!reset && (fsm_state == ST_CALC)) |=> (fsm_state == ST_WAIT);
endproperty
assert property (p_fsm_calc_to_wait);

// Scenario: WAIT transitions to WRITE once the arithmetic result is ready
property p_fsm_wait_to_write;
  @(posedge clk)
  (!reset && (fsm_state == ST_WAIT) && pe_result_valid) |=> (fsm_state == ST_WRITE);
endproperty
assert property (p_fsm_wait_to_write);

// Scenario: WRITE transitions back to READ_SRC1 to process the next instruction
property p_fsm_write_to_read1;
  @(posedge clk)
  (!reset && (fsm_state == ST_WRITE) && more_instr) |=> (fsm_state == ST_READ_SRC1);
endproperty
assert property (p_fsm_write_to_read1);

// Scenario: READ_SRC1 transitions to DONE when the instruction sequence is complete
property p_fsm_read1_to_done;
  @(posedge clk)
  (!reset && (fsm_state == ST_READ_SRC1) && !more_instr)
    |=> ((fsm_state == ST_DONE) && (done == 1'b1));
endproperty
assert property (p_fsm_read1_to_done);

// =====================================================================
// Processing element control word semantics
// =====================================================================

// Scenario: Add/subtract control word asserts exactly the add/sub function
property p_pe_addsub_exact;
  @(posedge clk)
  (!reset && op_add_sub && !op_cubic && !op_mult)
    |=> (add_sub_out && !cubic_out && !mult_out);
endproperty
assert property (p_pe_addsub_exact);

// Scenario: Cubic control word asserts exactly the cubic function
property p_pe_cubic_exact;
  @(posedge clk)
  (!reset && !op_add_sub && op_cubic && !op_mult)
    |=> (cubic_out && !add_sub_out && !mult_out);
endproperty
assert property (p_pe_cubic_exact);

// Scenario: Multiply control word asserts exactly the multiply function
property p_pe_mult_exact;
  @(posedge clk)
  (!reset && !op_add_sub && !op_cubic && op_mult)
    |=> (mult_out && !add_sub_out && !cubic_out);
endproperty
assert property (p_pe_mult_exact);

// Scenario: Processing element control word is mutually exclusive per operation
property p_pe_control_word_mutex;
  @(posedge clk)
  (!reset && $onehot({op_add_sub, op_cubic, op_mult}))
    |=> ($onehot({add_sub_out, cubic_out, mult_out}));
endproperty
assert property (p_pe_control_word_mutex);

// =====================================================================
// Serial output stability
// =====================================================================

// Scenario: Serial output o is stable when done is not newly asserted
property p_o_stable_when_done_held;
  @(posedge clk)
  (!reset && done && !(sel && w && update && (addr == output_addr)))
    |=> (o == $past(o));
endproperty
assert property (p_o_stable_when_done_held);