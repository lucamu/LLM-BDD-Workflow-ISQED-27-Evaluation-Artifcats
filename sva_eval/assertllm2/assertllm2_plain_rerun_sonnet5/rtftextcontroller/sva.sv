// method: plain_prompt

// Global checker bound to top module: rtfTextController
module rtfTextController_sva_global (
    input logic [11:0] HVCounter_cnt_offs,
    input logic [11:0] HVCounter_ctr,
    input logic [11:0] HVCounter_ctr1,
    input logic [4:0] HVCounter_maxpix,
    input logic HVCounter_nxp,
    input logic HVCounter_nxt_pix,
    input logic HVCounter_nxt_pos,
    input logic HVCounter_pixcce,
    input logic [3:0] HVCounter_pixsz,
    input logic [11:0] HVCounter_pos,
    input logic HVCounter_rst,
    input logic HVCounter_sync,
    input logic HVCounter_vclk,
    input logic ParallelToSerial_ce,
    input logic ParallelToSerial_clk,
    input logic [7:0] ParallelToSerial_d,
    input logic ParallelToSerial_ld,
    input logic ParallelToSerial_qh,
    input logic ParallelToSerial_qin,
    input logic ParallelToSerial_rst,
    input logic VT151_e_n,
    input logic [7:0] VT151_i0,
    input logic [7:0] VT151_i1,
    input logic [7:0] VT151_i2,
    input logic [7:0] VT151_i3,
    input logic [7:0] VT151_i4,
    input logic [7:0] VT151_i5,
    input logic [7:0] VT151_i6,
    input logic [7:0] VT151_i7,
    input logic [2:0] VT151_s,
    input logic [7:0] VT151_z,
    input logic [7:0] VT151_z_n,
    input logic VT163_clk,
    input logic VT163_clr_n,
    input logic [7:0] VT163_d,
    input logic VT163_enp,
    input logic VT163_ent,
    input logic VT163_ld_n,
    input logic [7:0] VT163_q,
    input logic VT163_rco,
    input logic edge_det_clk,
    input logic edge_det_dat_i,
    input logic edge_det_edge_both,
    input logic edge_det_edge_falling,
    input logic edge_det_edge_rising,
    input logic edge_det_rstn,
    input logic rtfColorROM_ce,
    input logic rtfColorROM_clk,
    input logic [4:0] rtfColorROM_code,
    input logic [23:0] rtfColorROM_color,
    input logic [8:0] syncRam4kx9_1rw1r_i,
    input logic [8:0] syncRam4kx9_1rw1r_o,
    input logic [11:0] syncRam4kx9_1rw1r_radr,
    input logic syncRam4kx9_1rw1r_rce,
    input logic syncRam4kx9_1rw1r_rclk,
    input logic syncRam4kx9_1rw1r_rrst,
    input logic [11:0] syncRam4kx9_1rw1r_wadr,
    input logic syncRam4kx9_1rw1r_wce,
    input logic syncRam4kx9_1rw1r_wclk,
    input logic syncRam4kx9_1rw1r_we,
    input logic [8:0] syncRam4kx9_1rw1r_wo,
    input logic syncRam4kx9_1rw1r_wrst,
    input logic top_ack_o,
    input logic [63:0] top_adr_i,
    input logic [23:0] top_bkColor24,
    input logic top_blank,
    input logic top_border,
    input logic [8:0] top_cdat_o,
    input logic [8:0] top_chdat_o,
    input logic top_clk_i,
    input logic [11:0] top_col,
    input logic top_cs_color,
    input logic top_cs_rom,
    input logic top_cs_text,
    input logic [15:0] top_curpos,
    input logic top_cyc_i,
    input logic [15:0] top_dat_i,
    input logic [15:0] top_dat_o,
    input logic top_eof,
    input logic top_eol,
    input logic [23:0] top_fgColor24,
    input logic top_ld_shft,
    input logic top_lp,
    input logic [4:0] top_maxScanline,
    input logic [4:0] top_maxScanpix,
    input logic top_nhp,
    input logic [3:0] top_pixelHeight,
    input logic [3:0] top_pixelWidth,
    input logic [2:0] top_rBlink,
    input logic [24:0] top_rgbIn,
    input logic [24:0] top_rgbOut,
    input logic [11:0] top_row,
    input logic top_rst_i,
    input logic [11:0] top_scanline,
    input logic [1:0] top_sel_i,
    input logic top_stb_i,
    input logic [8:0] top_tdat_o,
    input logic [15:0] top_txtAddr,
    input logic [3:0] top_txtBkCode1,
    input logic [4:0] top_txtFgCode1,
    input logic top_vclk,
    input logic top_we_i,
    input logic [11:0] top_windowLeft,
    input logic [11:0] top_windowTop
);

//======================================================================
// Assertions for Signal: top_ack_o
// Primary label from model: top_ack_o
//======================================================================
// ack_o must only be asserted when the bus cycle is actually active (cyc_i and stb_i qualified)
always_comb begin
  assert (top_ack_o -> (top_cyc_i && top_stb_i));
end

// Write transfers acknowledge when a mapped region is selected during an active cycle
always_comb begin
  assert ((top_we_i && top_cyc_i && top_stb_i &&
           (top_cs_text || top_cs_color || top_cs_rom)) -> top_ack_o);
end


