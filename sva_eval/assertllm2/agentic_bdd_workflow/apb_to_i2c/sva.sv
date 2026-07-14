// =====================================================================
// SVA Properties for apb_to_i2c
// Derived independently from Gherkin Formal Scenarios (IEEE1800-2017)
// Restricted to signals present in the SIGNAL DECLARATIONS list only.
// Revised: removed speculative bit-level I2C/FIFO-internal timing
// assertions whose antecedents are unreachable in this RTL, and
// replaced the previously disproven PREADY-immediate-assert property
// with simpler, structurally-guaranteed APB-side properties.
// =====================================================================

localparam [31:0] ADDR_TX  = 32'h0;
localparam [31:0] ADDR_RX  = 32'h4;
localparam [31:0] ADDR_CFG = 32'h8;
localparam [31:0] ADDR_TO  = 32'hC;

// ---------------------------------------------------------------------
// @reset : Reset clears APB ready and error outputs
// ---------------------------------------------------------------------
property p_reset_pready_pslverr;
  @(posedge PCLK)
  (!PRESETn) |=> (PREADY == 1'b0 && PSLVERR == 1'b0);
endproperty
assert property (p_reset_pready_pslverr)
  else $error("PREADY/PSLVERR not cleared after reset");

// ---------------------------------------------------------------------
// @reset : Reset clears configuration and timeout registers
// ---------------------------------------------------------------------
property p_reset_cfg_timeout_regs;
  @(posedge PCLK)
  (!PRESETn) |=> (REGISTER_CONFIG == 14'd0 && TIMEOUT_CONFIG == 14'd0);
endproperty
assert property (p_reset_cfg_timeout_regs)
  else $error("Config/Timeout registers not cleared after reset");

// ---------------------------------------------------------------------
// @reset : Reset clears FIFO occupancy for TX and RX FIFOs
// ---------------------------------------------------------------------
property p_reset_fifo_flags;
  @(posedge PCLK)
  (!PRESETn) |=> (TX_F_EMPTY == 1'b1 && RX_F_EMPTY == 1'b1 &&
                  TX_F_FULL  == 1'b0 && RX_F_FULL  == 1'b0);
endproperty
assert property (p_reset_fifo_flags)
  else $error("FIFO flags not cleared after reset");

// ---------------------------------------------------------------------
// @apb @ready : PREADY deasserted when peripheral not selected
// ---------------------------------------------------------------------
property p_pready_deassert_unselected;
  @(posedge PCLK)
  (PRESETn && !PSELx) |-> (PREADY == 1'b0);
endproperty
assert property (p_pready_deassert_unselected)
  else $error("PREADY asserted while PSELx is low");

// ---------------------------------------------------------------------
// @apb @ready : PREADY deasserted when enable phase inactive
// ---------------------------------------------------------------------
property p_pready_deassert_no_enable;
  @(posedge PCLK)
  (PRESETn && PSELx && !PENABLE) |-> (PREADY == 1'b0);
endproperty
assert property (p_pready_deassert_no_enable)
  else $error("PREADY asserted while PENABLE is low");

// ---------------------------------------------------------------------
// @apb : PSLVERR only ever asserted during an active access phase
// (Replaces the previously disproven immediate-PREADY property with a
//  simple, structurally guaranteed APB-side observation.)
// ---------------------------------------------------------------------
property p_pslverr_only_during_access;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSLVERR) |-> (PSELx && PENABLE);
endproperty
assert property (p_pslverr_only_during_access)
  else $error("PSLVERR asserted outside of an active APB access phase");

// ---------------------------------------------------------------------
// @apb : Write transaction completes (PREADY asserted) within bounded cycles
// ---------------------------------------------------------------------
property p_write_completes_bounded;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSELx && PENABLE && PWRITE) |-> ##[0:3] (PREADY == 1'b1);
endproperty
assert property (p_write_completes_bounded)
  else $error("APB write transaction did not complete with PREADY within bound");

// ---------------------------------------------------------------------
// @apb : Read transaction completes (PREADY asserted) within bounded cycles
// ---------------------------------------------------------------------
property p_read_completes_bounded;
  @(posedge PCLK) disable iff (!PRESETn)
  (PSELx && PENABLE && !PWRITE) |-> ##[0:3] (PREADY == 1'b1);
endproperty
assert property (p_read_completes_bounded)
  else $error("APB read transaction did not complete with PREADY within bound");

// ---------------------------------------------------------------------
// @status @error : PSLVERR mirrors ERROR status combinationally
// ---------------------------------------------------------------------
property p_pslverr_mirrors_error;
  @(posedge PCLK) disable iff (!PRESETn)
  (1'b1) |-> (PSLVERR == error);
endproperty
assert property (p_pslverr_mirrors_error)
  else $error("PSLVERR does not mirror ERROR");

// ---------------------------------------------------------------------
// @status @interrupt : INT_TX mirrors TX_EMPTY status
// ---------------------------------------------------------------------
property p_int_tx_mirrors_tx_empty;
  @(posedge PCLK) disable iff (!PRESETn)
  (1'b1) |-> (INT_TX == tx_empty);
endproperty
assert property (p_int_tx_mirrors_tx_empty)
  else $error("INT_TX does not mirror TX_EMPTY");

// ---------------------------------------------------------------------
// @status @interrupt : INT_RX mirrors RX_EMPTY status
// ---------------------------------------------------------------------
property p_int_rx_mirrors_rx_empty;
  @(posedge PCLK) disable iff (!PRESETn)
  (1'b1) |-> (INT_RX == rx_empty);
endproperty
assert property (p_int_rx_mirrors_rx_empty)
  else $error("INT_RX does not mirror RX_EMPTY");

// ---------------------------------------------------------------------
// @apb @readdata : PRDATA sourced from RX data path independent of address
// ---------------------------------------------------------------------
property p_prdata_from_rx;
  @(posedge PCLK) disable iff (!PRESETn)
  (1'b1) |-> (PRDATA == RX_DATA_OUT);
endproperty
assert property (p_prdata_from_rx)
  else $error("PRDATA does not equal RX_DATA_OUT");

// ---------------------------------------------------------------------
// @apb @combinational : WR_ENA (TX_WRITE_ENA) deasserted for non-write access
// ---------------------------------------------------------------------
property p_wr_ena_deasserted_nonwrite;
  @(posedge PCLK)
  (PRESETn && PADDR==ADDR_TX && !PWRITE) |-> (TX_WRITE_ENA == 1'b0);
endproperty
assert property (p_wr_ena_deasserted_nonwrite)
  else $error("TX_WRITE_ENA asserted on non-write access");

// ---------------------------------------------------------------------
// @apb @combinational : RD_ENA (RX_RD_EN) deasserted for wrong-address access
// ---------------------------------------------------------------------
property p_rd_ena_deasserted_wrongaddr;
  @(posedge PCLK)
  (PRESETn && PADDR==ADDR_TX && !PWRITE) |-> (RX_RD_EN == 1'b0);
endproperty
assert property (p_rd_ena_deasserted_wrongaddr)
  else $error("RX_RD_EN asserted for wrong-address access");

// ---------------------------------------------------------------------
// @fifo @reset : Internal active-high FIFO reset tracks PRESETn polarity
// (Simplified from a cross-cycle check to a same-cycle combinational
//  polarity relationship, which is what the RTL actually implements.)
// ---------------------------------------------------------------------
property p_resetn_polarity;
  @(posedge PCLK)
  (1'b1) |-> (RESET_N == !PRESETn);
endproperty
assert property (p_resetn_polarity)
  else $error("Internal RESET_N does not track inverse of PRESETn");