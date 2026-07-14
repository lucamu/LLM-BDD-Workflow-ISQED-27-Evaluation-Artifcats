// method: plain_prompt

// Global checker bound to top module: light8080
module light8080_sva_global (
    input logic micro_rom_clock,
    input logic [8:0] micro_rom_uc_addr,
    input logic [31:0] micro_rom_uc_dout,
    input logic [15:0] top_addr_out,
    input logic top_clk,
    input logic [7:0] top_data_in,
    input logic [7:0] top_data_out,
    input logic top_fetch,
    input logic top_halt,
    input logic top_inta,
    input logic top_inte,
    input logic top_intr,
    input logic top_io,
    input logic [8:0] top_next_uc_addr,
    input logic top_rd,
    input logic top_reset,
    input logic [31:0] top_ucode,
    input logic top_vma,
    input logic top_wr
);

//======================================================================
// Assertions for Signal: top_vma
// Primary label from model: top_vma
//======================================================================
// io, rd, and wr are only meaningful when vma=1; they must not be asserted
// without an active master transaction
always_comb begin
  // rd qualifier requires an active transaction
  assert (!top_rd || top_vma);
  // wr qualifier requires an active transaction
  assert (!top_wr || top_vma);
  // io qualifier requires an active transaction
  assert (!top_io || top_vma);
  // opcode fetch is always an active external access
  assert (!top_fetch || top_vma);
  // interrupt-acknowledge vector fetch is always an active external access
  assert (!top_inta || top_vma);
end


//======================================================================
// Assertions for Signal: top_rd
// Primary label from model: top_rd
//======================================================================
// rd and wr are direction qualifiers for a single access and are mutually exclusive
always_comb begin
  // a cycle cannot be both a read and a write
  assert (!(top_rd && top_wr));
  // opcode fetch is always a read cycle
  assert (!top_fetch || top_rd);
end


//======================================================================
// Assertions for Signal: top_wr
// Primary label from model: top_wr
//======================================================================
// fetch and interrupt-acknowledge cycles are read-only, never writes
always_comb begin
  // opcode fetch never performs a write
  assert (!top_fetch || !top_wr);
  // interrupt-acknowledge vector retrieval never performs a write
  assert (!top_inta || !top_wr);
end


//======================================================================
// Assertions for Signal: top_io
// Primary label from model: top_io
//======================================================================
// fetch and interrupt-acknowledge cycles access program memory, not I/O space
always_comb begin
  // opcode fetch is a memory access, not I/O
  assert (!top_fetch || !top_io);
  // interrupt-acknowledge vector fetch is a memory access, not I/O
  assert (!top_inta || !top_io);
end


//======================================================================
// Assertions for Signal: top_inta
// Primary label from model: top_inta
//======================================================================
// interrupt-acknowledge vector retrieval is a read cycle
always_comb begin
  // inta implies a read qualifier on the active access
  assert (!top_inta || top_rd);
end


//======================================================================
// Assertions for Signal: top_halt
// Primary label from model: top_halt
//======================================================================
// halt loop entry and interrupt-acknowledge instruction flow are mutually exclusive states
always_comb begin
  // halt and interrupt-acknowledge cannot be asserted simultaneously
  assert (!(top_halt && top_inta));
end


//======================================================================
// Assertions for Signal: top_reset
// Primary label from model: top_reset
//======================================================================
// reset initializes visible status outputs; while reset is active, no external
// access or interrupt/halt status should be indicated
always_comb begin
  // no active external transaction while reset is asserted
  assert (!top_reset || !top_vma);
  // halt status is cleared while reset is asserted
  assert (!top_reset || !top_halt);
  // interrupt-acknowledge status is cleared while reset is asserted
  assert (!top_reset || !top_inta);
end


//======================================================================
// Assertions for Signal: top_next_uc_addr
// Primary label from model: top_next_uc_addr
//======================================================================
// the microcode address computed by the core drives the microcode ROM address port
always_comb begin
  // next_uc_addr must match the address presented to the microcode ROM
  assert (top_next_uc_addr == micro_rom_uc_addr);
end


//======================================================================
// Assertions for Signal: top_ucode
// Primary label from model: top_ucode
//======================================================================
// the microinstruction used by the core must match the microcode ROM output
always_comb begin
  // ucode must reflect the registered microinstruction from the microcode ROM
  assert (top_ucode == micro_rom_uc_dout);
end
endmodule

