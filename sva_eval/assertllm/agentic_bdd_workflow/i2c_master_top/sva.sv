// =====================================================================
// SVA Formal Verification Suite for i2c_master_top
// Revision 2: fixed timing/retrigger issues, corrected bit-level
// reasoning per review feedback, widened synchronizer latency windows,
// and loosened previously-vacuous antecedents to reachable variants.
// =====================================================================

// NOTE: ARST_LVL is a parameter of the DUT itself; it is referenced
// directly below and must not be locally redeclared.

// Composite reset condition used to disable checks during reset
wire rst_cond = wb_rst_i || (arst_i == ARST_LVL);

// Field aliases for readability (mapped to real DUT signals)
wire ctr_en   = core_en;
wire ctr_ien  = ien;
wire sr_rxack = rxack;
wire sr_busy  = i2c_busy;
wire sr_al    = al;
wire sr_tip   = tip;
wire sr_if    = irq_flag;

// =====================================================================
// RESET BEHAVIOR
// =====================================================================

// Scenario: Synchronous reset clears all registers
property p_sync_rst_clears_all;
  @(posedge wb_clk_i)
  (wb_rst_i) |=> (prer == 16'hFFFF && ctr == 8'h00 &&
                  txr == 8'h00 && cr == 8'h00 && sr == 8'h00);
endproperty
assert property (p_sync_rst_clears_all);

// Scenario: Synchronous reset clears the Receive register
property p_sync_rst_clears_rxr;
  @(posedge wb_clk_i)
  (wb_rst_i) |=> (rxr == 8'h00);
endproperty
assert property (p_sync_rst_clears_rxr);

// Scenario: Asynchronous reset clears all registers regardless of clock
property p_async_rst_clears_all;
  @(posedge wb_clk_i)
  (arst_i == ARST_LVL) |-> (prer == 16'hFFFF && ctr == 8'h00 &&
                             cr == 8'h00 && sr == 8'h00);
endproperty
assert property (p_async_rst_clears_all);

// Scenario: Deasserting reset allows normal operation
property p_deassert_allows_write;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && wb_we_i && wb_ack_o && (wb_adr_i == 3'h2)) |=>
    (ctr[7:6] == $past(wb_dat_i[7:6]));
endproperty
assert property (p_deassert_allows_write);

// =====================================================================
// WISHBONE INTERFACE
// =====================================================================

// Scenario: Write cycle acknowledges after two clock cycles
// Fix: qualify on the *start* of the access (ack currently low) to
// avoid re-triggering the property on the ack cycle itself.
property p_write_ack_2cyc;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && wb_we_i && !wb_ack_o) |=> (wb_ack_o == 1'b1);
endproperty
assert property (p_write_ack_2cyc);

// Scenario: Read cycle returns registered value after two clock cycles
property p_read_ack_2cyc;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && !wb_we_i && !wb_ack_o) |=> (wb_ack_o == 1'b1);
endproperty
assert property (p_read_ack_2cyc);

// Scenario: No acknowledge without cycle and strobe asserted
// Fix: exclude the cycle immediately following a completed access,
// since ack deassertion there is covered by p_ack_deasserts.
property p_no_ack_without_cycstb;
  @(posedge wb_clk_i) disable iff (rst_cond)
  ((!wb_cyc_i || !wb_stb_i) && !$past(wb_ack_o)) |-> (wb_ack_o == 1'b0);
endproperty
assert property (p_no_ack_without_cycstb);

// Scenario: wb_ack_o deasserts after cycle completes
property p_ack_deasserts;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_ack_o && !(wb_cyc_i && wb_stb_i)) |=> (wb_ack_o == 1'b0);
endproperty
assert property (p_ack_deasserts);

// Scenario: Writing to address 0x03 updates TXR
property p_txr_write_updates;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && wb_we_i && wb_ack_o && (wb_adr_i == 3'h3)) |=>
    (txr == $past(wb_dat_i));
endproperty
assert property (p_txr_write_updates);

// Scenario: Reading address 0x03 returns RXR contents
// Fix: sample only on the rising edge of ack (first ack cycle) so the
// address/data alignment is unambiguous.
property p_rxr_read_not_txval;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o && !$past(wb_ack_o) &&
   (wb_adr_i == 3'h3)) |-> (wb_dat_o == rxr);
endproperty
assert property (p_rxr_read_not_txval);

// Scenario: Writing to address 0x04 issues a Command (accepted at next edge)
// Fix: qualify on start-of-access (ack low) instead of ack level, which
// also makes this reachable/non-vacuous.
property p_cr_write_accept;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (ctr_en && wb_cyc_i && wb_stb_i && wb_we_i && !wb_ack_o && (wb_adr_i == 3'h4)) |=>
    (cr[7:4] == $past(wb_dat_i[7:4]) && cr[0] == $past(wb_dat_i[0]));
endproperty
assert property (p_cr_write_accept);

// Scenario: Reading address 0x04 returns Status register contents
property p_sr_read_returns_status;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o && !$past(wb_ack_o) &&
   (wb_adr_i == 3'h4)) |-> (wb_dat_o == sr);
endproperty
assert property (p_sr_read_returns_status);

// =====================================================================
// PRESCALE REGISTER
// =====================================================================

// Scenario: Prescale register lo-byte is writable when EN is cleared
property p_prer_lo_writable;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (!ctr_en && wb_cyc_i && wb_stb_i && wb_we_i && wb_ack_o && (wb_adr_i == 3'h0)) |=>
    (prer[7:0] == $past(wb_dat_i));
endproperty
assert property (p_prer_lo_writable);

// Scenario: Prescale register hi-byte is writable when EN is cleared
property p_prer_hi_writable;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (!ctr_en && wb_cyc_i && wb_stb_i && wb_we_i && wb_ack_o && (wb_adr_i == 3'h1)) |=>
    (prer[15:8] == $past(wb_dat_i));
endproperty
assert property (p_prer_hi_writable);

// Scenario: Prescale register readback matches last written value
// Fix: use rising edge of ack for unambiguous address/data alignment.
property p_prer_readback;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && !wb_we_i && wb_ack_o && !$past(wb_ack_o) &&
   ((wb_adr_i == 3'h0) || (wb_adr_i == 3'h1))) |->
    ((wb_adr_i == 3'h0) ? (wb_dat_o == prer[7:0]) :
                          (wb_dat_o == prer[15:8]));
endproperty
assert property (p_prer_readback);

// Scenario: Prescale register write ignored while EN is set
// Fix: trigger on start-of-access (ack low) matching the write-update
// pattern used elsewhere, avoiding retrigger during the ack cycle.
property p_prer_write_ignored_en_set;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (ctr_en && wb_cyc_i && wb_stb_i && wb_we_i && !wb_ack_o &&
   ((wb_adr_i == 3'h0) || (wb_adr_i == 3'h1))) |=>
    (prer == $past(prer));
endproperty
assert property (p_prer_write_ignored_en_set);

// =====================================================================
// CONTROL REGISTER
// =====================================================================

// Scenario: Control register EN and IEN bits are directly writable
// Fix: qualified on start-of-access for reachability/consistency.
property p_ctr_en_ien_writable;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (wb_cyc_i && wb_stb_i && wb_we_i && !wb_ack_o && (wb_adr_i == 3'h2)) |=>
    (ctr[7] == $past(wb_dat_i[7]) && ctr[6] == $past(wb_dat_i[6]));
endproperty
assert property (p_ctr_en_ien_writable);

// Scenario: Reserved Control register bits always read as zero
// Fix: sample one cycle later to avoid a same-cycle race with reset
// deassertion / register update.
property p_ctr_reserved_zero;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (1'b1) |=> (ctr[5:0] == 6'b0);
endproperty
assert property (p_ctr_reserved_zero);

// Scenario: Core ignores new commands while EN is cleared
// Fix: widen the observation window (synchronizer latency) and hold
// TIP low throughout that window rather than a single-cycle check.
property p_core_ignores_cmd_en_clear;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (!ctr_en && wb_cyc_i && wb_stb_i && wb_we_i && !wb_ack_o && (wb_adr_i == 3'h4)) |->
    (sr_tip == 1'b0) throughout (##[1:4] 1'b1);
endproperty
assert property (p_core_ignores_cmd_en_clear);

// =====================================================================
// COMMAND REGISTER SEMANTICS
// =====================================================================

// Scenario: Command register auto-clears STA, STO, RD, WR, IACK bits
// Fix: trigger only on the rising edge of the command bits (avoid
// re-triggering while bits remain set) and widen the clear window to
// account for multi-cycle synchronization / byte-transfer latency.
property p_cr_autoclear;
  @(posedge wb_clk_i) disable iff (rst_cond)
  ((cr[7] || cr[6] || cr[5] || cr[4] || cr[0]) &&
   !$past(cr[7] || cr[6] || cr[5] || cr[4] || cr[0])) |-> ##[1:12]
    (cr[7:4] == 4'b0 && cr[0] == 1'b0);
endproperty
assert property (p_cr_autoclear);

// Scenario: Reserved Command register bits always read as zero
// Fix: sample one cycle later, consistent with p_ctr_reserved_zero fix.
property p_cr_reserved_zero;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (1'b1) |=> (cr[2:1] == 2'b0);
endproperty
assert property (p_cr_reserved_zero);

// =====================================================================
// STATUS REGISTER SEMANTICS
// =====================================================================

// Scenario: Reserved Status register bits always read as zero
property p_sr_reserved_zero;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (1'b1) |-> (sr[4:2] == 3'b0);
endproperty
assert property (p_sr_reserved_zero);

// =====================================================================
// ARBITRATION LOST
// =====================================================================

// Scenario: Status AL bit follows the core's internal arbitration-lost
// signal. Fix: trigger on rising edge (reachability) and allow a small
// synchronization window for the status bit to update.
property p_al_status_follows_internal;
  @(posedge wb_clk_i) disable iff (rst_cond)
  ($rose(i2c_al)) |-> ##[0:2] (al == 1'b1);
endproperty
assert property (p_al_status_follows_internal);

// =====================================================================
// INTERRUPT GENERATION
// =====================================================================

// Scenario: Interrupt output reflects IF and IEN
// Fix: wb_inta_o is a registered output; compare it against the
// IEN/IF values sampled one cycle earlier.
property p_inta_reflects_if_ien;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (1'b1) |-> (wb_inta_o == $past(ctr_ien && sr_if));
endproperty
assert property (p_inta_reflects_if_ien);

// Scenario: Interrupt cleared by IACK regardless of IEN
// Fix: trigger on start-of-access (ack low) and widen the completion
// window to account for command synchronization latency.
property p_inta_cleared_by_iack;
  @(posedge wb_clk_i) disable iff (rst_cond)
  (sr_if && wb_cyc_i && wb_stb_i && wb_we_i && !wb_ack_o && (wb_adr_i == 3'h4) &&
   wb_dat_i[0]) |-> ##[1:12] (sr_if == 1'b0 && wb_inta_o == 1'b0);
endproperty
assert property (p_inta_cleared_by_iack);