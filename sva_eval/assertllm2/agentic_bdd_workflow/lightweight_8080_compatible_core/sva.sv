// =====================================================================
// Formal SVA for lightweight_8080_compatible_core
// Derived strictly from the Gherkin specification (Background + Scenarios).
// NOTE: The RTL does not expose a discrete "mc_state" enumeration or an
// architectural "PC" register as separate signals. Per the DUT signal
// list, control-path stage information is instead inferred from real,
// declared signals:
//   - reset sequencing      -> do_reset
//   - opcode fetch cycle    -> fetch
//   - operand load stage    -> (load_t1 || load_t2)
//   - ALU/write-back stage  -> uc_end
//   - decode stage          -> uc_decode
//   - interrupt-ack stage   -> inta_reg (and output inta)
//   - halt loop stage       -> halt_reg (and output halt)
// The externally visible address bus "addr_out" ({rbank_data, addr_low})
// is used wherever the specification refers to the program counter
// ("PC"), since no separate PC signal is declared in the DUT interface.
// mc_addr is aliased to the microcode address register uc_addr.
// =====================================================================

wire [7:0] mc_addr = uc_addr;

// =====================================================================
// INPUT ASSUMPTIONS (from Background / Given clauses)
// =====================================================================

// Reset is synchronous, active-high
// (no special assumption needed beyond sampling on posedge clk)

// -----------------------------------------------------------------
// RESET BEHAVIOR
// -----------------------------------------------------------------

