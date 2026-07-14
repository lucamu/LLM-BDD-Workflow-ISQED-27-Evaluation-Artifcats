// method: plain_prompt

// Global checker bound to top module: rtcclock
module rtcclock_sva_global (
    input logic hexmap_i_clk,
    input logic [3:0] hexmap_i_hex,
    input logic [6:0] hexmap_o_map,
    input logic top_i_clk,
    input logic top_i_hack,
    input logic [2:0] top_i_wb_addr,
    input logic top_i_wb_cyc,
    input logic [31:0] top_i_wb_data,
    input logic top_i_wb_stb,
    input logic top_i_wb_we,
    input logic [31:0] top_o_data,
    input logic top_o_interrupt,
    input logic [15:0] top_o_led,
    input logic [31:0] top_o_sseg
);

//======================================================================
// Assertions for Signal: top_i_wb_addr
// Primary label from model: top_i_wb_addr
//======================================================================
// Address is 3-bit word select; must always resolve to one of the 8 defined registers
always_comb begin
  assert (top_i_wb_addr <= 3'b111);
end

// Address must be a known value whenever a bus cycle/strobe is active (stable-address constraint)
always_comb begin
  if (top_i_wb_cyc && top_i_wb_stb)
    assert (!$isunknown(top_i_wb_addr));
end


//======================================================================
// Assertions for Signal: top_i_wb_we
// Primary label from model: top_i_wb_we
//======================================================================
// Write-enable qualifier must be a known, stable-defined value during an active bus cycle
always_comb begin
  if (top_i_wb_cyc && top_i_wb_stb)
    assert (!$isunknown(top_i_wb_we));
end

// A write access is only legally qualified when cyc and stb are both asserted together with we
always_comb begin
  if (top_i_wb_we && !(top_i_wb_cyc && top_i_wb_stb))
    assert (1'b1); // we alone without cyc/stb must not be treated as an accepted write
end


//======================================================================
// Assertions for Signal: top_i_wb_data
// Primary label from model: top_i_wb_data
//======================================================================
// Write data must be a known value during an accepted write access
always_comb begin
  if (top_i_wb_cyc && top_i_wb_stb && top_i_wb_we)
    assert (!$isunknown(top_i_wb_data));
end


//======================================================================
// Assertions for Signal: top_o_data
// Primary label from model: top_o_data
//======================================================================
// Read data output must be a known value whenever a valid read access is selected
always_comb begin
  if (top_i_wb_cyc && top_i_wb_stb && !top_i_wb_we)
    assert (!$isunknown(top_o_data));
end

// Read data bus is 32-bit wide per the register map; must never exceed representable width
always_comb begin
  assert (top_o_data == (top_o_data & 32'hFFFF_FFFF));
end


//======================================================================
// Assertions for Signal: top_o_interrupt
// Primary label from model: top_o_interrupt
//======================================================================
// Interrupt output is a single-bit pulse indication and must never be unknown
always_comb begin
  assert (!$isunknown(top_o_interrupt));
end

// Interrupt output must be a legal boolean value (0 or 1)
always_comb begin
  assert (top_o_interrupt === 1'b0 || top_o_interrupt === 1'b1);
end


//======================================================================
// Assertions for Signal: top_o_sseg
// Primary label from model: top_o_sseg
//======================================================================
// Seven-segment output payload must always resolve to a known value
always_comb begin
  assert (!$isunknown(top_o_sseg));
end

// Seven-segment output is 32-bit wide (4 digits x 8 bits including decimal point control)
always_comb begin
  assert (top_o_sseg == (top_o_sseg & 32'hFFFF_FFFF));
end


//======================================================================
// Assertions for Signal: top_o_led
// Primary label from model: top_o_led
//======================================================================
// LED status output must always resolve to a known value
always_comb begin
  assert (!$isunknown(top_o_led));
end

// LED output is 16-bit wide per the interface definition
always_comb begin
  assert (top_o_led == (top_o_led & 16'hFFFF));
end


//======================================================================
// Assertions for Signal: top_i_hack
// Primary label from model: top_i_hack
//======================================================================
// Hack strobe input must be a known, legal boolean value at all times
always_comb begin
  assert (top_i_hack === 1'b0 || top_i_hack === 1'b1);
end


//======================================================================
// Assertions for Signal: hexmap_o_map
// Primary label from model: hexmap_o_map
//======================================================================
// Segment enable pattern output from hexmap must always be a known value
always_comb begin
  assert (!$isunknown(hexmap_o_map));
end

// Segment pattern is 7 bits wide (o_map[7:1]); must not exceed representable width
always_comb begin
  assert (hexmap_o_map == (hexmap_o_map & 7'h7F));
end


//======================================================================
// Assertions for Signal: hexmap_i_hex
// Primary label from model: hexmap_i_hex
//======================================================================
// Hexadecimal nibble input to hexmap must always be a known 4-bit value
always_comb begin
  assert (!$isunknown(hexmap_i_hex));
end
endmodule

