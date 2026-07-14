//---------------------------------------------------------------------------------------
// uart to internal bus top module 
//
//---------------------------------------------------------------------------------------

module uart2bus_top 
(
	// global signals 
	clock, reset,
	// uart serial signals 
	ser_in, ser_out,
	// internal bus to register file 
	int_address, int_wr_data, int_write,
	int_rd_data, int_read, 
	int_req, int_gnt 
);
//---------------------------------------------------------------------------------------
// modules inputs and outputs 
input 			clock;			// global clock input 
input 			reset;			// global reset input 
input			ser_in;			// serial data input 
output			ser_out;		// serial data output 
output	[15:0]	int_address;	// address bus to register file 
output	[7:0]	int_wr_data;	// write data to register file 
output			int_write;		// write control to register file 
output			int_read;		// read control to register file 
input	[7:0]	int_rd_data;	// data read from register file 
output			int_req;		// bus access request signal 
input			int_gnt;		// bus access grant signal 

// baud rate configuration, see baud_gen.v for more details.
// baud rate generator parameters for 115200 baud on 40MHz clock 
`define D_BAUD_FREQ			12'h90
`define D_BAUD_LIMIT		16'h0ba5
// baud rate generator parameters for 115200 baud on 44MHz clock 
// `define D_BAUD_FREQ			12'd23
// `define D_BAUD_LIMIT		16'd527
// baud rate generator parameters for 9600 baud on 66MHz clock 
//`define D_BAUD_FREQ		12'h10
//`define D_BAUD_LIMIT		16'h1ACB

// internal wires 
wire	[7:0]	tx_data;		// data byte to transmit 
wire			new_tx_data;	// asserted to indicate that there is a new data byte for transmission 
wire 			tx_busy;		// signs that transmitter is busy 
wire	[7:0]	rx_data;		// data byte received 
wire 			new_rx_data;	// signs that a new byte was received 
wire	[11:0]	baud_freq;
wire	[15:0]	baud_limit;
wire			baud_clk;

//---------------------------------------------------------------------------------------
// module implementation 
// uart top module instance 
uart_top uart1
(
	.clock(clock), .reset(reset),
	.ser_in(ser_in), .ser_out(ser_out),
	.rx_data(rx_data), .new_rx_data(new_rx_data), 
	.tx_data(tx_data), .new_tx_data(new_tx_data), .tx_busy(tx_busy), 
	.baud_freq(baud_freq), .baud_limit(baud_limit),
	.baud_clk(baud_clk) 
);

// assign baud rate default values 
assign baud_freq = `D_BAUD_FREQ;
assign baud_limit = `D_BAUD_LIMIT;

// uart parser instance 
uart_parser #(16) uart_parser1
(
	.clock(clock), .reset(reset),
	.rx_data(rx_data), .new_rx_data(new_rx_data), 
	.tx_data(tx_data), .new_tx_data(new_tx_data), .tx_busy(tx_busy), 
	.int_address(int_address), .int_wr_data(int_wr_data), .int_write(int_write),
	.int_rd_data(int_rd_data), .int_read(int_read), 
	.int_req(int_req), .int_gnt(int_gnt) 
);

// --- Formal assertions ---
// AssertionForge baseline SVA for uart
// 246 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge clock) int_write |=> !int_write;
endproperty
assert property(af_p0);

property af_p1;
@(posedge clock) int_gnt |=> !int_req;
endproperty
assert property(af_p1);

property af_p2;
@(posedge clock) int_req |-> int_req throughout (int_gnt[->1]);
endproperty
assert property(af_p2);

property af_p3;
@(posedge clock) int_req |-> ##[1:$] int_gnt;
endproperty
assert property(af_p3);

property af_p4;
@(posedge clock) !(int_write && int_read);
endproperty
assert property(af_p4);

property af_p5;
@(posedge clock) !int_read |=> $stable(int_rd_data);
endproperty
assert property(af_p5);

property af_p6;
@(posedge clock) (int_req && !int_gnt) |-> int_req throughout (int_gnt[->1]);
endproperty
assert property(af_p6);

