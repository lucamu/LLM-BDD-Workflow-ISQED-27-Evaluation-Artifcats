`include "sdrc_define.v"

// method: plain_prompt

// Global checker bound to top module: sdrc_top
module sdrc_top_sva_global (
    input logic sdrc_core_app_last_rd,
    input logic sdrc_core_app_last_wr,
    input logic [31:0] sdrc_core_app_rd_data,
    input logic sdrc_core_app_rd_valid,
    input logic sdrc_core_app_req,
    input logic sdrc_core_app_req_ack,
    input logic [25:0] sdrc_core_app_req_addr,
    input logic sdrc_core_app_req_dma_last,
    input logic [8:0] sdrc_core_app_req_len,
    input logic sdrc_core_app_req_wr_n,
    input logic sdrc_core_app_req_wrap,
    input logic [31:0] sdrc_core_app_wr_data,
    input logic [3:0] sdrc_core_app_wr_en_n,
    input logic sdrc_core_app_wr_next_req,
    input logic [1:0] sdrc_core_cfg_colbits,
    input logic [1:0] sdrc_core_cfg_req_depth,
    input logic [2:0] sdrc_core_cfg_sdr_cas,
    input logic sdrc_core_cfg_sdr_en,
    input logic [12:0] sdrc_core_cfg_sdr_mode_reg,
    input logic [`SDR_RFSH_ROW_CNT_W -1 : 0] sdrc_core_cfg_sdr_rfmax,
    input logic [`SDR_RFSH_TIMER_W-1 : 0] sdrc_core_cfg_sdr_rfsh,
    input logic [3:0] sdrc_core_cfg_sdr_tras_d,
    input logic [3:0] sdrc_core_cfg_sdr_trcar_d,
    input logic [3:0] sdrc_core_cfg_sdr_trcd_d,
    input logic [3:0] sdrc_core_cfg_sdr_trp_d,
    input logic [3:0] sdrc_core_cfg_sdr_twr_d,
    input logic sdrc_core_clk,
    input logic sdrc_core_pad_clk,
    input logic [15:0] sdrc_core_pad_sdr_din,
    input logic sdrc_core_reset_n,
    input logic [12:0] sdrc_core_sdr_addr,
    input logic [1:0] sdrc_core_sdr_ba,
    input logic sdrc_core_sdr_cas_n,
    input logic sdrc_core_sdr_cke,
    input logic sdrc_core_sdr_cs_n,
    input logic [1:0] sdrc_core_sdr_den_n,
    input logic [15:0] sdrc_core_sdr_dout,
    input logic [1:0] sdrc_core_sdr_dqm,
    input logic sdrc_core_sdr_init_done,
    input logic sdrc_core_sdr_ras_n,
    input logic sdrc_core_sdr_we_n,
    input logic [1:0] sdrc_core_sdr_width,
    input logic [1:0] top_cfg_colbits,
    input logic [1:0] top_cfg_req_depth,
    input logic [2:0] top_cfg_sdr_cas,
    input logic top_cfg_sdr_en,
    input logic [12:0] top_cfg_sdr_mode_reg,
    input logic [`SDR_RFSH_ROW_CNT_W -1 : 0] top_cfg_sdr_rfmax,
    input logic [`SDR_RFSH_TIMER_W-1 : 0] top_cfg_sdr_rfsh,
    input logic [3:0] top_cfg_sdr_tras_d,
    input logic [3:0] top_cfg_sdr_trcar_d,
    input logic [3:0] top_cfg_sdr_trcd_d,
    input logic [3:0] top_cfg_sdr_trp_d,
    input logic [3:0] top_cfg_sdr_twr_d,
    input logic [1:0] top_cfg_sdr_width,
    input logic [15:0] top_pad_sdr_din,
    input logic [12:0] top_sdr_addr,
    input logic [1:0] top_sdr_ba,
    input logic top_sdr_cas_n,
    input logic top_sdr_cke,
    input logic top_sdr_cs_n,
    input logic [15:0] top_sdr_dq,
    input logic [1:0] top_sdr_dqm,
    input logic top_sdr_init_done,
    input logic top_sdr_ras_n,
    input logic top_sdr_we_n,
    input logic top_sdram_clk,
    input logic top_sdram_resetn,
    input logic top_wb_ack_o,
    input logic [25:0] top_wb_addr_i,
    input logic top_wb_clk_i,
    input logic [2:0] top_wb_cti_i,
    input logic top_wb_cyc_i,
    input logic [31:0] top_wb_dat_i,
    input logic [31:0] top_wb_dat_o,
    input logic top_wb_rst_i,
    input logic [3:0] top_wb_sel_i,
    input logic top_wb_stb_i,
    input logic top_wb_we_i,
    input logic wb2sdrc_sdr_busy_n,
    input logic wb2sdrc_sdr_last_rd,
    input logic [31:0] wb2sdrc_sdr_rd_data,
    input logic wb2sdrc_sdr_rd_valid,
    input logic wb2sdrc_sdr_req,
    input logic wb2sdrc_sdr_req_ack,
    input logic [25:0] wb2sdrc_sdr_req_addr,
    input logic [8:0] wb2sdrc_sdr_req_len,
    input logic wb2sdrc_sdr_req_wr_n,
    input logic [31:0] wb2sdrc_sdr_wr_data,
    input logic [3:0] wb2sdrc_sdr_wr_en_n,
    input logic wb2sdrc_sdr_wr_next,
    input logic wb2sdrc_sdram_clk,
    input logic wb2sdrc_sdram_resetn,
    input logic wb2sdrc_wb_ack_o,
    input logic [25:0] wb2sdrc_wb_addr_i,
    input logic wb2sdrc_wb_clk_i,
    input logic [2:0] wb2sdrc_wb_cti_i,
    input logic wb2sdrc_wb_cyc_i,
    input logic [31:0] wb2sdrc_wb_dat_i,
    input logic [31:0] wb2sdrc_wb_dat_o,
    input logic wb2sdrc_wb_rst_i,
    input logic [3:0] wb2sdrc_wb_sel_i,
    input logic wb2sdrc_wb_stb_i,
    input logic wb2sdrc_wb_we_i
);

//======================================================================
// Assertions for Signal: top_wb_ack_o
// Primary label from model: top_wb_ack_o
//======================================================================
always_comb begin
  // wb_ack_o is passed through directly from the bridge module
  assert (top_wb_ack_o == wb2sdrc_wb_ack_o);
  // Wishbone protocol: ack must only occur while strobe is asserted
  assert (!top_wb_ack_o || top_wb_stb_i);
  // Wishbone protocol: ack must only occur during a valid bus cycle
  assert (!top_wb_ack_o || top_wb_cyc_i);
end


//======================================================================
// Assertions for Signal: top_wb_stb_i
// Primary label from model: top_wb_stb_i
//======================================================================
always_comb begin
  // Wishbone protocol: stb must only be asserted within an active cycle
  assert (!top_wb_stb_i || top_wb_cyc_i);
  // Top-level Wishbone signals are passed through unmodified to wb2sdrc
  assert (top_wb_stb_i == wb2sdrc_wb_stb_i);
  assert (top_wb_cyc_i == wb2sdrc_wb_cyc_i);
  assert (top_wb_addr_i == wb2sdrc_wb_addr_i);
  assert (top_wb_we_i   == wb2sdrc_wb_we_i);
  assert (top_wb_dat_i  == wb2sdrc_wb_dat_i);
  assert (top_wb_sel_i  == wb2sdrc_wb_sel_i);
  assert (top_wb_cti_i  == wb2sdrc_wb_cti_i);
end


//======================================================================
// Assertions for Signal: top_wb_clk_i
// Primary label from model: top_wb_clk_i
//======================================================================
always_comb begin
  // Wishbone clock and reset are passed through unmodified to wb2sdrc
  assert (top_wb_clk_i == wb2sdrc_wb_clk_i);
  assert (top_wb_rst_i == wb2sdrc_wb_rst_i);
end


//======================================================================
// Assertions for Signal: top_wb_dat_o
// Primary label from model: top_wb_dat_o
//======================================================================
always_comb begin
  // Read data returned to Wishbone is passed through from the bridge
  assert (top_wb_dat_o == wb2sdrc_wb_dat_o);
end


//======================================================================
// Assertions for Signal: top_sdr_cs_n
// Primary label from model: top_sdr_cs_n
//======================================================================
always_comb begin
  // SDRAM command/control pins are driven directly by sdrc_core
  assert (top_sdr_cs_n  == sdrc_core_sdr_cs_n);
  assert (top_sdr_ras_n == sdrc_core_sdr_ras_n);
  assert (top_sdr_cas_n == sdrc_core_sdr_cas_n);
  assert (top_sdr_we_n  == sdrc_core_sdr_we_n);
  assert (top_sdr_ba    == sdrc_core_sdr_ba);
  assert (top_sdr_addr  == sdrc_core_sdr_addr);
  assert (top_sdr_dqm   == sdrc_core_sdr_dqm);
  assert (top_sdr_cke   == sdrc_core_sdr_cke);
end


//======================================================================
// Assertions for Signal: top_sdr_dq
// Primary label from model: top_sdr_dq
//======================================================================
always_comb begin
  // sdr_dq must be actively driven with sdr_dout when any output-enable lane is active (den_n active-low)
  assert (!(|~sdrc_core_sdr_den_n) || (top_sdr_dq === sdrc_core_sdr_dout));
  // sdr_dq must be high impedance when no output-enable lane is active
  assert (!(&sdrc_core_sdr_den_n) || (top_sdr_dq === {16{1'bz}}));
end


//======================================================================
// Assertions for Signal: top_sdr_init_done
// Primary label from model: top_sdr_init_done
//======================================================================
always_comb begin
  // Initialization-done status is passed through directly from sdrc_core
  assert (top_sdr_init_done == sdrc_core_sdr_init_done);
end


//======================================================================
// Assertions for Signal: top_pad_sdr_din
// Primary label from model: top_pad_sdr_din
//======================================================================
always_comb begin
  // SDRAM read-data pad input is passed through directly to sdrc_core
  assert (top_pad_sdr_din == sdrc_core_pad_sdr_din);
end


//======================================================================
// Assertions for Signal: top_cfg_sdr_width
// Primary label from model: top_cfg_sdr_width
//======================================================================
always_comb begin
  // Configuration inputs are passed through directly from top-level to sdrc_core
  assert (top_cfg_sdr_width   == sdrc_core_sdr_width);
  assert (top_cfg_colbits     == sdrc_core_cfg_colbits);
  assert (top_cfg_req_depth   == sdrc_core_cfg_req_depth);
  assert (top_cfg_sdr_en      == sdrc_core_cfg_sdr_en);
  assert (top_cfg_sdr_mode_reg== sdrc_core_cfg_sdr_mode_reg);
  assert (top_cfg_sdr_tras_d  == sdrc_core_cfg_sdr_tras_d);
  assert (top_cfg_sdr_trp_d   == sdrc_core_cfg_sdr_trp_d);
  assert (top_cfg_sdr_trcd_d  == sdrc_core_cfg_sdr_trcd_d);
  assert (top_cfg_sdr_cas     == sdrc_core_cfg_sdr_cas);
  assert (top_cfg_sdr_trcar_d == sdrc_core_cfg_sdr_trcar_d);
  assert (top_cfg_sdr_twr_d   == sdrc_core_cfg_sdr_twr_d);
  assert (top_cfg_sdr_rfsh    == sdrc_core_cfg_sdr_rfsh);
  assert (top_cfg_sdr_rfmax   == sdrc_core_cfg_sdr_rfmax);
end


//======================================================================
// Assertions for Signal: top_sdram_clk
// Primary label from model: top_sdram_clk
//======================================================================
always_comb begin
  // SDRAM-domain clock is distributed unmodified to sdrc_core and wb2sdrc
  assert (top_sdram_clk == sdrc_core_clk);
  assert (top_sdram_clk == wb2sdrc_sdram_clk);
end


//======================================================================
// Assertions for Signal: top_sdram_resetn
// Primary label from model: top_sdram_resetn
//======================================================================
always_comb begin
  // SDRAM-domain active-low reset is distributed unmodified to sdrc_core and wb2sdrc
  assert (top_sdram_resetn == sdrc_core_reset_n);
  assert (top_sdram_resetn == wb2sdrc_sdram_resetn);
end


//======================================================================
// Assertions for Signal: sdrc_core_app_req_wrap
// Primary label from model: sdrc_core_app_req_wrap
//======================================================================
always_comb begin
  // wrap input to sdrc_core is tied low in sdrc_top per specification
  assert (sdrc_core_app_req_wrap == 1'b0);
end


//======================================================================
// Assertions for Signal: wb2sdrc_sdr_req
// Primary label from model: wb2sdrc_sdr_req
//======================================================================
always_comb begin
  // Request handshake signals pass directly between wb2sdrc and sdrc_core
  assert (wb2sdrc_sdr_req      == sdrc_core_app_req);
  assert (wb2sdrc_sdr_req_ack  == sdrc_core_app_req_ack);
  assert (wb2sdrc_sdr_req_addr == sdrc_core_app_req_addr);
  assert (wb2sdrc_sdr_req_len  == sdrc_core_app_req_len);
  assert (wb2sdrc_sdr_req_wr_n == sdrc_core_app_req_wr_n);
  // Request acknowledge is only legal while a request is outstanding
  assert (!sdrc_core_app_req_ack || sdrc_core_app_req);
end


//======================================================================
// Assertions for Signal: wb2sdrc_sdr_wr_data
// Primary label from model: wb2sdrc_sdr_wr_data
//======================================================================
always_comb begin
  // Write-data handshake signals pass directly between wb2sdrc and sdrc_core
  assert (wb2sdrc_sdr_wr_data  == sdrc_core_app_wr_data);
  assert (wb2sdrc_sdr_wr_en_n  == sdrc_core_app_wr_en_n);
  assert (wb2sdrc_sdr_wr_next  == sdrc_core_app_wr_next_req);
end


//======================================================================
// Assertions for Signal: wb2sdrc_sdr_rd_data
// Primary label from model: wb2sdrc_sdr_rd_data
//======================================================================
always_comb begin
  // Read-data handshake signals pass directly between sdrc_core and wb2sdrc
  assert (wb2sdrc_sdr_rd_data  == sdrc_core_app_rd_data);
  assert (wb2sdrc_sdr_rd_valid == sdrc_core_app_rd_valid);
  assert (wb2sdrc_sdr_last_rd  == sdrc_core_app_last_rd);
  // Last-read indicator is only meaningful when read data is valid
  assert (!sdrc_core_app_last_rd || sdrc_core_app_rd_valid);
end
endmodule

