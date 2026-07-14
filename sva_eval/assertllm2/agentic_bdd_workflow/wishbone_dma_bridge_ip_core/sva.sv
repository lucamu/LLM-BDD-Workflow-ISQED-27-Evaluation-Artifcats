// =====================================================================
// Formal SVA for wishbone_dma_bridge_ip_core
// Derived strictly from the Gherkin specification (Background + Scenarios)
// =====================================================================
// NOTE: The Gherkin references several per-channel / functional signals
// that are not part of the given port list (e.g. per-channel enable,
// busy, done, error, priority, mode bits, interrupt masks, register-file
// read data, EOL flag, chunk-done event). These are declared below as
// design-internal observation signals with names that mirror the
// specification text. They are assumed to be bound/visible at the
// verification scope (typical for a bind-file style FPV environment).
// Signals that already exist in the DUT scope (de_txsz_we, de_adr0_we,
// de_adr1_we, adr1) are NOT redeclared here to avoid duplicate
// declaration errors.
// =====================================================================

// ---- Assumed per-channel / internal observation signals ----
wire [ch_count-1:0] chan_en;          // capability EN bit (fixed=1 for ch0)
wire [ch_count-1:0] chan_enable;      // CSR.EN  (enable status bit)
wire [ch_count-1:0] chan_busy;        // CSR.BUSY
wire [ch_count-1:0] chan_done;        // CSR.DONE
wire [ch_count-1:0] chan_err;         // CSR.ERR
wire [ch_count-1:0] chan_chunk_done;  // chunk-done event pulse
wire [ch_count-1:0] chan_hw_hs;       // hardware-handshake mode select
wire [ch_count-1:0] chan_use_ed;      // USE_ED bit
wire [ch_count-1:0] chan_cbuf;        // CBUF capability bit
wire [ch_count-1:0] chan_inc_src;     // INC_SRC bit
wire [ch_count-1:0] chan_inc_dst;     // INC_DST bit
wire [ch_count-1:0] chan_src_sel;     // SRC_SEL bit (0=IF0,1=IF1)
wire [ch_count-1:0] chan_dst_sel;     // DST_SEL bit (0=IF0,1=IF1)
wire [4:0]          chan_prio [ch_count-1:0]; // priority field per channel
wire [31:0]         chan_chksz [ch_count-1:0]; // CHK_SZ per channel
wire [31:0]         chan_totsz [ch_count-1:0]; // total size per channel
wire [ch_count-1:0] int_mask_a;       // mask bit routes channel event -> inta_o
wire [ch_count-1:0] int_mask_b;       // mask bit routes channel event -> intb_o

wire        rf_sel0, rf_sel1;         // register-file select per interface
wire        pt_active0, pt_active1;   // pass-through active per interface
wire [31:0] rf_rdata0, rf_rdata1;     // addressed register-file readback value

// =====================================================================
// RESET BEHAVIOR
// =====================================================================

// Scenario: Reset clears interrupt outputs and channel enables
property p_reset_clears_int_and_en;
  @(posedge clk_i)
  (rst_i) |=> (inta_o==1'b0 && intb_o==1'b0 && chan_enable=='0 && chan_busy=='0);
endproperty
assert property (p_reset_clears_int_and_en);