property af_p7;
@(posedge clock) !int_req |=> !int_gnt;
endproperty
assert property(af_p7);

property af_p8;
@(posedge clock) $rose(int_read) |=> !$isunknown(int_rd_data);
endproperty
assert property(af_p8);

property af_p9;
@(posedge clock) int_req |-> ##[1:16] int_gnt;
endproperty
assert property(af_p9);

property af_p10;
@(posedge clock) int_read |=> !int_read;
endproperty
assert property(af_p10);

property af_p11;
@(posedge clock) int_write |-> $stable(int_wr_data);
endproperty
assert property(af_p11);

property af_p12;
@(posedge clock) int_read |=> !$isunknown(int_rd_data);
endproperty
assert property(af_p12);

property af_p13;
@(posedge clock) int_req |-> (int_req until int_gnt);
endproperty
assert property(af_p13);

property af_p14;
@(posedge clock) !(int_read && int_write);
endproperty
assert property(af_p14);


























property af_p40;
@(posedge clock) (!int_read) |-> $stable(int_rd_data);
endproperty
assert property(af_p40);







property af_p47;
@(posedge clock) (int_gnt) |-> (!int_req);
endproperty
assert property(af_p47);

property af_p48;
@(posedge clock) (int_req && !int_gnt) |=> (int_req);
endproperty
assert property(af_p48);

property af_p49;
@(posedge clock) (!int_gnt) |-> (int_req);
endproperty
assert property(af_p49);

property af_p50;
@(posedge clock) (int_gnt) |-> (!$rose(int_req) && !$fell(int_req));
endproperty
assert property(af_p50);

property af_p51;
@(posedge clock) ($fell(int_gnt)) |=> (int_req);
endproperty
assert property(af_p51);

property af_p52;
@(posedge clock) (int_req) |-> (int_req until_with int_gnt);
endproperty
assert property(af_p52);

property af_p53;
@(posedge clock) (int_read) |-> (int_gnt);
endproperty
assert property(af_p53);

property af_p54;
@(posedge clock) ($rose(int_gnt)) |=> (!int_req);
endproperty
assert property(af_p54);

property af_p55;
@(posedge clock) (int_write) |-> ($past(int_gnt));
endproperty
assert property(af_p55);

property af_p56;
@(posedge clock) (!int_gnt) |-> (!int_read && !int_write);
endproperty
assert property(af_p56);

property af_p57;
@(posedge clock) (int_req && int_gnt) |=> !int_req;
endproperty
assert property(af_p57);

property af_p58;
@(posedge clock) (int_gnt && int_write) |-> $stable(int_wr_data);
endproperty
assert property(af_p58);

property af_p59;
@(posedge clock) int_req |-> (int_req throughout int_gnt[->1]) ##1 !int_req;
endproperty
assert property(af_p59);

