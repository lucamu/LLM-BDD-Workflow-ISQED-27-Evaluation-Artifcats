// method: plain_prompt

// Global checker bound to top module: xgate_top
module xgate_top_sva_global (
    input logic top_arst_i,
    input logic top_chan_req_i,
    input logic top_debug_mode_i,
    input logic top_risc_clk,
    input logic top_scantestmode,
    input logic top_secure_mode_i,
    input logic top_wbm_ack_i,
    input logic [15:0] top_wbm_adr_o,
    input logic top_wbm_cyc_o,
    input logic [1:0] top_wbm_dat_i,
    input logic [1:0] top_wbm_dat_o,
    input logic [1:0] top_wbm_sel_o,
    input logic top_wbm_stb_o,
    input logic top_wbm_we_o,
    input logic top_wbs_ack_o,
    input logic [5:0] top_wbs_adr_i,
    input logic top_wbs_clk_i,
    input logic top_wbs_cyc_i,
    input logic [1:0] top_wbs_dat_i,
    input logic [1:0] top_wbs_dat_o,
    input logic top_wbs_err_o,
    input logic top_wbs_rst_i,
    input logic [1:0] top_wbs_sel_i,
    input logic top_wbs_stb_i,
    input logic top_wbs_we_i,
    input logic top_xg_sw_irq,
    input logic top_xgif,
    input logic [7:0] top_xgswt,
    input logic xgate_irq_encode_chan_bypass,
    input logic xgate_irq_encode_chan_req_i,
    input logic [6:0] xgate_irq_encode_int_req,
    input logic xgate_irq_encode_xgif,
    input logic xgate_irq_encode_xgif_status,
    input logic xgate_regs_async_rst_b,
    input logic xgate_regs_brk_irq_ena,
    input logic xgate_regs_bus_clk,
    input logic xgate_regs_chan_bypass,
    input logic xgate_regs_clear_xgif_0,
    input logic xgate_regs_clear_xgif_1,
    input logic xgate_regs_clear_xgif_2,
    input logic xgate_regs_clear_xgif_3,
    input logic xgate_regs_clear_xgif_4,
    input logic xgate_regs_clear_xgif_5,
    input logic xgate_regs_clear_xgif_6,
    input logic xgate_regs_clear_xgif_7,
    input logic [15:0] xgate_regs_clear_xgif_data,
    input logic xgate_regs_debug_ack,
    input logic xgate_regs_irq_bypass,
    input logic xgate_regs_sync_reset,
    input logic [15:0] xgate_regs_write_bus,
    input logic [1:0] xgate_regs_write_irw_en_0,
    input logic [1:0] xgate_regs_write_irw_en_1,
    input logic [1:0] xgate_regs_write_irw_en_2,
    input logic [1:0] xgate_regs_write_irw_en_3,
    input logic [1:0] xgate_regs_write_irw_en_4,
    input logic [1:0] xgate_regs_write_irw_en_5,
    input logic [1:0] xgate_regs_write_irw_en_6,
    input logic [1:0] xgate_regs_write_irw_en_7,
    input logic [1:0] xgate_regs_write_xgif_0,
    input logic [1:0] xgate_regs_write_xgif_1,
    input logic [1:0] xgate_regs_write_xgif_2,
    input logic [1:0] xgate_regs_write_xgif_3,
    input logic [1:0] xgate_regs_write_xgif_4,
    input logic [1:0] xgate_regs_write_xgif_5,
    input logic [1:0] xgate_regs_write_xgif_6,
    input logic [1:0] xgate_regs_write_xgif_7,
    input logic xgate_regs_write_xgmctl,
    input logic xgate_regs_write_xgswt,
    input logic [1:0] xgate_regs_write_xgvbr,
    input logic xgate_regs_xgdbg_clear,
    input logic xgate_regs_xgdbg_set,
    input logic xgate_regs_xge,
    input logic xgate_regs_xgfact,
    input logic xgate_regs_xgfrz,
    input logic xgate_regs_xgie,
    input logic xgate_regs_xgss,
    input logic xgate_regs_xgsweif_c,
    input logic [7:0] xgate_regs_xgswt,
    input logic [14:0] xgate_regs_xgvbr,
    input logic xgate_risc_async_rst_b,
    input logic xgate_risc_brk_irq_ena,
    input logic xgate_risc_carry_flag,
    input logic xgate_risc_clear_xgif_0,
    input logic xgate_risc_clear_xgif_1,
    input logic xgate_risc_clear_xgif_2,
    input logic xgate_risc_clear_xgif_3,
    input logic xgate_risc_clear_xgif_4,
    input logic xgate_risc_clear_xgif_5,
    input logic xgate_risc_clear_xgif_6,
    input logic xgate_risc_clear_xgif_7,
    input logic [15:0] xgate_risc_clear_xgif_data,
    input logic xgate_risc_debug_ack,
    input logic xgate_risc_debug_active,
    input logic xgate_risc_debug_mode_i,
    input logic [7:0] xgate_risc_host_semap,
    input logic [6:0] xgate_risc_int_req,
    input logic xgate_risc_mem_access,
    input logic xgate_risc_mem_req_ack,
    input logic xgate_risc_negative_flag,
    input logic xgate_risc_overflow_flag,
    input logic [15:0] xgate_risc_perif_data,
    input logic [15:0] xgate_risc_read_mem_data,
    input logic xgate_risc_risc_clk,
    input logic xgate_risc_single_step,
    input logic xgate_risc_ss_mem_ack,
    input logic [15:0] xgate_risc_write_mem_data,
    input logic xgate_risc_write_mem_strb_h,
    input logic xgate_risc_write_mem_strb_l,
    input logic xgate_risc_write_xgccr,
    input logic xgate_risc_write_xgchid,
    input logic [1:0] xgate_risc_write_xgpc,
    input logic [1:0] xgate_risc_write_xgr1,
    input logic [1:0] xgate_risc_write_xgr2,
    input logic [1:0] xgate_risc_write_xgr3,
    input logic [1:0] xgate_risc_write_xgr4,
    input logic [1:0] xgate_risc_write_xgr5,
    input logic [1:0] xgate_risc_write_xgr6,
    input logic [1:0] xgate_risc_write_xgr7,
    input logic xgate_risc_write_xgsem,
    input logic xgate_risc_xg_sw_irq,
    input logic [15:0] xgate_risc_xgate_address,
    input logic [6:0] xgate_risc_xgchid,
    input logic xgate_risc_xgdbg_clear,
    input logic xgate_risc_xgdbg_set,
    input logic xgate_risc_xge,
    input logic xgate_risc_xgie,
    input logic [126:0] xgate_risc_xgif_status,
    input logic [15:0] xgate_risc_xgr1,
    input logic [15:0] xgate_risc_xgr2,
    input logic [15:0] xgate_risc_xgr3,
    input logic [15:0] xgate_risc_xgr4,
    input logic [15:0] xgate_risc_xgr5,
    input logic [15:0] xgate_risc_xgr6,
    input logic [15:0] xgate_risc_xgr7,
    input logic xgate_risc_xgss,
    input logic xgate_risc_xgsweif_c,
    input logic [14:0] xgate_risc_xgvbr,
    input logic xgate_risc_zero_flag,
    input logic xgate_wbm_bus_async_rst_b,
    input logic xgate_wbm_bus_mem_access,
    input logic xgate_wbm_bus_mem_req_ack,
    input logic [1:0] xgate_wbm_bus_read_mem_data,
    input logic xgate_wbm_bus_risc_clk,
    input logic xgate_wbm_bus_single_step,
    input logic xgate_wbm_bus_ss_mem_ack,
    input logic xgate_wbm_bus_wbm_ack_i,
    input logic [15:0] xgate_wbm_bus_wbm_adr_o,
    input logic xgate_wbm_bus_wbm_cyc_o,
    input logic [1:0] xgate_wbm_bus_wbm_dat_i,
    input logic [1:0] xgate_wbm_bus_wbm_dat_o,
    input logic [1:0] xgate_wbm_bus_wbm_sel_o,
    input logic xgate_wbm_bus_wbm_stb_o,
    input logic xgate_wbm_bus_wbm_we_o,
    input logic [1:0] xgate_wbm_bus_write_mem_data,
    input logic xgate_wbm_bus_write_mem_strb_h,
    input logic xgate_wbm_bus_write_mem_strb_l,
    input logic [15:0] xgate_wbm_bus_xgate_address,
    input logic xgate_wbm_bus_xge,
    input logic xgate_wbs_bus_arst_i,
    input logic xgate_wbs_bus_async_rst_b,
    input logic [126:0] xgate_wbs_bus_irq_bypass,
    input logic [415:0] xgate_wbs_bus_read_risc_regs,
    input logic xgate_wbs_bus_sync_reset,
    input logic xgate_wbs_bus_wbs_ack_o,
    input logic [5:0] xgate_wbs_bus_wbs_adr_i,
    input logic xgate_wbs_bus_wbs_clk_i,
    input logic xgate_wbs_bus_wbs_cyc_i,
    input logic [1:0] xgate_wbs_bus_wbs_dat_o,
    input logic xgate_wbs_bus_wbs_err_o,
    input logic xgate_wbs_bus_wbs_rst_i,
    input logic [1:0] xgate_wbs_bus_wbs_sel_i,
    input logic xgate_wbs_bus_wbs_stb_i,
    input logic xgate_wbs_bus_wbs_we_i,
    input logic [1:0] xgate_wbs_bus_write_irw_en_0,
    input logic [1:0] xgate_wbs_bus_write_irw_en_1,
    input logic [1:0] xgate_wbs_bus_write_irw_en_2,
    input logic [1:0] xgate_wbs_bus_write_irw_en_3,
    input logic [1:0] xgate_wbs_bus_write_irw_en_4,
    input logic [1:0] xgate_wbs_bus_write_irw_en_5,
    input logic [1:0] xgate_wbs_bus_write_irw_en_6,
    input logic [1:0] xgate_wbs_bus_write_irw_en_7,
    input logic xgate_wbs_bus_write_xgccr,
    input logic xgate_wbs_bus_write_xgchid,
    input logic [1:0] xgate_wbs_bus_write_xgif_0,
    input logic [1:0] xgate_wbs_bus_write_xgif_1,
    input logic [1:0] xgate_wbs_bus_write_xgif_2,
    input logic [1:0] xgate_wbs_bus_write_xgif_3,
    input logic [1:0] xgate_wbs_bus_write_xgif_4,
    input logic [1:0] xgate_wbs_bus_write_xgif_5,
    input logic [1:0] xgate_wbs_bus_write_xgif_6,
    input logic [1:0] xgate_wbs_bus_write_xgif_7,
    input logic xgate_wbs_bus_write_xgisp30,
    input logic xgate_wbs_bus_write_xgisp74,
    input logic xgate_wbs_bus_write_xgmctl,
    input logic [1:0] xgate_wbs_bus_write_xgpc,
    input logic [1:0] xgate_wbs_bus_write_xgr1,
    input logic [1:0] xgate_wbs_bus_write_xgr2,
    input logic [1:0] xgate_wbs_bus_write_xgr3,
    input logic [1:0] xgate_wbs_bus_write_xgr4,
    input logic [1:0] xgate_wbs_bus_write_xgr5,
    input logic [1:0] xgate_wbs_bus_write_xgr6,
    input logic [1:0] xgate_wbs_bus_write_xgr7,
    input logic xgate_wbs_bus_write_xgsem,
    input logic xgate_wbs_bus_write_xgswt,
    input logic [1:0] xgate_wbs_bus_write_xgvbr
);

