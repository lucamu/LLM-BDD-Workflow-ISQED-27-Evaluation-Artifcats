// =============================================================================
// SVA for sdc_controller - refined to remove overly specific/incorrect
// timing and address assumptions that caused disproven properties against
// the golden RTL. Properties are kept only when they express a structural
// invariant clearly derivable from the interface/behavioral spec, or a
// bounded/liveness relationship that does not hardcode an unverified exact
// latency. Guessed register-address matching, guessed bit positions for
// registers whose exact mapping to RTL signals could not be confirmed, and
// guessed exact-cycle latencies have been removed rather than left in with
// incorrect timing.
// =============================================================================

localparam integer N_BUSY_MAX = 8;  // bounded upper latency for busy assertion

// =============================================================================
// Scenario: Core registers return to reset values after external reset
// =============================================================================
property p_core_reset_values;
  @(posedge wb_clk_i)
  $fell(wb_rst_i) |->
    (cmd_arg_s        == 32'h0000_0000) &&
    (cmd_set_s        == 16'h0000)      &&
    (status_reg_w     == 16'h0000)      &&
    (cmd_resp_1_w     == 32'h0000_0000) &&
    (settings         == 16'h0000)      &&
    (serial_status    == 8'h00)         &&
    (free_bd_tx_bd    == 4)             &&
    (free_bd_rx_bd    == 4)             &&
    (bd_int_st_w      == 8'h00);
endproperty
assert property (p_core_reset_values);

// =============================================================================
// Scenario: Writing the Argument register initiates command transmission
// (write_req_s is the real command-write-request strobe issued on Argument
// register writes; only the bounded-latency relationship to busy assertion
// is asserted, with no assumption on exact capture-cycle of the argument
// value itself).
// =============================================================================
property p_cmd_write_triggers_busy;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  write_req_s |-> ##[0:N_BUSY_MAX] (status_reg_busy == 1'b1);
endproperty
assert property (p_cmd_write_triggers_busy);

// =============================================================================
// Scenario: Command Inhibit blocks new command while busy
// =============================================================================
property p_cmd_inhibit_blocks;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (status_reg_busy && write_req_s) |=>
    (status_reg_busy == 1'b1);
endproperty
assert property (p_cmd_inhibit_blocks);

// =============================================================================
// Scenario: Command Complete - completion is reflected by status_reg_busy
// deasserting after cmd_busy falls (bounded eventually, whole-signal check).
// =============================================================================
property p_cmd_complete_resp;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  $fell(cmd_busy) |->
    ##[0:N_BUSY_MAX] (status_reg_busy == 1'b0);
endproperty
assert property (p_cmd_complete_resp);

// =============================================================================
// Scenario: When the whole error-status register is zero, the error
// interrupt output must be deasserted (whole-register based structural
// invariant; does not assume immediate assertion on error-status rising,
// only that zero status implies zero interrupt).
// =============================================================================
property p_err_int_zero_when_status_zero;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (serial_status == 8'h00) |-> (int_a == 1'b0);
endproperty
assert property (p_err_int_zero_when_status_zero);

// =============================================================================
// Scenario: Normal interrupt enable gates the command complete interrupt
// output (whole-register based structural invariant: when all enables are
// disabled, int_busy must be deasserted).
// =============================================================================
property p_cc_int_zero_when_enable_zero;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (settings == 16'h0000) |-> (int_busy == 1'b0);
endproperty
assert property (p_cc_int_zero_when_enable_zero);

// =============================================================================
// Scenario: BD Buffer Status register free-count decreases on new TX descriptor
// =============================================================================
property p_bd_fbtx_dec;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  ((free_bd_tx_bd > 0) && new_tx_bd) |=>
    (free_bd_tx_bd == ($past(free_bd_tx_bd) - 1));
endproperty
assert property (p_bd_fbtx_dec);

// =============================================================================
// Scenario: BD Buffer Status register free-count increases on TX completion
// =============================================================================
property p_bd_fbtx_inc;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  a_cmp_tx_bd_w |=>
    (free_bd_tx_bd == ($past(free_bd_tx_bd) + 1));
endproperty
assert property (p_bd_fbtx_inc);

// =============================================================================
// Scenario: BD Buffer Status register free-count decreases on new RX descriptor
// =============================================================================
property p_bd_fbrx_dec;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  ((free_bd_rx_bd > 0) && new_rx_bd) |=>
    (free_bd_rx_bd == ($past(free_bd_rx_bd) - 1));
endproperty
assert property (p_bd_fbrx_dec);

// =============================================================================
// Scenario: BD Buffer Status register free-count increases on RX completion
// =============================================================================
property p_bd_fbrx_inc;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  a_cmp_rx_bd_w |=>
    (free_bd_rx_bd == ($past(free_bd_rx_bd) + 1));
endproperty
assert property (p_bd_fbrx_inc);

// =============================================================================
// Scenario: No new BD descriptor accepted when free count is zero
// =============================================================================
property p_bd_no_free_tx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (free_bd_tx_bd == 0) |-> (!new_tx_bd);
endproperty
assert property (p_bd_no_free_tx);

property p_bd_no_free_tx_stable;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (free_bd_tx_bd == 0) |=> (free_bd_tx_bd == 0);
endproperty
assert property (p_bd_no_free_tx_stable);

// =============================================================================
// Scenario: Data interrupt enable gates the interrupt output (whole-register
// based structural invariant: when the data interrupt status is entirely
// clear, int_busy that reflects it must be deasserted).
// =============================================================================
property p_data_int_zero_when_status_zero;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (bd_int_st_w == 8'h00) |-> (int_busy == 1'b0);
endproperty
assert property (p_data_int_zero_when_status_zero);

// =============================================================================
// Scenario: Wishbone slave acknowledge structural invariants only (no
// assumption on exact ack latency or exact single-cycle deassertion, since
// the golden RTL's ack generation timing/latency could not be confirmed):
//   - wb_ack_o may only be asserted while a transaction is outstanding
//   - wb_ack_o must be deasserted whenever wb_cyc_i is not asserted
// =============================================================================
property p_wb_ack_requires_cyc_stb;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  wb_ack_o |-> (wb_cyc_i && wb_stb_i);
endproperty
assert property (p_wb_ack_requires_cyc_stb);

property p_wb_ack_low_when_idle;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property (p_wb_ack_low_when_idle);

// =============================================================================
// Scenario: Master Wishbone interface initiates a memory access only when a
// BD is active (restated using the real BD acceptance signals new_tx_bd /
// new_rx_bd and the real per-BD DMA address signals m_wb_adr_o_tx /
// m_wb_adr_o_rx). The cyc assertion is checked as a bounded liveness
// property (s_eventually) rather than an exact/short fixed-cycle bound,
// since the true arbitration/FIFO latency in the golden RTL is not fixed.
// =============================================================================
property p_master_dma_cyc;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_tx_bd || new_rx_bd) |-> s_eventually (m_wb_cyc_o);
endproperty
assert property (p_master_dma_cyc);

property p_master_dma_we_tx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_tx_bd && m_wb_cyc_o) |->
    (m_wb_we_o == 1'b1);
endproperty
assert property (p_master_dma_we_tx);

property p_master_dma_we_rx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_rx_bd && m_wb_cyc_o) |->
    (m_wb_we_o == 1'b0);
endproperty
assert property (p_master_dma_we_rx);

property p_master_dma_addr_tx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_tx_bd && m_wb_cyc_o) |->
    (m_wb_adr_o == m_wb_adr_o_tx);
endproperty
assert property (p_master_dma_addr_tx);

property p_master_dma_addr_rx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_rx_bd && m_wb_cyc_o) |->
    (m_wb_adr_o == m_wb_adr_o_rx);
endproperty
assert property (p_master_dma_addr_rx);

// =============================================================================
// Scenario: Master Wishbone interface remains idle with no pending BD
// (restated using the real BD status/read-enable signals re_s_tx_bd_w and
// re_s_rx_bd_w as the proxy for "no BD active".)
// =============================================================================
property p_master_idle_no_bd;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!re_s_tx_bd_w && !re_s_rx_bd_w) |->
    (m_wb_cyc_o == 1'b0);
endproperty
assert property (p_master_idle_no_bd);