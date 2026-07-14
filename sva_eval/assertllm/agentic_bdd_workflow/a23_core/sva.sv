// =========================================================================
// SVA for a23_core - derived independently from the Gherkin specification
// No explicit reset exists in this design (Background: FPGA config init),
// so no disable iff(reset) is used. i_system_rdy gates register updates.
//
// Only signals present in the SIGNAL DECLARATIONS list (top-level a23_core
// ports and internal control/status nets) are referenced. Properties whose
// specification concept required a signal that has no real counterpart in
// the declared signal set (raw ALU operands/output, raw barrel-shifter
// data path, per-field instruction decode bits, source register read
// values, condition-pass/decode-stall/pre-fetch internal probes, Booth
// product register, etc.) have been removed rather than invented.
// =========================================================================

// CPSR flag extraction from execute_status_bits (ARM CPSR bit layout)
wire n_flag = execute_status_bits[31];
wire z_flag = execute_status_bits[30];
wire c_flag = execute_status_bits[29];
wire v_flag = execute_status_bits[28];

localparam [1:0] MODE_USR = 2'b00, MODE_FIRQ = 2'b01,
                 MODE_IRQ = 2'b10, MODE_SVC = 2'b11;

// =========================================================================
// Condition Code Evaluation
// (cond_pass has no real signal; execute_address_valid is used as the
//  observable proxy for "instruction executes")
// =========================================================================