property af_p60;
@(posedge clock) int_gnt |=> (int_read ##1 !int_read);
endproperty
assert property(af_p60);

property af_p61;
@(posedge clock) (int_read || int_write) |-> $past(int_gnt);
endproperty
assert property(af_p61);

property af_p62;
@(posedge clock) !int_gnt |-> (!int_read && !int_write);
endproperty
assert property(af_p62);

property af_p63;
@(posedge clock) int_read |-> $past(int_gnt);
endproperty
assert property(af_p63);

property af_p64;
@(posedge clock) $changed(int_rd_data) |-> ($past(int_gnt) && $past(int_read));
endproperty
assert property(af_p64);

property af_p65;
@(posedge clock) ($past(int_gnt) && !int_gnt) |-> (!int_read && !int_write);
endproperty
assert property(af_p65);

property af_p66;
@(posedge clock) $changed(int_req) |-> $past($stable(int_gnt));
endproperty
assert property(af_p66);

property af_p67;
@(posedge clock) !int_write |-> $stable(int_wr_data);
endproperty
assert property(af_p67);

property af_p68;
@(posedge clock) int_gnt |-> !int_req;
endproperty
assert property(af_p68);

property af_p69;
@(posedge clock) (int_gnt && int_write) |-> ##0 int_write;
endproperty
assert property(af_p69);

property af_p70;
@(posedge clock) (int_gnt && int_write) |=> $stable(int_wr_data);
endproperty
assert property(af_p70);

property af_p71;
@(posedge clock) $rose(int_gnt) |-> ##[0:1] (int_read || int_write);
endproperty
assert property(af_p71);

property af_p72;
@(posedge clock) $rose(int_gnt) |-> (int_write ##1 !int_write);
endproperty
assert property(af_p72);

property af_p73;
@(posedge clock) (int_gnt && int_read) |-> ##0 (int_gnt && int_read);
endproperty
assert property(af_p73);

property af_p74;
@(posedge clock) int_write |-> int_gnt;
endproperty
assert property(af_p74);

property af_p75;
@(posedge clock) int_gnt |=> !int_req;
endproperty
assert property(af_p75);

property af_p76;
@(posedge clock) $fell(int_gnt) |=> int_req;
endproperty
assert property(af_p76);

property af_p77;
@(posedge clock) int_gnt |=> !int_req throughout ##[1:$] int_gnt;
endproperty
assert property(af_p77);

property af_p78;
@(posedge clock) (int_gnt == 1'b1) |-> ($rose(int_req) |=> !int_req);
endproperty
assert property(af_p78);

property af_p79;
@(posedge clock) int_gnt |-> $stable(int_wr_data);
endproperty
assert property(af_p79);

property af_p80;
@(posedge clock) (int_gnt && int_read) |=> $stable(int_rd_data);
endproperty
assert property(af_p80);

property af_p81;
@(posedge clock) $rose(int_gnt) |=> !int_req;
endproperty
assert property(af_p81);

property af_p82;
@(posedge clock) ($fell(int_gnt) && $past(int_read)) |=> $stable(int_rd_data);
endproperty
assert property(af_p82);

property af_p83;
@(posedge clock) int_read |=> (int_rd_data >= 0) && (int_rd_data <= 255) && $stable(int_rd_data);
endproperty
assert property(af_p83);

property af_p84;
@(posedge clock) (!int_read) |=> $stable(int_rd_data);
endproperty
assert property(af_p84);

property af_p85;
@(posedge clock) (!int_read) |-> $stable(int_rd_data);
endproperty
assert property(af_p85);

property af_p86;
@(posedge clock) (int_read && int_read[*2]) |-> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p86);

property af_p87;
@(posedge clock) ($past(int_req) && int_gnt) |-> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p87);

property af_p88;
@(posedge clock) (int_req && int_gnt) |-> ##[1:2] ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p88);

property af_p89;
@(posedge clock) (int_gnt && int_read) |-> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p89);

property af_p90;
@(posedge clock) (!int_read && !int_write) |-> $stable(int_rd_data);
endproperty
assert property(af_p90);

property af_p91;
@(posedge clock) (!int_read && !int_write) |=> $stable(int_rd_data);
endproperty
assert property(af_p91);

property af_p92;
@(posedge clock) ($rose(int_gnt) && int_req) |-> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p92);

property af_p93;
@(posedge clock) (int_req && int_gnt) |=> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p93);

property af_p94;
@(posedge clock) (int_write) |-> ($stable(int_rd_data));
endproperty
assert property(af_p94);

property af_p95;
@(posedge clock) (int_req && int_gnt) |-> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p95);

property af_p96;
@(posedge clock) (int_req && int_gnt) |-> ##3 ((int_rd_data >= 100) && (int_rd_data <= 200));
endproperty
assert property(af_p96);

property af_p97;
@(posedge clock) (int_read && int_gnt) |-> ($stable(int_rd_data) throughout (!int_req)[->1]);
endproperty
assert property(af_p97);

property af_p98;
@(posedge clock) (int_read) |=> ((int_rd_data >= 0) && (int_rd_data <= 255));
endproperty
assert property(af_p98);

property af_p99;
@(posedge clock) ((int_rd_data >= 200) && (int_rd_data <= 255)) |=> ((int_rd_data >= 180) && (int_rd_data <= 255));
endproperty
assert property(af_p99);

property af_p100;
@(posedge clock) (!int_read) |-> ($stable(int_rd_data));
endproperty
assert property(af_p100);

