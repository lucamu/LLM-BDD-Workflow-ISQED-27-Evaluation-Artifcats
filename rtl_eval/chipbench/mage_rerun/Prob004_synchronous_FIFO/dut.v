module dual_port_RAM #(parameter DEPTH = 16,
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


module TopModule (
    input  logic clk,
    input  logic rst_n,
    input  logic winc,
    input  logic rinc,
    input  logic [7:0] wdata,
    output logic wfull,
    output logic rempty,
    output logic [7:0] rdata
);

    localparam DEPTH = 16;
    localparam WIDTH = 8;
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Pointers with one extra bit for full/empty detection
    logic [ADDR_WIDTH:0] wptr;
    logic [ADDR_WIDTH:0] rptr;

    logic wenc;
    logic renc;

    logic [ADDR_WIDTH-1:0] waddr;
    logic [ADDR_WIDTH-1:0] raddr;

    // Full/empty detection based on pointer comparison
    assign wfull  = (wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH]) &&
                    (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]);
    assign rempty = (wptr == rptr);

    // Qualified enables so we never write when full or read when empty
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    assign waddr = wptr[ADDR_WIDTH-1:0];
    assign raddr = rptr[ADDR_WIDTH-1:0];

    // Write pointer update
    always @(posedge clk) begin
        if (!rst_n)
            wptr <= '0;
        else if (wenc)
            wptr <= wptr + 1'b1;
    end

    // Read pointer update
    always @(posedge clk) begin
        if (!rst_n)
            rptr <= '0;
        else if (renc)
            rptr <= rptr + 1'b1;
    end

    // Dual-port RAM instance for actual data storage
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk  (clk),
        .wenc  (wenc),
        .waddr (waddr),
        .wdata (wdata),
        .rclk  (clk),
        .renc  (renc),
        .raddr (raddr),
        .rdata (rdata)
    );

endmodule