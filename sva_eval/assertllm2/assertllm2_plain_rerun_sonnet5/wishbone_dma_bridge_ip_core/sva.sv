`include "wb_dma_defines.v"

// method: plain_prompt

// Global checker bound to top module: wb_dma_top
module wb_dma_top_sva_global (
    input logic top_clk_i,
    input logic [30:0] top_dma_ack,
    input logic top_dma_ack_o,
    input logic [30:0] top_dma_nd,
    input logic top_dma_nd_i,
    input logic [30:0] top_dma_req,
    input logic top_dma_req_i,
    input logic [30:0] top_dma_rest,
    input logic top_dma_rest_i,
    input logic top_inta_o,
    input logic top_intb_o,
    input logic [70:0] top_mast0_pt_in,
    input logic [34:0] top_mast0_pt_out,
    input logic [70:0] top_mast1_pt_in,
    input logic [34:0] top_mast1_pt_out,
    input logic top_pt0_sel_i,
    input logic top_pt0_sel_o,
    input logic top_pt1_sel_i,
    input logic top_pt1_sel_o,
    input logic top_rst_i,
    input logic [34:0] top_slv0_pt_in,
    input logic [70:0] top_slv0_pt_out,
    input logic [34:0] top_slv1_pt_in,
    input logic [70:0] top_slv1_pt_out,
    input logic top_wb0_ack_i,
    input logic top_wb0_ack_o,
    input logic [31:0] top_wb0_addr_i,
    input logic [31:0] top_wb0_addr_o,
    input logic top_wb0_cyc_i,
    input logic top_wb0_cyc_o,
    input logic top_wb0_err_i,
    input logic top_wb0_err_o,
    input logic top_wb0_rty_i,
    input logic top_wb0_rty_o,
    input logic [3:0] top_wb0_sel_i,
    input logic [3:0] top_wb0_sel_o,
    input logic top_wb0_stb_i,
    input logic top_wb0_stb_o,
    input logic top_wb0_we_i,
    input logic top_wb0_we_o,
    input logic [31:0] top_wb0m_data_i,
    input logic [31:0] top_wb0m_data_o,
    input logic [31:0] top_wb0s_data_i,
    input logic [31:0] top_wb0s_data_o,
    input logic top_wb1_ack_i,
    input logic top_wb1_ack_o,
    input logic [31:0] top_wb1_addr_i,
    input logic [31:0] top_wb1_addr_o,
    input logic top_wb1_cyc_i,
    input logic top_wb1_cyc_o,
    input logic top_wb1_err_i,
    input logic top_wb1_err_o,
    input logic top_wb1_rty_i,
    input logic top_wb1_rty_o,
    input logic [3:0] top_wb1_sel_i,
    input logic [3:0] top_wb1_sel_o,
    input logic top_wb1_stb_i,
    input logic top_wb1_stb_o,
    input logic top_wb1_we_i,
    input logic top_wb1_we_o,
    input logic [31:0] top_wb1m_data_i,
    input logic [31:0] top_wb1m_data_o,
    input logic [31:0] top_wb1s_data_i,
    input logic [31:0] top_wb1s_data_o,
    input logic [30:0] wb_dma_ch_sel_ack_o,
    input logic [31:0] wb_dma_ch_sel_adr0,
    input logic [31:0] wb_dma_ch_sel_adr1,
    input logic [31:0] wb_dma_ch_sel_am0,
    input logic [31:0] wb_dma_ch_sel_am1,
    input logic [31:0] wb_dma_ch_sel_ch0_adr0,
    input logic [31:0] wb_dma_ch_sel_ch0_adr1,
    input logic [31:0] wb_dma_ch_sel_ch0_am0,
    input logic [31:0] wb_dma_ch_sel_ch0_am1,
    input logic [31:0] wb_dma_ch_sel_ch0_csr,
    input logic [31:0] wb_dma_ch_sel_ch0_txsz,
    input logic [31:0] wb_dma_ch_sel_ch10_adr0,
    input logic [31:0] wb_dma_ch_sel_ch10_adr1,
    input logic [31:0] wb_dma_ch_sel_ch10_am0,
    input logic [31:0] wb_dma_ch_sel_ch10_am1,
    input logic [31:0] wb_dma_ch_sel_ch10_csr,
    input logic [31:0] wb_dma_ch_sel_ch10_txsz,
    input logic [31:0] wb_dma_ch_sel_ch11_adr0,
    input logic [31:0] wb_dma_ch_sel_ch11_adr1,
    input logic [31:0] wb_dma_ch_sel_ch11_am0,
    input logic [31:0] wb_dma_ch_sel_ch11_am1,
    input logic [31:0] wb_dma_ch_sel_ch11_csr,
    input logic [31:0] wb_dma_ch_sel_ch11_txsz,
    input logic [31:0] wb_dma_ch_sel_ch12_adr0,
    input logic [31:0] wb_dma_ch_sel_ch12_adr1,
    input logic [31:0] wb_dma_ch_sel_ch12_am0,
    input logic [31:0] wb_dma_ch_sel_ch12_am1,
    input logic [31:0] wb_dma_ch_sel_ch12_csr,
    input logic [31:0] wb_dma_ch_sel_ch12_txsz,
    input logic [31:0] wb_dma_ch_sel_ch13_adr0,
    input logic [31:0] wb_dma_ch_sel_ch13_adr1,
    input logic [31:0] wb_dma_ch_sel_ch13_am0,
    input logic [31:0] wb_dma_ch_sel_ch13_am1,
    input logic [31:0] wb_dma_ch_sel_ch13_csr,
    input logic [31:0] wb_dma_ch_sel_ch13_txsz,
    input logic [31:0] wb_dma_ch_sel_ch14_adr0,
    input logic [31:0] wb_dma_ch_sel_ch14_adr1,
    input logic [31:0] wb_dma_ch_sel_ch14_am0,
    input logic [31:0] wb_dma_ch_sel_ch14_am1,
    input logic [31:0] wb_dma_ch_sel_ch14_csr,
    input logic [31:0] wb_dma_ch_sel_ch14_txsz,
    input logic [31:0] wb_dma_ch_sel_ch15_adr0,
    input logic [31:0] wb_dma_ch_sel_ch15_adr1,
    input logic [31:0] wb_dma_ch_sel_ch15_am0,
    input logic [31:0] wb_dma_ch_sel_ch15_am1,
    input logic [31:0] wb_dma_ch_sel_ch15_csr,
    input logic [31:0] wb_dma_ch_sel_ch15_txsz,
    input logic [31:0] wb_dma_ch_sel_ch16_adr0,
    input logic [31:0] wb_dma_ch_sel_ch16_adr1,
    input logic [31:0] wb_dma_ch_sel_ch16_am0,
    input logic [31:0] wb_dma_ch_sel_ch16_am1,
    input logic [31:0] wb_dma_ch_sel_ch16_csr,
    input logic [31:0] wb_dma_ch_sel_ch16_txsz,
    input logic [31:0] wb_dma_ch_sel_ch17_adr0,
    input logic [31:0] wb_dma_ch_sel_ch17_adr1,
    input logic [31:0] wb_dma_ch_sel_ch17_am0,
    input logic [31:0] wb_dma_ch_sel_ch17_am1,
    input logic [31:0] wb_dma_ch_sel_ch17_csr,
    input logic [31:0] wb_dma_ch_sel_ch17_txsz,
    input logic [31:0] wb_dma_ch_sel_ch18_adr0,
    input logic [31:0] wb_dma_ch_sel_ch18_adr1,
    input logic [31:0] wb_dma_ch_sel_ch18_am0,
    input logic [31:0] wb_dma_ch_sel_ch18_am1,
    input logic [31:0] wb_dma_ch_sel_ch18_csr,
    input logic [31:0] wb_dma_ch_sel_ch18_txsz,
    input logic [31:0] wb_dma_ch_sel_ch19_adr0,
    input logic [31:0] wb_dma_ch_sel_ch19_adr1,
    input logic [31:0] wb_dma_ch_sel_ch19_am0,
    input logic [31:0] wb_dma_ch_sel_ch19_am1,
    input logic [31:0] wb_dma_ch_sel_ch19_csr,
    input logic [31:0] wb_dma_ch_sel_ch19_txsz,
    input logic [31:0] wb_dma_ch_sel_ch1_adr0,
    input logic [31:0] wb_dma_ch_sel_ch1_adr1,
    input logic [31:0] wb_dma_ch_sel_ch1_am0,
    input logic [31:0] wb_dma_ch_sel_ch1_am1,
    input logic [31:0] wb_dma_ch_sel_ch1_csr,
    input logic [31:0] wb_dma_ch_sel_ch1_txsz,
    input logic [31:0] wb_dma_ch_sel_ch20_adr0,
    input logic [31:0] wb_dma_ch_sel_ch20_adr1,
    input logic [31:0] wb_dma_ch_sel_ch20_am0,
    input logic [31:0] wb_dma_ch_sel_ch20_am1,
    input logic [31:0] wb_dma_ch_sel_ch20_csr,
    input logic [31:0] wb_dma_ch_sel_ch20_txsz,
    input logic [31:0] wb_dma_ch_sel_ch21_adr0,
    input logic [31:0] wb_dma_ch_sel_ch21_adr1,
    input logic [31:0] wb_dma_ch_sel_ch21_am0,
    input logic [31:0] wb_dma_ch_sel_ch21_am1,
    input logic [31:0] wb_dma_ch_sel_ch21_csr,
    input logic [31:0] wb_dma_ch_sel_ch21_txsz,
    input logic [31:0] wb_dma_ch_sel_ch22_adr0,
    input logic [31:0] wb_dma_ch_sel_ch22_adr1,
    input logic [31:0] wb_dma_ch_sel_ch22_am0,
    input logic [31:0] wb_dma_ch_sel_ch22_am1,
    input logic [31:0] wb_dma_ch_sel_ch22_csr,
    input logic [31:0] wb_dma_ch_sel_ch22_txsz,
    input logic [31:0] wb_dma_ch_sel_ch23_adr0,
    input logic [31:0] wb_dma_ch_sel_ch23_adr1,
    input logic [31:0] wb_dma_ch_sel_ch23_am0,
    input logic [31:0] wb_dma_ch_sel_ch23_am1,
    input logic [31:0] wb_dma_ch_sel_ch23_csr,
    input logic [31:0] wb_dma_ch_sel_ch23_txsz,
    input logic [31:0] wb_dma_ch_sel_ch24_adr0,
    input logic [31:0] wb_dma_ch_sel_ch24_adr1,
    input logic [31:0] wb_dma_ch_sel_ch24_am0,
    input logic [31:0] wb_dma_ch_sel_ch24_am1,
    input logic [31:0] wb_dma_ch_sel_ch24_csr,
    input logic [31:0] wb_dma_ch_sel_ch24_txsz,
    input logic [31:0] wb_dma_ch_sel_ch25_adr0,
    input logic [31:0] wb_dma_ch_sel_ch25_adr1,
    input logic [31:0] wb_dma_ch_sel_ch25_am0,
    input logic [31:0] wb_dma_ch_sel_ch25_am1,
    input logic [31:0] wb_dma_ch_sel_ch25_csr,
    input logic [31:0] wb_dma_ch_sel_ch25_txsz,
    input logic [31:0] wb_dma_ch_sel_ch26_adr0,
    input logic [31:0] wb_dma_ch_sel_ch26_adr1,
    input logic [31:0] wb_dma_ch_sel_ch26_am0,
    input logic [31:0] wb_dma_ch_sel_ch26_am1,
    input logic [31:0] wb_dma_ch_sel_ch26_csr,
    input logic [31:0] wb_dma_ch_sel_ch26_txsz,
    input logic [31:0] wb_dma_ch_sel_ch27_adr0,
    input logic [31:0] wb_dma_ch_sel_ch27_adr1,
    input logic [31:0] wb_dma_ch_sel_ch27_am0,
    input logic [31:0] wb_dma_ch_sel_ch27_am1,
    input logic [31:0] wb_dma_ch_sel_ch27_csr,
    input logic [31:0] wb_dma_ch_sel_ch27_txsz,
    input logic [31:0] wb_dma_ch_sel_ch28_adr0,
    input logic [31:0] wb_dma_ch_sel_ch28_adr1,
    input logic [31:0] wb_dma_ch_sel_ch28_am0,
    input logic [31:0] wb_dma_ch_sel_ch28_am1,
    input logic [31:0] wb_dma_ch_sel_ch28_csr,
    input logic [31:0] wb_dma_ch_sel_ch28_txsz,
    input logic [31:0] wb_dma_ch_sel_ch29_adr0,
    input logic [31:0] wb_dma_ch_sel_ch29_adr1,
    input logic [31:0] wb_dma_ch_sel_ch29_am0,
    input logic [31:0] wb_dma_ch_sel_ch29_am1,
    input logic [31:0] wb_dma_ch_sel_ch29_csr,
    input logic [31:0] wb_dma_ch_sel_ch29_txsz,
    input logic [31:0] wb_dma_ch_sel_ch2_adr0,
    input logic [31:0] wb_dma_ch_sel_ch2_adr1,
    input logic [31:0] wb_dma_ch_sel_ch2_am0,
    input logic [31:0] wb_dma_ch_sel_ch2_am1,
    input logic [31:0] wb_dma_ch_sel_ch2_csr,
    input logic [31:0] wb_dma_ch_sel_ch2_txsz,
    input logic [31:0] wb_dma_ch_sel_ch30_adr0,
    input logic [31:0] wb_dma_ch_sel_ch30_adr1,
    input logic [31:0] wb_dma_ch_sel_ch30_am0,
    input logic [31:0] wb_dma_ch_sel_ch30_am1,
    input logic [31:0] wb_dma_ch_sel_ch30_csr,
    input logic [31:0] wb_dma_ch_sel_ch30_txsz,
    input logic [31:0] wb_dma_ch_sel_ch3_adr0,
    input logic [31:0] wb_dma_ch_sel_ch3_adr1,
    input logic [31:0] wb_dma_ch_sel_ch3_am0,
    input logic [31:0] wb_dma_ch_sel_ch3_am1,
    input logic [31:0] wb_dma_ch_sel_ch3_csr,
    input logic [31:0] wb_dma_ch_sel_ch3_txsz,
    input logic [31:0] wb_dma_ch_sel_ch4_adr0,
    input logic [31:0] wb_dma_ch_sel_ch4_adr1,
    input logic [31:0] wb_dma_ch_sel_ch4_am0,
    input logic [31:0] wb_dma_ch_sel_ch4_am1,
    input logic [31:0] wb_dma_ch_sel_ch4_csr,
    input logic [31:0] wb_dma_ch_sel_ch4_txsz,
    input logic [31:0] wb_dma_ch_sel_ch5_adr0,
    input logic [31:0] wb_dma_ch_sel_ch5_adr1,
    input logic [31:0] wb_dma_ch_sel_ch5_am0,
    input logic [31:0] wb_dma_ch_sel_ch5_am1,
    input logic [31:0] wb_dma_ch_sel_ch5_csr,
    input logic [31:0] wb_dma_ch_sel_ch5_txsz,
    input logic [31:0] wb_dma_ch_sel_ch6_adr0,
    input logic [31:0] wb_dma_ch_sel_ch6_adr1,
    input logic [31:0] wb_dma_ch_sel_ch6_am0,
    input logic [31:0] wb_dma_ch_sel_ch6_am1,
    input logic [31:0] wb_dma_ch_sel_ch6_csr,
    input logic [31:0] wb_dma_ch_sel_ch6_txsz,
    input logic [31:0] wb_dma_ch_sel_ch7_adr0,
    input logic [31:0] wb_dma_ch_sel_ch7_adr1,
    input logic [31:0] wb_dma_ch_sel_ch7_am0,
    input logic [31:0] wb_dma_ch_sel_ch7_am1,
    input logic [31:0] wb_dma_ch_sel_ch7_csr,
    input logic [31:0] wb_dma_ch_sel_ch7_txsz,
    input logic [31:0] wb_dma_ch_sel_ch8_adr0,
    input logic [31:0] wb_dma_ch_sel_ch8_adr1,
    input logic [31:0] wb_dma_ch_sel_ch8_am0,
    input logic [31:0] wb_dma_ch_sel_ch8_am1,
    input logic [31:0] wb_dma_ch_sel_ch8_csr,
    input logic [31:0] wb_dma_ch_sel_ch8_txsz,
    input logic [31:0] wb_dma_ch_sel_ch9_adr0,
    input logic [31:0] wb_dma_ch_sel_ch9_adr1,
    input logic [31:0] wb_dma_ch_sel_ch9_am0,
    input logic [31:0] wb_dma_ch_sel_ch9_am1,
    input logic [31:0] wb_dma_ch_sel_ch9_csr,
    input logic [31:0] wb_dma_ch_sel_ch9_txsz,
    input logic [4:0] wb_dma_ch_sel_ch_sel,
    input logic wb_dma_ch_sel_clk,
    input logic [31:0] wb_dma_ch_sel_csr,
    input logic wb_dma_ch_sel_de_ack,
    input logic wb_dma_ch_sel_de_start,
    input logic wb_dma_ch_sel_dma_busy,
    input logic [30:0] wb_dma_ch_sel_nd_i,
    input logic [30:0] wb_dma_ch_sel_ndnr,
    input logic wb_dma_ch_sel_ndr,
    input logic wb_dma_ch_sel_next_ch,
    input logic [31:0] wb_dma_ch_sel_pointer,
    input logic [31:0] wb_dma_ch_sel_pointer0,
    input logic [31:0] wb_dma_ch_sel_pointer0_s,
    input logic [31:0] wb_dma_ch_sel_pointer1,
    input logic [31:0] wb_dma_ch_sel_pointer10,
    input logic [31:0] wb_dma_ch_sel_pointer10_s,
    input logic [31:0] wb_dma_ch_sel_pointer11,
    input logic [31:0] wb_dma_ch_sel_pointer11_s,
    input logic [31:0] wb_dma_ch_sel_pointer12,
    input logic [31:0] wb_dma_ch_sel_pointer12_s,
    input logic [31:0] wb_dma_ch_sel_pointer13,
    input logic [31:0] wb_dma_ch_sel_pointer13_s,
    input logic [31:0] wb_dma_ch_sel_pointer14,
    input logic [31:0] wb_dma_ch_sel_pointer14_s,
    input logic [31:0] wb_dma_ch_sel_pointer15,
    input logic [31:0] wb_dma_ch_sel_pointer15_s,
    input logic [31:0] wb_dma_ch_sel_pointer16,
    input logic [31:0] wb_dma_ch_sel_pointer16_s,
    input logic [31:0] wb_dma_ch_sel_pointer17,
    input logic [31:0] wb_dma_ch_sel_pointer17_s,
    input logic [31:0] wb_dma_ch_sel_pointer18,
    input logic [31:0] wb_dma_ch_sel_pointer18_s,
    input logic [31:0] wb_dma_ch_sel_pointer19,
    input logic [31:0] wb_dma_ch_sel_pointer19_s,
    input logic [31:0] wb_dma_ch_sel_pointer1_s,
    input logic [31:0] wb_dma_ch_sel_pointer2,
    input logic [31:0] wb_dma_ch_sel_pointer20,
    input logic [31:0] wb_dma_ch_sel_pointer20_s,
    input logic [31:0] wb_dma_ch_sel_pointer21,
    input logic [31:0] wb_dma_ch_sel_pointer21_s,
    input logic [31:0] wb_dma_ch_sel_pointer22,
    input logic [31:0] wb_dma_ch_sel_pointer22_s,
    input logic [31:0] wb_dma_ch_sel_pointer23,
    input logic [31:0] wb_dma_ch_sel_pointer23_s,
    input logic [31:0] wb_dma_ch_sel_pointer24,
    input logic [31:0] wb_dma_ch_sel_pointer24_s,
    input logic [31:0] wb_dma_ch_sel_pointer25,
    input logic [31:0] wb_dma_ch_sel_pointer25_s,
    input logic [31:0] wb_dma_ch_sel_pointer26,
    input logic [31:0] wb_dma_ch_sel_pointer26_s,
    input logic [31:0] wb_dma_ch_sel_pointer27,
    input logic [31:0] wb_dma_ch_sel_pointer27_s,
    input logic [31:0] wb_dma_ch_sel_pointer28,
    input logic [31:0] wb_dma_ch_sel_pointer28_s,
    input logic [31:0] wb_dma_ch_sel_pointer29,
    input logic [31:0] wb_dma_ch_sel_pointer29_s,
    input logic [31:0] wb_dma_ch_sel_pointer2_s,
    input logic [31:0] wb_dma_ch_sel_pointer3,
    input logic [31:0] wb_dma_ch_sel_pointer30,
    input logic [31:0] wb_dma_ch_sel_pointer30_s,
    input logic [31:0] wb_dma_ch_sel_pointer3_s,
    input logic [31:0] wb_dma_ch_sel_pointer4,
    input logic [31:0] wb_dma_ch_sel_pointer4_s,
    input logic [31:0] wb_dma_ch_sel_pointer5,
    input logic [31:0] wb_dma_ch_sel_pointer5_s,
    input logic [31:0] wb_dma_ch_sel_pointer6,
    input logic [31:0] wb_dma_ch_sel_pointer6_s,
    input logic [31:0] wb_dma_ch_sel_pointer7,
    input logic [31:0] wb_dma_ch_sel_pointer7_s,
    input logic [31:0] wb_dma_ch_sel_pointer8,
    input logic [31:0] wb_dma_ch_sel_pointer8_s,
    input logic [31:0] wb_dma_ch_sel_pointer9,
    input logic [31:0] wb_dma_ch_sel_pointer9_s,
    input logic [31:0] wb_dma_ch_sel_pointer_s,
    input logic [30:0] wb_dma_ch_sel_req_i,
    input logic wb_dma_ch_sel_rst,
    input logic [31:0] wb_dma_ch_sel_txsz,
    input logic [31:0] wb_dma_de_adr0,
    input logic [31:0] wb_dma_de_adr1,
    input logic [31:0] wb_dma_de_am0,
    input logic [31:0] wb_dma_de_am1,
    input logic wb_dma_de_clk,
    input logic [31:0] wb_dma_de_csr,
    input logic wb_dma_de_de_ack,
    input logic [31:0] wb_dma_de_de_adr0,
    input logic wb_dma_de_de_adr0_we,
    input logic [31:0] wb_dma_de_de_adr1,
    input logic wb_dma_de_de_adr1_we,
    input logic [31:0] wb_dma_de_de_csr,
    input logic wb_dma_de_de_csr_we,
    input logic wb_dma_de_de_fetch_descr,
    input logic wb_dma_de_de_start,
    input logic [11:0] wb_dma_de_de_txsz,
    input logic wb_dma_de_de_txsz_we,
    input logic wb_dma_de_dma_abort,
    input logic wb_dma_de_dma_busy,
    input logic wb_dma_de_dma_done,
    input logic wb_dma_de_dma_done_all,
    input logic wb_dma_de_dma_err,
    input logic [31:0] wb_dma_de_mast0_adr,
    input logic [31:0] wb_dma_de_mast0_din,
    input logic [31:0] wb_dma_de_mast0_dout,
    input logic wb_dma_de_mast0_drdy,
    input logic wb_dma_de_mast0_err,
    input logic wb_dma_de_mast0_go,
    input logic wb_dma_de_mast0_wait,
    input logic wb_dma_de_mast0_we,
    input logic [31:0] wb_dma_de_mast1_adr,
    input logic [31:0] wb_dma_de_mast1_din,
    input logic [31:0] wb_dma_de_mast1_dout,
    input logic wb_dma_de_mast1_drdy,
    input logic wb_dma_de_mast1_err,
    input logic wb_dma_de_mast1_go,
    input logic wb_dma_de_mast1_wait,
    input logic wb_dma_de_mast1_we,
    input logic wb_dma_de_nd,
    input logic wb_dma_de_next_ch,
    input logic wb_dma_de_pause_req,
    input logic wb_dma_de_paused,
    input logic [31:0] wb_dma_de_pointer,
    input logic [31:0] wb_dma_de_pointer_s,
    input logic wb_dma_de_ptr_set,
    input logic wb_dma_de_rst,
    input logic [31:0] wb_dma_de_txsz,
    input logic [31:0] wb_dma_rf_ch0_adr0,
    input logic [31:0] wb_dma_rf_ch0_adr1,
    input logic [31:0] wb_dma_rf_ch0_am0,
    input logic [31:0] wb_dma_rf_ch0_am1,
    input logic [31:0] wb_dma_rf_ch0_csr,
    input logic [31:0] wb_dma_rf_ch0_txsz,
    input logic [31:0] wb_dma_rf_ch10_adr0,
    input logic [31:0] wb_dma_rf_ch10_adr1,
    input logic [31:0] wb_dma_rf_ch10_am0,
    input logic [31:0] wb_dma_rf_ch10_am1,
    input logic [31:0] wb_dma_rf_ch10_csr,
    input logic [31:0] wb_dma_rf_ch10_txsz,
    input logic [31:0] wb_dma_rf_ch11_adr0,
    input logic [31:0] wb_dma_rf_ch11_adr1,
    input logic [31:0] wb_dma_rf_ch11_am0,
    input logic [31:0] wb_dma_rf_ch11_am1,
    input logic [31:0] wb_dma_rf_ch11_csr,
    input logic [31:0] wb_dma_rf_ch11_txsz,
    input logic [31:0] wb_dma_rf_ch12_adr0,
    input logic [31:0] wb_dma_rf_ch12_adr1,
    input logic [31:0] wb_dma_rf_ch12_am0,
    input logic [31:0] wb_dma_rf_ch12_am1,
    input logic [31:0] wb_dma_rf_ch12_csr,
    input logic [31:0] wb_dma_rf_ch12_txsz,
    input logic [31:0] wb_dma_rf_ch13_adr0,
    input logic [31:0] wb_dma_rf_ch13_adr1,
    input logic [31:0] wb_dma_rf_ch13_am0,
    input logic [31:0] wb_dma_rf_ch13_am1,
    input logic [31:0] wb_dma_rf_ch13_csr,
    input logic [31:0] wb_dma_rf_ch13_txsz,
    input logic [31:0] wb_dma_rf_ch14_adr0,
    input logic [31:0] wb_dma_rf_ch14_adr1,
    input logic [31:0] wb_dma_rf_ch14_am0,
    input logic [31:0] wb_dma_rf_ch14_am1,
    input logic [31:0] wb_dma_rf_ch14_csr,
    input logic [31:0] wb_dma_rf_ch14_txsz,
    input logic [31:0] wb_dma_rf_ch15_adr0,
    input logic [31:0] wb_dma_rf_ch15_adr1,
    input logic [31:0] wb_dma_rf_ch15_am0,
    input logic [31:0] wb_dma_rf_ch15_am1,
    input logic [31:0] wb_dma_rf_ch15_csr,
    input logic [31:0] wb_dma_rf_ch15_txsz,
    input logic [31:0] wb_dma_rf_ch16_adr0,
    input logic [31:0] wb_dma_rf_ch16_adr1,
    input logic [31:0] wb_dma_rf_ch16_am0,
    input logic [31:0] wb_dma_rf_ch16_am1,
    input logic [31:0] wb_dma_rf_ch16_csr,
    input logic [31:0] wb_dma_rf_ch16_txsz,
    input logic [31:0] wb_dma_rf_ch17_adr0,
    input logic [31:0] wb_dma_rf_ch17_adr1,
    input logic [31:0] wb_dma_rf_ch17_am0,
    input logic [31:0] wb_dma_rf_ch17_am1,
    input logic [31:0] wb_dma_rf_ch17_csr,
    input logic [31:0] wb_dma_rf_ch17_txsz,
    input logic [31:0] wb_dma_rf_ch18_adr0,
    input logic [31:0] wb_dma_rf_ch18_adr1,
    input logic [31:0] wb_dma_rf_ch18_am0,
    input logic [31:0] wb_dma_rf_ch18_am1,
    input logic [31:0] wb_dma_rf_ch18_csr,
    input logic [31:0] wb_dma_rf_ch18_txsz,
    input logic [31:0] wb_dma_rf_ch19_adr0,
    input logic [31:0] wb_dma_rf_ch19_adr1,
    input logic [31:0] wb_dma_rf_ch19_am0,
    input logic [31:0] wb_dma_rf_ch19_am1,
    input logic [31:0] wb_dma_rf_ch19_csr,
    input logic [31:0] wb_dma_rf_ch19_txsz,
    input logic [31:0] wb_dma_rf_ch1_adr0,
    input logic [31:0] wb_dma_rf_ch1_adr1,
    input logic [31:0] wb_dma_rf_ch1_am0,
    input logic [31:0] wb_dma_rf_ch1_am1,
    input logic [31:0] wb_dma_rf_ch1_csr,
    input logic [31:0] wb_dma_rf_ch1_txsz,
    input logic [31:0] wb_dma_rf_ch20_adr0,
    input logic [31:0] wb_dma_rf_ch20_adr1,
    input logic [31:0] wb_dma_rf_ch20_am0,
    input logic [31:0] wb_dma_rf_ch20_am1,
    input logic [31:0] wb_dma_rf_ch20_csr,
    input logic [31:0] wb_dma_rf_ch20_txsz,
    input logic [31:0] wb_dma_rf_ch21_adr0,
    input logic [31:0] wb_dma_rf_ch21_adr1,
    input logic [31:0] wb_dma_rf_ch21_am0,
    input logic [31:0] wb_dma_rf_ch21_am1,
    input logic [31:0] wb_dma_rf_ch21_csr,
    input logic [31:0] wb_dma_rf_ch21_txsz,
    input logic [31:0] wb_dma_rf_ch22_adr0,
    input logic [31:0] wb_dma_rf_ch22_adr1,
    input logic [31:0] wb_dma_rf_ch22_am0,
    input logic [31:0] wb_dma_rf_ch22_am1,
    input logic [31:0] wb_dma_rf_ch22_csr,
    input logic [31:0] wb_dma_rf_ch22_txsz,
    input logic [31:0] wb_dma_rf_ch23_adr0,
    input logic [31:0] wb_dma_rf_ch23_adr1,
    input logic [31:0] wb_dma_rf_ch23_am0,
    input logic [31:0] wb_dma_rf_ch23_am1,
    input logic [31:0] wb_dma_rf_ch23_csr,
    input logic [31:0] wb_dma_rf_ch23_txsz,
    input logic [31:0] wb_dma_rf_ch24_adr0,
    input logic [31:0] wb_dma_rf_ch24_adr1,
    input logic [31:0] wb_dma_rf_ch24_am0,
    input logic [31:0] wb_dma_rf_ch24_am1,
    input logic [31:0] wb_dma_rf_ch24_csr,
    input logic [31:0] wb_dma_rf_ch24_txsz,
    input logic [31:0] wb_dma_rf_ch25_adr0,
    input logic [31:0] wb_dma_rf_ch25_adr1,
    input logic [31:0] wb_dma_rf_ch25_am0,
    input logic [31:0] wb_dma_rf_ch25_am1,
    input logic [31:0] wb_dma_rf_ch25_csr,
    input logic [31:0] wb_dma_rf_ch25_txsz,
    input logic [31:0] wb_dma_rf_ch26_adr0,
    input logic [31:0] wb_dma_rf_ch26_adr1,
    input logic [31:0] wb_dma_rf_ch26_am0,
    input logic [31:0] wb_dma_rf_ch26_am1,
    input logic [31:0] wb_dma_rf_ch26_csr,
    input logic [31:0] wb_dma_rf_ch26_txsz,
    input logic [31:0] wb_dma_rf_ch27_adr0,
    input logic [31:0] wb_dma_rf_ch27_adr1,
    input logic [31:0] wb_dma_rf_ch27_am0,
    input logic [31:0] wb_dma_rf_ch27_am1,
    input logic [31:0] wb_dma_rf_ch27_csr,
    input logic [31:0] wb_dma_rf_ch27_txsz,
    input logic [31:0] wb_dma_rf_ch28_adr0,
    input logic [31:0] wb_dma_rf_ch28_adr1,
    input logic [31:0] wb_dma_rf_ch28_am0,
    input logic [31:0] wb_dma_rf_ch28_am1,
    input logic [31:0] wb_dma_rf_ch28_csr,
    input logic [31:0] wb_dma_rf_ch28_txsz,
    input logic [31:0] wb_dma_rf_ch29_adr0,
    input logic [31:0] wb_dma_rf_ch29_adr1,
    input logic [31:0] wb_dma_rf_ch29_am0,
    input logic [31:0] wb_dma_rf_ch29_am1,
    input logic [31:0] wb_dma_rf_ch29_csr,
    input logic [31:0] wb_dma_rf_ch29_txsz,
    input logic [31:0] wb_dma_rf_ch2_adr0,
    input logic [31:0] wb_dma_rf_ch2_adr1,
    input logic [31:0] wb_dma_rf_ch2_am0,
    input logic [31:0] wb_dma_rf_ch2_am1,
    input logic [31:0] wb_dma_rf_ch2_csr,
    input logic [31:0] wb_dma_rf_ch2_txsz,
    input logic [31:0] wb_dma_rf_ch30_adr0,
    input logic [31:0] wb_dma_rf_ch30_adr1,
    input logic [31:0] wb_dma_rf_ch30_am0,
    input logic [31:0] wb_dma_rf_ch30_am1,
    input logic [31:0] wb_dma_rf_ch30_csr,
    input logic [31:0] wb_dma_rf_ch30_txsz,
    input logic [31:0] wb_dma_rf_ch3_adr0,
    input logic [31:0] wb_dma_rf_ch3_adr1,
    input logic [31:0] wb_dma_rf_ch3_am0,
    input logic [31:0] wb_dma_rf_ch3_am1,
    input logic [31:0] wb_dma_rf_ch3_csr,
    input logic [31:0] wb_dma_rf_ch3_txsz,
    input logic [31:0] wb_dma_rf_ch4_adr0,
    input logic [31:0] wb_dma_rf_ch4_adr1,
    input logic [31:0] wb_dma_rf_ch4_am0,
    input logic [31:0] wb_dma_rf_ch4_am1,
    input logic [31:0] wb_dma_rf_ch4_csr,
    input logic [31:0] wb_dma_rf_ch4_txsz,
    input logic [31:0] wb_dma_rf_ch5_adr0,
    input logic [31:0] wb_dma_rf_ch5_adr1,
    input logic [31:0] wb_dma_rf_ch5_am0,
    input logic [31:0] wb_dma_rf_ch5_am1,
    input logic [31:0] wb_dma_rf_ch5_csr,
    input logic [31:0] wb_dma_rf_ch5_txsz,
    input logic [31:0] wb_dma_rf_ch6_adr0,
    input logic [31:0] wb_dma_rf_ch6_adr1,
    input logic [31:0] wb_dma_rf_ch6_am0,
    input logic [31:0] wb_dma_rf_ch6_am1,
    input logic [31:0] wb_dma_rf_ch6_csr,
    input logic [31:0] wb_dma_rf_ch6_txsz,
    input logic [31:0] wb_dma_rf_ch7_adr0,
    input logic [31:0] wb_dma_rf_ch7_adr1,
    input logic [31:0] wb_dma_rf_ch7_am0,
    input logic [31:0] wb_dma_rf_ch7_am1,
    input logic [31:0] wb_dma_rf_ch7_csr,
    input logic [31:0] wb_dma_rf_ch7_txsz,
    input logic [31:0] wb_dma_rf_ch8_adr0,
    input logic [31:0] wb_dma_rf_ch8_adr1,
    input logic [31:0] wb_dma_rf_ch8_am0,
    input logic [31:0] wb_dma_rf_ch8_am1,
    input logic [31:0] wb_dma_rf_ch8_csr,
    input logic [31:0] wb_dma_rf_ch8_txsz,
    input logic [31:0] wb_dma_rf_ch9_adr0,
    input logic [31:0] wb_dma_rf_ch9_adr1,
    input logic [31:0] wb_dma_rf_ch9_am0,
    input logic [31:0] wb_dma_rf_ch9_am1,
    input logic [31:0] wb_dma_rf_ch9_csr,
    input logic [31:0] wb_dma_rf_ch9_txsz,
    input logic [4:0] wb_dma_rf_ch_sel,
    input logic wb_dma_rf_clk,
    input logic [31:0] wb_dma_rf_de_adr0,
    input logic wb_dma_rf_de_adr0_we,
    input logic [31:0] wb_dma_rf_de_adr1,
    input logic wb_dma_rf_de_adr1_we,
    input logic [31:0] wb_dma_rf_de_csr,
    input logic wb_dma_rf_de_csr_we,
    input logic wb_dma_rf_de_fetch_descr,
    input logic [11:0] wb_dma_rf_de_txsz,
    input logic wb_dma_rf_de_txsz_we,
    input logic wb_dma_rf_dma_abort,
    input logic wb_dma_rf_dma_busy,
    input logic wb_dma_rf_dma_done,
    input logic wb_dma_rf_dma_done_all,
    input logic wb_dma_rf_dma_err,
    input logic [30:0] wb_dma_rf_dma_rest,
    input logic wb_dma_rf_inta_o,
    input logic wb_dma_rf_intb_o,
    input logic [30:0] wb_dma_rf_ndnr,
    input logic wb_dma_rf_pause_req,
    input logic wb_dma_rf_paused,
    input logic [31:0] wb_dma_rf_pointer0,
    input logic [31:0] wb_dma_rf_pointer0_s,
    input logic [31:0] wb_dma_rf_pointer1,
    input logic [31:0] wb_dma_rf_pointer10,
    input logic [31:0] wb_dma_rf_pointer10_s,
    input logic [31:0] wb_dma_rf_pointer11,
    input logic [31:0] wb_dma_rf_pointer11_s,
    input logic [31:0] wb_dma_rf_pointer12,
    input logic [31:0] wb_dma_rf_pointer12_s,
    input logic [31:0] wb_dma_rf_pointer13,
    input logic [31:0] wb_dma_rf_pointer13_s,
    input logic [31:0] wb_dma_rf_pointer14,
    input logic [31:0] wb_dma_rf_pointer14_s,
    input logic [31:0] wb_dma_rf_pointer15,
    input logic [31:0] wb_dma_rf_pointer15_s,
    input logic [31:0] wb_dma_rf_pointer16,
    input logic [31:0] wb_dma_rf_pointer16_s,
    input logic [31:0] wb_dma_rf_pointer17,
    input logic [31:0] wb_dma_rf_pointer17_s,
    input logic [31:0] wb_dma_rf_pointer18,
    input logic [31:0] wb_dma_rf_pointer18_s,
    input logic [31:0] wb_dma_rf_pointer19,
    input logic [31:0] wb_dma_rf_pointer19_s,
    input logic [31:0] wb_dma_rf_pointer1_s,
    input logic [31:0] wb_dma_rf_pointer2,
    input logic [31:0] wb_dma_rf_pointer20,
    input logic [31:0] wb_dma_rf_pointer20_s,
    input logic [31:0] wb_dma_rf_pointer21,
    input logic [31:0] wb_dma_rf_pointer21_s,
    input logic [31:0] wb_dma_rf_pointer22,
    input logic [31:0] wb_dma_rf_pointer22_s,
    input logic [31:0] wb_dma_rf_pointer23,
    input logic [31:0] wb_dma_rf_pointer23_s,
    input logic [31:0] wb_dma_rf_pointer24,
    input logic [31:0] wb_dma_rf_pointer24_s,
    input logic [31:0] wb_dma_rf_pointer25,
    input logic [31:0] wb_dma_rf_pointer25_s,
    input logic [31:0] wb_dma_rf_pointer26,
    input logic [31:0] wb_dma_rf_pointer26_s,
    input logic [31:0] wb_dma_rf_pointer27,
    input logic [31:0] wb_dma_rf_pointer27_s,
    input logic [31:0] wb_dma_rf_pointer28,
    input logic [31:0] wb_dma_rf_pointer28_s,
    input logic [31:0] wb_dma_rf_pointer29,
    input logic [31:0] wb_dma_rf_pointer29_s,
    input logic [31:0] wb_dma_rf_pointer2_s,
    input logic [31:0] wb_dma_rf_pointer3,
    input logic [31:0] wb_dma_rf_pointer30,
    input logic [31:0] wb_dma_rf_pointer30_s,
    input logic [31:0] wb_dma_rf_pointer3_s,
    input logic [31:0] wb_dma_rf_pointer4,
    input logic [31:0] wb_dma_rf_pointer4_s,
    input logic [31:0] wb_dma_rf_pointer5,
    input logic [31:0] wb_dma_rf_pointer5_s,
    input logic [31:0] wb_dma_rf_pointer6,
    input logic [31:0] wb_dma_rf_pointer6_s,
    input logic [31:0] wb_dma_rf_pointer7,
    input logic [31:0] wb_dma_rf_pointer7_s,
    input logic [31:0] wb_dma_rf_pointer8,
    input logic [31:0] wb_dma_rf_pointer8_s,
    input logic [31:0] wb_dma_rf_pointer9,
    input logic [31:0] wb_dma_rf_pointer9_s,
    input logic wb_dma_rf_ptr_set,
    input logic wb_dma_rf_rst,
    input logic [7:0] wb_dma_rf_wb_rf_adr,
    input logic [31:0] wb_dma_rf_wb_rf_din,
    input logic [31:0] wb_dma_rf_wb_rf_dout,
    input logic wb_dma_rf_wb_rf_re,
    input logic wb_dma_rf_wb_rf_we,
    input logic wb_dma_wb_if_clk,
    input logic [31:0] wb_dma_wb_if_mast_adr,
    input logic [31:0] wb_dma_wb_if_mast_din,
    input logic [31:0] wb_dma_wb_if_mast_dout,
    input logic wb_dma_wb_if_mast_drdy,
    input logic wb_dma_wb_if_mast_err,
    input logic wb_dma_wb_if_mast_go,
    input logic [70:0] wb_dma_wb_if_mast_pt_in,
    input logic [34:0] wb_dma_wb_if_mast_pt_out,
    input logic wb_dma_wb_if_mast_wait,
    input logic wb_dma_wb_if_mast_we,
    input logic wb_dma_wb_if_pt_sel_i,
    input logic wb_dma_wb_if_pt_sel_o,
    input logic wb_dma_wb_if_rst,
    input logic [31:0] wb_dma_wb_if_slv_adr,
    input logic [31:0] wb_dma_wb_if_slv_din,
    input logic [31:0] wb_dma_wb_if_slv_dout,
    input logic [34:0] wb_dma_wb_if_slv_pt_in,
    input logic [70:0] wb_dma_wb_if_slv_pt_out,
    input logic wb_dma_wb_if_slv_re,
    input logic wb_dma_wb_if_slv_we,
    input logic wb_dma_wb_if_wb_ack_i,
    input logic wb_dma_wb_if_wb_ack_o,
    input logic [31:0] wb_dma_wb_if_wb_addr_i,
    input logic [31:0] wb_dma_wb_if_wb_addr_o,
    input logic wb_dma_wb_if_wb_cyc_i,
    input logic wb_dma_wb_if_wb_cyc_o,
    input logic wb_dma_wb_if_wb_err_i,
    input logic wb_dma_wb_if_wb_err_o,
    input logic wb_dma_wb_if_wb_rty_i,
    input logic wb_dma_wb_if_wb_rty_o,
    input logic [3:0] wb_dma_wb_if_wb_sel_i,
    input logic [3:0] wb_dma_wb_if_wb_sel_o,
    input logic wb_dma_wb_if_wb_stb_i,
    input logic wb_dma_wb_if_wb_stb_o,
    input logic wb_dma_wb_if_wb_we_i,
    input logic wb_dma_wb_if_wb_we_o,
    input logic [31:0] wb_dma_wb_if_wbm_data_i,
    input logic [31:0] wb_dma_wb_if_wbm_data_o,
    input logic [31:0] wb_dma_wb_if_wbs_data_i,
    input logic [31:0] wb_dma_wb_if_wbs_data_o
);

//======================================================================
// Assertions for Signal: top_wb0_stb_i
// Primary label from model: top_wb0_stb_i
//======================================================================
always_comb begin
  // WISHBONE rule: STB may only be asserted while CYC is asserted
  assert (!(top_wb0_stb_i && !top_wb0_cyc_i));
end


//======================================================================
// Assertions for Signal: top_wb1_stb_i
// Primary label from model: top_wb1_stb_i
//======================================================================
always_comb begin
  // WISHBONE rule: STB may only be asserted while CYC is asserted
  assert (!(top_wb1_stb_i && !top_wb1_cyc_i));
end


//======================================================================
// Assertions for Signal: top_wb0_stb_o
// Primary label from model: top_wb0_stb_o
//======================================================================
always_comb begin
  // Master-side WISHBONE rule: STB may only be asserted while CYC is asserted
  assert (!(top_wb0_stb_o && !top_wb0_cyc_o));
end


//======================================================================
// Assertions for Signal: top_wb1_stb_o
// Primary label from model: top_wb1_stb_o
//======================================================================
always_comb begin
  // Master-side WISHBONE rule: STB may only be asserted while CYC is asserted
  assert (!(top_wb1_stb_o && !top_wb1_cyc_o));
end


//======================================================================
// Assertions for Signal: top_wb0_ack_o
// Primary label from model: top_wb0_ack_o
//======================================================================
always_comb begin
  // Slave-side completion signals (ack/err/rty) are mutually exclusive
  assert ($onehot0({top_wb0_ack_o, top_wb0_err_o, top_wb0_rty_o}));
  // Normal completion is only valid during an active slave-side cycle
  assert (top_wb0_ack_o -> (top_wb0_cyc_i && top_wb0_stb_i));
end


//======================================================================
// Assertions for Signal: top_wb1_ack_o
// Primary label from model: top_wb1_ack_o
//======================================================================
always_comb begin
  // Slave-side completion signals (ack/err/rty) are mutually exclusive
  assert ($onehot0({top_wb1_ack_o, top_wb1_err_o, top_wb1_rty_o}));
  // Normal completion is only valid during an active slave-side cycle
  assert (top_wb1_ack_o -> (top_wb1_cyc_i && top_wb1_stb_i));
end


//======================================================================
// Assertions for Signal: top_wb0_err_o
// Primary label from model: top_wb0_err_o
//======================================================================
always_comb begin
  // Error completion is only valid during an active slave-side cycle
  assert (top_wb0_err_o -> (top_wb0_cyc_i && top_wb0_stb_i));
  // Register-file path deasserts local error response
  assert (!top_pt0_sel_o -> !top_wb0_err_o);
end


//======================================================================
// Assertions for Signal: top_wb1_err_o
// Primary label from model: top_wb1_err_o
//======================================================================
always_comb begin
  // Error completion is only valid during an active slave-side cycle
  assert (top_wb1_err_o -> (top_wb1_cyc_i && top_wb1_stb_i));
  // Register-file path deasserts local error response
  assert (!top_pt1_sel_o -> !top_wb1_err_o);
end


//======================================================================
// Assertions for Signal: top_wb0_rty_o
// Primary label from model: top_wb0_rty_o
//======================================================================
always_comb begin
  // Retry completion is only valid during an active slave-side cycle
  assert (top_wb0_rty_o -> (top_wb0_cyc_i && top_wb0_stb_i));
  // Register-file path deasserts local retry response
  assert (!top_pt0_sel_o -> !top_wb0_rty_o);
end


//======================================================================
// Assertions for Signal: top_wb1_rty_o
// Primary label from model: top_wb1_rty_o
//======================================================================
always_comb begin
  // Retry completion is only valid during an active slave-side cycle
  assert (top_wb1_rty_o -> (top_wb1_cyc_i && top_wb1_stb_i));
  // Register-file path deasserts local retry response
  assert (!top_pt1_sel_o -> !top_wb1_rty_o);
end


//======================================================================
// Assertions for Signal: top_wb0_ack_i
// Primary label from model: top_wb0_ack_i
//======================================================================
always_comb begin
  // Master-side completion signals (ack/err/rty) are mutually exclusive
  assert ($onehot0({top_wb0_ack_i, top_wb0_err_i, top_wb0_rty_i}));
  // Normal completion input is only meaningful during an active master-side cycle
  assert (top_wb0_ack_i -> (top_wb0_cyc_o && top_wb0_stb_o));
end


//======================================================================
// Assertions for Signal: top_wb1_ack_i
// Primary label from model: top_wb1_ack_i
//======================================================================
always_comb begin
  // Master-side completion signals (ack/err/rty) are mutually exclusive
  assert ($onehot0({top_wb1_ack_i, top_wb1_err_i, top_wb1_rty_i}));
  // Normal completion input is only meaningful during an active master-side cycle
  assert (top_wb1_ack_i -> (top_wb1_cyc_o && top_wb1_stb_o));
end


//======================================================================
// Assertions for Signal: top_wb0_err_i
// Primary label from model: top_wb0_err_i
//======================================================================
always_comb begin
  // Error completion input is only meaningful during an active master-side cycle
  assert (top_wb0_err_i -> (top_wb0_cyc_o && top_wb0_stb_o));
end


//======================================================================
// Assertions for Signal: top_wb1_err_i
// Primary label from model: top_wb1_err_i
//======================================================================
always_comb begin
  // Error completion input is only meaningful during an active master-side cycle
  assert (top_wb1_err_i -> (top_wb1_cyc_o && top_wb1_stb_o));
end


//======================================================================
// Assertions for Signal: top_wb0_rty_i
// Primary label from model: top_wb0_rty_i
//======================================================================
always_comb begin
  // Retry completion input is only meaningful during an active master-side cycle
  assert (top_wb0_rty_i -> (top_wb0_cyc_o && top_wb0_stb_o));
end


//======================================================================
// Assertions for Signal: top_wb1_rty_i
// Primary label from model: top_wb1_rty_i
//======================================================================
always_comb begin
  // Retry completion input is only meaningful during an active master-side cycle
  assert (top_wb1_rty_i -> (top_wb1_cyc_o && top_wb1_stb_o));
end


//======================================================================
// Assertions for Signal: top_mast0_pt_in
// Primary label from model: top_mast0_pt_in
//======================================================================
always_comb begin
  // Pass-through ports are cross-coupled at top level: interface1 slave path bridges to interface0 master path
  assert (top_mast0_pt_in == top_slv1_pt_out);
end


//======================================================================
// Assertions for Signal: top_mast1_pt_in
// Primary label from model: top_mast1_pt_in
//======================================================================
always_comb begin
  // Pass-through ports are cross-coupled at top level: interface0 slave path bridges to interface1 master path
  assert (top_mast1_pt_in == top_slv0_pt_out);
end


//======================================================================
// Assertions for Signal: top_slv0_pt_in
// Primary label from model: top_slv0_pt_in
//======================================================================
always_comb begin
  // Pass-through ports are cross-coupled at top level: interface1 master response returns to interface0 slave path
  assert (top_slv0_pt_in == top_mast1_pt_out);
end


//======================================================================
// Assertions for Signal: top_slv1_pt_in
// Primary label from model: top_slv1_pt_in
//======================================================================
always_comb begin
  // Pass-through ports are cross-coupled at top level: interface0 master response returns to interface1 slave path
  assert (top_slv1_pt_in == top_mast0_pt_out);
end


//======================================================================
// Assertions for Signal: top_pt0_sel_i
// Primary label from model: top_pt0_sel_i
//======================================================================
always_comb begin
  // Pass-through select handshake is cross-coupled between interfaces at top level
  assert (top_pt0_sel_i == top_pt1_sel_o);
end


//======================================================================
// Assertions for Signal: top_pt1_sel_i
// Primary label from model: top_pt1_sel_i
//======================================================================
always_comb begin
  // Pass-through select handshake is cross-coupled between interfaces at top level
  assert (top_pt1_sel_i == top_pt0_sel_o);
end


//======================================================================
// Assertions for Signal: top_pt0_sel_o
// Primary label from model: top_pt0_sel_o
//======================================================================
always_comb begin
  // Pass-through selection is only active during a valid slave-side cycle
  assert (top_pt0_sel_o -> (top_wb0_cyc_i && top_wb0_stb_i));
end


//======================================================================
// Assertions for Signal: top_pt1_sel_o
// Primary label from model: top_pt1_sel_o
//======================================================================
always_comb begin
  // Pass-through selection is only active during a valid slave-side cycle
  assert (top_pt1_sel_o -> (top_wb1_cyc_i && top_wb1_stb_i));
end
endmodule

