// =========================================================================
// SVA Properties for video_stream_scaler (streamScaler)
// Revised to eliminate vacuity: every property now uses either (a) a
// single, atomic antecedent condition (a single signal, no ANDed
// qualifiers), or (b) no antecedent at all (a plain register-equality
// invariant that is evaluated, and can be falsified, every single clock
// cycle regardless of any other signal's value). All previously
// compound/nested antecedents (e.g. "$past(!rst) |->" gated additionally
// by "disable iff (rst)", which effectively required two independent
// conditions to align) have been removed/simplified to remove the
// structural source of vacuity.
// =========================================================================

// -------------------------------------------------------------------------
// Reset behavior (Background: "when rst is asserted all internal control
// and datapath state is reset"; "nextDin"/"dOutValid" deasserted under rst)
// Single atomic antecedent: rst.
// -------------------------------------------------------------------------

property p_reset_nextDin_zero;
  @(posedge clk)
  (rst) |-> (nextDin == 1'b0);
endproperty
assert property (p_reset_nextDin_zero);

property p_reset_dOutValid_zero;
  @(posedge clk)
  (rst) |-> (dOutValid == 1'b0);
endproperty
assert property (p_reset_dOutValid_zero);

property p_reset_fillCount_zero;
  @(posedge clk)
  (rst) |-> (fillCount == '0);
endproperty
assert property (p_reset_fillCount_zero);

property p_reset_writeColCount_zero;
  @(posedge clk)
  (rst) |-> (writeColCount == '0);
endproperty
assert property (p_reset_writeColCount_zero);

property p_reset_writeRowCount_zero;
  @(posedge clk)
  (rst) |-> (writeRowCount == '0);
endproperty
assert property (p_reset_writeRowCount_zero);

property p_reset_discardCountReg_zero;
  @(posedge clk)
  (rst) |-> (discardCountReg == '0);
endproperty
assert property (p_reset_discardCountReg_zero);

property p_reset_outputColumn_zero;
  @(posedge clk)
  (rst) |-> (outputColumn == '0);
endproperty
assert property (p_reset_outputColumn_zero);

property p_reset_outputLine_zero;
  @(posedge clk)
  (rst) |-> (outputLine == '0);
endproperty
assert property (p_reset_outputLine_zero);

property p_reset_xScaleAmount_zero;
  @(posedge clk)
  (rst) |-> (xScaleAmount == '0);
endproperty
assert property (p_reset_xScaleAmount_zero);

property p_reset_yScaleAmount_zero;
  @(posedge clk)
  (rst) |-> (yScaleAmount == '0);
endproperty
assert property (p_reset_yScaleAmount_zero);

// -------------------------------------------------------------------------
// @frame_lifecycle - start pulse reinitializes read and write frame state
// Single atomic antecedent: start.
// -------------------------------------------------------------------------

property p_start_resets_read_coords;
  @(posedge clk) disable iff (rst)
  (start) |=> (outputColumn == '0 && outputLine == '0);
endproperty
assert property (p_start_resets_read_coords);

property p_start_resets_write_coords;
  @(posedge clk) disable iff (rst)
  (start) |=> (writeColCount == '0 && writeRowCount == '0);
endproperty
assert property (p_start_resets_write_coords);

// -------------------------------------------------------------------------
// @output_valid_latency - dOutValid pipeline shift chain
// No antecedent at all: plain register-copy invariant checked every cycle.
// -------------------------------------------------------------------------

property p_dOutValid_stage2_shift;
  @(posedge clk) disable iff (rst)
  (dOutValid_2 == $past(dOutValid_1));
endproperty
assert property (p_dOutValid_stage2_shift);

property p_dOutValid_stage3_shift;
  @(posedge clk) disable iff (rst)
  (dOutValid_3 == $past(dOutValid_2));
endproperty
assert property (p_dOutValid_stage3_shift);

property p_dOutValid_final_shift;
  @(posedge clk) disable iff (rst)
  (dOutValid == $past(dOutValid_3));
endproperty
assert property (p_dOutValid_final_shift);

// -------------------------------------------------------------------------
// @ramfifo - registered neighbor-sample copy
// No antecedent at all: plain register-copy invariant checked every
// cycle (disable iff (rst) alone is a clocking qualifier, not a compound
// antecedent condition).
// -------------------------------------------------------------------------

property p_readData00Reg_copy;
  @(posedge clk) disable iff (rst)
  (readData00Reg == $past(readData00));
endproperty
assert property (p_readData00Reg_copy);

property p_readData01Reg_copy;
  @(posedge clk) disable iff (rst)
  (readData01Reg == $past(readData01));
endproperty
assert property (p_readData01Reg_copy);

property p_readData10Reg_copy;
  @(posedge clk) disable iff (rst)
  (readData10Reg == $past(readData10));
endproperty
assert property (p_readData10Reg_copy);

property p_readData11Reg_copy;
  @(posedge clk) disable iff (rst)
  (readData11Reg == $past(readData11));
endproperty
assert property (p_readData11Reg_copy);

// -------------------------------------------------------------------------
// @write_completion - nextDin deasserted once all input data has been
// written. Single atomic antecedent: allDataWritten.
// -------------------------------------------------------------------------

property p_nextDin_zero_when_allDataWritten;
  @(posedge clk) disable iff (rst)
  (allDataWritten) |-> (nextDin == 1'b0);
endproperty
assert property (p_nextDin_zero_when_allDataWritten);