//======================================================================
// Assertions for Signal: top_cs_text
// Primary label from model: top_cs_text
//======================================================================
// Address decode must select at most one memory region at a time (text/attribute/char-bitmap)
always_comb begin
  assert ($countones({top_cs_text, top_cs_color, top_cs_rom}) <= 1);
end


//======================================================================
// Assertions for Signal: top_blank
// Primary label from model: top_blank
//======================================================================
// Global blanking forces black output, highest priority in output color selection
always_comb begin
  assert (top_blank -> (top_rgbOut[23:0] == 24'h0));
end


//======================================================================
// Assertions for Signal: top_scanline
// Primary label from model: top_scanline
//======================================================================
// Current scanline index must never exceed the programmed maximum scanline per character row
always_comb begin
  assert (top_scanline <= {7'b0, top_maxScanline});
end


//======================================================================
// Assertions for Signal: top_cdat_o
// Primary label from model: top_cdat_o
//======================================================================
// Attribute RAM entry format: background code occupies bits [8:5]
always_comb begin
  assert (top_txtBkCode1 == top_cdat_o[8:5]);
end

// Attribute RAM entry format: foreground code occupies bits [4:0]
always_comb begin
  assert (top_txtFgCode1 == top_cdat_o[4:0]);
end


//======================================================================
// Assertions for Signal: top_rgbOut
// Primary label from model: top_rgbOut
//======================================================================
// Internally generated color constants drive the MSB (bit 24) low; otherwise rgbIn bit24 passes through
always_comb begin
  assert ((top_rgbOut[24] == 1'b0) || (top_rgbOut[24] == top_rgbIn[24]));
end


//======================================================================
// Assertions for Signal: top_sel_i
// Primary label from model: top_sel_i
//======================================================================
// Byte-lane select must indicate at least one active byte lane during a write access
always_comb begin
  assert ((top_we_i && top_cyc_i && top_stb_i) -> (top_sel_i != 2'b00));
end


//======================================================================
// Assertions for Signal: syncRam4kx9_1rw1r_we
// Primary label from model: syncRam4kx9_1rw1r_we
//======================================================================
// Character bitmap RAM write enable is tied inactive in this RTL integration
always_comb begin
  assert (syncRam4kx9_1rw1r_we == 1'b0);
end


//======================================================================
// Assertions for Signal: edge_det_edge_both
// Primary label from model: edge_det_edge_both
//======================================================================
// edge_both must reflect the logical OR of rising and falling edge detections
always_comb begin
  assert (edge_det_edge_both == (edge_det_edge_rising | edge_det_edge_falling));
end

// Rising and falling edge pulses are mutually exclusive at any given time
always_comb begin
  assert (!(edge_det_edge_rising && edge_det_edge_falling));
end


//======================================================================
// Assertions for Signal: edge_det_dat_i
// Primary label from model: edge_det_dat_i
//======================================================================
// Light-pen edge detector data input is driven by the top-level light-pen strobe
always_comb begin
  assert (edge_det_dat_i == top_lp);
end


//======================================================================
// Assertions for Signal: edge_det_rstn
// Primary label from model: edge_det_rstn
//======================================================================
// Light-pen edge detector reset is the active-low complement of the top-level reset
always_comb begin
  assert (edge_det_rstn == ~top_rst_i);
end


//======================================================================
// Assertions for Signal: edge_det_clk
// Primary label from model: edge_det_clk
//======================================================================
// Light-pen edge detector is sampled in the bus/control clock domain
always_comb begin
  assert (edge_det_clk == top_clk_i);
end


//======================================================================
// Assertions for Signal: ParallelToSerial_clk
// Primary label from model: ParallelToSerial_clk
//======================================================================
// Parallel-to-serial shifter is clocked by the video pixel clock
always_comb begin
  assert (ParallelToSerial_clk == top_vclk);
end


//======================================================================
// Assertions for Signal: ParallelToSerial_ce
// Primary label from model: ParallelToSerial_ce
//======================================================================
// Shift enable of the parallel-to-serial glyph shifter is driven by nhp timing pulse
always_comb begin
  assert (ParallelToSerial_ce == top_nhp);
end


//======================================================================
// Assertions for Signal: ParallelToSerial_ld
// Primary label from model: ParallelToSerial_ld
//======================================================================
// Parallel-load control of the glyph shifter is driven by ld_shft timing pulse
always_comb begin
  assert (ParallelToSerial_ld == top_ld_shft);
end


//======================================================================
// Assertions for Signal: HVCounter_sync
// Primary label from model: HVCounter_sync
//======================================================================
// HVCounter synchronization pulse must originate from either end-of-line or end-of-frame timing
always_comb begin
  assert ((HVCounter_sync == top_eol) || (HVCounter_sync == top_eof));
end


//======================================================================
// Assertions for Signal: HVCounter_nxt_pos
// Primary label from model: HVCounter_nxt_pos
//======================================================================
// Position-change strobe can only occur coincident with a pixel-step strobe
always_comb begin
  assert (HVCounter_nxt_pos -> HVCounter_nxt_pix);
end


//======================================================================
// Assertions for Signal: VT151_z_n
// Primary label from model: VT151_z_n
//======================================================================
// Complementary multiplexer output must be the bitwise negation of the primary output
always_comb begin
  assert (VT151_z_n == ~VT151_z);
end
endmodule