property p_cc_eq;
  @(posedge i_clk) (condition == 4'b0000) |-> (execute_address_valid == z_flag);
endproperty
assert property (p_cc_eq);

property p_cc_ne;
  @(posedge i_clk) (condition == 4'b0001) |-> (execute_address_valid == !z_flag);
endproperty
assert property (p_cc_ne);

property p_cc_cs;
  @(posedge i_clk) (condition == 4'b0010) |-> (execute_address_valid == c_flag);
endproperty
assert property (p_cc_cs);

property p_cc_cc;
  @(posedge i_clk) (condition == 4'b0011) |-> (execute_address_valid == !c_flag);
endproperty
assert property (p_cc_cc);

property p_cc_mi;
  @(posedge i_clk) (condition == 4'b0100) |-> (execute_address_valid == n_flag);
endproperty
assert property (p_cc_mi);

property p_cc_pl;
  @(posedge i_clk) (condition == 4'b0101) |-> (execute_address_valid == !n_flag);
endproperty
assert property (p_cc_pl);

property p_cc_vs;
  @(posedge i_clk) (condition == 4'b0110) |-> (execute_address_valid == v_flag);
endproperty
assert property (p_cc_vs);

property p_cc_vc;
  @(posedge i_clk) (condition == 4'b0111) |-> (execute_address_valid == !v_flag);
endproperty
assert property (p_cc_vc);

property p_cc_hi;
  @(posedge i_clk) (condition == 4'b1000) |-> (execute_address_valid == (c_flag && !z_flag));
endproperty
assert property (p_cc_hi);

property p_cc_ls;
  @(posedge i_clk) (condition == 4'b1001) |-> (execute_address_valid == (!c_flag || z_flag));
endproperty
assert property (p_cc_ls);

property p_cc_ge;
  @(posedge i_clk) (condition == 4'b1010) |-> (execute_address_valid == (n_flag == v_flag));
endproperty
assert property (p_cc_ge);

property p_cc_lt;
  @(posedge i_clk) (condition == 4'b1011) |-> (execute_address_valid == (n_flag != v_flag));
endproperty
assert property (p_cc_lt);

property p_cc_gt;
  @(posedge i_clk) (condition == 4'b1100) |-> (execute_address_valid == (!z_flag && (n_flag == v_flag)));
endproperty
assert property (p_cc_gt);

property p_cc_le;
  @(posedge i_clk) (condition == 4'b1101) |-> (execute_address_valid == (z_flag || (n_flag != v_flag)));
endproperty
assert property (p_cc_le);

property p_cc_al;
  @(posedge i_clk) (condition == 4'b1110) |-> (execute_address_valid == 1'b1);
endproperty
assert property (p_cc_al);

property p_cc_nv;
  @(posedge i_clk) (condition == 4'b1111) |-> (execute_address_valid == 1'b0);
endproperty
assert property (p_cc_nv);

// =========================================================================
// Multiply (Booth's Algorithm) Properties
// (Only completion timing is observable; operand/product internals are
//  not exposed as real signals.)
// =========================================================================

property p_multiply_completes;
  @(posedge i_clk)
  $rose(multiply_function != 2'b00) |-> ##[1:34] multiply_done;
endproperty
assert property (p_multiply_completes);

// =========================================================================
// Pipeline Stall / Load-Store Behavior
// =========================================================================

property p_load_stall_2cyc;
  @(posedge i_clk)
  (data_access_exec && !write_enable) |-> ##1 fetch_stall ##1 fetch_stall ##1 !fetch_stall;
endproperty
assert property (p_load_stall_2cyc);

property p_store_stall_2cyc;
  @(posedge i_clk)
  (data_access_exec && write_enable) |-> ##1 fetch_stall ##1 fetch_stall ##1 !fetch_stall;
endproperty
assert property (p_store_stall_2cyc);

property p_cache_miss_stall;
  @(posedge i_clk)
  (fetch_stall && o_wb_cyc) |-> (fetch_stall throughout (!i_wb_ack)[->1]);
endproperty
assert property (p_cache_miss_stall);

property p_sysrdy_freeze;
  @(posedge i_clk)
  (!i_system_rdy) |=> ($stable(execute_address) && $stable(execute_status_bits));
endproperty
assert property (p_sysrdy_freeze);

// =========================================================================
// Interrupt / Exception Vector Selection
// =========================================================================

property p_reset_vector;
  @(posedge i_clk)
  (interrupt_vector_sel == 3'd0) |-> (execute_address_nxt == 32'h00000000 &&
                                       status_bits_mode == MODE_SVC);
endproperty
assert property (p_reset_vector);

property p_undef_vector;
  @(posedge i_clk)
  (decode_fault) |-> (execute_address_nxt == 32'h00000004 && status_bits_mode == MODE_SVC);
endproperty
assert property (p_undef_vector);

property p_swi_vector;
  @(posedge i_clk)
  (interrupt_vector_sel == 3'd2 && execute_address_valid) |-> (execute_address_nxt == 32'h00000008 &&
                                                                 status_bits_mode == MODE_SVC);
endproperty
assert property (p_swi_vector);

property p_pabt_vector;
  @(posedge i_clk)
  (iabt_trigger) |-> (execute_address_nxt == 32'h0000000C && status_bits_mode == MODE_SVC);
endproperty
assert property (p_pabt_vector);

property p_dabt_vector;
  @(posedge i_clk)
  (dabt_trigger) |-> (execute_address_nxt == 32'h00000010 && status_bits_mode == MODE_SVC);
endproperty
assert property (p_dabt_vector);

property p_adex_vector;
  @(posedge i_clk)
  (adex) |-> (execute_address_nxt == 32'h00000014 && status_bits_mode == MODE_SVC);
endproperty
assert property (p_adex_vector);

property p_irq_vector;
  @(posedge i_clk)
  (i_irq && !i_firq && !status_bits_irq_mask) |=> (execute_address == 32'h00000018 &&
                                                     status_bits_mode == MODE_IRQ);
endproperty
assert property (p_irq_vector);

property p_firq_vector;
  @(posedge i_clk)
  (i_firq && !status_bits_firq_mask) |=> (execute_address == 32'h0000001C &&
                                            status_bits_mode == MODE_FIRQ);
endproperty
assert property (p_firq_vector);

property p_irq_masked;
  @(posedge i_clk)
  (i_irq && status_bits_irq_mask) |=> (status_bits_mode != MODE_IRQ);
endproperty
assert property (p_irq_masked);

property p_irq_defer_simple;
  @(posedge i_clk)
  (i_irq && fetch_stall) |-> (status_bits_mode != MODE_IRQ);
endproperty
assert property (p_irq_defer_simple);

// =========================================================================
// Register Bank / Banking Properties
// =========================================================================

property p_firq_bank_wsel;
  @(posedge i_clk)
  (status_bits_mode == MODE_FIRQ && reg_bank_wsel >= 4'd8 && reg_bank_wsel <= 4'd14)
    |-> (reg_bank_wen != 15'd0);
endproperty
assert property (p_firq_bank_wsel);

property p_svc_bank_wsel;
  @(posedge i_clk)
  (status_bits_mode == MODE_SVC && (reg_bank_wsel == 4'd13 || reg_bank_wsel == 4'd14))
    |-> (reg_bank_wen != 15'd0);
endproperty
assert property (p_svc_bank_wsel);

// =========================================================================
// Status Register Field Properties
// =========================================================================

property p_mode_not_writable_user;
  @(posedge i_clk)
  (status_bits_mode == MODE_USR && status_bits_mode_wen)
    |=> (status_bits_mode == MODE_USR);
endproperty
assert property (p_mode_not_writable_user);

// =========================================================================
// Instruction Set Semantics: Swap, Single Transfer
// =========================================================================

property p_swp_exchange;
  @(posedge i_clk)
  (exclusive_exec && byte_enable == 4'b1111 && !write_enable)
    |-> ##[1:2] (exclusive_exec && write_enable && byte_enable == 4'b1111);
endproperty
assert property (p_swp_exchange);

property p_swpb_exchange;
  @(posedge i_clk)
  (exclusive_exec && byte_enable_sel == 2'd1 && !write_enable)
    |-> (read_data[31:8] == 24'h0);
endproperty
assert property (p_swpb_exchange);

property p_ldr_rotate;
  @(posedge i_clk)
  (read_data_alignment != 5'd0)
    |-> (read_data == ((read_data_s2 >> {read_data_alignment[1:0], 3'b0}) |
                        (read_data_s2 << (32 - {read_data_alignment[1:0], 3'b0}))));
endproperty
assert property (p_ldr_rotate);

property p_ldrb_zeroext;
  @(posedge i_clk)
  (byte_enable_sel == 2'd1 && !write_enable) |-> (read_data[31:8] == 24'h0);
endproperty
assert property (p_ldrb_zeroext);

property p_str_word;
  @(posedge i_clk)
  (write_enable && byte_enable == 4'b1111) |-> (o_wb_dat == write_data);
endproperty
assert property (p_str_word);

property p_strb_byte;
  @(posedge i_clk)
  (write_enable && byte_enable_sel == 2'd1) |-> (o_wb_dat[7:0] == write_data[7:0]);
endproperty
assert property (p_strb_byte);

// =========================================================================
// Coprocessor Register Transfer Instructions
// =========================================================================

property p_mcr_transfer;
  @(posedge i_clk)
  (copro_operation == 2'd1) |-> (copro_write_data_wen);
endproperty
assert property (p_mcr_transfer);

property p_mrc_transfer;
  @(posedge i_clk)
  (copro_operation == 2'd2 && rds_sel != 4'd15) |-> (write_data == copro_read_data);
endproperty
assert property (p_mrc_transfer);

property p_mrc_r15_flags;
  @(posedge i_clk)
  (copro_operation == 2'd2 && rds_sel == 4'd15)
    |-> (execute_status_bits[31:28] == copro_read_data[31:28]);
endproperty
assert property (p_mrc_r15_flags);

// =========================================================================
// Little-Endian Byte Ordering
// =========================================================================

property p_endian_store_lsb;
  @(posedge i_clk)
  (write_enable && byte_enable == 4'b1111) |-> (o_wb_dat[7:0] == write_data[7:0] &&
                                                  o_wb_dat[31:24] == write_data[31:24]);
endproperty
assert property (p_endian_store_lsb);

property p_endian_load_lsb;
  @(posedge i_clk)
  (i_wb_ack && !write_enable) |-> (read_data == i_wb_dat);
endproperty
assert property (p_endian_load_lsb);

property p_byte_lane_select;
  @(posedge i_clk)
  (write_enable && byte_enable_sel == 2'd1) |-> ($countones(o_wb_sel) == 1);
endproperty
assert property (p_byte_lane_select);

// =========================================================================
// Wishbone Interface Signal Properties
// =========================================================================

property p_wb_address;
  @(posedge i_clk)
  (o_wb_stb) |-> (o_wb_adr == execute_address);
endproperty
assert property (p_wb_address);

property p_wb_byte_select;
  @(posedge i_clk)
  (o_wb_we) |-> (o_wb_sel == byte_enable);
endproperty
assert property (p_wb_byte_select);

property p_wb_we;
  @(posedge i_clk)
  (o_wb_stb) |-> (o_wb_we == write_enable);
endproperty
assert property (p_wb_we);

property p_wb_read_sample;
  @(posedge i_clk)
  (o_wb_stb && !o_wb_we && i_wb_ack) |=> ($past(i_wb_dat) == read_data);
endproperty
assert property (p_wb_read_sample);

property p_wb_write_data;
  @(posedge i_clk)
  (o_wb_stb && o_wb_we) |-> (o_wb_dat == write_data);
endproperty
assert property (p_wb_write_data);

property p_wb_cyc_hold;
  @(posedge i_clk)
  (o_wb_cyc && !i_wb_ack) |=> (o_wb_cyc);
endproperty
assert property (p_wb_cyc_hold);

property p_wb_stb_once;
  @(posedge i_clk)
  (o_wb_stb && i_wb_ack) |=> (!o_wb_stb || o_wb_cyc);
endproperty
assert property (p_wb_stb_once);

property p_wb_err_terminate;
  @(posedge i_clk)
  (i_wb_err) |=> (!o_wb_cyc || !o_wb_stb);
endproperty
assert property (p_wb_err_terminate);

property p_wb_err_no_write;
  @(posedge i_clk)
  (i_wb_err) |-> (write_enable == 1'b0 || o_wb_we == 1'b0);
endproperty
assert property (p_wb_err_no_write);

// =========================================================================
// Cache Configuration and Behavior
// =========================================================================

property p_cache_write_through;
  @(posedge i_clk)
  (write_enable && cache_enable) |-> (o_wb_stb && o_wb_we);
endproperty
assert property (p_cache_write_through);

property p_cache_read_miss_fill;
  @(posedge i_clk)
  (fetch_stall && !write_enable) |-> (o_wb_cyc && !o_wb_we);
endproperty
assert property (p_cache_read_miss_fill);

property p_cache_write_miss_no_alloc;
  @(posedge i_clk)
  (write_enable && fetch_stall) |-> (!o_wb_cyc || o_wb_we);
endproperty
assert property (p_cache_write_miss_no_alloc);

// =========================================================================
// Input Assumptions
// =========================================================================

property a_condition_valid;
  @(posedge i_clk) (condition inside {[4'b0000:4'b1111]});
endproperty
assume property (a_condition_valid);