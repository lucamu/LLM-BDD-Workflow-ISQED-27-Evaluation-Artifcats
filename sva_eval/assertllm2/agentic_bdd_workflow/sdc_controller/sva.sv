// =========================================================================
// SDC Controller - Formal SVA (Conservative Revision)
// Focus: top-level Wishbone slave/master interface signals and a small,
// high-confidence subset of internal signals that are explicitly present
// in the SIGNAL DECLARATIONS list. All undeclared registers/hierarchical
// sub-module signals referenced in the Gherkin spec (e.g. time_out_reg,
// software_reset_reg, Bd_status_reg, normal_int_status_reg,
// error_int_status_reg, TIMEOUT_REG, ERR_INT_REG, NORMAL_INT_REG,
// Dat_Int_Status, RST_IN, RST_PAD_I, cmd_setting_reg, argument_reg,
// go_idle_o, int_b, int_c) have been removed rather than invented.
// =========================================================================

localparam [`BD_WIDTH-1:0] MAX_BD_COUNT = {`BD_WIDTH{1'b1}};

// =========================================================================
// RESET BEHAVIOR
// =========================================================================

// Scenario: Wishbone reset forces all outputs to idle state
// (int_b/int_c are not present in the SIGNAL DECLARATIONS list - only
//  int_a is a declared top-level output - so only int_a is checked)
property p_reset_idle_outputs;
  @(posedge wb_clk_i)
  (wb_rst_i) |=> (wb_ack_o   == 1'b0) &&
                 (m_wb_cyc_o == 1'b0) &&
                 (m_wb_stb_o == 1'b0) &&
                 (m_wb_we_o  == 1'b0) &&
                 (m_wb_adr_o == 32'h0) &&
                 (int_a      == 1'b0);
endproperty
assert property (p_reset_idle_outputs);

// Scenario: Core setup sequence completes in required order before normal operation
// (only the new_cmd portion is directly verifiable from declared signals)
property p_setup_new_cmd_zero_after_reset;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  ($past(wb_rst_i) && !wb_rst_i) |-> (new_cmd == 1'b0);
endproperty
assert property (p_setup_new_cmd_zero_after_reset);

// =========================================================================
// WISHBONE SLAVE PROTOCOL
// =========================================================================

// Scenario: Slave acknowledge only asserted during valid cycle and strobe
// Robust to either combinational or one-cycle-registered ack implementation.
property p_wb_ack_only_if_valid;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  wb_ack_o |-> ((wb_cyc_i && wb_stb_i) || ($past(wb_cyc_i) && $past(wb_stb_i)));
endproperty
assert property (p_wb_ack_only_if_valid);

// Scenario: No ack asserted while cyc is deasserted (no spurious ack)
property p_wb_no_ack_without_cyc;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!wb_cyc_i) |-> (!wb_ack_o);
endproperty
assert property (p_wb_no_ack_without_cyc);

// =========================================================================
// CARD DETECT
// =========================================================================

// Scenario: card_detect deasserted prevents sd_cmd_master from issuing new commands
property p_card_detect_blocks_cmd;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!card_detect && new_cmd) |=> (!cmd_busy);
endproperty
assert property (p_card_detect_blocks_cmd);

// Scenario: card_detect asserted allows sd_cmd_master to process a pending command
property p_card_detect_allows_cmd;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (card_detect && new_cmd) |=> (cmd_busy) && (cmd_out_master != 40'h0);
endproperty
assert property (p_card_detect_allows_cmd);

// Scenario: card_detect transition to deasserted while a command is in progress forces command abort
property p_card_detect_abort;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  ($past(card_detect) && !card_detect && $past(cmd_busy)) |=> (!cmd_busy) && (go_idle == 1'b1);
endproperty
assert property (p_card_detect_abort);

// =========================================================================
// MASTER WISHBONE MUX CONTROL
// =========================================================================

// Scenario: Master interface connects to Tx FIFO filler when start_tx_fifo is asserted
property p_mux_tx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (start_tx_fifo) |-> (m_wb_adr_o == m_wb_adr_o_tx) &&
                       (m_wb_we_o  == m_wb_we_o_tx)  &&
                       (m_wb_cyc_o == m_wb_cyc_o_tx) &&
                       (m_wb_stb_o == m_wb_stb_o_tx) &&
                       (m_wb_cti_o == m_wb_cti_o_tx) &&
                       (m_wb_bte_o == m_wb_bte_o_tx);
endproperty
assert property (p_mux_tx);

// Scenario: Master interface connects to Rx FIFO filler when start_rx_fifo is asserted and start_tx_fifo is not
property p_mux_rx;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!start_tx_fifo && start_rx_fifo) |-> (m_wb_adr_o == m_wb_adr_o_rx) &&
                                        (m_wb_we_o  == m_wb_we_o_rx)  &&
                                        (m_wb_cyc_o == m_wb_cyc_o_rx) &&
                                        (m_wb_stb_o == m_wb_stb_o_rx) &&
                                        (m_wb_cti_o == m_wb_cti_o_rx) &&
                                        (m_wb_bte_o == m_wb_bte_o_rx);
endproperty
assert property (p_mux_rx);

// Scenario: Master interface defaults to zero when neither Tx nor Rx transfer is active
property p_mux_default_zero;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (!start_tx_fifo && !start_rx_fifo) |-> (m_wb_adr_o == 32'h0) &&
                                         (m_wb_we_o  == 1'b0) &&
                                         (m_wb_cyc_o == 1'b0) &&
                                         (m_wb_stb_o == 1'b0) &&
                                         (m_wb_cti_o == 3'b0) &&
                                         (m_wb_bte_o == 2'b0);
endproperty
assert property (p_mux_default_zero);

// Scenario: start_tx_fifo takes priority over start_rx_fifo when both asserted
property p_mux_tx_priority;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (start_tx_fifo && start_rx_fifo) |-> (m_wb_adr_o == m_wb_adr_o_tx) &&
                                       (m_wb_cyc_o == m_wb_cyc_o_tx);
endproperty
assert property (p_mux_tx_priority);

// Scenario: Master byte select is always all bytes valid
property p_mux_sel_always_full;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  1'b1 |-> (m_wb_sel_o == 4'b1111);
endproperty
assert property (p_mux_sel_always_full);

// =========================================================================
// STATUS REGISTER COMPOSITION (limited to declared signals)
// =========================================================================

// Scenario: status_reg bit 1 reflects cidat_w
property p_status_reg_bit1;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  1'b1 |-> (status_reg_w[1] == cidat_w);
endproperty
assert property (p_status_reg_bit1);

// Scenario: cmd_int_busy is reflected in status_reg_w bit 0
property p_status_reg_bit0_busy;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (cmd_int_busy) |-> (status_reg_w[0] == 1'b1);
endproperty
assert property (p_status_reg_bit0_busy);

// Scenario: bd_isr_reset clears bd_int_st_w
property p_bd_isr_reset_clear;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (Bd_isr_reset) |=> (bd_int_st_w == 8'h0);
endproperty
assert property (p_bd_isr_reset_clear);

// =========================================================================
// COMMAND SEQUENCE / SUB-MODULE HANDSHAKE
// =========================================================================

// Scenario: write_req_s from data master is granted and reflected as cmd_int_busy
property p_write_req_grant;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (write_req_s && !cmd_busy) |=> (we_ack) && (cmd_int_busy == 1'b1);
endproperty
assert property (p_write_req_grant);

// =========================================================================
// BUFFER DESCRIPTOR RAM
// =========================================================================

// Scenario: Free BD count decreases only on successful write and consumption (Tx)
property p_free_tx_bd_decrement;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_tx_bd) |=> (free_bd_tx_bd == $past(free_bd_tx_bd) - 1'b1);
endproperty
assert property (p_free_tx_bd_decrement);

property p_free_tx_bd_partial_hold;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (we_m_tx_bd && !new_tx_bd) |=> (free_bd_tx_bd == $past(free_bd_tx_bd));
endproperty
assert property (p_free_tx_bd_partial_hold);

// Scenario: Free RX BD count decreases only on successful write and consumption
property p_free_rx_bd_decrement;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (new_rx_bd) |=> (free_bd_rx_bd == $past(free_bd_rx_bd) - 1'b1);
endproperty
assert property (p_free_rx_bd_decrement);

property p_free_rx_bd_partial_hold;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (we_m_rx_bd && !new_rx_bd) |=> (free_bd_rx_bd == $past(free_bd_rx_bd));
endproperty
assert property (p_free_rx_bd_partial_hold);

// Scenario: a_cmp acknowledgment increments free BD count after transfer completion
property p_free_tx_bd_increment;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  (a_cmp_tx_bd_w && (free_bd_tx_bd < MAX_BD_COUNT)) |=> (free_bd_tx_bd == $past(free_bd_tx_bd) + 1'b1);
endproperty
assert property (p_free_tx_bd_increment);

// =========================================================================
// CLOCKING
// =========================================================================

`ifdef SDC_CLK_BUS_CLK
// Scenario: sd_clk_o equals wb_clk_i when SDC_CLK_BUS_CLK is defined
property p_sd_clk_o_eq_wb_clk;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  1'b1 |=> (sd_clk_o == $past(wb_clk_i));
endproperty
assert property (p_sd_clk_o_eq_wb_clk);
`endif

// Scenario: sd_clk_o_pad is an alias of sd_clk_o
property p_sd_clk_o_pad_alias;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  1'b1 |-> (sd_clk_o_pad == sd_clk_o);
endproperty
assert property (p_sd_clk_o_pad_alias);

`ifdef SDC_CLK_SEP
// Scenario: sd_clk_i equals sd_clk_i_pad when SDC_CLK_SEP is defined
property p_sd_clk_i_eq_pad;
  @(posedge sd_clk_i_pad) disable iff (wb_rst_i)
  1'b1 |-> (sd_clk_i == sd_clk_i_pad);
endproperty
assert property (p_sd_clk_i_eq_pad);
`else
// Scenario: sd_clk_i equals wb_clk_i when SDC_CLK_SEP is not defined
property p_sd_clk_i_eq_wb_clk;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  1'b1 |-> (sd_clk_i == wb_clk_i);
endproperty
assert property (p_sd_clk_i_eq_wb_clk);
`endif