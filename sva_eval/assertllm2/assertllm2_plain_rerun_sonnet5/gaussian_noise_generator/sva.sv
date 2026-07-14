// method: plain_prompt

// Global checker bound to top module: gng
module gng_sva_global (
    input logic gng_ctg_ce,
    input logic gng_ctg_clk,
    input logic [63:0] gng_ctg_data_out,
    input logic gng_ctg_rstn,
    input logic gng_interp_clk,
    input logic [63:0] gng_interp_data_in,
    input logic [15:0] gng_interp_data_out,
    input logic gng_interp_rstn,
    input logic gng_interp_valid_in,
    input logic top_ce,
    input logic top_clk,
    input logic [15:0] top_data_out,
    input logic top_rstn,
    input logic top_valid_out
);

//======================================================================
// Assertions for Signal: gng_ctg_clk
// Primary label from model: gng_ctg_clk
//======================================================================
// Clock input to CTG submodule must match top-level clock (direct structural connection).
always_comb begin
  assert (gng_ctg_clk == top_clk);
end


//======================================================================
// Assertions for Signal: gng_ctg_rstn
// Primary label from model: gng_ctg_rstn
//======================================================================
// Reset input to CTG submodule must match top-level reset (direct structural connection).
always_comb begin
  assert (gng_ctg_rstn == top_rstn);
end


//======================================================================
// Assertions for Signal: gng_ctg_ce
// Primary label from model: gng_ctg_ce
//======================================================================
// Clock enable to CTG submodule must match top-level ce (direct structural connection controlling state advance).
always_comb begin
  assert (gng_ctg_ce == top_ce);
end


//======================================================================
// Assertions for Signal: gng_interp_clk
// Primary label from model: gng_interp_clk
//======================================================================
// Clock input to interpolation submodule must match top-level clock (single clock domain).
always_comb begin
  assert (gng_interp_clk == top_clk);
end


//======================================================================
// Assertions for Signal: gng_interp_rstn
// Primary label from model: gng_interp_rstn
//======================================================================
// Reset input to interpolation submodule must match top-level reset (single reset domain).
always_comb begin
  assert (gng_interp_rstn == top_rstn);
end


//======================================================================
// Assertions for Signal: gng_interp_data_in
// Primary label from model: gng_interp_data_in
//======================================================================
// Per spec 5.1: gng_ctg.data_out feeds gng_interp.data_in directly.
always_comb begin
  assert (gng_interp_data_in == gng_ctg_data_out);
end


//======================================================================
// Assertions for Signal: gng_interp_data_out
// Primary label from model: gng_interp_data_out
//======================================================================
// Top-level data_out is driven directly by the interpolation datapath output.
always_comb begin
  assert (gng_interp_data_out == top_data_out);
end

// Output sample must always be a defined value, per registered datapath logic requirement.
always_comb begin
  assert (!$isunknown(gng_interp_data_out));
end


//======================================================================
// Assertions for Signal: gng_ctg_data_out
// Primary label from model: gng_ctg_data_out
//======================================================================
// CTG output data register must always produce a defined 64-bit uniform random word.
always_comb begin
  assert (!$isunknown(gng_ctg_data_out));
end


//======================================================================
// Assertions for Signal: top_data_out
// Primary label from model: top_data_out
//======================================================================
// Output sample must be a valid, defined 16-bit signed fixed-point value at all times.
always_comb begin
  assert (!$isunknown(top_data_out));
end


//======================================================================
// Assertions for Signal: top_valid_out
// Primary label from model: top_valid_out
//======================================================================
// valid_out must always resolve to a legal, defined boolean value (no backpressure signal exists).
always_comb begin
  assert (!$isunknown(top_valid_out));
end
endmodule

