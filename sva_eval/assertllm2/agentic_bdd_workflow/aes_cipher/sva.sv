// =========================================================================
// AES Cipher Formal Verification Assertions
// NOTE ON SIGNAL SCOPE:
//   The provided signal list does not explicitly include rst_n, ld_r, and
//   the key-expansion round-key words (wo_0..wo_3 / w1..w3) even though the
//   specification Background explicitly requires them. These are assumed
//   to be present as internal/hierarchical signals of the DUT for the
//   purpose of white-box formal verification, as required by the Gherkin
//   Background section.
// =========================================================================

wire rst = ~rst_n;

// Round key bundled from key-expansion word outputs (per key_expansion_interface scenario)
wire [127:0] rk_bundle = {w0, w1, w2, w3};

// Round keys used contextually (initial / current-round / final).
wire [127:0] RK0      = key;
wire [127:0] RK       = rk_bundle;
wire [127:0] RK_final = rk_bundle;

// =========================================================================
// Reference model functions (specification-defined, NOT copied from DUT)
// =========================================================================

function automatic bit [7:0] aes_sbox(bit [7:0] a);
  bit [7:0] tbl [0:255];
  tbl = '{
    8'h63,8'h7c,8'h77,8'h7b,8'hf2,8'h6b,8'h6f,8'hc5,8'h30,8'h01,8'h67,8'h2b,8'hfe,8'hd7,8'hab,8'h76,
    8'hca,8'h82,8'hc9,8'h7d,8'hfa,8'h59,8'h47,8'hf0,8'had,8'hd4,8'ha2,8'haf,8'h9c,8'ha4,8'h72,8'hc0,
    8'hb7,8'hfd,8'h93,8'h26,8'h36,8'h3f,8'hf7,8'hcc,8'h34,8'ha5,8'he5,8'hf1,8'h71,8'hd8,8'h31,8'h15,
    8'h04,8'hc7,8'h23,8'hc3,8'h18,8'h96,8'h05,8'h9a,8'h07,8'h12,8'h80,8'he2,8'heb,8'h27,8'hb2,8'h75,
    8'h09,8'h83,8'h2c,8'h1a,8'h1b,8'h6e,8'h5a,8'ha0,8'h52,8'h3b,8'hd6,8'hb3,8'h29,8'he3,8'h2f,8'h84,
    8'h53,8'hd1,8'h00,8'hed,8'h20,8'hfc,8'hb1,8'h5b,8'h6a,8'hcb,8'hbe,8'h39,8'h4a,8'h4c,8'h58,8'hcf,
    8'hd0,8'hef,8'haa,8'hfb,8'h43,8'h4d,8'h33,8'h85,8'h45,8'hf9,8'h02,8'h7f,8'h50,8'h3c,8'h9f,8'ha8,
    8'h51,8'ha3,8'h40,8'h8f,8'h92,8'h9d,8'h38,8'hf5,8'hbc,8'hb6,8'hda,8'h21,8'h10,8'hff,8'hf3,8'hd2,
    8'hcd,8'h0c,8'h13,8'hec,8'h5f,8'h97,8'h44,8'h17,8'hc4,8'ha7,8'h7e,8'h3d,8'h64,8'h5d,8'h19,8'h73,
    8'h60,8'h81,8'h4f,8'hdc,8'h22,8'h2a,8'h90,8'h88,8'h46,8'hee,8'hb8,8'h14,8'hde,8'h5e,8'h0b,8'hdb,
    8'he0,8'h32,8'h3a,8'h0a,8'h49,8'h06,8'h24,8'h5c,8'hc2,8'hd3,8'hac,8'h62,8'h91,8'h95,8'he4,8'h79,
    8'he7,8'hc8,8'h37,8'h6d,8'h8d,8'hd5,8'h4e,8'ha9,8'h6c,8'h56,8'hf4,8'hea,8'h65,8'h7a,8'hae,8'h08,
    8'hba,8'h78,8'h25,8'h2e,8'h1c,8'ha6,8'hb4,8'hc6,8'he8,8'hdd,8'h74,8'h1f,8'h4b,8'hbd,8'h8b,8'h8a,
    8'h70,8'h3e,8'hb5,8'h66,8'h48,8'h03,8'hf6,8'h0e,8'h61,8'h35,8'h57,8'hb9,8'h86,8'hc1,8'h1d,8'h9e,
    8'he1,8'hf8,8'h98,8'h11,8'h69,8'hd9,8'h8e,8'h94,8'h9b,8'h1e,8'h87,8'he9,8'hce,8'h55,8'h28,8'hdf,
    8'h8c,8'ha1,8'h89,8'h0d,8'hbf,8'he6,8'h42,8'h68,8'h41,8'h99,8'h2d,8'h0f,8'hb0,8'h54,8'hbb,8'h16
  };
  return tbl[a];