property af_p101;
@(posedge clock) (!$stable(int_rd_data)) |-> (int_req && int_gnt);
endproperty
assert property(af_p101);

property af_p102;
@(posedge clock) (int_gnt) |-> (int_rd_data >= 0) && (int_rd_data <= 255) && $stable(int_rd_data);
endproperty
assert property(af_p102);

property af_p103;
@(posedge clock) (int_write) |-> $stable(int_rd_data);
endproperty
assert property(af_p103);

property af_p104;
@(posedge clock) (!int_req |-> ((int_rd_data >= 0) && (int_rd_data <= 127))) and (int_req |-> ((int_rd_data >= 128) && (int_rd_data <= 255)));
endproperty
assert property(af_p104);

property af_p105;
@(posedge clock) (1'b1) |-> (int_rd_data >= 0) && (int_rd_data <= 255);
endproperty
assert property(af_p105);

property af_p106;
@(posedge clock) (!int_write && int_read) |-> ##1 $changed(int_rd_data) && (int_rd_data >= 0) && (int_rd_data <= 255);
endproperty
assert property(af_p106);

property af_p107;
@(posedge clock) (!int_req) |-> ($stable(int_rd_data) throughout (!int_req)[*1:$] ##1 int_req);
endproperty
assert property(af_p107);

property af_p108;
@(posedge clock) (int_read && int_gnt) |=> (int_rd_data >= 0) && (int_rd_data <= 255);
endproperty
assert property(af_p108);

property af_p109;
@(posedge clock) (int_gnt) |-> (int_rd_data >= 0) && (int_rd_data <= 255);
endproperty
assert property(af_p109);

property af_p110;
@(posedge clock) $fell(int_read) |-> ##1 (int_rd_data >= 0) && (int_rd_data <= 255);
endproperty
assert property(af_p110);

property af_p111;
@(posedge clock) ($rose(int_gnt) && int_req) |-> ((int_rd_data >= 0) && (int_rd_data <= 255)) [*2];
endproperty
assert property(af_p111);

property af_p112;
@(posedge clock) int_read |-> int_gnt;
endproperty
assert property(af_p112);

property af_p113;
@(posedge clock) int_read |=> !int_read;
endproperty
assert property(af_p113);

property af_p114;
@(posedge clock) int_read |-> (int_req && int_gnt);
endproperty
assert property(af_p114);

property af_p115;
@(posedge clock) $fell(int_read) |=> $stable(int_rd_data);
endproperty
assert property(af_p115);

property af_p116;
@(posedge clock) $rose(int_gnt) |=> (int_read ##1 !int_read);
endproperty
assert property(af_p116);

property af_p117;
@(posedge clock) int_read |=> !$isunknown(int_rd_data);
endproperty
assert property(af_p117);

property af_p118;
@(posedge clock) int_read |-> $stable(int_wr_data);
endproperty
assert property(af_p118);

property af_p119;
@(posedge clock) !(int_read && int_write);
endproperty
assert property(af_p119);

property af_p120;
@(posedge clock) $rose(int_read) |=> !int_read;
endproperty
assert property(af_p120);

property af_p121;
@(posedge clock) (!int_gnt) |-> (!int_read);
endproperty
assert property(af_p121);

property af_p122;
@(posedge clock) (int_read) |-> $past(int_gnt);
endproperty
assert property(af_p122);

property af_p123;
@(posedge clock) (int_read === 1'b0) || (int_read === 1'b1);
endproperty
assert property(af_p123);

property af_p124;
@(posedge clock) (int_read) |=> (!int_read);
endproperty
assert property(af_p124);

property af_p125;
@(posedge clock) (int_read) |-> (!int_write);
endproperty
assert property(af_p125);

property af_p126;
@(posedge clock) ($fell(int_read)) |=> $stable(int_rd_data);
endproperty
assert property(af_p126);

property af_p127;
@(posedge clock) (int_read) |=> $changed(int_rd_data);
endproperty
assert property(af_p127);



property af_p130;
@(posedge clock) (int_req && !int_gnt) |-> !int_read;
endproperty
assert property(af_p130);

property af_p131;
@(posedge clock) int_read |-> ##1 !int_read;
endproperty
assert property(af_p131);

property af_p132;
@(posedge clock) $rose(int_req) |-> (!int_read until_with int_gnt);
endproperty
assert property(af_p132);

property af_p133;
@(posedge clock) $past(int_read) |-> $stable(int_rd_data);
endproperty
assert property(af_p133);

property af_p134;
@(posedge clock) !int_req |-> !int_read;
endproperty
assert property(af_p134);

property af_p135;
@(posedge clock) $rose(int_read) |-> $past(int_req);
endproperty
assert property(af_p135);

property af_p136;
@(posedge clock) $fell(int_read) |-> ##1 $stable(int_rd_data);
endproperty
assert property(af_p136);

property af_p137;
@(posedge clock) int_write |-> $past(int_req);
endproperty
assert property(af_p137);

property af_p138;
@(posedge clock) int_read |-> $past(int_req);
endproperty
assert property(af_p138);

property af_p139;
@(posedge clock) int_gnt |=> !int_req;
endproperty
assert property(af_p139);

property af_p140;
@(posedge clock) $past(int_gnt) |-> !int_req;
endproperty
assert property(af_p140);

property af_p141;
@(posedge clock) int_req |-> (int_req until int_gnt);
endproperty
assert property(af_p141);

property af_p142;
@(posedge clock) $rose(int_req) |-> (int_req until int_gnt);
endproperty
assert property(af_p142);

property af_p143;
@(posedge clock) int_gnt |-> (int_read || int_write || !int_req);
endproperty
assert property(af_p143);

property af_p144;
@(posedge clock) ($past(int_gnt) && $fell(int_req)) |-> ((!$isunknown(int_wr_data) || !$isunknown(int_rd_data)) or ##1 (!$isunknown(int_wr_data) || !$isunknown(int_rd_data)));
endproperty
assert property(af_p144);

property af_p145;
@(posedge clock) (int_read || int_write) |-> $past(int_req);
endproperty
assert property(af_p145);

property af_p146;
@(posedge clock) int_req |-> (int_read || int_write);
endproperty
assert property(af_p146);

property af_p147;
@(posedge clock) (int_req && !int_gnt) |=> $stable(int_req);
endproperty
assert property(af_p147);

property af_p148;
@(posedge clock) int_req |-> (int_req until_with int_gnt);
endproperty
assert property(af_p148);

property af_p149;
@(posedge clock) (int_req && int_gnt) |=> (!int_req);
endproperty
assert property(af_p149);

property af_p150;
@(posedge clock) (int_read && !$isunknown(int_rd_data)) |-> $past(int_req);
endproperty
assert property(af_p150);

property af_p151;
@(posedge clock) (!int_read && !int_write) |-> !int_req;
endproperty
assert property(af_p151);

property af_p152;
@(posedge clock) int_req |-> !$isunknown(int_wr_data);
endproperty
assert property(af_p152);

property af_p153;
@(posedge clock) (!int_gnt) |-> $stable(int_req);
endproperty
assert property(af_p153);

property af_p154;
@(posedge clock) (int_req && !int_gnt) |=> int_req;
endproperty
assert property(af_p154);

property af_p155;
@(posedge clock) (int_req && int_gnt) |=> (!int_req) ##1 int_req;
endproperty
assert property(af_p155);

property af_p156;
@(posedge clock) int_req |-> ##1 (int_write || int_read);
endproperty
assert property(af_p156);

property af_p157;
@(posedge clock) int_write |=> int_req;
endproperty
assert property(af_p157);

property af_p158;
@(posedge clock) $rose(int_gnt) |=> (!int_req ##1 int_req);
endproperty
assert property(af_p158);

property af_p159;
@(posedge clock) ($past(int_req) && !int_gnt) |-> int_req;
endproperty
assert property(af_p159);


property af_p161;
@(posedge clock) ($past(int_gnt) && !$past(int_req)) |=> int_req;
endproperty
assert property(af_p161);

property af_p162;
@(posedge clock) ((int_wr_data >= 200) && (int_wr_data <= 255)) |=> (int_wr_data >= 180) && (int_wr_data <= 255);
endproperty
assert property(af_p162);

property af_p163;
@(posedge clock) (int_req) |-> ##2 (int_wr_data >= 50) && (int_wr_data <= 200);
endproperty
assert property(af_p163);

property af_p164;
@(posedge clock) (int_req && int_gnt) |-> (int_wr_data >= 0) && (int_wr_data <= 255);
endproperty
assert property(af_p164);

property af_p165;
@(posedge clock) (int_write) |-> (int_wr_data >= 0) && (int_wr_data <= 255);
endproperty
assert property(af_p165);

property af_p166;
@(posedge clock) (!int_write) |-> $stable(int_wr_data);
endproperty
assert property(af_p166);

property af_p167;
@(posedge clock) (int_req) |-> ##2 (int_wr_data >= 0) && (int_wr_data <= 255);
endproperty
assert property(af_p167);

property af_p168;
@(posedge clock) (((int_wr_data >= 100) && (int_wr_data <= 120)) && int_write) |=> (int_write) |-> (int_wr_data >= 80) && (int_wr_data <= 140);
endproperty
assert property(af_p168);

property af_p169;
@(posedge clock) (int_write && !int_gnt) |-> ##1 $stable(int_wr_data);
endproperty
assert property(af_p169);

property af_p170;
@(posedge clock) (int_write && $rose(int_write) && (int_wr_data >= 138) && (int_wr_data <= 153)) |-> ##[1:2] (int_wr_data >= 98) && (int_wr_data <= 153);
endproperty
assert property(af_p170);

property af_p171;
@(posedge clock) (int_req && int_gnt) |-> ##3 ((int_wr_data >= 0) && (int_wr_data <= 45))[*1:$];
endproperty
assert property(af_p171);



property af_p174;
@(posedge clock) (int_write) |-> ((int_wr_data >= 20) && (int_wr_data <= 235));
endproperty
assert property(af_p174);

property af_p175;
@(posedge clock) disable iff (!int_write) $stable(int_wr_data) || $changed(int_wr_data);
endproperty
assert property(af_p175);

property af_p176;
@(posedge clock) (int_req && !int_gnt) |-> $stable(int_wr_data);
endproperty
assert property(af_p176);



property af_p179;
@(posedge clock) (int_write) |-> $stable(int_wr_data);
endproperty
assert property(af_p179);

property af_p180;
@(posedge clock) ((int_wr_data >= 200) && (int_wr_data <= 255)) |-> ##1 (int_wr_data >= 180) && (int_wr_data <= 255);
endproperty
assert property(af_p180);

property af_p181;
@(posedge clock) ((int_req) && (int_wr_data >= 100) && (int_wr_data <= 150)) |-> ((int_wr_data >= 80) && (int_wr_data <= 150)) throughout (int_gnt[->1]);
endproperty
assert property(af_p181);

property af_p182;
@(posedge clock) $rose(int_write) |=> $stable(int_wr_data);
endproperty
assert property(af_p182);

property af_p183;
@(posedge clock) ((int_wr_data >= 100) && (int_wr_data <= 120)) |=> ((int_wr_data >= 80) && (int_wr_data <= 140));
endproperty
assert property(af_p183);

property af_p184;
@(posedge clock) $rose(int_write) |-> ##3 ((int_wr_data >= 50) && (int_wr_data <= 200));
endproperty
assert property(af_p184);

property af_p185;
@(posedge clock) (int_req && !int_gnt) |=> $stable(int_wr_data);
endproperty
assert property(af_p185);

property af_p186;
@(posedge clock) $rose(int_write) |-> ##4 ((int_wr_data >= 0) && (int_wr_data <= 45));
endproperty
assert property(af_p186);

property af_p187;
@(posedge clock) (int_req && int_gnt) |-> ((int_wr_data >= 0) && (int_wr_data <= 255));
endproperty
assert property(af_p187);

property af_p188;
@(posedge clock) (!int_write) |=> $stable(int_wr_data);
endproperty
assert property(af_p188);

property af_p189;
@(posedge clock) (int_write) |-> ((int_wr_data >= 0) && (int_wr_data <= 255));
endproperty
assert property(af_p189);

property af_p190;
@(posedge clock) ((int_wr_data >= 200) && (int_wr_data <= 255)) |=> ((int_wr_data >= 180) && (int_wr_data <= 255));
endproperty
assert property(af_p190);

property af_p191;
@(posedge clock) $rose(int_write) |=> !int_write throughout (!$rose(int_write)[->1]);
endproperty
assert property(af_p191);

property af_p192;
@(posedge clock) int_write |=> !int_write;
endproperty
assert property(af_p192);

property af_p193;
@(posedge clock) !int_write |-> 1'b1;
endproperty
assert property(af_p193);

property af_p194;
@(posedge clock) $rose(int_write) |=> !int_write;
endproperty
assert property(af_p194);

property af_p195;
@(posedge clock) !(int_write && int_read);
endproperty
assert property(af_p195);

property af_p196;
@(posedge clock) int_write |-> $stable(int_wr_data);
endproperty
assert property(af_p196);

property af_p197;
@(posedge clock) $fell(int_write) |=> (int_wr_data !== $past(int_wr_data)) or (int_wr_data === $past(int_wr_data));
endproperty
assert property(af_p197);

property af_p198;
@(posedge clock) $changed(int_write) |-> $stable(int_write, @(negedge clock));
endproperty
assert property(af_p198);

property af_p199;
@(posedge clock) (int_write) |-> (int_req);
endproperty
assert property(af_p199);

property af_p200;
@(posedge clock) (int_write) |-> (int_gnt);
endproperty
assert property(af_p200);

property af_p201;
@(posedge clock) $fell(int_gnt) |=> (!int_write);
endproperty
assert property(af_p201);

property af_p202;
@(posedge clock) (int_write) |-> (!$isunknown(int_wr_data));
endproperty
assert property(af_p202);

property af_p203;
@(posedge clock) (int_write) |-> ($stable(int_wr_data));
endproperty
assert property(af_p203);

property af_p204;
@(posedge clock) (int_write) |-> ($past(int_req));
endproperty
assert property(af_p204);

property af_p205;
@(posedge clock) (int_write) |-> (!int_read);
endproperty
assert property(af_p205);

property af_p206;
@(posedge clock) $fell(int_write) |-> ##1 !int_write;
endproperty
assert property(af_p206);

property af_p207;
@(posedge clock) int_write |-> $past(int_req);
endproperty
assert property(af_p207);

property af_p208;
@(posedge clock) int_write |-> int_gnt;
endproperty
assert property(af_p208);

property af_p209;
@(posedge clock) int_write |-> (!int_read) && (!$past(int_read));
endproperty
assert property(af_p209);

property af_p210;
@(posedge clock) (!int_gnt) |-> (!int_write);
endproperty
assert property(af_p210);

property af_p211;
@(posedge clock) int_write |-> $past(int_req && int_gnt);
endproperty
assert property(af_p211);

property af_p212;
@(posedge clock) $rose(int_write) |-> ##1 $fell(int_write);
endproperty
assert property(af_p212);

property af_p213;
@(posedge clock) $rose(int_write) |-> int_gnt;
endproperty
assert property(af_p213);

property af_p214;
@(posedge clock) int_write |-> ##0 (int_wr_data == int_wr_data);
endproperty
assert property(af_p214);







property af_p221;
@(posedge clock) (int_write) |-> $stable(int_wr_data) throughout (int_write[*1]);
endproperty
assert property(af_p221);



property af_p224;
@(posedge clock) (int_write) |-> $stable(int_wr_data);
endproperty
assert property(af_p224);





property af_p229;
@(posedge clock) (int_gnt) |-> (int_req == 1'b0);
endproperty
assert property(af_p229);











property af_p240;
@(posedge clock) $rose(int_read) |-> $past(int_gnt);
endproperty
assert property(af_p240);

property af_p241;
@(posedge clock) (int_req) |-> (int_req throughout (int_gnt[->1]));
endproperty
assert property(af_p241);

property af_p242;
@(posedge clock) !(int_read && int_write);
endproperty
assert property(af_p242);







endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------
