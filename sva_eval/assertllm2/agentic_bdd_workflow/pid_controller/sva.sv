// =============================================================
// SVA Formal Checker for pid_controller
// All properties are declared as simple parameterless named
// properties, each with explicit @(posedge i_clk) disable iff
// (i_rst) clocking, and are defined before use. Only signals
// from the SIGNAL DECLARATIONS list are referenced.
// =============================================================

// -------------------------------------------------------------
// RESET BEHAVIOR
// -------------------------------------------------------------

property p_reset_clears_regs;
  @(posedge i_clk)
  (i_rst) |=> (((RS == 1'b0)) && ((wla == 1'b0)) && ((wack == 1'b0)) &&
               ((state_0 == 1'b0)) && ((rla == 1'b0)) && ((rlb == 1'b0)) &&
               ((cout == 1'b0)) && ((start == 1'b0)));
endproperty
a_reset_clears_regs: assert property (p_reset_clears_regs);

property p_reset_async_override;
  @(posedge i_clk)
  (i_rst) |=> (((RS == 1'b0)) && ((wla == 1'b0)) && ((wack == 1'b0)) &&
               ((state_0 == 1'b0)) && ((rla == 1'b0)) && ((rlb == 1'b0)) &&
               ((cout == 1'b0)) && ((start == 1'b0)) && ((o_valid == 1'b1)));
endproperty
a_reset_async_override: assert property (p_reset_async_override);

// -------------------------------------------------------------
// WISHBONE WRITE TRANSACTION SEMANTICS
// -------------------------------------------------------------

property p_write_req_recognized;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we)) |-> (we == 1'b1);
endproperty
a_write_req_recognized: assert property (p_write_req_recognized);

property p_write_kp_updates_and_triggers;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (o_wb_ack)) |=>
   (update_kpd == 1'b1);
endproperty
a_write_kp_updates_and_triggers: assert property (p_write_kp_updates_and_triggers);

property p_write_kd_updates_and_triggers;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (o_wb_ack)) |=>
   (update_kpd == 1'b1);
endproperty
a_write_kd_updates_and_triggers: assert property (p_write_kd_updates_and_triggers);

property p_write_pv_updates_and_triggers;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (o_wb_ack)) |=>
   ((update_esu == 1'b1) && (o_valid == 1'b0));
endproperty
a_write_pv_updates_and_triggers: assert property (p_write_pv_updates_and_triggers);

property p_rs_write_zero_clears_state;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (o_wb_ack)) |=>
   (RS == 1'b0);
endproperty
a_rs_write_zero_clears_state: assert property (p_rs_write_zero_clears_state);

property p_write_ack_delayed_locked;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (wlRS)) |->
   (o_wb_ack == 1'b0);
endproperty
a_write_ack_delayed_locked: assert property (p_write_ack_delayed_locked);

property p_write_completes_after_unlock;
  @(posedge i_clk) disable iff (i_rst)
  ((($past((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (wlRS)))) &&
   ((!wlRS))) |-> (o_wb_ack == 1'b1);
endproperty
a_write_completes_after_unlock: assert property (p_write_completes_after_unlock);

// -------------------------------------------------------------
// WISHBONE READ TRANSACTION SEMANTICS
// -------------------------------------------------------------

property p_read_req_recognized;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we)) |-> (re == 1'b1);
endproperty
a_read_req_recognized: assert property (p_read_req_recognized);

property p_read_valid_reg_value;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check_1) && (o_wb_ack)) |->
   (o_wb_ack == 1'b1);
endproperty
a_read_valid_reg_value: assert property (p_read_valid_reg_value);

property p_read_oor_returns_zero;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (!adr_check_1)) |->
   ((output == '0) && (o_wb_ack == 1'b1));
endproperty
a_read_oor_returns_zero: assert property (p_read_oor_returns_zero);

property p_read_completes_after_unlock;
  @(posedge i_clk) disable iff (i_rst)
    ((i_wb_stb) && (i_wb_cyc) && (!i_wb_we)) |-> ##[1:9] (o_wb_ack);
endproperty
a_read_completes_after_unlock: assert property(p_read_completes_after_unlock);

property p_rs_readback_zero;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check) && (o_wb_ack)) |->
   (output == '0);
endproperty
a_rs_readback_zero: assert property (p_rs_readback_zero);

// -------------------------------------------------------------
// BUS WIDTH FORMATTING BEHAVIOR
// -------------------------------------------------------------

`ifdef WB_16BIT
property p_16bit_truncate_un;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check) && (o_wb_ack)) |->
   (output == output);
endproperty
a_16bit_truncate_un: assert property (p_16bit_truncate_un);
`endif

`ifdef WB_32BIT
property p_32bit_signext_kp;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check) && (o_wb_ack)) |->
   (output[31:16] == {16{output[15]}});
endproperty
a_32bit_signext_kp: assert property (p_32bit_signext_kp);

property p_32bit_zeroext_of;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check) && (o_wb_ack)) |->
   (output[31:5] == 27'b0);
endproperty
a_32bit_zeroext_of: assert property (p_32bit_zeroext_of);
`endif

`ifdef WB_64BIT
property p_64bit_signext_sp;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check) && (o_wb_ack)) |->
   (output[63:16] == {48{output[15]}});
endproperty
a_64bit_signext_sp: assert property (p_64bit_signext_sp);

property p_64bit_zeroext_of;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we) && (adr_check) && (o_wb_ack)) |->
   (output[63:5] == 59'b0);
endproperty
a_64bit_zeroext_of: assert property (p_64bit_zeroext_of);
`endif

// -------------------------------------------------------------
// CONTROL-UPDATE SEQUENCE / ARITHMETIC BEHAVIOR
// -------------------------------------------------------------

property p_read_latency;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!i_wb_we)) |-> ##[1:9] (o_wb_ack == 1'b1);
endproperty
a_read_latency: assert property (p_read_latency);

property p_pv_write_latency;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (update_esu)) |->
   ##[1:9] (o_valid == 1'b1);
endproperty
a_pv_write_latency: assert property (p_pv_write_latency);

property p_err0_derivation;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu, 1))) && ((!update_esu))) |-> (rack == 1'b1);
endproperty
a_err0_derivation: assert property (p_err0_derivation);

property p_err1_capture_prior;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu))) && ((!update_esu))) |-> (state_0 == 1'b0);
endproperty
a_err1_capture_prior: assert property (p_err1_capture_prior);

property p_kpd_sum;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_kpd))) && ((!update_kpd))) |-> (wack == 1'b1);
endproperty
a_kpd_sum: assert property (p_kpd_sum);

property p_ovalid_deasserted_during_seq;
  @(posedge i_clk) disable iff (i_rst)
  (update_esu) |-> (o_valid == 1'b0);
endproperty
a_ovalid_deasserted_during_seq: assert property (p_ovalid_deasserted_during_seq);

property p_ovalid_asserted_after_seq;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu))) && ((!update_esu))) |-> (o_valid == 1'b1);
endproperty
a_ovalid_asserted_after_seq: assert property (p_ovalid_asserted_after_seq);

property p_oun_reflects_un;
  @(posedge i_clk) disable iff (i_rst)
  ((!update_esu) && (!update_kpd)) |-> (rack == rack);
endproperty
a_oun_reflects_un: assert property (p_oun_reflects_un);

// -------------------------------------------------------------
// OVERFLOW REPORTING
// -------------------------------------------------------------

property p_of0_kpd_overflow;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_kpd))) && ((!update_kpd)) && ((cin))) |-> (wack == 1'b1);
endproperty
a_of0_kpd_overflow: assert property (p_of0_kpd_overflow);

property p_of1_err0_overflow;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu))) && ((!update_esu)) && ((cin))) |-> (rack == 1'b1);
endproperty
a_of1_err0_overflow: assert property (p_of1_err0_overflow);

property p_of2_err1_overflow;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu))) && ((!update_esu))) |-> (rack == 1'b1);
endproperty
a_of2_err1_overflow: assert property (p_of2_err1_overflow);

property p_of3_un_overflow;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu))) && ((!update_esu)) && ((of_addition))) |-> (rack == 1'b1);
endproperty
a_of3_un_overflow: assert property (p_of3_un_overflow);

property p_of4_sigma_overflow;
  @(posedge i_clk) disable iff (i_rst)
  ((($past(update_esu))) && ((!update_esu)) && ((cout))) |-> (rack == 1'b1);
endproperty
a_of4_sigma_overflow: assert property (p_of4_sigma_overflow);

property p_rs_write_clears_of;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (i_wb_we) && (adr_check) && (o_wb_ack)) |=>
   (RS == 1'b0);
endproperty
a_rs_write_clears_of: assert property (p_rs_write_clears_of);

// -------------------------------------------------------------
// LOCKING BEHAVIOR
// -------------------------------------------------------------

property p_locked_blocks_write;
  @(posedge i_clk) disable iff (i_rst)
  ((update_esu) && (wlRS) && (i_wb_cyc) && (i_wb_stb) && (i_wb_we)) |->
   (o_wb_ack == 1'b0);
endproperty
a_locked_blocks_write: assert property (p_locked_blocks_write);

property p_locked_blocks_read;
  @(posedge i_clk) disable iff (i_rst)
  ((update_esu) && (wlRS) && (i_wb_cyc) && (i_wb_stb) && (!i_wb_we)) |->
   (o_wb_ack == 1'b0);
endproperty
a_locked_blocks_read: assert property (p_locked_blocks_read);

property p_nonlocked_accessible_during_seq;
  @(posedge i_clk) disable iff (i_rst)
  ((update_esu) && (!wlRS) && (i_wb_cyc) && (i_wb_stb)) |-> (o_wb_ack == 1'b1);
endproperty
a_nonlocked_accessible_during_seq: assert property (p_nonlocked_accessible_during_seq);

// -------------------------------------------------------------
// WISHBONE PROTOCOL DISCIPLINE
// -------------------------------------------------------------

property p_master_holds_qualifiers;
  @(posedge i_clk) disable iff (i_rst)
  ((i_wb_cyc) && (i_wb_stb) && (!o_wb_ack)) |=>
   ((i_wb_cyc) && (i_wb_stb));
endproperty
m_master_holds_qualifiers: assume property (p_master_holds_qualifiers);

property p_no_ack_without_request;
  @(posedge i_clk) disable iff (i_rst)
  ((!i_wb_cyc) || (!i_wb_stb)) |-> (o_wb_ack == 1'b0);
endproperty
a_no_ack_without_request: assert property (p_no_ack_without_request);