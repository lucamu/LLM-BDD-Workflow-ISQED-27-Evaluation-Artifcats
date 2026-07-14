module TopModule #(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input  wclk,
	input  rclk,
	input  wrstn,
	input  rrstn,
	input  winc,
	input  rinc,
	input  [WIDTH-1:0] wdata,
	output wfull,
	output rempty,
	output [WIDTH-1:0] rdata
);
localparam ADDR_WIDTH = $clog2(DEPTH);
reg [ADDR_WIDTH:0] wptr;
reg [ADDR_WIDTH:0] rptr;
wire [ADDR_WIDTH-1:0] waddr;
wire [ADDR_WIDTH-1:0] raddr;
wire wclken;
wire rclken;
wire wfull_next;
wire rempty_next;
reg wclken_reg;
reg rclken_reg;
wire [WIDTH-1:0] wdata_reg;
wire [WIDTH-1:0] rdata_next;
wire wfull_r;
wire rempty_r;
wire wfull_w;
wire rempty_w;
dual_port_RAM #(
	.DEPTH(DEPTH),
	.WIDTH(WIDTH)
) dp_ram(
	.wclk(wclk),
	.wenc(wclken),
	.waddr(waddr),
	.wdata(wdata_reg),
	.rclk(rclk),
	.renc(rclken),
	.raddr(raddr),
	.rdata(rdata_next)
);
assign waddr = wptr[ADDR_WIDTH-1:0];
assign raddr = rptr[ADDR_WIDTH-1:0];
assign wclken = (wptr[ADDR_WIDTH] == rptr[ADDR_WIDTH]) && (waddr == raddr) ? 1'b0 : 1'b1;
assign rclken = (wptr[ADDR_WIDTH] == rptr[ADDR_WIDTH]) && (waddr == raddr) ? 1'b0 : 1'b1;
assign wdata_reg = wdata;
assign rdata = rdata_next;
assign wfull_next = (wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH-1]) && (waddr == raddr) ? 1'b1 : 1'b0;
assign rempty_next = (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]) && (wptr[ADDR_WIDTH] == rptr[ADDR_WIDTH]) ? 1'b1 : 1'b0;
assign wfull_r = wfull_next;
assign rempty_r = rempty_next;
assign wfull_w = wfull_next;
assign rempty_w = rempty_next;
always @(posedge wclk or negedge wrstn) begin
	if(!wrstn) begin
		wptr <= 0;
	end else begin
		if(wclken) begin
			wptr <= wptr + 1;
		end
	end
end
always @(posedge rclk or negedge rrstn) begin
	if(!rrstn) begin
		rptr <= 0;
	end else begin
		if(rclken) begin
			rptr <= rptr + 1;
		end
	end
end
always @(posedge wclk or negedge wrstn) begin
	if(!wrstn) begin
		wclken_reg <= 0;
	end else begin
		wclken_reg <= wclken;
	end
end
always @(posedge rclk or negedge rrstn) begin
	if(!rrstn) begin
		rclken_reg <= 0;
	end else begin
		rclken_reg <= rclken;
	end
end
assign wfull = wfull_r | wfull_w;
assign rempty = rempty_r | rempty_w;
endmodule
