`include "timescale.v"

// method: plain_prompt

// Global checker bound to top module: simple_spi_top
module simple_spi_top_sva_global (
    input logic fifo4_clk,
    input logic fifo4_clr,
    input logic [7:0] fifo4_din,
    input logic [7:0] fifo4_dout,
    input logic fifo4_empty,
    input logic fifo4_full,
    input logic fifo4_re,
    input logic fifo4_rst,
    input logic fifo4_we,
    input logic top_ack_o,
    input logic [1:0] top_adr_i,
    input logic top_clk_i,
    input logic top_cyc_i,
    input logic [7:0] top_dat_i,
    input logic [7:0] top_dat_o,
    input logic top_inta_o,
    input logic top_miso_i,
    input logic top_mosi_o,
    input logic [7:0] top_rfdout,
    input logic top_rfempty,
    input logic top_rffull,
    input logic top_rfre,
    input logic top_rfwe,
    input logic top_rst_n,
    input logic top_sck_o,
    input logic top_stb_i,
    input logic [7:0] top_treg,
    input logic top_we_i,
    input logic [7:0] top_wfdout,
    input logic top_wfempty,
    input logic top_wffull,
    input logic top_wfre,
    input logic top_wfwe
);

//======================================================================
// Assertions for Signal: top_ack_o
// Primary label from model: top_ack_o
//======================================================================
// ack_o must only be asserted for a valid, decoded WISHBONE access (cyc_i & stb_i)
always_comb begin
  assert (top_ack_o -> (top_cyc_i && top_stb_i));
end


//======================================================================
// Assertions for Signal: top_wffull
// Primary label from model: top_wffull
//======================================================================
// Write FIFO cannot be simultaneously full and empty
always_comb begin
  assert (!(top_wffull && top_wfempty));
end


//======================================================================
// Assertions for Signal: top_rffull
// Primary label from model: top_rffull
//======================================================================
// Read FIFO cannot be simultaneously full and empty
always_comb begin
  assert (!(top_rffull && top_rfempty));
end

// Top-level read-FIFO full status must match the underlying fifo4 (rfifo) full indicator
always_comb begin
  assert (top_rffull == fifo4_full);
end


//======================================================================
// Assertions for Signal: fifo4_full
// Primary label from model: fifo4_full
//======================================================================
// fifo4 instance (rfifo) cannot report full and empty simultaneously
always_comb begin
  assert (!(fifo4_full && fifo4_empty));
end


//======================================================================
// Assertions for Signal: fifo4_empty
// Primary label from model: fifo4_empty
//======================================================================
// fifo4 (rfifo) empty status must match the top-level read-FIFO empty status
always_comb begin
  assert (fifo4_empty == top_rfempty);
end


//======================================================================
// Assertions for Signal: fifo4_dout
// Primary label from model: fifo4_dout
//======================================================================
// fifo4 (rfifo) data output must match the top-level read-FIFO data output presented for SPDR reads
always_comb begin
  assert (fifo4_dout == top_rfdout);
end


//======================================================================
// Assertions for Signal: fifo4_we
// Primary label from model: fifo4_we
//======================================================================
// fifo4 (rfifo) write-enable must match the top-level read-FIFO write-enable used on byte completion
always_comb begin
  assert (fifo4_we == top_rfwe);
end


//======================================================================
// Assertions for Signal: fifo4_re
// Primary label from model: fifo4_re
//======================================================================
// fifo4 (rfifo) read-enable must match the top-level read-FIFO read-enable used on SPDR reads
always_comb begin
  assert (fifo4_re == top_rfre);
end


//======================================================================
// Assertions for Signal: fifo4_clk
// Primary label from model: fifo4_clk
//======================================================================
// fifo4 (rfifo) clock input must be the same system/WISHBONE clock as the top-level clk_i
always_comb begin
  assert (fifo4_clk == top_clk_i);
end


//======================================================================
// Assertions for Signal: fifo4_rst
// Primary label from model: fifo4_rst
//======================================================================
// fifo4 (rfifo) asynchronous reset must be driven by the same active-low reset as the top-level rst_n
always_comb begin
  assert (fifo4_rst == top_rst_n);
end
endmodule

