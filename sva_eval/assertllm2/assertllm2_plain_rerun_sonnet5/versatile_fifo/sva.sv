// method: plain_prompt

// Global checker bound to top module: async_fifo_dw_simplex_top
module async_fifo_dw_simplex_top_sva_global (
    input logic adr_gen_cke,
    input logic adr_gen_clk,
    input logic [3:0] adr_gen_q,
    input logic [3:0] adr_gen_q_bin,
    input logic adr_gen_rst,
    input logic top_a_clk,
    input logic [35:0] top_a_d,
    input logic [4:0] top_a_dpram_adr,
    input logic top_a_fifo_empty,
    input logic top_a_fifo_full,
    input logic [35:0] top_a_q,
    input logic [3:0] top_a_radr_bin,
    input logic top_a_rd,
    input logic top_a_rst,
    input logic [3:0] top_a_wadr_bin,
    input logic top_a_wr,
    input logic top_b_clk,
    input logic [35:0] top_b_d,
    input logic [4:0] top_b_dpram_adr,
    input logic top_b_fifo_empty,
    input logic top_b_fifo_full,
    input logic [35:0] top_b_q,
    input logic [3:0] top_b_radr_bin,
    input logic top_b_rd,
    input logic top_b_rst,
    input logic [3:0] top_b_wadr_bin,
    input logic top_b_wr,
    input logic versatile_fifo_async_cmp_fifo_full,
    input logic versatile_fifo_async_cmp_rclk,
    input logic versatile_fifo_async_cmp_rptr,
    input logic versatile_fifo_async_cmp_rst,
    input logic versatile_fifo_async_cmp_wclk,
    input logic versatile_fifo_async_cmp_wptr,
    input logic [7:0] vfifo_dual_port_ram_dc_dw_adr_a,
    input logic [7:0] vfifo_dual_port_ram_dc_dw_adr_b,
    input logic vfifo_dual_port_ram_dc_dw_clk_a,
    input logic vfifo_dual_port_ram_dc_dw_clk_b,
    input logic [31:0] vfifo_dual_port_ram_dc_dw_d_a,
    input logic [31:0] vfifo_dual_port_ram_dc_dw_d_b,
    input logic [31:0] vfifo_dual_port_ram_dc_dw_q_a,
    input logic [31:0] vfifo_dual_port_ram_dc_dw_q_b,
    input logic vfifo_dual_port_ram_dc_dw_we_a,
    input logic vfifo_dual_port_ram_dc_dw_we_b
);

//======================================================================
// Assertions for Signal: top_a_dpram_adr
// Primary label from model: top_a_dpram_adr
//======================================================================
// Address mux: side-A RAM address selects write pointer when writing, else read pointer (write has priority)
always_comb begin
  assert (top_a_dpram_adr == (top_a_wr ? {1'b0, top_a_wadr_bin} : {1'b1, top_a_radr_bin}));
end

// MSB of side-A RAM address encodes direction: 0 for A-to-B write region, 1 for B-to-A read region
always_comb begin
  assert (top_a_wr -> (top_a_dpram_adr[4] == 1'b0));
end

always_comb begin
  assert (!top_a_wr -> (top_a_dpram_adr[4] == 1'b1));
end


//======================================================================
// Assertions for Signal: top_b_dpram_adr
// Primary label from model: top_b_dpram_adr
//======================================================================
// Address mux: side-B RAM address selects write pointer when writing, else read pointer (write has priority)
always_comb begin
  assert (top_b_dpram_adr == (top_b_wr ? {1'b1, top_b_wadr_bin} : {1'b0, top_b_radr_bin}));
end

// MSB of side-B RAM address encodes direction: 1 for B-to-A write region, 0 for A-to-B read region
always_comb begin
  assert (top_b_wr -> (top_b_dpram_adr[4] == 1'b1));
end

always_comb begin
  assert (!top_b_wr -> (top_b_dpram_adr[4] == 1'b0));
end


//======================================================================
// Assertions for Signal: vfifo_dual_port_ram_dc_dw_we_a
// Primary label from model: vfifo_dual_port_ram_dc_dw_we_a
//======================================================================
// RAM port-A write enable is directly tied to side-A write request
always_comb begin
  assert (vfifo_dual_port_ram_dc_dw_we_a == top_a_wr);
end


//======================================================================
// Assertions for Signal: vfifo_dual_port_ram_dc_dw_we_b
// Primary label from model: vfifo_dual_port_ram_dc_dw_we_b
//======================================================================
// RAM port-B write enable is directly tied to side-B write request
always_comb begin
  assert (vfifo_dual_port_ram_dc_dw_we_b == top_b_wr);
end


//======================================================================
// Assertions for Signal: top_a_fifo_full
// Primary label from model: top_a_fifo_full
//======================================================================
// While side-A reset is asserted, the A-to-B full flag (driven by the a_rst-controlled comparator) must not be asserted
always_comb begin
  assert (!(top_a_rst && top_a_fifo_full));
end

// A single direction cannot simultaneously report full (write side) and empty (read side)
always_comb begin
  assert (!(top_a_fifo_full && top_b_fifo_empty));
end


//======================================================================
// Assertions for Signal: top_b_fifo_empty
// Primary label from model: top_b_fifo_empty
//======================================================================
// While side-A reset is asserted, the comparator that drives b_fifo_empty (same reset domain as a_fifo_full) must force empty active
always_comb begin
  assert (top_a_rst -> top_b_fifo_empty);
end


//======================================================================
// Assertions for Signal: top_b_fifo_full
// Primary label from model: top_b_fifo_full
//======================================================================
// While side-B reset is asserted, the B-to-A full flag (driven by the b_rst-controlled comparator) must not be asserted
always_comb begin
  assert (!(top_b_rst && top_b_fifo_full));
end

// A single direction cannot simultaneously report full (write side) and empty (read side)
always_comb begin
  assert (!(top_b_fifo_full && top_a_fifo_empty));
end


//======================================================================
// Assertions for Signal: top_a_fifo_empty
// Primary label from model: top_a_fifo_empty
//======================================================================
// While side-B reset is asserted, the comparator that drives a_fifo_empty (same reset domain as b_fifo_full) must force empty active
always_comb begin
  assert (top_b_rst -> top_a_fifo_empty);
end
endmodule

