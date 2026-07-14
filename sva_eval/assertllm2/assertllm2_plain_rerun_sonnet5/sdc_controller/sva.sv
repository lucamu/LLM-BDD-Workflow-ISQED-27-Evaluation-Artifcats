`include "sd_defines.v"

// method: plain_prompt

// Global checker bound to top module: sdc_controller
module sdc_controller_sva_global (
    input logic sd_bd_a_cmp,
    input logic sd_bd_clk,
    input logic [`RAM_MEM_WIDTH-1:0] sd_bd_dat_in_m,
    input logic [`BD_WIDTH-1 :0] sd_bd_free_bd,
    input logic sd_bd_re_s,
    input logic sd_bd_rst,
    input logic sd_bd_we_m,
    input logic sd_cmd_master_CLK_PAD_IO,
    input logic [4:0] sd_cmd_master_ERR_INT_REG,
    input logic sd_cmd_master_ERR_INT_RST,
    input logic [15:0] sd_cmd_master_NORMAL_INT_REG,
    input logic sd_cmd_master_NORMAL_INT_RST,
    input logic sd_cmd_master_New_CMD,
    input logic [31:0] sd_cmd_master_RESP_1_REG,
    input logic sd_cmd_master_RST_PAD_I,
    input logic [15:0] sd_cmd_master_STATUS_REG,
    input logic [15:0] sd_cmd_master_TIMEOUT_REG,
    input logic sd_cmd_master_ack_in,
    input logic sd_cmd_master_card_detect,
    input logic [39:0] sd_cmd_master_cmd_in,
    input logic [39:0] sd_cmd_master_cmd_out,
    input logic sd_cmd_master_data_read,
    input logic sd_cmd_master_data_write,
    input logic sd_cmd_master_req_in,
    input logic [7:0] sd_cmd_master_serial_status,
    input logic [15:0] sd_cmd_master_settings,
    input logic sd_cmd_serial_host_ACK_IN,
    input logic sd_cmd_serial_host_ACK_OUT,
    input logic [39:0] sd_cmd_serial_host_CMD_IN,
    input logic [39:0] sd_cmd_serial_host_CMD_OUT,
    input logic sd_cmd_serial_host_REQ_IN,
    input logic sd_cmd_serial_host_REQ_OUT,
    input logic sd_cmd_serial_host_RST_IN,
    input logic sd_cmd_serial_host_SD_CLK_IN,
    input logic [15:0] sd_cmd_serial_host_SETTING_IN,
    input logic [7:0] sd_cmd_serial_host_STATUS,
    input logic sd_cmd_serial_host_cmd_dat_i,
    input logic [1:0] sd_cmd_serial_host_st_dat_t,
    input logic [15:0] sd_controller_wb_Bd_Status_reg,
    input logic [7:0] sd_controller_wb_Bd_isr_enable_reg,
    input logic [7:0] sd_controller_wb_Bd_isr_reg,
    input logic [31:0] sd_controller_wb_argument_reg,
    input logic [7:0] sd_controller_wb_clock_divider,
    input logic [31:0] sd_controller_wb_cmd_arg_s,
    input logic [31:0] sd_controller_wb_cmd_resp_1,
    input logic [15:0] sd_controller_wb_cmd_set_s,
    input logic [15:0] sd_controller_wb_cmd_setting_reg,
    input logic [`RAM_MEM_WIDTH-1:0] sd_controller_wb_dat_in_m_rx_bd,
    input logic [`RAM_MEM_WIDTH-1:0] sd_controller_wb_dat_in_m_tx_bd,
    input logic [7:0] sd_controller_wb_software_reset_reg,
    input logic [15:0] sd_controller_wb_status_reg,
    input logic [15:0] sd_controller_wb_time_out_reg,
    input logic sd_controller_wb_wb_ack_o,
    input logic [7:0] sd_controller_wb_wb_adr_i,
    input logic sd_controller_wb_wb_clk_i,
    input logic sd_controller_wb_wb_cyc_i,
    input logic [31:0] sd_controller_wb_wb_dat_i,
    input logic [31:0] sd_controller_wb_wb_dat_o,
    input logic sd_controller_wb_wb_rst_i,
    input logic [3:0] sd_controller_wb_wb_sel_i,
    input logic sd_controller_wb_wb_stb_i,
    input logic sd_controller_wb_wb_we_i,
    input logic sd_controller_wb_write_req_s,
    input logic sd_data_master_CIDAT,
    input logic [7:0] sd_data_master_Dat_Int_Status,
    input logic sd_data_master_Dat_Int_Status_rst,
    input logic sd_data_master_ack_i_s_rx,
    input logic sd_data_master_ack_i_s_tx,
    input logic sd_data_master_busy_n,
    input logic [4:0] sd_data_master_card_status,
    input logic sd_data_master_clk,
    input logic [31:0] sd_data_master_cmd_arg,
    input logic sd_data_master_cmd_busy,
    input logic [15:0] sd_data_master_cmd_set,
    input logic sd_data_master_cmd_tsf_err,
    input logic sd_data_master_crc_ok,
    input logic [`RAM_MEM_WIDTH-1:0] sd_data_master_dat_in_rx,
    input logic [`RAM_MEM_WIDTH-1:0] sd_data_master_dat_in_tx,
    input logic [`BD_WIDTH-1:0] sd_data_master_free_rx_bd,
    input logic [`BD_WIDTH-1:0] sd_data_master_free_tx_bd,
    input logic sd_data_master_rst,
    input logic sd_data_master_rx_full,
    input logic [31:0] sd_data_master_sys_adr,
    input logic [1:0] sd_data_master_transfer_type,
    input logic sd_data_master_transm_complete,
    input logic sd_data_master_tx_empt,
    input logic sd_data_master_tx_full,
    input logic sd_data_master_we_ack,
    input logic [`SD_BUS_W-1:0] sd_data_serial_host_DAT_dat_i,
    input logic sd_data_serial_host_ack_transfer,
    input logic [31:0] sd_data_serial_host_data_in,
    input logic [`SD_BUS_W-1:0] sd_data_serial_host_data_out,
    input logic sd_data_serial_host_rst,
    input logic sd_data_serial_host_sd_clk,
    input logic [1:0] sd_data_serial_host_start_dat,
    input logic [31:0] sd_fifo_rx_filler_adr,
    input logic sd_fifo_rx_filler_clk,
    input logic [`SD_BUS_W-1:0] sd_fifo_rx_filler_dat_i,
    input logic sd_fifo_rx_filler_en,
    input logic sd_fifo_rx_filler_full,
    input logic sd_fifo_rx_filler_m_wb_ack_i,
    input logic [31:0] sd_fifo_rx_filler_m_wb_adr_o,
    input logic [1:0] sd_fifo_rx_filler_m_wb_bte_o,
    input logic [2:0] sd_fifo_rx_filler_m_wb_cti_o,
    input logic sd_fifo_rx_filler_m_wb_cyc_o,
    input logic [31:0] sd_fifo_rx_filler_m_wb_dat_o,
    input logic sd_fifo_rx_filler_m_wb_stb_o,
    input logic sd_fifo_rx_filler_m_wb_we_o,
    input logic sd_fifo_rx_filler_rst,
    input logic sd_fifo_rx_filler_sd_clk,
    input logic sd_fifo_rx_filler_wr,
    input logic [31:0] sd_fifo_tx_filler_adr,
    input logic sd_fifo_tx_filler_clk,
    input logic [31:0] sd_fifo_tx_filler_dat_o,
    input logic sd_fifo_tx_filler_empty,
    input logic sd_fifo_tx_filler_en,
    input logic sd_fifo_tx_filler_fe,
    input logic sd_fifo_tx_filler_m_wb_ack_i,
    input logic [31:0] sd_fifo_tx_filler_m_wb_adr_o,
    input logic [1:0] sd_fifo_tx_filler_m_wb_bte_o,
    input logic [2:0] sd_fifo_tx_filler_m_wb_cti_o,
    input logic sd_fifo_tx_filler_m_wb_cyc_o,
    input logic [31:0] sd_fifo_tx_filler_m_wb_dat_i,
    input logic sd_fifo_tx_filler_m_wb_stb_o,
    input logic sd_fifo_tx_filler_m_wb_we_o,
    input logic sd_fifo_tx_filler_rd,
    input logic sd_fifo_tx_filler_rst,
    input logic sd_fifo_tx_filler_sd_clk,
    input logic [15:0] top_Bd_Status_reg,
    input logic [7:0] top_Bd_isr_reg,
    input logic [7:0] top_bd_int_st_w,
    input logic top_card_detect,
    input logic top_cidat_w,
    input logic top_cmd_busy,
    input logic [31:0] top_cmd_resp_1,
    input logic [31:0] top_cmd_resp_1_w,
    input logic [`BD_WIDTH-1 :0] top_free_bd_rx_bd,
    input logic [`BD_WIDTH-1 :0] top_free_bd_tx_bd,
    input logic top_m_wb_ack_i,
    input logic [31:0] top_m_wb_adr_o,
    input logic [31:0] top_m_wb_adr_o_rx,
    input logic [31:0] top_m_wb_adr_o_tx,
    input logic [1:0] top_m_wb_bte_o,
    input logic top_m_wb_bte_o_rx,
    input logic top_m_wb_bte_o_tx,
    input logic [2:0] top_m_wb_cti_o,
    input logic top_m_wb_cti_o_rx,
    input logic top_m_wb_cti_o_tx,
    input logic top_m_wb_cyc_o,
    input logic top_m_wb_cyc_o_rx,
    input logic top_m_wb_cyc_o_tx,
    input logic [31:0] top_m_wb_dat_i,
    input logic [31:0] top_m_wb_dat_o,
    input logic [3:0] top_m_wb_sel_o,
    input logic top_m_wb_stb_o,
    input logic top_m_wb_stb_o_rx,
    input logic top_m_wb_stb_o_tx,
    input logic top_m_wb_we_o,
    input logic top_m_wb_we_o_rx,
    input logic top_m_wb_we_o_tx,
    input logic [15:0] top_normal_int_status_reg,
    input logic top_sd_clk_o,
    input logic top_sd_clk_o_pad,
    input logic [3:0] top_sd_dat_dat_i,
    input logic [3:0] top_sd_dat_out_o,
    input logic top_start_rx_fifo,
    input logic top_start_tx_fifo,
    input logic [15:0] top_status_reg,
    input logic [15:0] top_status_reg_w,
    input logic top_wb_ack_o,
    input logic [7:0] top_wb_adr_i,
    input logic top_wb_clk_i,
    input logic top_wb_cyc_i,
    input logic [31:0] top_wb_dat_i,
    input logic [31:0] top_wb_dat_o,
    input logic top_wb_rst_i,
    input logic [3:0] top_wb_sel_i,
    input logic top_wb_stb_i,
    input logic top_wb_we_i
);

