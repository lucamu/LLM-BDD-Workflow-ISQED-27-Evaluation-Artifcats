//=============================================================================
// Module: TopModule
// Purpose: Asynchronous FIFO with dual-port RAM and clock-domain-crossing
//          Gray-code pointer synchronization between write (wclk) and
//          read (rclk) domains. Implements all scenarios from the spec:
//          reset behavior, pointer increment/hold, full/empty flag
//          generation, Gray-code synchronization, and data integrity.
//=============================================================================
module TopModule #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDRWIDTH = $clog2(DEPTH)
) (
    input                    wclk,
    input                    rclk,
    input                    wrstn,
    input                    rrstn,
    input                    winc,
    input                    rinc,
    input      [WIDTH-1:0]   wdata,
    output                   wfull,
    output                   rempty,
    output     [WIDTH-1:0]   rdata
);

    // -------------------------------------------------------------------
    // Internal wires connecting the sub-modules
    // -------------------------------------------------------------------
    wire [ADDRWIDTH-1:0] waddr;          // write address into RAM
    wire [ADDRWIDTH-1:0] raddr;          // read address into RAM
    wire [ADDRWIDTH:0]   wptr_gray;      // write pointer, Gray coded
    wire [ADDRWIDTH:0]   rptr_gray;      // read pointer, Gray coded
    wire [ADDRWIDTH:0]   wptr_sync;      // write pointer synchronized into read domain
    wire [ADDRWIDTH:0]   rptr_sync;      // read pointer synchronized into write domain

    // -------------------------------------------------------------------
    // Scenario: @reset @write_domain - write pointer handler clears wptr
    // and forces wfull=0 on wrstn deassertion. Also handles pointer
    // increment / hold-on-full / hold-when-disabled scenarios, and
    // Gray-code one-bit transition scenario, and full-flag correctness.
    // -------------------------------------------------------------------
    dut__write_pointer_handler #(
        .ADDRWIDTH(ADDRWIDTH)
    ) u_write_pointer_handler (
        .wclk       (wclk),
        .wrstn      (wrstn),
        .winc       (winc),
        .rptr_sync  (rptr_sync),
        .wfull      (wfull),
        .waddr      (waddr),
        .wptr_gray  (wptr_gray)
    );

    // -------------------------------------------------------------------
    // Scenario: @reset @read_domain - read pointer handler clears rptr
    // and forces rempty=1 on rrstn deassertion. Also handles pointer
    // increment / hold-on-empty / hold-when-disabled scenarios, and
    // Gray-code one-bit transition scenario, and empty-flag correctness.
    // -------------------------------------------------------------------
    dut__read_pointer_handler #(
        .ADDRWIDTH(ADDRWIDTH)
    ) u_read_pointer_handler (
        .rclk       (rclk),
        .rrstn      (rrstn),
        .rinc       (rinc),
        .wptr_sync  (wptr_sync),
        .rempty     (rempty),
        .raddr      (raddr),
        .rptr_gray  (rptr_gray)
    );

    // -------------------------------------------------------------------
    // Scenario: @gray_code @synchronizer - Write pointer Gray code
    // synchronized into read domain via 2-flop synchronizer (sync_w2r)
    // -------------------------------------------------------------------
    dut__sync_w2r #(
        .ADDRWIDTH(ADDRWIDTH)
    ) u_sync_w2r (
        .rclk       (rclk),
        .rrstn      (rrstn),
        .wptr_gray  (wptr_gray),
        .wptr_sync  (wptr_sync)
    );

    // -------------------------------------------------------------------
    // Scenario: @gray_code @synchronizer - Read pointer Gray code
    // synchronized into write domain via 2-flop synchronizer (sync_r2w)
    // -------------------------------------------------------------------
    dut__sync_r2w #(
        .ADDRWIDTH(ADDRWIDTH)
    ) u_sync_r2w (
        .wclk       (wclk),
        .wrstn      (wrstn),
        .rptr_gray  (rptr_gray),
        .rptr_sync  (rptr_sync)
    );

    // -------------------------------------------------------------------
    // Scenario: @write @pointer_increment / @data_integrity @fifo_order
    // Dual-port RAM stores write data at waddr when winc & !wfull,
    // and provides read data at raddr for the read domain.
    // -------------------------------------------------------------------
    dut__dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk   (wclk),
        .wenc   (winc & ~wfull),   // only write when enabled and not full
        .waddr  (waddr),
        .wdata  (wdata),
        .rclk   (rclk),
        .renc   (rinc & ~rempty),  // only read when enabled and not empty
        .raddr  (raddr),
        .rdata  (rdata)
    );

endmodule

