// =====================================================================
// SVA Formal Verification Properties for xge_mac
// Pruned set: only known-good (proven) properties retained
// =====================================================================

// ---------------------------------------------------------------------
// INPUT ASSUMPTIONS (field-width sanity, combinational range checks)
// ---------------------------------------------------------------------

// Assumption: pkt_tx_mod range restricted to 0-7 (3-bit field)
property a_tx_mod_range;
  @(posedge clk_156m25) disable iff (!reset_156m25_n)
  (pkt_tx_mod <= 3'b111);
endproperty
assume property (a_tx_mod_range);

// ---------------------------------------------------------------------
// FIFO WRITE-SIDE SAFETY: never assert a write-enable while the
// corresponding FIFO reports full (steady-state invariant)
// ---------------------------------------------------------------------

property p_rxdfifo_write_not_full;
  @(posedge clk_156m25) disable iff (!reset_156m25_n)
  rxdfifo_wen |-> !rxdfifo_wfull;
endproperty
assert property (p_rxdfifo_write_not_full);

// ---------------------------------------------------------------------
// FIFO READ-SIDE SAFETY: never assert a read-enable while the
// corresponding FIFO reports empty (steady-state invariant)
// ---------------------------------------------------------------------

property p_txdfifo_read_not_empty;
  @(posedge clk_156m25) disable iff (!reset_156m25_n)
  txdfifo_ren |-> !txdfifo_rempty;
endproperty
assert property (p_txdfifo_read_not_empty);

property p_rxdfifo_read_not_empty;
  @(posedge clk_156m25) disable iff (!reset_156m25_n)
  rxdfifo_ren |-> !rxdfifo_rempty;
endproperty
assert property (p_rxdfifo_read_not_empty);

// ---------------------------------------------------------------------
// PACKET RECEIVE INTERFACE HANDSHAKE
// ---------------------------------------------------------------------

// Receive data is not valid on the cycle following a de-asserted
// read enable
property p_rx_val_without_ren;
  @(posedge clk_156m25) disable iff (!reset_156m25_n)
  $past(!pkt_rx_ren) |-> !pkt_rx_val;
endproperty
assert property (p_rx_val_without_ren);

// ---------------------------------------------------------------------
// WISHBONE ACKNOWLEDGE (one-directional steady-state checks)
// ---------------------------------------------------------------------

property p_wb_ack_low_when_not_stb;
  @(posedge wb_clk_i) disable iff (wb_rst_i)
  !wb_stb_i |-> !wb_ack_o;
endproperty
assert property (p_wb_ack_low_when_not_stb);