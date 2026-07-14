module TopModule #(
    parameter ADDRESS_WIDTH = 5,
    parameter DATA_WIDTH    = 32
) (
    input                           clk,
    input                           rst,
    input                           rg_wrt_en,
    input  [ADDRESS_WIDTH-1:0]      rg_wrt_dest,
    input  [ADDRESS_WIDTH-1:0]      rg_rd_addr1,
    input  [ADDRESS_WIDTH-1:0]      rg_rd_addr2,
    input  [DATA_WIDTH-1:0]         rg_wrt_data,
    output [DATA_WIDTH-1:0]         rg_rd_data1,
    output [DATA_WIDTH-1:0]         rg_rd_data2
);

    // Instantiate the register file, which internally implements:
    //  - Synchronous active-high reset clearing all 32 registers
    //    (@reset scenarios, including reset priority over write)
    //  - Clocked single write port (@write scenarios: write updates
    //    target register, leaves others untouched, no write when
    //    rg_wrt_en is deasserted)
    //  - Two combinational read ports (@read scenarios: independent
    //    addressing, same-address reads)
    //  - Write-read hazard behavior: reads reflect pre-write value
    //    during the write cycle, and updated value only after the
    //    clock edge (@write-read-hazard scenarios)
    //  - Value retention across cycles with no write/reset
    //    (@stability scenario)
    dut__RegisterFile u_RegisterFile (
        .clk          (clk),
        .rst          (rst),
        .rg_wrt_en    (rg_wrt_en),
        .rg_wrt_dest  (rg_wrt_dest),
        .rg_rd_addr1  (rg_rd_addr1),
        .rg_rd_addr2  (rg_rd_addr2),
        .rg_wrt_data  (rg_wrt_data),
        .rg_rd_data1  (rg_rd_data1),
        .rg_rd_data2  (rg_rd_data2)
    );

endmodule

module dut__RegisterFile (
    input               clk,
    input               rst,
    input               rg_wrt_en,
    input  [4:0]        rg_wrt_dest,
    input  [4:0]        rg_rd_addr1,
    input  [4:0]        rg_rd_addr2,
    input  [31:0]       rg_wrt_data,
    output [31:0]       rg_rd_data1,
    output [31:0]       rg_rd_data2
);

    // 32 internal 32-bit storage registers (index 0 to 31)
    reg [31:0] regs [0:31];

    integer i;

    // -------------------------------------------------------------------
    // Sequential write / reset logic
    // Scenarios covered:
    //   - Synchronous reset clears all registers (@reset @synchronous)
    //   - Reset overrides a simultaneous write (@reset @priority)
    //   - Write updates the targeted register when enabled (@write @update)
    //   - Write is ignored when write enable is deasserted (@write @no_write)
    //   - Write does not affect registers other than the destination
    //     (@write @isolation)
    //   - Read-before-write hazard: writes take effect only on the clock
    //     edge, so combinational reads reflect the old value beforehand
    //     (@read_before_write @hazard)
    // -------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Synchronous reset: clear all 32 registers, overrides any write
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'd0;
            end
        end else begin
            // Normal operation: write only when enabled, only to destination
            if (rg_wrt_en) begin
                regs[rg_wrt_dest] <= rg_wrt_data;
            end
            // else: no write, all registers retain their values
        end
    end

    // -------------------------------------------------------------------
    // Combinational read logic
    // Scenarios covered:
    //   - Read port 1 combinationally reflects addressed register
    //     (@read @combinational)
    //   - Read port 2 combinationally reflects addressed register
    //     (@read @combinational)
    //   - Read ports operate independently for distinct addresses
    //     (@read @independence)
    //   - Both read ports return same value for identical addresses
    //     (@read @same_address)
    // -------------------------------------------------------------------
    assign rg_rd_data1 = regs[rg_rd_addr1];
    assign rg_rd_data2 = regs[rg_rd_addr2];

endmodule