//======================================================================
// Assertions for Signal: top_m_wb_cyc_o
// Primary label from model: top_m_wb_cyc_o
//======================================================================
// Master WB cycle output must reflect tx fifo cycle when tx fifo is selected
always_comb begin
  assert (top_start_tx_fifo -> (top_m_wb_cyc_o == top_m_wb_cyc_o_tx));
end

// Master WB cycle output must reflect rx fifo cycle when rx fifo is selected and tx not selected
always_comb begin
  assert ((!top_start_tx_fifo && top_start_rx_fifo) -> (top_m_wb_cyc_o == top_m_wb_cyc_o_rx));
end

// Master WB cycle output must be deasserted when neither fifo is selected
always_comb begin
  assert ((!top_start_tx_fifo && !top_start_rx_fifo) -> (top_m_wb_cyc_o == 1'b0));
end


//======================================================================
// Assertions for Signal: top_m_wb_stb_o
// Primary label from model: top_m_wb_stb_o
//======================================================================
// Master WB strobe output must reflect tx fifo strobe when tx fifo is selected
always_comb begin
  assert (top_start_tx_fifo -> (top_m_wb_stb_o == top_m_wb_stb_o_tx));
end

// Master WB strobe output must reflect rx fifo strobe when rx fifo is selected and tx not selected
always_comb begin
  assert ((!top_start_tx_fifo && top_start_rx_fifo) -> (top_m_wb_stb_o == top_m_wb_stb_o_rx));
end

// Master WB strobe output must be deasserted when neither fifo is selected
always_comb begin
  assert ((!top_start_tx_fifo && !top_start_rx_fifo) -> (top_m_wb_stb_o == 1'b0));
end


//======================================================================
// Assertions for Signal: top_m_wb_we_o
// Primary label from model: top_m_wb_we_o
//======================================================================
// Master WB write-enable output must reflect tx fifo write-enable when tx fifo is selected
always_comb begin
  assert (top_start_tx_fifo -> (top_m_wb_we_o == top_m_wb_we_o_tx));
end

// Master WB write-enable output must reflect rx fifo write-enable when rx fifo is selected and tx not selected
always_comb begin
  assert ((!top_start_tx_fifo && top_start_rx_fifo) -> (top_m_wb_we_o == top_m_wb_we_o_rx));
end

// Master WB write-enable output must be deasserted when neither fifo is selected
always_comb begin
  assert ((!top_start_tx_fifo && !top_start_rx_fifo) -> (top_m_wb_we_o == 1'b0));
end


//======================================================================
// Assertions for Signal: top_m_wb_adr_o
// Primary label from model: top_m_wb_adr_o
//======================================================================
// Master WB address output must reflect tx fifo address when tx fifo is selected
always_comb begin
  assert (top_start_tx_fifo -> (top_m_wb_adr_o == top_m_wb_adr_o_tx));
end

// Master WB address output must reflect rx fifo address when rx fifo is selected and tx not selected
always_comb begin
  assert ((!top_start_tx_fifo && top_start_rx_fifo) -> (top_m_wb_adr_o == top_m_wb_adr_o_rx));
end

// Master WB address output must be zero when neither fifo is selected
always_comb begin
  assert ((!top_start_tx_fifo && !top_start_rx_fifo) -> (top_m_wb_adr_o == 32'h0));
end


//======================================================================
// Assertions for Signal: top_m_wb_sel_o
// Primary label from model: top_m_wb_sel_o
//======================================================================
// Master WB byte select is always fully enabled (all 4 bytes valid)
always_comb begin
  assert (top_m_wb_sel_o == 4'b1111);
end


//======================================================================
// Assertions for Signal: top_wb_ack_o
// Primary label from model: top_wb_ack_o
//======================================================================
// Slave WISHBONE acknowledge must only be asserted during an active cycle with strobe
always_comb begin
  assert (top_wb_ack_o -> (top_wb_cyc_i && top_wb_stb_i));
end


//======================================================================
// Assertions for Signal: top_status_reg_w
// Primary label from model: top_status_reg_w
//======================================================================
// Status register bit 1 reflects the CRC interrupt data status (cidat_w)
always_comb begin
  assert (top_status_reg_w[1] == top_cidat_w);
end

// Status register bit 0 is forced to 1 when command bus access is busy, otherwise holds prior value
always_comb begin
  assert (top_status_reg_w[0] == (top_cmd_busy ? 1'b1 : top_status_reg[0]));
end


//======================================================================
// Assertions for Signal: top_Bd_Status_reg
// Primary label from model: top_Bd_Status_reg
//======================================================================
// Lower field of BD status register reflects free Tx buffer descriptor count
always_comb begin
  assert (top_Bd_Status_reg[0] == top_free_bd_tx_bd);
end

// Upper field of BD status register reflects free Rx buffer descriptor count
always_comb begin
  assert (top_Bd_Status_reg[8] == top_free_bd_rx_bd);
end


//======================================================================
// Assertions for Signal: top_normal_int_status_reg
// Primary label from model: top_normal_int_status_reg
//======================================================================
// Normal interrupt status register is driven from the cmd master normal interrupt register
always_comb begin
  assert (top_normal_int_status_reg == sd_cmd_master_NORMAL_INT_REG);
end


//======================================================================
// Assertions for Signal: top_Bd_isr_reg
// Primary label from model: top_Bd_isr_reg
//======================================================================
// Data interrupt status register (Bd_isr_reg) reflects the data master's interrupt status output
always_comb begin
  assert (top_Bd_isr_reg == sd_data_master_Dat_Int_Status);
end


//======================================================================
// Assertions for Signal: top_cmd_resp_1
// Primary label from model: top_cmd_resp_1
//======================================================================
// Command response register output reflects the internally computed response value
always_comb begin
  assert (top_cmd_resp_1 == top_cmd_resp_1_w);
end


//======================================================================
// Assertions for Signal: top_card_detect
// Primary label from model: top_card_detect
//======================================================================
// Top-level card detect input is forwarded unchanged to the command master module
always_comb begin
  assert (top_card_detect == sd_cmd_master_card_detect);
end
endmodule

