// ============================================================================
// Module: TopModule
// Purpose: Dual-Port RAM with 8 locations of 4-bit width.
//          Supports independent, simultaneous read (combinational) and
//          write (registered) operations. Asynchronous active-low reset
//          clears all memory locations to 4'b0000.
// ============================================================================
module TopModule (
    input        clk,
    input        rst_n,
    input        write_en,
    input  [7:0] write_addr,
    input  [3:0] write_data,
    input        read_en,
    input  [7:0] read_addr,
    output [3:0] read_data
);

    // ------------------------------------------------------------------------
    // Memory array: 8 locations, 4 bits wide.
    // Only the lower 3 bits of the 8-bit address are used since there
    // are only 8 valid locations (0-7). Upper bits are don't-care.
    // ------------------------------------------------------------------------
    reg [3:0] mem [0:7];

    integer i;

    // ------------------------------------------------------------------------
    // Sequential write / reset logic
    // Covers scenarios:
    //   - @reset @async: Asynchronous reset clears all memory locations
    //   - @write @basic: Write operation updates target memory location
    //   - @write @disabled: Memory unchanged when write is disabled
    //   - @read @write @independent_addresses: write updates only WADDR
    //   - @read @write @same_address_collision: write updates after edge
    //   - @write @multiple_addresses @independence: other addresses unaffected
    //   - @read @disabled: memory unmodified when only read asserted
    //   - @write @sequential @persistence: written data persists
    //   - @reset @write @priority: async reset overrides pending write
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset @async / @reset @write @priority
            // Asynchronous reset forces all memory locations to 0,
            // regardless of clk edge or any pending write.
            for (i = 0; i < 8; i = i + 1) begin
                mem[i] <= 4'b0000;
            end
        end else begin
            // @write @basic / @write @disabled / independence scenarios
            if (write_en) begin
                // Only the addressed location is updated; all others
                // implicitly retain their previous values (independence).
                mem[write_addr[2:0]] <= write_data;
            end
            // else: write_en == 0 -> no memory location changes
            // (@write @disabled, @read @disabled scenarios satisfied
            //  since no assignment occurs to any mem[i])
        end
    end

    // ------------------------------------------------------------------------
    // Combinational read logic
    // Covers scenarios:
    //   - @reset @read_after_reset: read returns 0 after reset
    //   - @read @basic: read returns stored value
    //   - @read @write @independent_addresses: read unaffected by write
    //     to a different address in same cycle
    //   - @read @write @same_address_collision: read returns pre-write
    //     (OLD_DATA) value since read is combinational and reflects
    //     mem contents before the clock edge updates it
    // ------------------------------------------------------------------------
    assign read_data = (read_en) ? mem[read_addr[2:0]] : 4'b0000;

endmodule