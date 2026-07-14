module TopModule #(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input clk,
	input rst_n,
	input winc,
	input rinc,
	input [WIDTH-1:0] wdata,
	output wfull,
	output rempty,
	output [WIDTH-1:0] rdata
);
reg [$clog2(DEPTH):0] wptr,rptr;
wire wclk,rclk;
wire [$clog2(DEPTH)-1:0] waddr,raddr;
wire wen,rin;
assign wclk = clk;
assign rclk = clk;
assign wen = winc & (~wfull);
assign rin = rinc & (~rempty);
assign waddr = wptr[$clog2(DEPTH)-1:0];
assign raddr = rptr[$clog2(DEPTH)-1:0];
assign wfull = (wptr[$clog2(DEPTH)] != rptr[$clog2(DEPTH)]) & (wptr[$clog2(DEPTH)-1:0] == rptr[$clog2(DEPTH)-1:0]);
assign rempty = (wptr == rptr);
always @(posedge wclk or negedge rst_n) begin
	if(!rst_n) begin
		wptr <= 0;
	end
	else if(wen) begin
		wptr <= wptr + 1;
	end
end
always @(posedge rclk or negedge rst_n) begin
	if(!rst_n) begin
		rptr <= 0;
	end
	else if(rin) begin
		rptr <= rptr + 1;
	end
end
dual_port_RAM #(
	.DEPTH(DEPTH),
	.WIDTH(WIDTH)
) dpram (
	.wclk(wclk),
	.wenc(wen),
	.waddr(waddr),
	.wdata(wdata),
	.rclk(rclk),
	.renc(rin),
	.raddr(raddr),
	.rdata(rdata)
);
endmodule