module dut__dual_port_RAM #(parameter DEPTH = 16,
   parameter WIDTH = 8)(
 input wclk
,input wenc
,input [$clog2(DEPTH)-1:0] waddr
,input [WIDTH-1:0] wdata
,input rclk
,input renc
,input [$clog2(DEPTH)-1:0] raddr
,output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
if(wenc)
RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
if(renc)
rdata <= RAM_MEM[raddr];
end 

endmodule

module dut__write_pointer_handler #(
    parameter ADDRWIDTH = 4
) (
    input                       wclk,
    input                       wrstn,
    input                       winc,
    input      [ADDRWIDTH:0]    rptr_sync,
    output                      wfull,
    output     [ADDRWIDTH-1:0]  waddr,
    output     [ADDRWIDTH:0]    wptr_gray
);

    // -------------------------------------------------------------------
    // Internal registers: binary pointer, Gray pointer, full flag
    // -------------------------------------------------------------------
    reg [ADDRWIDTH:0] wbin;        // current binary write pointer
    reg [ADDRWIDTH:0] wptr_gray_r; // current registered Gray write pointer
    reg               wfull_r;     // current registered full flag

    // -------------------------------------------------------------------
    // Combinational: next binary pointer value
    // wbin_next = wbin + (winc AND NOT wfull)
    // Scenarios: @increment, @hold, @no_overflow_when_full
    // -------------------------------------------------------------------
    wire [ADDRWIDTH:0] wbin_next;
    assign wbin_next = wbin + ((winc && !wfull_r) ? 1'b1 : 1'b0);

    // -------------------------------------------------------------------
    // Combinational: next Gray pointer value (binary-to-Gray conversion)
    // wgray_next = (wbin_next >> 1) ^ wbin_next
    // Scenarios: @gray_conversion
    // -------------------------------------------------------------------
    wire [ADDRWIDTH:0] wgray_next;
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;

    // -------------------------------------------------------------------
    // Combinational: full detection pattern
    // Compare wgray_next against rptr_sync with two MSBs inverted and
    // remaining lower bits identical.
    // Scenarios: @full_detection
    // -------------------------------------------------------------------
    wire [ADDRWIDTH:0] full_compare_pattern;
    assign full_compare_pattern = {~rptr_sync[ADDRWIDTH],
                                    ~rptr_sync[ADDRWIDTH-1],
                                    rptr_sync[ADDRWIDTH-2:0]};

    wire wfull_next;
    assign wfull_next = (wgray_next == full_compare_pattern);

    // -------------------------------------------------------------------
    // Sequential logic: update binary pointer, Gray pointer, full flag
    // Scenarios: @reset, @increment, @hold, @gray_conversion,
    //            @full_detection, @gray_property, @no_overflow_when_full
    // -------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            // @reset: Synchronous reset clears binary and Gray write pointers
            wbin        <= {(ADDRWIDTH+1){1'b0}};
            wptr_gray_r <= {(ADDRWIDTH+1){1'b0}};
            wfull_r     <= 1'b0;
        end else begin
            // @increment/@hold/@no_overflow_when_full: update binary pointer
            wbin <= wbin_next;

            // @gray_conversion: update Gray pointer independent of prior value
            wptr_gray_r <= wgray_next;

            // @full_detection: update full flag based on next Gray pointer
            wfull_r <= wfull_next;
        end
    end

    // -------------------------------------------------------------------
    // Output assignments
    // -------------------------------------------------------------------

    // @address: waddr is the lower ADDRWIDTH bits of the current binary pointer
    assign waddr = wbin[ADDRWIDTH-1:0];

    // @synchronization_output: wptr_gray reflects registered Gray pointer
    assign wptr_gray = wptr_gray_r;

    // wfull reflects registered full flag
    assign wfull = wfull_r;

endmodule

module dut__read_pointer_handler #(
    parameter ADDRWIDTH = 4,
    parameter PTRWIDTH  = ADDRWIDTH + 1
) (
    input                       rclk,
    input                       rrstn,
    input                       rinc,
    input      [ADDRWIDTH:0]    wptr_sync,
    output                      rempty,
    output     [ADDRWIDTH-1:0]  raddr,
    output     [ADDRWIDTH:0]    rptr_gray
);

    // -------------------------------------------------------------------------
    // Internal registers
    // -------------------------------------------------------------------------
    reg [PTRWIDTH-1:0] rptr_bin;    // Binary read pointer
    reg [PTRWIDTH-1:0] rptr_gray_r; // Gray-coded read pointer (registered)

    // Next-state binary pointer computed combinationally
    reg [PTRWIDTH-1:0] rptr_bin_next;
    reg [PTRWIDTH-1:0] rptr_gray_next;

    // -------------------------------------------------------------------------
    // @empty_detection / @empty_detection_negative
    // Empty flag: asserted when Gray pointers match (registered gray vs
    // synchronized write gray pointer). Combinational comparison.
    // -------------------------------------------------------------------------
    assign rempty = (rptr_gray_r == wptr_sync);

    // -------------------------------------------------------------------------
    // Combinational next-state logic
    // -------------------------------------------------------------------------
    always @(*) begin
        // @increment: increment when read requested and FIFO not empty
        // @no_increment_rinc_low / @no_increment_when_empty: hold otherwise
        if (rinc && !rempty) begin
            rptr_bin_next = rptr_bin + 1'b1;
        end else begin
            rptr_bin_next = rptr_bin;
        end

        // @gray_conversion: gray(x) = x XOR (x >> 1)
        rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);
    end

    // -------------------------------------------------------------------------
    // Sequential logic: registers update on rising edge of rclk
    // -------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            // @reset: synchronous (active-low async) reset clears pointers
            rptr_bin    <= {PTRWIDTH{1'b0}};
            rptr_gray_r <= {PTRWIDTH{1'b0}};
        end else begin
            // @increment / @no_increment_rinc_low / @no_increment_when_empty
            // @synchronization_output: gray pointer stable when no increment
            rptr_bin    <= rptr_bin_next;
            rptr_gray_r <= rptr_gray_next;
        end
    end

    // -------------------------------------------------------------------------
    // @address_output: raddr reflects lower ADDRWIDTH bits of binary pointer
    // -------------------------------------------------------------------------
    assign raddr = rptr_bin[ADDRWIDTH-1:0];

    // -------------------------------------------------------------------------
    // @gray_conversion / @synchronization_output: registered Gray pointer output
    // -------------------------------------------------------------------------
    assign rptr_gray = rptr_gray_r;

endmodule

module dut__sync_r2w #(
    parameter ADDRWIDTH = 3
) (
    input                       wclk,       // write domain clock
    input                       wrstn,      // active-low reset (async)
    input      [ADDRWIDTH:0]    rptr_gray,  // gray-coded read pointer (rclk domain)
    output     [ADDRWIDTH:0]    rptr_sync   // synchronized pointer in wclk domain
);

    // Internal synchronizer stages
    reg [ADDRWIDTH:0] stage1_q;
    reg [ADDRWIDTH:0] stage2_q;

    //-------------------------------------------------------------------
    // Sequential logic: two-stage synchronizer
    //
    // @reset: Both stages clear to 0 when wrstn is asserted (active-low)
    // @capture: stage1_q captures rptr_gray, stage2_q captures stage1_q
    // @propagation: two-cycle latency from rptr_gray to rptr_sync
    // @hold: registers only update on wclk rising edges
    // @no_reset: normal shift resumes once wrstn deasserts
    // @stability: rptr_sync (stage2_q) only changes on wclk edges
    // @determinism: output is pure function of 2-cycle delayed input
    //-------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            // Reset scenario: clear both synchronizer stages
            stage1_q <= {(ADDRWIDTH+1){1'b0}};
            stage2_q <= {(ADDRWIDTH+1){1'b0}};
        end else begin
            // Normal operation: shift gray pointer through two FF stages
            stage1_q <= rptr_gray;   // Capture scenario: first stage samples input
            stage2_q <= stage1_q;    // Capture scenario: second stage samples first stage
        end
    end

    // Output assignment: rptr_sync equals the second stage register
    assign rptr_sync = stage2_q;

endmodule

module dut__sync_w2r #(
    parameter ADDRWIDTH = 3
) (
    input                       rclk,
    input                       rrstn,
    input      [ADDRWIDTH:0]    wptr_gray,
    output     [ADDRWIDTH:0]    wptr_sync
);

    // Internal synchronizer stages
    reg [ADDRWIDTH:0] stage1_reg;      // First synchronizer flip-flop stage
    reg [ADDRWIDTH:0] wptr_sync_reg;   // Second synchronizer flip-flop stage

    // wptr_sync is directly driven by the second stage register
    // (no combinational bypass - satisfies @no-combinational-bypass scenario)
    assign wptr_sync = wptr_sync_reg;

    //-------------------------------------------------------------------
    // Sequential logic: two-stage synchronizer
    // Implements:
    //   @reset @synchronous-clear
    //   @capture-stage1 @normal-operation
    //   @capture-stage2 @pipeline-behavior
    //   @two-cycle-latency @propagation
    //   @reset-priority @override
    //   @stability @hold-value
    //-------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            // Scenario: Reset clears both synchronizer stages
            // Scenario: Reset overrides capture regardless of write pointer value
            stage1_reg    <= {(ADDRWIDTH+1){1'b0}};
            wptr_sync_reg <= {(ADDRWIDTH+1){1'b0}};
        end else begin
            // Scenario: First stage captures write pointer gray value
            stage1_reg    <= wptr_gray;

            // Scenario: Second stage captures previous value of first stage
            // Scenario: Two-cycle latency propagation
            // Scenario: Stability - output holds steady when input is constant
            wptr_sync_reg <= stage1_reg;
        end
    end

endmodule