// Scenario: Reset forces WISHBONE outputs to idle
property p_reset_wb_idle;
  @(posedge clk_i)
  (rst_i) |=> (wb0_cyc_o==1'b0 && wb0_stb_o==1'b0 && wb1_cyc_o==1'b0 &&
               wb1_stb_o==1'b0 && wb0_ack_o==1'b0 && wb1_ack_o==1'b0);
endproperty
assert property (p_reset_wb_idle);

// Scenario: Reset clears interrupt mask registers
property p_reset_clears_masks;
  @(posedge clk_i)
  (rst_i) |=> (int_mask_a=='0 && int_mask_b=='0);
endproperty
assert property (p_reset_clears_masks);

// =====================================================================
// ADDRESS DECODE
// =====================================================================

// Scenario: Interface 0 address nibble match selects register file
property p_if0_rf_sel;
  @(posedge clk_i) disable iff (rst_i)
  (wb0_addr_i[31:28]==rf_addr && wb0_cyc_i && wb0_stb_i) |=>
    (rf_sel0==1'b1 && pt_active0==1'b0);
endproperty
assert property (p_if0_rf_sel);

// Scenario: Interface 0 address nibble mismatch selects pass-through
property p_if0_pt_active;
  @(posedge clk_i) disable iff (rst_i)
  (wb0_addr_i[31:28]!=rf_addr && wb0_cyc_i && wb0_stb_i) |=>
    (pt_active0==1'b1 && rf_sel0==1'b0 &&
     wb1_addr_o==wb0_addr_i && wb1_we_o==wb0_we_i && wb1_sel_o==wb0_sel_i);
endproperty
assert property (p_if0_pt_active);

// Scenario: Interface 1 address nibble match selects register file
property p_if1_rf_sel;
  @(posedge clk_i) disable iff (rst_i)
  (wb1_addr_i[31:28]==rf_addr && wb1_cyc_i && wb1_stb_i) |=>
    (rf_sel1==1'b1 && pt_active1==1'b0);
endproperty
assert property (p_if1_rf_sel);

// Scenario: Interface 1 address nibble mismatch selects pass-through to interface 0
property p_if1_pt_active;
  @(posedge clk_i) disable iff (rst_i)
  (wb1_addr_i[31:28]!=rf_addr && wb1_cyc_i && wb1_stb_i) |=>
    (pt_active1==1'b1 && rf_sel1==1'b0 &&
     wb0_addr_o==wb1_addr_i && wb0_we_o==wb1_we_i);
endproperty
assert property (p_if1_pt_active);

// Scenario: Pass-through selection is combinational and requires valid cycle
property p_pt_requires_cyc;
  @(posedge clk_i) disable iff (rst_i)
  (wb0_addr_i[31:28]!=rf_addr && wb0_cyc_i==1'b0) |=>
    (pt_active0==1'b0 && wb1_cyc_o==1'b0);
endproperty
assert property (p_pt_requires_cyc);

// =====================================================================
// WISHBONE PROTOCOL - INTERFACE 0
// =====================================================================

// Scenario: Register-file read returns ack with data and deasserts err/rty on interface 0
property p_if0_rf_read_ack;
  @(posedge clk_i) disable iff (rst_i)
  (wb0_addr_i[31:28]==rf_addr && wb0_we_i==1'b0 && wb0_cyc_i && wb0_stb_i) |=>
    (wb0_ack_o==1'b1 && wb0_err_o==1'b0 && wb0_rty_o==1'b0 && wb0s_data_o==rf_rdata0);
endproperty
assert property (p_if0_rf_read_ack);

// Scenario: Register-file write updates register content on interface 0
property p_if0_rf_write_ack;
  @(posedge clk_i) disable iff (rst_i)
  (wb0_addr_i[31:28]==rf_addr && wb0_we_i && wb0_cyc_i && wb0_stb_i) |=>
    (wb0_ack_o==1'b1 && rf_rdata0==$past(wb0s_data_i));
endproperty
assert property (p_if0_rf_write_ack);

// Scenario: No ack without an active cycle and strobe on interface 0
property p_if0_no_ack_wo_cyc;
  @(posedge clk_i) disable iff (rst_i)
  (wb0_cyc_i==1'b0) |=> (wb0_ack_o==1'b0);
endproperty
assert property (p_if0_no_ack_wo_cyc);

// Scenario: Internal DMA master transfers use full word byte enable on interface 0
property p_if0_master_sel_full;
  @(posedge clk_i) disable iff (rst_i)
  (mast0_go && wb0_cyc_o && wb0_stb_o) |=> (wb0_sel_o==4'hf);
endproperty
assert property (p_if0_master_sel_full);

// =====================================================================
// WISHBONE PROTOCOL - INTERFACE 1
// =====================================================================

// Scenario: Register-file read returns ack with data and deasserts err/rty on interface 1
property p_if1_rf_read_ack;
  @(posedge clk_i) disable iff (rst_i)
  (wb1_addr_i[31:28]==rf_addr && wb1_we_i==1'b0 && wb1_cyc_i && wb1_stb_i) |=>
    (wb1_ack_o==1'b1 && wb1_err_o==1'b0 && wb1_rty_o==1'b0 && wb1s_data_o==rf_rdata1);
endproperty
assert property (p_if1_rf_read_ack);

// Scenario: Register-file write updates register content on interface 1
property p_if1_rf_write_ack;
  @(posedge clk_i) disable iff (rst_i)
  (wb1_addr_i[31:28]==rf_addr && wb1_we_i && wb1_cyc_i && wb1_stb_i) |=>
    (wb1_ack_o==1'b1 && rf_rdata1==$past(wb1s_data_i));
endproperty
assert property (p_if1_rf_write_ack);

// Scenario: No ack without an active cycle and strobe on interface 1
property p_if1_no_ack_wo_cyc;
  @(posedge clk_i) disable iff (rst_i)
  (wb1_cyc_i==1'b0) |=> (wb1_ack_o==1'b0);
endproperty
assert property (p_if1_no_ack_wo_cyc);

// Scenario: Internal DMA master transfers use full word byte enable on interface 1
property p_if1_master_sel_full;
  @(posedge clk_i) disable iff (rst_i)
  (mast1_go && wb1_cyc_o && wb1_stb_o) |=> (wb1_sel_o==4'hf);
endproperty
assert property (p_if1_master_sel_full);

// =====================================================================
// CHANNEL ARBITRATION
// =====================================================================
genvar gi, gj;
generate
  for (gi = 0; gi < ch_count; gi = gi + 1) begin : g_arb_i
    for (gj = 0; gj < ch_count; gj = gj + 1) begin : g_arb_j
      if (gi != gj) begin

        // Scenario: Higher priority eligible channel is selected over lower priority channel
        property p_arb_priority_win;
          @(posedge clk_i) disable iff (rst_i)
          (chan_prio[gi] > chan_prio[gj] && chan_enable[gi] && chan_enable[gj] &&
           ((chan_enable & ~((1<<gi)|(1<<gj))) == '0)) |=> (ch_sel==gi);
        endproperty
        assert property (p_arb_priority_win);

        // Scenario: Equal priority channels are serviced round-robin
        property p_arb_round_robin;
          @(posedge clk_i) disable iff (rst_i)
          (chan_prio[gi]==chan_prio[gj] && chan_enable[gi] && chan_enable[gj] &&
           ch_sel==gi && ((chan_enable & ~((1<<gi)|(1<<gj))) == '0)) |=> (ch_sel==gj);
        endproperty
        assert property (p_arb_round_robin);

      end
    end
  end

  for (gi = 0; gi < ch_count; gi = gi + 1) begin : g_arb_neg
    // Scenario: Disabled channel is never selected
    property p_arb_disabled_never_sel;
      @(posedge clk_i) disable iff (rst_i)
      (chan_enable[gi]==1'b0) |-> (ch_sel != gi);
    endproperty
    assert property (p_arb_disabled_never_sel);

    // Scenario: Non-existent channel is never selected
    property p_arb_nonexistent_never_sel;
      @(posedge clk_i) disable iff (rst_i)
      (chan_en[gi]==1'b0) |-> (ch_sel != gi);
    endproperty
    assert property (p_arb_nonexistent_never_sel);

    // Scenario: Hardware-handshake channel requires dma_req_i to be eligible
    property p_arb_hw_req_needed;
      @(posedge clk_i) disable iff (rst_i)
      (chan_hw_hs[gi] && chan_enable[gi] && dma_req_i[gi]==1'b0) |-> (ch_sel != gi);
    endproperty
    assert property (p_arb_hw_req_needed);
  end
endgenerate

// =====================================================================
// NORMAL DMA MODE TRANSFER EXECUTION
// =====================================================================
generate
  for (gi = 0; gi < ch_count; gi = gi + 1) begin : g_normal
    // Scenario: Normal mode transfer completes when total size reaches zero
    property p_normal_done;
      @(posedge clk_i) disable iff (rst_i)
      (ch_sel==gi && chan_enable[gi] && chan_busy[gi] && txsz==32'd0) |=>
        (chan_done[gi]==1'b1 && chan_busy[gi]==1'b0);
    endproperty
    assert property (p_normal_done);

    // Scenario: Chunked transfer re-arbitrates between chunks
    property p_chunk_rearbitrate;
      @(posedge clk_i) disable iff (rst_i)
      (ch_sel==gi && chan_chksz[gi]!=32'd0 && chan_totsz[gi] > chan_chksz[gi] &&
       txsz==32'd0) |=> (ch_sel != gi && chan_busy[gi]==1'b1);
    endproperty
    assert property (p_chunk_rearbitrate);
  end
endgenerate

// Scenario: Address increment follows INC_SRC and INC_DST configuration
property p_inc_src;
  @(posedge clk_i) disable iff (rst_i)
  (chan_inc_src[ch_sel] && de_ack) |=> (adr0 == ($past(adr0) + 32'd4));
endproperty
assert property (p_inc_src);

property p_inc_dst;
  @(posedge clk_i) disable iff (rst_i)
  (chan_inc_dst[ch_sel] && de_ack) |=> (adr1 == ($past(adr1) + 32'd4));
endproperty
assert property (p_inc_dst);

// Scenario: Address does not increment when INC bit is cleared
property p_no_inc_src;
  @(posedge clk_i) disable iff (rst_i)
  (chan_inc_src[ch_sel]==1'b0 && de_ack) |=> (adr0 == $past(adr0));
endproperty
assert property (p_no_inc_src);

// Scenario: Source and destination interface selection follows SRC_SEL/DST_SEL
property p_src_dst_sel;
  @(posedge clk_i) disable iff (rst_i)
  (chan_src_sel[ch_sel]==1'b0 && chan_dst_sel[ch_sel]==1'b1 && dma_busy) |->
    ((wb0_cyc_o && wb0_stb_o && !wb0_we_o) || (wb1_cyc_o && wb1_stb_o && wb1_we_o));
endproperty
assert property (p_src_dst_sel);

// =====================================================================
// HARDWARE-HANDSHAKE MODE
// =====================================================================
generate
  for (gi = 0; gi < ch_count; gi = gi + 1) begin : g_hs
    // Scenario: dma_req_i trigger starts one chunk transfer
    property p_hs_ack_pulse;
      @(posedge clk_i) disable iff (rst_i)
      ($fell(chan_busy[gi]) && $past(chan_hw_hs[gi])) |-> (dma_ack_o[gi]==1'b1);
    endproperty
    assert property (p_hs_ack_pulse);

    // Scenario: Zero chunk size uses total size semantics in handshake mode
    property p_hs_zero_chunk;
      @(posedge clk_i) disable iff (rst_i)
      (chan_hw_hs[gi] && chan_chksz[gi]==32'd0 && $fell(chan_busy[gi])) |-> (dma_ack_o[gi]==1'b1);
    endproperty
    assert property (p_hs_zero_chunk);

    // Scenario: dma_ack_o remains deasserted while chunk transfer is in progress
    property p_hs_ack_low_inprogress;
      @(posedge clk_i) disable iff (rst_i)
      (chan_hw_hs[gi] && chan_busy[gi] && txsz!=32'd0) |-> (dma_ack_o[gi]==1'b0);
    endproperty
    assert property (p_hs_ack_low_inprogress);
  end
endgenerate

// =====================================================================
// LINKED-LIST DESCRIPTOR MODE
// =====================================================================

// Scenario: Descriptor fetch updates channel working state
property p_desc_fetch;
  @(posedge clk_i) disable iff (rst_i)
  (chan_use_ed[ch_sel] && de_fetch_descr) |=>
    (de_csr_we && de_txsz_we && de_adr0_we && de_adr1_we);
endproperty
assert property (p_desc_fetch);

// Scenario: End-of-list descriptor completes the channel
// (assumes de_csr[0] encodes end-of-list flag)
property p_desc_eol_done;
  @(posedge clk_i) disable iff (rst_i)
  (chan_use_ed[ch_sel] && de_csr_we && de_csr[0]==1'b1) |=>
    (chan_done[ch_sel]==1'b1 && chan_busy[ch_sel]==1'b0);
endproperty
assert property (p_desc_eol_done);

// Scenario: Non-end descriptor continues channel transfer flow
property p_desc_continue;
  @(posedge clk_i) disable iff (rst_i)
  (chan_use_ed[ch_sel] && de_csr_we && de_csr[0]==1'b0) |=>
    (chan_busy[ch_sel]==1'b1 && adr0==de_adr0 && adr1==de_adr1 && txsz==de_txsz);
endproperty
assert property (p_desc_continue);

// =====================================================================
// CIRCULAR BUFFER / SOFTWARE POINTER BEHAVIOR
// =====================================================================

// Scenario: Address mask restricts increment to unmasked bits
property p_cbuf_mask_restrict;
  @(posedge clk_i) disable iff (rst_i)
  (chan_cbuf[ch_sel] && de_ack) |=> ((adr0 & ~am0) == ($past(adr0) & ~am0));
endproperty
assert property (p_cbuf_mask_restrict);

// Scenario: Software pointer stalls channel at boundary
property p_swptr_stall;
  @(posedge clk_i) disable iff (rst_i)
  (chan_cbuf[ch_sel] && adr0==pointer_s) |=>
    (chan_busy[ch_sel]==1'b1 && adr0==$past(adr0));
endproperty
assert property (p_swptr_stall);

// =====================================================================
// FORCED DESCRIPTOR ADVANCE AND RESTART
// =====================================================================
generate
  for (gi = 0; gi < ch_count; gi = gi + 1) begin : g_restart
    // Scenario: dma_nd_i forces descriptor advance in linked-list handshake mode
    property p_nd_force_advance;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(dma_nd_i[gi]) && chan_use_ed[gi] && chan_hw_hs[gi]) |=>
        (ndr==1'b1 && de_fetch_descr==1'b1);
    endproperty
    assert property (p_nd_force_advance);

    // Scenario: dma_rest_i reloads channel working state when channel is idle
    property p_rest_idle_reload;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(dma_rest_i[gi]) && !chan_busy[gi]) |=> (ptr_set==1'b1);
    endproperty
    assert property (p_rest_idle_reload);

    // Scenario: dma_rest_i has no defined effect during active transfer
    property p_rest_busy_noeffect;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(dma_rest_i[gi]) && chan_busy[gi] && ch_sel==gi) |=>
        (adr0==$past(adr0) && adr1==$past(adr1) && chan_busy[gi]==1'b1);
    endproperty
    assert property (p_rest_busy_noeffect);
  end
endgenerate

// =====================================================================
// INTERRUPT AND STATUS BEHAVIOR
// =====================================================================
generate
  for (gi = 0; gi < ch_count; gi = gi + 1) begin : g_intr
    // Scenario: Channel done event sets interrupt source and masked output asserts
    property p_int_done_asserts_a;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(chan_done[gi]) && int_mask_a[gi]) |=> (chan_done[gi]==1'b1 && inta_o==1'b1);
    endproperty
    assert property (p_int_done_asserts_a);

    // Scenario: Masked-off event does not assert interrupt output
    property p_int_masked_off;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(chan_done[gi]) && !int_mask_a[gi] && !int_mask_b[gi]) |=>
        (chan_done[gi]==1'b1 && inta_o==1'b0 && intb_o==1'b0);
    endproperty
    assert property (p_int_masked_off);

    // Scenario: Channel error event sets error status and interrupt source
    property p_int_error_set;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(chan_err[gi])) |=> (chan_err[gi]==1'b1);
    endproperty
    assert property (p_int_error_set);

    // Scenario: Chunk done event routed to intb_o when configured
    property p_int_chunk_done_b;
      @(posedge clk_i) disable iff (rst_i)
      ($rose(chan_chunk_done[gi]) && int_mask_b[gi]) |=> (intb_o==1'b1);
    endproperty
    assert property (p_int_chunk_done_b);
  end
endgenerate

// =====================================================================
// PAUSE AND ABORT CONTROL
// =====================================================================

// Scenario: pause_req halts new channel dispatch
property p_pause_no_dispatch;
  @(posedge clk_i) disable iff (rst_i)
  (pause_req) |-> (de_start==1'b0);
endproperty
assert property (p_pause_no_dispatch);

// Scenario: dma_abort terminates active engine execution
property p_abort_terminate;
  int sel_cap;
  @(posedge clk_i) disable iff (rst_i)
  (dma_busy && dma_abort, sel_cap = ch_sel) |=>
    (dma_busy==1'b0 && chan_busy[sel_cap]==1'b0);
endproperty
assert property (p_abort_terminate);

// =====================================================================
// BACKGROUND / GLOBAL INPUT ASSUMPTIONS
// =====================================================================

// Given: channel 0 capability bit EN is fixed to 1
assume property (@(posedge clk_i) disable iff (rst_i) chan_en[0]==1'b1);

// Given: rst_i is the active-high synchronous reset (well-formed pulse assumption
// not further constrained; used only via disable iff in all properties above)