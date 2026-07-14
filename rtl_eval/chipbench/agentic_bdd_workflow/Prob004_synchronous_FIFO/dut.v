module TopModule #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                      clk,
    input                      rst_n,
    input                      winc,
    input                      rinc,
    input      [WIDTH-1:0]     wdata,
    output                     wfull,
    output                     rempty,
    output     [WIDTH-1:0]     rdata
);

    // Address width derived from DEPTH
    localparam AW = $clog2(DEPTH);

    // Internal signals connecting pointer control and RAM
    wire [AW-1:0] waddr;
    wire [AW-1:0] raddr;
    wire          ram_wen;
    wire          ram_ren;

    //-------------------------------------------------------------------
    // Pointer / Flag control logic
    // Handles: @reset, @write, @read, @flags, @simultaneous,
    //          @pointer_wraparound, @mutual_exclusion
    //-------------------------------------------------------------------
    dut__fifo_pointer_ctrl #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ptr_ctrl (
        .clk     (clk),
        .rst_n   (rst_n),
        .winc    (winc),
        .rinc    (rinc),
        .wfull   (wfull),
        .rempty  (rempty),
        .waddr   (waddr),
        .raddr   (raddr),
        .ram_wen (ram_wen),
        .ram_ren (ram_ren)
    );

    //-------------------------------------------------------------------
    // Dual-port RAM backing store
    // Handles: @write (data committed on ram_wen), @read (data retrieved
    // on ram_ren), @data_integrity (FIFO-order data correctness)
    //-------------------------------------------------------------------
    dut__dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk  (clk),
        .wenc  (ram_wen),
        .waddr (waddr),
        .wdata (wdata),
        .rclk  (clk),
        .renc  (ram_ren),
        .raddr (raddr),
        .rdata (rdata)
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

module dut__fifo_pointer_ctrl #(
    parameter DEPTH = 16                      // FIFO depth (must be power of 2)
) (
    input                           clk,
    input                           rst_n,
    input                           winc,
    input                           rinc,
    output                          wfull,
    output                          rempty,
    output [$clog2(DEPTH)-1:0]     waddr,
    output [$clog2(DEPTH)-1:0]     raddr,
    output                          ram_wen,
    output                          ram_ren
);

    // -------------------------------------------------------------------
    // Local parameter: address width (DEPTH_LOG2 in specification)
    // -------------------------------------------------------------------
    localparam DEPTH_LOG2 = $clog2(DEPTH);

    // -------------------------------------------------------------------
    // Internal pointer registers (DEPTH_LOG2+1 bits wide)
    // -------------------------------------------------------------------
    reg [DEPTH_LOG2:0] wptr;
    reg [DEPTH_LOG2:0] rptr;

    // -------------------------------------------------------------------
    // Combinational flags
    // -------------------------------------------------------------------
    // @wfull_definition : wfull asserted when MSBs differ and lower bits match
    assign wfull  = (wptr[DEPTH_LOG2] != rptr[DEPTH_LOG2]) &&
                    (wptr[DEPTH_LOG2-1:0] == rptr[DEPTH_LOG2-1:0]);

    // @rempty_definition : rempty asserted when pointers are exactly equal
    assign rempty = (wptr == rptr);

    // @address_truncation : output addresses are lower DEPTH_LOG2 bits
    assign waddr = wptr[DEPTH_LOG2-1:0];
    assign raddr = rptr[DEPTH_LOG2-1:0];

    // @ram_wen_gating : ram_wen = winc AND NOT wfull
    assign ram_wen = winc & ~wfull;

    // @ram_ren_gating : ram_ren = rinc AND NOT rempty
    assign ram_ren = rinc & ~rempty;

    // -------------------------------------------------------------------
    // Sequential pointer update logic
    // -------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // @reset : synchronous reset (async assert) clears both pointers
            wptr <= {(DEPTH_LOG2+1){1'b0}};
            rptr <= {(DEPTH_LOG2+1){1'b0}};
        end else begin
            // ----------------------------------------------------------
            // Write pointer update
            // ----------------------------------------------------------
            if (winc && !wfull) begin
                // @write_increment / @simultaneous_access / @empty_to_nonempty_transition
                wptr <= wptr + 1'b1;
            end else begin
                // @write_hold_when_full / @write_hold_when_no_request / @no_overflow_safety
                wptr <= wptr;
            end

            // ----------------------------------------------------------
            // Read pointer update
            // ----------------------------------------------------------
            if (rinc && !rempty) begin
                // @read_increment / @simultaneous_access / @full_to_nonfull_transition
                rptr <= rptr + 1'b1;
            end else begin
                // @read_hold_when_empty / @read_hold_when_no_request / @no_underflow_safety
                rptr <= rptr;
            end
        end
    end

endmodule
