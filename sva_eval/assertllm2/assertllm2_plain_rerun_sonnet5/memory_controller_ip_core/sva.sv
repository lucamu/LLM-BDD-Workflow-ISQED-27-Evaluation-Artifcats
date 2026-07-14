`include "mc_defines.v"

// method: plain_prompt

// Global checker bound to top module: mc_top
module mc_top_sva_global (
    input logic [1:0] mc_adr_sel_bank_adr,
    input logic mc_adr_sel_cas,
    input logic mc_adr_sel_clk,
    input logic mc_adr_sel_cmd_a10,
    input logic mc_adr_sel_cs_le,
    input logic [31:0] mc_adr_sel_csc,
    input logic mc_adr_sel_lmr_sel,
    input logic [23:0] mc_adr_sel_mc_addr,
    input logic mc_adr_sel_next_adr,
    input logic [10:0] mc_adr_sel_page_size,
    input logic mc_adr_sel_rfr_ack,
    input logic [12:0] mc_adr_sel_row_adr,
    input logic mc_adr_sel_row_sel,
    input logic [31:0] mc_adr_sel_tms,
    input logic mc_adr_sel_wb_ack_o,
    input logic [31:0] mc_adr_sel_wb_addr_i,
    input logic mc_adr_sel_wb_stb_i,
    input logic mc_adr_sel_wb_we_i,
    input logic mc_adr_sel_wb_write_go,
    input logic mc_adr_sel_wr_cycle,
    input logic mc_adr_sel_wr_hold,
    input logic [3:0] mc_dp_byte_en,
    input logic mc_dp_clk,
    input logic [31:0] mc_dp_csc,
    input logic mc_dp_dv,
    input logic mc_dp_mc_clk,
    input logic [35:0] mc_dp_mc_data_del,
    input logic [31:0] mc_dp_mc_data_o,
    input logic [3:0] mc_dp_mc_dp_i,
    input logic [3:0] mc_dp_mc_dp_o,
    input logic mc_dp_mem_ack,
    input logic mc_dp_pack_le0,
    input logic mc_dp_pack_le1,
    input logic mc_dp_pack_le2,
    input logic mc_dp_par_err,
    input logic mc_dp_rst,
    input logic mc_dp_wb_ack_o,
    input logic mc_dp_wb_cyc_i,
    input logic [31:0] mc_dp_wb_data_i,
    input logic [31:0] mc_dp_wb_data_o,
    input logic mc_dp_wb_read_go,
    input logic mc_dp_wb_stb_i,
    input logic mc_dp_wb_we_i,
    input logic mc_mem_if_cas,
    input logic mc_mem_if_cke,
    input logic mc_mem_if_clk,
    input logic [7:0] mc_mem_if_cs,
    input logic mc_mem_if_cs_en,
    input logic [7:0] mc_mem_if_cs_need_rfr,
    input logic mc_mem_if_data_oe,
    input logic mc_mem_if_fs,
    input logic mc_mem_if_lmr_sel,
    input logic mc_mem_if_mc_ack,
    input logic mc_mem_if_mc_ack_r,
    input logic [23:0] mc_mem_if_mc_addr,
    input logic [23:0] mc_mem_if_mc_addr_d,
    input logic mc_mem_if_mc_adsc,
    input logic mc_mem_if_mc_adsc_d,
    input logic mc_mem_if_mc_adv,
    input logic mc_mem_if_mc_adv_d,
    input logic mc_mem_if_mc_bg,
    input logic mc_mem_if_mc_bg_d,
    input logic mc_mem_if_mc_br,
    input logic mc_mem_if_mc_br_r,
    input logic mc_mem_if_mc_c_oe,
    input logic mc_mem_if_mc_c_oe_d,
    input logic mc_mem_if_mc_cas,
    input logic mc_mem_if_mc_cke,
    input logic mc_mem_if_mc_clk,
    input logic [7:0] mc_mem_if_mc_cs,
    input logic [31:0] mc_mem_if_mc_data_i,
    input logic [35:0] mc_mem_if_mc_data_ir,
    input logic [31:0] mc_mem_if_mc_data_o,
    input logic [31:0] mc_mem_if_mc_data_od,
    input logic mc_mem_if_mc_data_oe,
    input logic [3:0] mc_mem_if_mc_dp_i,
    input logic [3:0] mc_mem_if_mc_dp_o,
    input logic [3:0] mc_mem_if_mc_dp_od,
    input logic [3:0] mc_mem_if_mc_dqm,
    input logic mc_mem_if_mc_oe,
    input logic mc_mem_if_mc_ras,
    input logic mc_mem_if_mc_rp,
    input logic mc_mem_if_mc_sts_i,
    input logic mc_mem_if_mc_sts_ir,
    input logic mc_mem_if_mc_we,
    input logic mc_mem_if_mc_zz_o,
    input logic mc_mem_if_oe,
    input logic mc_mem_if_ras,
    input logic mc_mem_if_rfr_ack,
    input logic mc_mem_if_rst,
    input logic [7:0] mc_mem_if_spec_req_cs,
    input logic mc_mem_if_susp_sel,
    input logic mc_mem_if_suspended_o,
    input logic mc_mem_if_wb_cyc_i,
    input logic mc_mem_if_wb_cycle,
    input logic [3:0] mc_mem_if_wb_sel_i,
    input logic mc_mem_if_wb_stb_i,
    input logic mc_mem_if_we,
    input logic mc_mem_if_wr_cycle,
    input logic mc_obct_top_any_bank_open,
    input logic [1:0] mc_obct_top_bank_adr,
    input logic mc_obct_top_bank_clr,
    input logic mc_obct_top_bank_clr_all,
    input logic mc_obct_top_bank_open,
    input logic mc_obct_top_bank_set,
    input logic mc_obct_top_clk,
    input logic [7:0] mc_obct_top_cs,
    input logic mc_obct_top_rfr_ack,
    input logic [12:0] mc_obct_top_row_adr,
    input logic mc_obct_top_row_same,
    input logic mc_obct_top_rst,
    input logic mc_refresh_clk,
    input logic [7:0] mc_refresh_cs_need_rfr,
    input logic [2:0] mc_refresh_ref_int,
    input logic mc_refresh_rfr_ack,
    input logic [7:0] mc_refresh_rfr_ps_val,
    input logic mc_refresh_rfr_req,
    input logic mc_refresh_rst,
    input logic mc_rf_clk,
    input logic [7:0] mc_rf_cs,
    input logic mc_rf_cs_le,
    input logic mc_rf_cs_le_d,
    input logic [7:0] mc_rf_cs_need_rfr,
    input logic [31:0] mc_rf_csc,
    input logic mc_rf_fs,
    input logic mc_rf_init_ack,
    input logic mc_rf_init_req,
    input logic mc_rf_lmr_ack,
    input logic mc_rf_lmr_req,
    input logic [31:0] mc_rf_mc_data_i,
    input logic mc_rf_mc_sts,
    input logic mc_rf_mc_vpen,
    input logic [31:0] mc_rf_poc,
    input logic [2:0] mc_rf_ref_int,
    input logic [31:0] mc_rf_rf_dout,
    input logic [7:0] mc_rf_rfr_ps_val,
    input logic mc_rf_rst,
    input logic [31:0] mc_rf_sp_csc,
    input logic [31:0] mc_rf_sp_tms,
    input logic [7:0] mc_rf_spec_req_cs,
    input logic [31:0] mc_rf_tms,
    input logic mc_rf_wb_ack_o,
    input logic [31:0] mc_rf_wb_addr_i,
    input logic mc_rf_wb_cyc_i,
    input logic [31:0] mc_rf_wb_data_i,
    input logic mc_rf_wb_stb_i,
    input logic mc_rf_wb_we_i,
    input logic mc_rf_wp_err,
    input logic mc_timing_any_bank_open,
    input logic mc_timing_bank_clr,
    input logic mc_timing_bank_clr_all,
    input logic mc_timing_bank_open,
    input logic mc_timing_bank_set,
    input logic mc_timing_cas,
    input logic mc_timing_cke,
    input logic mc_timing_clk,
    input logic mc_timing_cmd_a10,
    input logic [7:0] mc_timing_cs,
    input logic mc_timing_cs_en,
    input logic mc_timing_cs_le,
    input logic mc_timing_cs_le_d,
    input logic [31:0] mc_timing_csc,
    input logic mc_timing_data_oe,
    input logic mc_timing_dv,
    input logic mc_timing_err,
    input logic mc_timing_init_ack,
    input logic mc_timing_init_req,
    input logic mc_timing_lmr_ack,
    input logic mc_timing_lmr_req,
    input logic mc_timing_mc_ack,
    input logic mc_timing_mc_adsc,
    input logic mc_timing_mc_adv,
    input logic mc_timing_mc_bg,
    input logic mc_timing_mc_br,
    input logic mc_timing_mc_c_oe,
    input logic mc_timing_mc_clk,
    input logic mc_timing_mem_ack,
    input logic mc_timing_next_adr,
    input logic mc_timing_not_mem_cyc,
    input logic mc_timing_oe,
    input logic mc_timing_pack_le0,
    input logic mc_timing_pack_le1,
    input logic mc_timing_pack_le2,
    input logic [10:0] mc_timing_page_size,
    input logic mc_timing_par_err,
    input logic mc_timing_ras,
    input logic mc_timing_resume_req,
    input logic mc_timing_rfr_ack,
    input logic mc_timing_rfr_req,
    input logic mc_timing_row_same,
    input logic mc_timing_row_sel,
    input logic mc_timing_rst,
    input logic mc_timing_susp_req,
    input logic mc_timing_susp_sel,
    input logic mc_timing_suspended,
    input logic [31:0] mc_timing_tms,
    input logic mc_timing_wb_cyc_i,
    input logic mc_timing_wb_cycle,
    input logic mc_timing_wb_first,
    input logic mc_timing_wb_read_go,
    input logic mc_timing_wb_stb_i,
    input logic mc_timing_wb_wait,
    input logic mc_timing_wb_we_i,
    input logic mc_timing_wb_write_go,
    input logic mc_timing_we,
    input logic mc_timing_wr_cycle,
    input logic mc_wb_if_clk,
    input logic mc_wb_if_err,
    input logic mc_wb_if_mem_ack,
    input logic [31:0] mc_wb_if_mem_dout,
    input logic mc_wb_if_par_err,
    input logic [31:0] mc_wb_if_rf_dout,
    input logic mc_wb_if_rst,
    input logic mc_wb_if_wb_ack_o,
    input logic [31:0] mc_wb_if_wb_addr_i,
    input logic mc_wb_if_wb_cyc_i,
    input logic [31:0] mc_wb_if_wb_data_o,
    input logic mc_wb_if_wb_err,
    input logic mc_wb_if_wb_first,
    input logic mc_wb_if_wb_read_go,
    input logic mc_wb_if_wb_stb_i,
    input logic mc_wb_if_wb_wait,
    input logic mc_wb_if_wb_we_i,
    input logic mc_wb_if_wb_write_go,
    input logic mc_wb_if_wp_err,
    input logic mc_wb_if_wr_hold,
    input logic top_clk_i,
    input logic [7:0] top_cs_need_rfr,
    input logic [31:0] top_csc,
    input logic [31:0] top_csc_s,
    input logic top_init_ack,
    input logic top_lmr_ack,
    input logic top_lmr_sel,
    input logic top_mc_ack_pad_i,
    input logic [23:0] top_mc_addr_pad_o,
    input logic top_mc_adsc_pad_o,
    input logic top_mc_adv_pad_o,
    input logic top_mc_bg_pad_o,
    input logic top_mc_br_pad_i,
    input logic top_mc_cas_pad_o,
    input logic top_mc_cke_pad_o,
    input logic top_mc_clk_i,
    input logic top_mc_coe_pad_coe_o,
    input logic [7:0] top_mc_cs_pad_o,
    input logic [31:0] top_mc_data_pad_i,
    input logic [31:0] top_mc_data_pad_o,
    input logic top_mc_doe_pad_doe_o,
    input logic [3:0] top_mc_dp_pad_i,
    input logic [3:0] top_mc_dp_pad_o,
    input logic [3:0] top_mc_dqm_pad_o,
    input logic top_mc_oe_pad_o,
    input logic top_mc_ras_pad_o,
    input logic top_mc_rp_pad_o,
    input logic top_mc_sts_pad_i,
    input logic top_mc_vpen_pad_o,
    input logic top_mc_we_pad_o,
    input logic top_mc_zz_pad_o,
    input logic top_mem_ack,
    input logic top_mem_ack_r,
    input logic top_not_mem_cyc,
    input logic [7:0] top_obct_cs,
    input logic [31:0] top_poc_o,
    input logic top_resume_req_i,
    input logic top_rfr_ack,
    input logic top_rst_i,
    input logic [31:0] top_sp_csc,
    input logic [31:0] top_sp_tms,
    input logic top_susp_req_i,
    input logic top_susp_sel,
    input logic top_suspended_o,
    input logic [31:0] top_tms,
    input logic [31:0] top_tms_s,
    input logic top_wb_ack_o,
    input logic [31:0] top_wb_addr_i,
    input logic top_wb_cyc_i,
    input logic [31:0] top_wb_data_i,
    input logic [31:0] top_wb_data_o,
    input logic top_wb_err_o,
    input logic [3:0] top_wb_sel_i,
    input logic top_wb_stb_i,
    input logic top_wb_we_i
);

//======================================================================
// Assertions for Signal: top_wb_ack_o
// Primary label from model: top_wb_ack_o
//======================================================================
always_comb begin
  // wb_ack_o and wb_err_o must be mutually exclusive for a given transfer
  assert (!(top_wb_ack_o && top_wb_err_o));
  // wb_ack_o must only be asserted during a qualified WISHBONE transfer
  assert (top_wb_ack_o -> (top_wb_cyc_i && top_wb_stb_i));
  // wb_ack_o must be deasserted during reset (no normal transactions serviced)
  assert (top_rst_i -> !top_wb_ack_o);
end


//======================================================================
// Assertions for Signal: top_wb_err_o
// Primary label from model: top_wb_err_o
//======================================================================
always_comb begin
  // wb_err_o must only be asserted during a qualified WISHBONE transfer
  assert (top_wb_err_o -> (top_wb_cyc_i && top_wb_stb_i));
  // wb_err_o must be deasserted during reset
  assert (top_rst_i -> !top_wb_err_o);
end


//======================================================================
// Assertions for Signal: top_wb_stb_i
// Primary label from model: top_wb_stb_i
//======================================================================
always_comb begin
  // WISHBONE strobe is only legal while cycle is asserted
  assert (top_wb_stb_i -> top_wb_cyc_i);
end


//======================================================================
// Assertions for Signal: top_mc_bg_pad_o
// Primary label from model: top_mc_bg_pad_o
//======================================================================
always_comb begin
  // Bus grant to external master must not be issued without a pending request
  assert (top_mc_bg_pad_o -> top_mc_br_pad_i);
end


//======================================================================
// Assertions for Signal: top_mc_cs_pad_o
// Primary label from model: top_mc_cs_pad_o
//======================================================================
always_comb begin
  // During reset, active-low chip-select outputs must be deasserted (all high)
  assert (top_rst_i -> (top_mc_cs_pad_o == 8'hFF));
end


//======================================================================
// Assertions for Signal: mc_wb_if_wb_read_go
// Primary label from model: mc_wb_if_wb_read_go
//======================================================================
always_comb begin
  // Read and write request strobes are mutually exclusive
  assert (!(mc_wb_if_wb_read_go && mc_wb_if_wb_write_go));
end


//======================================================================
// Assertions for Signal: mc_timing_wb_read_go
// Primary label from model: mc_timing_wb_read_go
//======================================================================
always_comb begin
  // Read and write go qualifiers seen by timing sequencer are mutually exclusive
  assert (!(mc_timing_wb_read_go && mc_timing_wb_write_go));
end


//======================================================================
// Assertions for Signal: mc_rf_init_req
// Primary label from model: mc_rf_init_req
//======================================================================
always_comb begin
  // Initialization and load-mode special requests are serviced one target at a time
  assert (!(mc_rf_init_req && mc_rf_lmr_req));
end


//======================================================================
// Assertions for Signal: mc_timing_init_req
// Primary label from model: mc_timing_init_req
//======================================================================
always_comb begin
  // Init and LMR requests must be mutually exclusive at the sequencer
  assert (!(mc_timing_init_req && mc_timing_lmr_req));
  // Init acknowledge implies an init request was outstanding
  assert (mc_timing_init_ack -> mc_timing_init_req);
end


//======================================================================
// Assertions for Signal: mc_timing_lmr_req
// Primary label from model: mc_timing_lmr_req
//======================================================================
always_comb begin
  // LMR acknowledge implies an LMR request was outstanding
  assert (mc_timing_lmr_ack -> mc_timing_lmr_req);
end


//======================================================================
// Assertions for Signal: mc_refresh_rfr_req
// Primary label from model: mc_refresh_rfr_req
//======================================================================
always_comb begin
  // Refresh acknowledge must only occur in response to an active refresh request
  assert (mc_refresh_rfr_ack -> mc_refresh_rfr_req);
  // Refresh request must be deasserted during reset
  assert (mc_refresh_rst -> !mc_refresh_rfr_req);
end


//======================================================================
// Assertions for Signal: mc_timing_rfr_req
// Primary label from model: mc_timing_rfr_req
//======================================================================
always_comb begin
  // Refresh acknowledge seen by timing sequencer implies a pending refresh request
  assert (mc_timing_rfr_ack -> mc_timing_rfr_req);
end


//======================================================================
// Assertions for Signal: mc_timing_mem_ack
// Primary label from model: mc_timing_mem_ack
//======================================================================
always_comb begin
  // Memory completion acknowledge and error indication are mutually exclusive
  assert (!(mc_timing_mem_ack && mc_timing_err));
end


//======================================================================
// Assertions for Signal: mc_wb_if_wb_err
// Primary label from model: mc_wb_if_wb_err
//======================================================================
always_comb begin
  // Normal acknowledge is suppressed when an error is signaled for the same transfer
  assert (!(mc_wb_if_wb_ack_o && mc_wb_if_wb_err));
  // Error termination only applies to a qualified transfer
  assert (mc_wb_if_wb_err -> (mc_wb_if_wb_cyc_i && mc_wb_if_wb_stb_i));
end


//======================================================================
// Assertions for Signal: mc_obct_top_bank_open
// Primary label from model: mc_obct_top_bank_open
//======================================================================
always_comb begin
  // If a specific bank is open, the aggregate any-bank-open indication must also be set
  assert (mc_obct_top_bank_open -> mc_obct_top_any_bank_open);
end


//======================================================================
// Assertions for Signal: mc_obct_top_row_same
// Primary label from model: mc_obct_top_row_same
//======================================================================
always_comb begin
  // Row-match indication is only meaningful when a bank is actually open
  assert (mc_obct_top_row_same -> mc_obct_top_bank_open);
end


//======================================================================
// Assertions for Signal: mc_mem_if_susp_sel
// Primary label from model: mc_mem_if_susp_sel
//======================================================================
always_comb begin
  // During suspend selection, SSRAM snooze/sleep control must be driven active
  assert (mc_mem_if_susp_sel -> mc_mem_if_mc_zz_o);
end


//======================================================================
// Assertions for Signal: mc_timing_susp_req
// Primary label from model: mc_timing_susp_req
//======================================================================
always_comb begin
  // Suspend-select context must correspond to an active suspend request or suspended state
  assert (mc_timing_susp_sel -> (mc_timing_susp_req || mc_timing_suspended));
end


//======================================================================
// Assertions for Signal: mc_mem_if_mc_cs
// Primary label from model: mc_mem_if_mc_cs
//======================================================================
always_comb begin
  // During reset, registered chip-select outputs must be deasserted (active-low, all high)
  assert (mc_mem_if_rst -> (mc_mem_if_mc_cs == 8'hFF));
end


//======================================================================
// Assertions for Signal: mc_rf_wb_ack_o
// Primary label from model: mc_rf_wb_ack_o
//======================================================================
always_comb begin
  // Register-file acknowledge only valid during a qualified WISHBONE cycle
  assert (mc_rf_wb_ack_o -> (mc_rf_wb_cyc_i && mc_rf_wb_stb_i));
end


//======================================================================
// Assertions for Signal: mc_rf_wp_err
// Primary label from model: mc_rf_wp_err
//======================================================================
always_comb begin
  // Write-protect error generated by register file must match the value observed by the WISHBONE interface error logic
  assert (mc_rf_wp_err == mc_wb_if_wp_err);
end


//======================================================================
// Assertions for Signal: mc_dp_par_err
// Primary label from model: mc_dp_par_err
//======================================================================
always_comb begin
  // Read parity error generated by data path must match the value observed by the WISHBONE interface error logic
  assert (mc_dp_par_err == mc_wb_if_par_err);
end


//======================================================================
// Assertions for Signal: mc_rf_cs
// Primary label from model: mc_rf_cs
//======================================================================
always_comb begin
  // At most one chip-select region should be active at a time
  assert ($onehot0(mc_rf_cs));
end


//======================================================================
// Assertions for Signal: mc_rf_spec_req_cs
// Primary label from model: mc_rf_spec_req_cs
//======================================================================
always_comb begin
  // Special SDRAM sequencing requests target at most one chip-select at a time
  assert ($onehot0(mc_rf_spec_req_cs));
end
endmodule