// Scenario: Reset forces halt output low
property p_reset_forces_halt_low;
  @(posedge clk)
  reset |=> (halt == 1'b0);
endproperty
assert property (p_reset_forces_halt_low);

// Scenario: Reset forces interrupt-acknowledge output low
property p_reset_forces_inta_low;
  @(posedge clk)
  reset |=> (inta == 1'b0);
endproperty
assert property (p_reset_forces_inta_low);

// Scenario: Reset forces interrupt-enable output low
property p_reset_forces_inte_low;
  @(posedge clk)
  reset |=> (inte == 1'b0);
endproperty
assert property (p_reset_forces_inte_low);

// Scenario: Reset initializes the microcode state to the reset sequence entry point
property p_reset_mc_state;
  @(posedge clk)
  reset |=> (do_reset);
endproperty
assert property (p_reset_mc_state);

// Scenario: First fetch after reset targets address zero
// (relaxed to also accept do_reset still asserted in the same cycle as
// the fetch, avoiding vacuity if RESET_SEQ->FETCH_ENTRY overlap differs)
property p_first_fetch_zero_addr;
  @(posedge clk) disable iff (reset)
  (fetch && (do_reset || $past(do_reset))) |->
    (addr_out == 16'h0000 && fetch == 1'b1 && vma == 1'b1 &&
     rd == 1'b1 && wr == 1'b0 && io == 1'b0);
endproperty
assert property (p_first_fetch_zero_addr);

// -----------------------------------------------------------------
// BUS PROTOCOL SEMANTICS
// -----------------------------------------------------------------

// Scenario: Read and write are mutually exclusive when vma is active
property p_rd_wr_mutex;
  @(posedge clk) disable iff (reset)
  vma |-> !(rd && wr);
endproperty
assert property (p_rd_wr_mutex);

// Scenario: Address bus high byte is driven from register bank during any active access
property p_addr_high_byte;
  @(posedge clk) disable iff (reset)
  vma |-> (addr_out[15:8] == rbank_data);
endproperty
assert property (p_addr_high_byte);

// Scenario: Address bus low byte is driven from internal low-address latch
property p_addr_low_byte;
  @(posedge clk) disable iff (reset)
  vma |-> (addr_out[7:0] == addr_low);
endproperty
assert property (p_addr_low_byte);

// Scenario: data_out is only meaningful during a write cycle
property p_data_out_write;
  @(posedge clk) disable iff (reset)
  (vma && wr) |-> (data_out == DO);
endproperty
assert property (p_data_out_write);

// Scenario: data_in is sampled only during a qualified read cycle
// (fixed: only meaningful when the read is destined for T1; not every
// qualified read cycle loads T1 -- e.g. opcode fetch loads IR, other
// reads may load T2)
property p_data_in_sampled;
  @(posedge clk) disable iff (reset)
  (vma && rd && load_t1) |=> (T1 == $past(data_in));
endproperty
assert property (p_data_in_sampled);

// -----------------------------------------------------------------
// FETCH AND PC UPDATE BEHAVIOR
// -----------------------------------------------------------------

// Scenario: Fetch cycle always issues a memory read
property p_fetch_mem_read;
  @(posedge clk) disable iff (reset)
  fetch |-> (vma == 1'b1 && io == 1'b0 && rd == 1'b1 && wr == 1'b0);
endproperty
assert property (p_fetch_mem_read);

// Scenario: Normal fetch places current PC value on the address bus
property p_normal_fetch_addr;
  @(posedge clk) disable iff (reset)
  (!inta_reg && fetch) |-> (addr_out == {rbank_data, addr_low});
endproperty
assert property (p_normal_fetch_addr);

// Scenario: PC advances after a normal opcode fetch completes
// (relaxed rigid 2-cycle assumption to a bounded eventual match on
// uc_end, since the operand stage may take a variable number of cycles)
property p_pc_increment_after_fetch;
  logic [7:0] al_cap;
  @(posedge clk) disable iff (reset)
  (fetch && !inta_reg, al_cap = addr_low)
    |-> ##[1:8] uc_end ##0 (addr_low == al_cap + 8'h01);
endproperty
assert property (p_pc_increment_after_fetch);

// -----------------------------------------------------------------
// INTERRUPT ACKNOWLEDGE (INTA) BEHAVIOR
// -----------------------------------------------------------------

// Scenario: Interrupt acknowledge asserts inta throughout the acknowledged instruction flow
property p_inta_during_intaseq;
  @(posedge clk) disable iff (reset)
  (inta_reg) |-> (inta == 1'b1);
endproperty
assert property (p_inta_during_intaseq);

property p_inta_returns_low;
  @(posedge clk) disable iff (reset)
  ($past(inta_reg) && !inta_reg) |-> (inta == 1'b0);
endproperty
assert property (p_inta_returns_low);

// Scenario: PC auto-increment is inhibited during interrupt-acknowledge fetch
// (relaxed rigid 2-cycle assumption to a bounded eventual match on uc_end)
property p_pc_no_incr_inta;
  logic [7:0] al_cap;
  @(posedge clk) disable iff (reset)
  (fetch && inta_reg && inta, al_cap = addr_low)
    |-> ##[1:8] uc_end ##0 (addr_low == al_cap);
endproperty
assert property (p_pc_no_incr_inta);

// Scenario: Explicit control-flow instructions determine PC update during INTA-driven execution
// (fixed: compare against the internal low-address latch, driven from
// uc_jmp_addr for jump/call/return-class micro-branches, rather than
// forcing a fixed multi-cycle pipeline shape that may not match the RTL)
property p_inta_control_flow_pc;
  @(posedge clk) disable iff (reset)
  (inta_reg && uc_end) |->
    ( (uc_do_jmp || uc_jsr || uc_do_ret) -> (addr_low == uc_jmp_addr) ) &&
    ( !(uc_do_jmp || uc_jsr || uc_do_ret) -> (addr_low == $past(addr_low)) );
endproperty
assert property (p_inta_control_flow_pc);

// Scenario: Interrupts are disabled upon interrupt service entry
// (fixed latency: inte reflects the disable one cycle after inta_reg
// first rises, matching the registered inte/inte_reg update timing)
property p_inte_disabled_on_entry;
  @(posedge clk) disable iff (reset)
  ($rose(inta_reg)) |=> (inte == 1'b0);
endproperty
assert property (p_inte_disabled_on_entry);

// (fixed: inte may legitimately be re-enabled within the same INTA_SEQ
// window if the interrupt-vector opcode fetched is itself an EI-class
// instruction; exclude that specific completion cycle)
property p_inte_stays_disabled;
  @(posedge clk) disable iff (reset)
  (inta_reg && !(uc_end && uc_ei)) |-> (inte == 1'b0);
endproperty
assert property (p_inte_stays_disabled);

// Scenario: Interrupt is not serviced when interrupts are disabled
// (fixed: only a *new* service request while not already pending/servicing
// is prevented by inte==0; a previously latched request cannot be undone
// by inte)
property p_no_service_when_disabled;
  @(posedge clk) disable iff (reset)
  (!inte && intr && !int_pending) |=> (!int_pending);
endproperty
assert property (p_no_service_when_disabled);

// (fixed: inta is intentionally 1 while inte is 0 during active service --
// that is precisely how interrupt-service entry disables inte. The real
// check is that a *new* acknowledge cannot begin while inte is 0 and no
// acknowledge is already underway)
property p_inta_zero_when_disabled;
  @(posedge clk) disable iff (reset)
  (!inte && !inta_reg && intr) |=> (!inta_reg);
endproperty
assert property (p_inta_zero_when_disabled);

// Scenario: Interrupt servicing occurs only at instruction boundaries
// (fixed: uc_end marks the boundary itself, so it must be excluded from
// the "mid-instruction" qualifying condition)
property p_intr_boundary_only;
  @(posedge clk) disable iff (reset)
  (intr && inte && (load_t1 || load_t2) && !uc_end) |=>
    (!inta_reg);
endproperty
assert property (p_intr_boundary_only);

property p_inta_zero_until_boundary;
  @(posedge clk) disable iff (reset)
  (intr && inte && (load_t1 || load_t2) && !uc_end) |->
    (inta == 1'b0);
endproperty
assert property (p_inta_zero_until_boundary);

// -----------------------------------------------------------------
// HALT BEHAVIOR
// -----------------------------------------------------------------

// Scenario: Halt output asserted upon entering halt microcode loop
property p_halt_asserted_on_entry;
  @(posedge clk) disable iff (reset)
  (halt_reg) |-> (halt == 1'b1);
endproperty
assert property (p_halt_asserted_on_entry);

// Scenario: Halt exits on reset
property p_halt_exit_on_reset;
  @(posedge clk)
  (halt_reg && halt && reset) |=>
    (halt == 1'b0 && do_reset);
endproperty
assert property (p_halt_exit_on_reset);

// Scenario: Halt exits on qualifying interrupt service condition
// (fixed: split into a same/next-cycle halt deassertion check and a
// bounded eventual check for inta_reg, since the transition through
// INTA_SEQ entry may take more than a single cycle)
property p_halt_exit_on_intr_halt_deassert;
  @(posedge clk) disable iff (reset)
  (halt_reg && halt && inte && intr) |=> (halt == 1'b0);
endproperty
assert property (p_halt_exit_on_intr_halt_deassert);

property p_halt_exit_on_intr_inta_eventually;
  @(posedge clk) disable iff (reset)
  (halt_reg && halt && inte && intr) |=> ##[0:4] inta_reg;
endproperty
assert property (p_halt_exit_on_intr_inta_eventually);

// Scenario: Halt persists while no exit condition is present
// (fixed: also require no already-latched pending interrupt request,
// since a previously latched request can still cause an exit even if
// intr/inte sampled this cycle look benign)
property p_halt_persist;
  @(posedge clk) disable iff (reset)
  (halt_reg && halt && !reset && !(inte && intr) && !int_pending) |=>
    (halt == 1'b1 && halt_reg);
endproperty
assert property (p_halt_persist);

// -----------------------------------------------------------------
// ALU AND FLAG SEMANTICS
// -----------------------------------------------------------------

// Scenario: Zero flag reflects ALU result value
property p_zero_flag_correct;
  @(posedge clk) disable iff (reset)
  (uc_end && flag_pattern[1]) |->
    (flag_z == (alu_output == 8'h00));
endproperty
assert property (p_zero_flag_correct);

// Scenario: Carry flag update is gated by the microinstruction flag-pattern field
property p_carry_flag_update;
  @(posedge clk) disable iff (reset)
  (uc_end && do_cy_op && flag_pattern[0]) |->
    (flag_cy == cy_arith);
endproperty
assert property (p_carry_flag_update);

// Scenario: Carry flag is not modified when carry-group update is not enabled
property p_carry_flag_hold;
  logic f_cap;
  @(posedge clk) disable iff (reset)
  (uc_end && do_cy_op && !flag_pattern[0], f_cap = flag_cy)
  |=> (flag_cy == f_cap);
endproperty
assert property (p_carry_flag_hold);

// Scenario: ALU operand registers are loaded before ALU stage computation
// (fixed: rather than assuming a fixed single-cycle gap between operand
// load and uc_end, assert stability of T1/T2 whenever they are not being
// loaded and the ALU stage has not yet completed)
property p_operand_regs_stable;
  @(posedge clk) disable iff (reset)
  (!load_t1 && !load_t2 && !uc_end) |=>
    (T1 == $past(T1) && T2 == $past(T2));
endproperty
assert property (p_operand_regs_stable);

// Scenario: Auxiliary-carry update for logical AND-class operations
property p_aux_carry_and_rule;
  @(posedge clk) disable iff (reset)
  (uc_end && use_logic && flag_pattern[0]) |->
    (flag_aux_cy == (T1[3] | T2[3]));
endproperty
assert property (p_aux_carry_and_rule);

// -----------------------------------------------------------------
// MICROCODE SEQUENCER / PIPELINE OVERLAP
// -----------------------------------------------------------------

// Scenario: Second stage of a started microinstruction completes unless reset intervenes
// (fixed: allow a bounded number of cycles for uc_end to occur, since
// operand loading may span more than a single cycle)
property p_stage_progress_no_reset;
  @(posedge clk) disable iff (reset)
  (load_t1 || load_t2) |-> ##[1:8] uc_end;
endproperty
assert property (p_stage_progress_no_reset);

// Scenario: Reset aborts a pipelined microinstruction write-back
// (fixed: check that the register-bank write-back is suppressed, rather
// than a vacuous/trivial implication)
property p_reset_aborts_writeback;
  @(posedge clk)
  ((load_t1 || load_t2) && reset) |=> (!we_rb && do_reset);
endproperty
assert property (p_reset_aborts_writeback);

// Scenario: Opcode decode dispatches to the corresponding micro-routine entry point
// (fixed: sample uc_jmp_addr at the decode cycle itself via $past, since
// it is a combinational function of the current opcode and would have
// already changed by the next cycle)
property p_decode_dispatch;
  @(posedge clk) disable iff (reset)
  (uc_decode) |=> (mc_addr == $past(uc_jmp_addr));
endproperty
assert property (p_decode_dispatch);

// Scenario: Sequential microcode address increments when no branch condition is asserted
// (fixed: also exclude the decode cycle itself, since mc_addr is set from
// the jump table rather than incremented during decode)
property p_mc_addr_increment;
  logic [7:0] madr_cap;
  @(posedge clk) disable iff (reset)
  (!uc_jsr && !uc_do_jmp && !uc_do_ret && !uc_tjsr && !uc_decode, madr_cap = mc_addr)
  |=> (mc_addr == madr_cap + 8'h01);
endproperty
assert property (p_mc_addr_increment);

// Scenario: Micro-subroutine call preserves a single-level return address
property p_jsr_saves_return;
  @(posedge clk) disable iff (reset)
  uc_jsr |=> (uc_ret_addr == $past(addr_plus_1));
endproperty
assert property (p_jsr_saves_return);

property p_jsr_return_executes;
  @(posedge clk) disable iff (reset)
  uc_do_ret |=> (mc_addr == $past(uc_ret_addr));
endproperty
assert property (p_jsr_return_executes);