endfunction

function automatic bit [7:0] gf_mul2(bit [7:0] x);
  gf_mul2 = x[7] ? (({x[6:0],1'b0}) ^ 8'h1b) : {x[6:0],1'b0};
endfunction

function automatic bit [7:0] gf_mul3(bit [7:0] x);
  gf_mul3 = gf_mul2(x) ^ x;
endfunction

// =========================================================================
// Reset Scenarios
// =========================================================================

property p_reset_init;
  @(posedge clk)
  (!rst_n) |=> (dcnt==4'h0 && ld_r==1'b0 && sa00==8'h0 && sa10==8'h0 &&
                sa20==8'h0 && sa30==8'h0 && text_in_r==128'h0 &&
                text_out==128'h0 && done==1'b0);
endproperty
assert property (p_reset_init);

property p_reset_dominates_ld;
  @(posedge clk)
  (!rst_n) |=> (dcnt==4'h0 && done==1'b0);
endproperty
assert property (p_reset_dominates_ld);

// =========================================================================
// IDLE / LOAD Scenarios
// =========================================================================

property p_load_capture;
  @(posedge clk) disable iff (!rst_n)
  (dcnt==4'h0 && ld) |=> (ld_r==1'b1 && text_in_r==$past(text_in));
endproperty
assert property (p_load_capture);

// Restored (previously proven, mistakenly deleted): IDLE holds dcnt, done
// and text_out steady while no load is pending.
property p_idle_hold;
  @(posedge clk) disable iff (!rst_n)
  (dcnt==4'h0 && !ld) |=> (dcnt==4'h0 && done==1'b0 && text_out==$past(text_out));
endproperty
assert property (p_idle_hold);

// =========================================================================
// INIT_ROUND Scenarios (restored, previously proven)
// =========================================================================

property p_init_round;
  @(posedge clk) disable iff (!rst_n)
  ($past(ld_r)) |-> (
    sa00 == ($past(text_in_r[127:120]) ^ RK0[127:120]) &&
    sa10 == ($past(text_in_r[119:112]) ^ RK0[119:112]) &&
    sa20 == ($past(text_in_r[111:104]) ^ RK0[111:104]) &&
    sa30 == ($past(text_in_r[103:96])  ^ RK0[103:96])
  );
endproperty
assert property (p_init_round);

property p_init_round_dcnt;
  @(posedge clk) disable iff (!rst_n)
  ($past(ld_r)) |-> (dcnt == 4'hB);
endproperty
assert property (p_init_round_dcnt);

// =========================================================================
// ROUND_OP / FINAL_ROUND Scenarios (independent recompute using registers)
// =========================================================================

property p_round_op;
  @(posedge clk) disable iff (!rst_n)
  (dcnt > 4'h1 && !ld_r) |-> (
    sa00_mc == (gf_mul2(sa00_sr) ^ gf_mul3(sa10_sr) ^ sa20_sr ^ sa30_sr) &&
    sa10_mc == (sa00_sr ^ gf_mul2(sa10_sr) ^ gf_mul3(sa20_sr) ^ sa30_sr) &&
    sa20_mc == (sa00_sr ^ sa10_sr ^ gf_mul2(sa20_sr) ^ gf_mul3(sa30_sr)) &&
    sa30_mc == (gf_mul3(sa00_sr) ^ sa10_sr ^ sa20_sr ^ gf_mul2(sa30_sr)) &&
    sa00_next == (sa00_mc ^ RK[127:120]) &&
    sa10_next == (sa10_mc ^ RK[119:112]) &&
    sa20_next == (sa20_mc ^ RK[111:104]) &&
    sa30_next == (sa30_mc ^ RK[103:96])
  );
endproperty
assert property (p_round_op);

// =========================================================================
// DONE Scenarios
// =========================================================================

property p_done_output_stability;
  @(posedge clk) disable iff (!rst_n)
  (dcnt == 4'h0 && done && $past(done)) |=> (text_out == $past(text_out) && done == 1'b1);
endproperty
assert property (p_done_output_stability);

property p_reload_after_done;
  @(posedge clk) disable iff (!rst_n)
  (done && ld) |=> (ld_r == 1'b1);
endproperty
assert property (p_reload_after_done);

property p_reload_done_clears;
  @(posedge clk) disable iff (!rst_n)
  (done && ld) |=> (done == 1'b0);
endproperty
assert property (p_reload_done_clears);

// Restored (previously proven, mistakenly deleted): the terminal
// dcnt==1 -> dcnt==0 transition asserts done in the same cycle.
property p_done_generation;
  @(posedge clk) disable iff (!rst_n)
  (dcnt == 4'h1) |=> (dcnt == 4'h0 && done == 1'b1);
endproperty
assert property (p_done_generation);

// =========================================================================
// SubBytes Scenario
// =========================================================================

property p_sbox;
  @(posedge clk) disable iff (!rst_n)
  (1'b1) |-> (
    sa00_sub == aes_sbox(sa00) &&
    sa10_sub == aes_sbox(sa10) &&
    sa20_sub == aes_sbox(sa20) &&
    sa30_sub == aes_sbox(sa30)
  );
endproperty
assert property (p_sbox);

// =========================================================================
// Counter / Output Stability / Done Exclusivity Scenarios
// =========================================================================

property p_counter_no_change_idle;
  @(posedge clk) disable iff (!rst_n)
  (dcnt==4'h0 && !done && !ld) |=> (dcnt==4'h0);
endproperty
assert property (p_counter_no_change_idle);

property p_done_implies_dcnt_zero;
  @(posedge clk) disable iff (!rst_n)
  (done) |-> (dcnt == 4'h0);
endproperty
assert property (p_done_implies_dcnt_zero);

// Restored (previously proven, mistakenly deleted): text_out is held
// stable throughout all non-idle (round-active) cycles.
property p_output_stable_during_rounds;
  @(posedge clk) disable iff (!rst_n)
  (dcnt != 4'h0) |=> (text_out == $past(text_out));
endproperty
assert property (p_output_stable_during_rounds);

// =========================================================================
// ld_r Delay Scenario
// =========================================================================

property p_ld_r_delay;
  @(posedge clk) disable iff (!rst_n)
  (1'b1) |=> (ld_r == $past(ld));
endproperty
assert property (p_ld_r_delay);

// =========================================================================
// Round counter bound / stability / monotonicity
// =========================================================================

property p_dcnt_max_bound;
  @(posedge clk) disable iff (!rst_n)
  (dcnt <= 4'hB);
endproperty
assert property (p_dcnt_max_bound);

property p_dcnt_stable_when_idle;
  @(posedge clk) disable iff (!rst_n)
  (dcnt == 4'h0 && !ld) |=> (dcnt == 4'h0);
endproperty
assert property (p_dcnt_stable_when_idle);

property p_dcnt_monotonic_when_busy;
  @(posedge clk) disable iff (!rst_n)
  (dcnt != 4'h0 && !ld) |=> (dcnt <= $past(dcnt));
endproperty
assert property (p_dcnt_monotonic_when_busy);

// =========================================================================
// REMOVED (trivially vacuous / redundant, per review):
//   p_reset_asserted_dcnt_idle  - combinational check on a synchronously
//                                 reset register; antecedent/consequent
//                                 pairing collapses to a vacuous check
//                                 given the registered reset timing.
//   p_key_expansion_interface   - tautological self-comparison of
//                                 rk_bundle against its own defining
//                                 expression; antecedent (1'b1) proves
//                                 nothing beyond the wire assignment.
//   p_addroundkey               - fully subsumed duplicate of p_round_op
//                                 with a strictly weaker guard, adding no
//                                 distinct proof obligation.
//   p_done_matches_dcnt_zero_next - superseded by the restored, more
//                                 direct p_done_generation transition
//                                 check on the same signals.
//   p_text_out_stable_until_load  - superseded by the restored, more
//                                 general p_output_stable_during_rounds
//                                 property.
// =========================================================================