//======================================================================
// Assertions for Signal: xgate_irq_encode_xgif
// Primary label from model: xgate_irq_encode_xgif
//======================================================================
// Bypassed channels forward chan_req_i directly; non-bypassed channels forward xgif_status
always_comb begin
  if (xgate_irq_encode_chan_bypass)
    assert (xgate_irq_encode_xgif == xgate_irq_encode_chan_req_i);
  else
    assert (xgate_irq_encode_xgif == xgate_irq_encode_xgif_status);
end


//======================================================================
// Assertions for Signal: xgate_irq_encode_int_req
// Primary label from model: xgate_irq_encode_int_req
//======================================================================
// Encoded channel index must stay within MAX_CHANNEL (127) range
always_comb begin
  assert (xgate_irq_encode_int_req <= 7'd127);
end


//======================================================================
// Assertions for Signal: xgate_irq_encode_chan_req_i
// Primary label from model: xgate_irq_encode_chan_req_i
//======================================================================
// Interrupt request input is passed directly to the encoder
always_comb begin
  assert (xgate_irq_encode_chan_req_i == top_chan_req_i);
end


//======================================================================
// Assertions for Signal: xgate_regs_chan_bypass
// Primary label from model: xgate_regs_chan_bypass
//======================================================================
// Bypass control bits stored in regs feed the interrupt encoder directly
always_comb begin
  assert (xgate_regs_chan_bypass == xgate_irq_encode_chan_bypass);
end


//======================================================================
// Assertions for Signal: top_xgif
// Primary label from model: top_xgif
//======================================================================
// Host-visible interrupt vector equals the encoder output
always_comb begin
  assert (top_xgif == xgate_irq_encode_xgif);
end


//======================================================================
// Assertions for Signal: top_xgswt
// Primary label from model: top_xgswt
//======================================================================
// Software-trigger output reflects the regs XGSWT register bits directly
always_comb begin
  assert (top_xgswt == xgate_regs_xgswt);
end


//======================================================================
// Assertions for Signal: xgate_risc_xg_sw_irq
// Primary label from model: xgate_risc_xg_sw_irq
//======================================================================
// Software error interrupt is gated by the interrupt-enable control
always_comb begin
  if (!xgate_risc_xgie)
    assert (xgate_risc_xg_sw_irq == 1'b0);
end
// Top-level software error interrupt passes through directly from the RISC core
always_comb begin
  assert (top_xg_sw_irq == xgate_risc_xg_sw_irq);
end


//======================================================================
// Assertions for Signal: top_wbm_stb_o
// Primary label from model: top_wbm_stb_o
//======================================================================
// WISHBONE master strobe must only be asserted while cycle is valid
always_comb begin
  assert (top_wbm_stb_o -> top_wbm_cyc_o);
end
// Top-level strobe passes through from the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_stb_o == xgate_wbm_bus_wbm_stb_o);
end


//======================================================================
// Assertions for Signal: top_wbm_cyc_o
// Primary label from model: top_wbm_cyc_o
//======================================================================
// Top-level cycle valid passes through from the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_cyc_o == xgate_wbm_bus_wbm_cyc_o);
end


//======================================================================
// Assertions for Signal: top_wbm_adr_o
// Primary label from model: top_wbm_adr_o
//======================================================================
// Top-level master address passes through from the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_adr_o == xgate_wbm_bus_wbm_adr_o);
end


//======================================================================
// Assertions for Signal: top_wbm_dat_o
// Primary label from model: top_wbm_dat_o
//======================================================================
// Top-level master write data passes through from the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_dat_o == xgate_wbm_bus_wbm_dat_o);
end


//======================================================================
// Assertions for Signal: top_wbm_we_o
// Primary label from model: top_wbm_we_o
//======================================================================
// Top-level master write enable passes through from the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_we_o == xgate_wbm_bus_wbm_we_o);
end


//======================================================================
// Assertions for Signal: top_wbm_sel_o
// Primary label from model: top_wbm_sel_o
//======================================================================
// Top-level master byte-lane select passes through from the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_sel_o == xgate_wbm_bus_wbm_sel_o);
end


//======================================================================
// Assertions for Signal: top_wbm_ack_i
// Primary label from model: top_wbm_ack_i
//======================================================================
// Top-level master acknowledge input is distributed unchanged to the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_ack_i == xgate_wbm_bus_wbm_ack_i);
end


//======================================================================
// Assertions for Signal: top_wbm_dat_i
// Primary label from model: top_wbm_dat_i
//======================================================================
// Top-level master read data input is distributed unchanged to the WISHBONE master adaptor
always_comb begin
  assert (top_wbm_dat_i == xgate_wbm_bus_wbm_dat_i);
end


//======================================================================
// Assertions for Signal: top_wbs_ack_o
// Primary label from model: top_wbs_ack_o
//======================================================================
// Top-level slave acknowledge passes through from the WISHBONE slave block
always_comb begin
  assert (top_wbs_ack_o == xgate_wbs_bus_wbs_ack_o);
end


//======================================================================
// Assertions for Signal: top_wbs_err_o
// Primary label from model: top_wbs_err_o
//======================================================================
// Top-level slave error indicator passes through from the WISHBONE slave block
always_comb begin
  assert (top_wbs_err_o == xgate_wbs_bus_wbs_err_o);
end


//======================================================================
// Assertions for Signal: top_wbs_dat_o
// Primary label from model: top_wbs_dat_o
//======================================================================
// Top-level slave read data passes through from the WISHBONE slave block
always_comb begin
  assert (top_wbs_dat_o == xgate_wbs_bus_wbs_dat_o);
end


//======================================================================
// Assertions for Signal: top_wbs_stb_i
// Primary label from model: top_wbs_stb_i
//======================================================================
// WISHBONE protocol: strobe should only be asserted while cycle is valid
always_comb begin
  assert (top_wbs_stb_i -> top_wbs_cyc_i);
end
// Top-level slave strobe input is distributed unchanged to the WISHBONE slave block
always_comb begin
  assert (top_wbs_stb_i == xgate_wbs_bus_wbs_stb_i);
end


//======================================================================
// Assertions for Signal: top_wbs_cyc_i
// Primary label from model: top_wbs_cyc_i
//======================================================================
// Top-level slave cycle input is distributed unchanged to the WISHBONE slave block
always_comb begin
  assert (top_wbs_cyc_i == xgate_wbs_bus_wbs_cyc_i);
end


//======================================================================
// Assertions for Signal: top_wbs_we_i
// Primary label from model: top_wbs_we_i
//======================================================================
// Top-level slave write enable input is distributed unchanged to the WISHBONE slave block
always_comb begin
  assert (top_wbs_we_i == xgate_wbs_bus_wbs_we_i);
end


//======================================================================
// Assertions for Signal: top_wbs_sel_i
// Primary label from model: top_wbs_sel_i
//======================================================================
// Top-level slave byte-lane select input is distributed unchanged to the WISHBONE slave block
always_comb begin
  assert (top_wbs_sel_i == xgate_wbs_bus_wbs_sel_i);
end


//======================================================================
// Assertions for Signal: top_wbs_adr_i
// Primary label from model: top_wbs_adr_i
//======================================================================
// Top-level slave address input is distributed unchanged to the WISHBONE slave block
always_comb begin
  assert (top_wbs_adr_i == xgate_wbs_bus_wbs_adr_i);
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_async_rst_b
// Primary label from model: xgate_wbs_bus_async_rst_b
//======================================================================
// Internal async reset net equals arst_i XOR ARST_LVL; ARST_LVL default is 0
always_comb begin
  assert (xgate_wbs_bus_async_rst_b == top_arst_i);
end


//======================================================================
// Assertions for Signal: xgate_regs_async_rst_b
// Primary label from model: xgate_regs_async_rst_b
//======================================================================
// Internal async reset net equals arst_i XOR ARST_LVL; ARST_LVL default is 0
always_comb begin
  assert (xgate_regs_async_rst_b == top_arst_i);
end


//======================================================================
// Assertions for Signal: xgate_risc_async_rst_b
// Primary label from model: xgate_risc_async_rst_b
//======================================================================
// Internal async reset net equals arst_i XOR ARST_LVL; ARST_LVL default is 0
always_comb begin
  assert (xgate_risc_async_rst_b == top_arst_i);
end


//======================================================================
// Assertions for Signal: xgate_wbm_bus_async_rst_b
// Primary label from model: xgate_wbm_bus_async_rst_b
//======================================================================
// Internal async reset net equals arst_i XOR ARST_LVL; ARST_LVL default is 0
always_comb begin
  assert (xgate_wbm_bus_async_rst_b == top_arst_i);
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgmctl
// Primary label from model: xgate_wbs_bus_write_xgmctl
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert (xgate_wbs_bus_write_xgmctl -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end
// XGMCTL requires a full-word write
always_comb begin
  assert (xgate_wbs_bus_write_xgmctl -> (xgate_wbs_bus_wbs_sel_i == 2'b11));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgswt
// Primary label from model: xgate_wbs_bus_write_xgswt
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert (xgate_wbs_bus_write_xgswt -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end
// XGSWT requires a full-word write
always_comb begin
  assert (xgate_wbs_bus_write_xgswt -> (xgate_wbs_bus_wbs_sel_i == 2'b11));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgsem
// Primary label from model: xgate_wbs_bus_write_xgsem
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert (xgate_wbs_bus_write_xgsem -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end
// XGSEM requires a full-word write
always_comb begin
  assert (xgate_wbs_bus_write_xgsem -> (xgate_wbs_bus_wbs_sel_i == 2'b11));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgvbr
// Primary label from model: xgate_wbs_bus_write_xgvbr
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgvbr != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgchid
// Primary label from model: xgate_wbs_bus_write_xgchid
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert (xgate_wbs_bus_write_xgchid -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgccr
// Primary label from model: xgate_wbs_bus_write_xgccr
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert (xgate_wbs_bus_write_xgccr -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgpc
// Primary label from model: xgate_wbs_bus_write_xgpc
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgpc != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_0
// Primary label from model: xgate_wbs_bus_write_xgif_0
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_0 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_1
// Primary label from model: xgate_wbs_bus_write_xgif_1
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_1 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_2
// Primary label from model: xgate_wbs_bus_write_xgif_2
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_2 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_3
// Primary label from model: xgate_wbs_bus_write_xgif_3
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_3 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_4
// Primary label from model: xgate_wbs_bus_write_xgif_4
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_4 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_5
// Primary label from model: xgate_wbs_bus_write_xgif_5
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_5 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_6
// Primary label from model: xgate_wbs_bus_write_xgif_6
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_6 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgif_7
// Primary label from model: xgate_wbs_bus_write_xgif_7
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgif_7 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr1
// Primary label from model: xgate_wbs_bus_write_xgr1
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr1 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr2
// Primary label from model: xgate_wbs_bus_write_xgr2
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr2 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr3
// Primary label from model: xgate_wbs_bus_write_xgr3
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr3 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr4
// Primary label from model: xgate_wbs_bus_write_xgr4
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr4 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr5
// Primary label from model: xgate_wbs_bus_write_xgr5
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr5 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr6
// Primary label from model: xgate_wbs_bus_write_xgr6
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr6 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_wbs_bus_write_xgr7
// Primary label from model: xgate_wbs_bus_write_xgr7
//======================================================================
// Write strobe must be qualified by we/stb/cyc
always_comb begin
  assert ((xgate_wbs_bus_write_xgr7 != 2'b00) -> (xgate_wbs_bus_wbs_we_i && xgate_wbs_bus_wbs_stb_i && xgate_wbs_bus_wbs_cyc_i));
end


//======================================================================
// Assertions for Signal: xgate_regs_xge
// Primary label from model: xgate_regs_xge
//======================================================================
// Module-enable control is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xge == xgate_risc_xge);
end


//======================================================================
// Assertions for Signal: xgate_regs_xgie
// Primary label from model: xgate_regs_xgie
//======================================================================
// Interrupt-enable control is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xgie == xgate_risc_xgie);
end


//======================================================================
// Assertions for Signal: xgate_regs_xgss
// Primary label from model: xgate_regs_xgss
//======================================================================
// Single-step control is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xgss == xgate_risc_xgss);
end


//======================================================================
// Assertions for Signal: xgate_regs_brk_irq_ena
// Primary label from model: xgate_regs_brk_irq_ena
//======================================================================
// Break-interrupt enable is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_brk_irq_ena == xgate_risc_brk_irq_ena);
end


//======================================================================
// Assertions for Signal: xgate_regs_xgsweif_c
// Primary label from model: xgate_regs_xgsweif_c
//======================================================================
// Software-error clear control is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xgsweif_c == xgate_risc_xgsweif_c);
end


//======================================================================
// Assertions for Signal: xgate_regs_xgdbg_clear
// Primary label from model: xgate_regs_xgdbg_clear
//======================================================================
// Debug clear control is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xgdbg_clear == xgate_risc_xgdbg_clear);
end


//======================================================================
// Assertions for Signal: xgate_regs_xgdbg_set
// Primary label from model: xgate_regs_xgdbg_set
//======================================================================
// Debug set control is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xgdbg_set == xgate_risc_xgdbg_set);
end


//======================================================================
// Assertions for Signal: xgate_regs_debug_ack
// Primary label from model: xgate_regs_debug_ack
//======================================================================
// Debug acknowledge status is shared between regs and RISC core
always_comb begin
  assert (xgate_regs_debug_ack == xgate_risc_debug_ack);
end


//======================================================================
// Assertions for Signal: xgate_regs_xgvbr
// Primary label from model: xgate_regs_xgvbr
//======================================================================
// Vector base address register is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_xgvbr == xgate_risc_xgvbr);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_0
// Primary label from model: xgate_regs_clear_xgif_0
//======================================================================
// Decoded clear control for flag bank 0 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_0 == xgate_risc_clear_xgif_0);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_1
// Primary label from model: xgate_regs_clear_xgif_1
//======================================================================
// Decoded clear control for flag bank 1 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_1 == xgate_risc_clear_xgif_1);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_2
// Primary label from model: xgate_regs_clear_xgif_2
//======================================================================
// Decoded clear control for flag bank 2 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_2 == xgate_risc_clear_xgif_2);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_3
// Primary label from model: xgate_regs_clear_xgif_3
//======================================================================
// Decoded clear control for flag bank 3 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_3 == xgate_risc_clear_xgif_3);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_4
// Primary label from model: xgate_regs_clear_xgif_4
//======================================================================
// Decoded clear control for flag bank 4 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_4 == xgate_risc_clear_xgif_4);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_5
// Primary label from model: xgate_regs_clear_xgif_5
//======================================================================
// Decoded clear control for flag bank 5 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_5 == xgate_risc_clear_xgif_5);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_6
// Primary label from model: xgate_regs_clear_xgif_6
//======================================================================
// Decoded clear control for flag bank 6 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_6 == xgate_risc_clear_xgif_6);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_7
// Primary label from model: xgate_regs_clear_xgif_7
//======================================================================
// Decoded clear control for flag bank 7 is forwarded unchanged to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_7 == xgate_risc_clear_xgif_7);
end


//======================================================================
// Assertions for Signal: xgate_regs_clear_xgif_data
// Primary label from model: xgate_regs_clear_xgif_data
//======================================================================
// Decoded clear data is forwarded unchanged from regs to the RISC core
always_comb begin
  assert (xgate_regs_clear_xgif_data == xgate_risc_clear_xgif_data);
end


//======================================================================
// Assertions for Signal: xgate_wbm_bus_xge
// Primary label from model: xgate_wbm_bus_xge
//======================================================================
// Module-enable control is shared between regs and the WISHBONE master adaptor
always_comb begin
  assert (xgate_wbm_bus_xge == xgate_regs_xge);
end


//======================================================================
// Assertions for Signal: xgate_risc_mem_access
// Primary label from model: xgate_risc_mem_access
//======================================================================
// Memory access request from RISC is forwarded unchanged to the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_mem_access == xgate_wbm_bus_mem_access);
end
// Memory access request should result in a WISHBONE strobe
always_comb begin
  assert (xgate_risc_mem_access -> xgate_wbm_bus_wbm_stb_o);
end


//======================================================================
// Assertions for Signal: xgate_risc_xgate_address
// Primary label from model: xgate_risc_xgate_address
//======================================================================
// RISC-driven memory address is forwarded unchanged to the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_xgate_address == xgate_wbm_bus_xgate_address);
end


//======================================================================
// Assertions for Signal: xgate_risc_write_mem_strb_h
// Primary label from model: xgate_risc_write_mem_strb_h
//======================================================================
// High-byte write strobe is forwarded unchanged to the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_write_mem_strb_h == xgate_wbm_bus_write_mem_strb_h);
end


//======================================================================
// Assertions for Signal: xgate_risc_write_mem_strb_l
// Primary label from model: xgate_risc_write_mem_strb_l
//======================================================================
// Low-byte write strobe is forwarded unchanged to the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_write_mem_strb_l == xgate_wbm_bus_write_mem_strb_l);
end


//======================================================================
// Assertions for Signal: xgate_risc_mem_req_ack
// Primary label from model: xgate_risc_mem_req_ack
//======================================================================
// Memory request acknowledge is forwarded unchanged from the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_mem_req_ack == xgate_wbm_bus_mem_req_ack);
end
// Memory request acknowledge is synchronized with the WISHBONE master acknowledge
always_comb begin
  assert (xgate_risc_mem_req_ack -> top_wbm_ack_i);
end


//======================================================================
// Assertions for Signal: xgate_risc_single_step
// Primary label from model: xgate_risc_single_step
//======================================================================
// Single-step control is forwarded unchanged to the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_single_step == xgate_wbm_bus_single_step);
end


//======================================================================
// Assertions for Signal: xgate_risc_ss_mem_ack
// Primary label from model: xgate_risc_ss_mem_ack
//======================================================================
// Single-step memory acknowledge is forwarded unchanged from the WISHBONE master adaptor
always_comb begin
  assert (xgate_risc_ss_mem_ack == xgate_wbm_bus_ss_mem_ack);
end
// Single-step memory acknowledge is synchronized with the WISHBONE master acknowledge
always_comb begin
  assert (xgate_risc_ss_mem_ack -> top_wbm_ack_i);
end
endmodule

