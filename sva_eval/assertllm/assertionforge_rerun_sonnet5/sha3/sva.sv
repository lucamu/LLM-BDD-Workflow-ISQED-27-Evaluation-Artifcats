// AssertionForge baseline SVA for sha3
// 216 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge clk) (buffer_full) |-> ##[1:3] ($isunknown(out) == 1'b0);
endproperty
assert property(af_p0);

property af_p1;
@(posedge clk) (buffer_full && out_ready) |-> ##1 (buffer_full == 1'b0);
endproperty
assert property(af_p1);

property af_p2;
@(posedge clk) (buffer_full && out_ready) |-> ##[1:4] (buffer_full == 1'b0);
endproperty
assert property(af_p2);

property af_p3;
@(posedge clk) (buffer_full && byte_num < BUFFER_CAPACITY) |-> ##1 (buffer_full == 1'b0);
endproperty
assert property(af_p3);

property af_p4;
@(posedge clk) (buffer_full && in) |-> !$changed(data);
endproperty
assert property(af_p4);

property af_p5;
@(posedge clk) (buffer_full) |-> (in_ready == 1'b0);
endproperty
assert property(af_p5);

property af_p6;
@(posedge clk) $rose(buffer_full) |-> ##1 $stable(buffer_full) throughout (1'b1);
endproperty
assert property(af_p6);

property af_p7;
@(posedge clk) (buffer_full) |-> $stable(data) throughout (buffer_full == 1'b1);
endproperty
assert property(af_p7);

property af_p8;
@(posedge clk) (byte_num < BUFFER_CAPACITY) |-> (buffer_full == 1'b0);
endproperty
assert property(af_p8);

property af_p9;
@(posedge clk) (!buffer_full) |-> (in_ready);
endproperty
assert property(af_p9);

property af_p10;
@(posedge clk) (buffer_full && out_ready ##1 !out_ready) |-> ##[1:3] (!buffer_full);
endproperty
assert property(af_p10);

property af_p11;
@(posedge clk) ($rose(buffer_full)) |-> (byte_num == MAX_BYTE_NUM);
endproperty
assert property(af_p11);

property af_p12;
@(posedge clk) ($changed(in_ready)) |-> (!$changed(buffer_full));
endproperty
assert property(af_p12);

property af_p13;
@(posedge clk) (buffer_full) |-> (byte_num == $past(byte_num));
endproperty
assert property(af_p13);

property af_p14;
@(posedge clk) (buffer_full) |-> (byte_num == MAX_BYTE_NUM);
endproperty
assert property(af_p14);

property af_p15;
@(posedge clk) (buffer_full && !out_ready) |-> ##1 buffer_full;
endproperty
assert property(af_p15);

property af_p16;
@(posedge clk) (buffer_full) |-> !($rose(out_valid));
endproperty
assert property(af_p16);

property af_p17;
@(posedge clk) (buffer_full && out_ready && out) |-> ##[1:4] (!buffer_full);
endproperty
assert property(af_p17);

property af_p18;
@(posedge clk) (buffer_full) |-> (!in_ready);
endproperty
assert property(af_p18);

property af_p19;
@(posedge clk) $fell(buffer_full) |-> (in_ready || ##1 in_ready);
endproperty
assert property(af_p19);

property af_p20;
@(posedge clk) buffer_full |-> (in_ready == 1'b0) until (!buffer_full);
endproperty
assert property(af_p20);

property af_p21;
@(posedge clk) (in && data)[*4] |-> ##[1:4] $rose(buffer_full);
endproperty
assert property(af_p21);

property af_p22;
@(posedge clk) (byte_num < MAX_BYTE_NUM) |-> !buffer_full;
endproperty
assert property(af_p22);

property af_p23;
@(posedge clk) (byte_num == MAX_BYTE_NUM) |-> ##[1:4] buffer_full;
endproperty
assert property(af_p23);

property af_p24;
@(posedge clk) buffer_full |-> !in;
endproperty
assert property(af_p24);

property af_p25;
@(posedge clk) (!$changed(in) && !$changed(out_ready)) |-> $stable(buffer_full);
endproperty
assert property(af_p25);

property af_p26;
@(posedge clk) $rose(buffer_full) |-> ($past(in_ready) && data);
endproperty
assert property(af_p26);

property af_p27;
@(posedge clk) buffer_full |-> ##1 $stable(in);
endproperty
assert property(af_p27);

property af_p28;
@(posedge clk) $rose(buffer_full) |-> ##1 buffer_full;
endproperty
assert property(af_p28);

property af_p29;
@(posedge clk) ($fell(out_ready)) |-> ##1 (byte_num == 0);
endproperty
assert property(af_p29);

property af_p30;
@(posedge clk) (byte_num >= 0) && (byte_num <= 8);
endproperty
assert property(af_p30);

property af_p31;
@(posedge clk) (in) |-> ((byte_num >= 0) && (byte_num <= 8));
endproperty
assert property(af_p31);

property af_p32;
@(posedge clk) (buffer_full) |-> (byte_num == $past(byte_num));
endproperty
assert property(af_p32);

property af_p33;
@(posedge clk) (in && !buffer_full) |-> (byte_num == ($past(byte_num) + 1));
endproperty
assert property(af_p33);

property af_p34;
@(posedge clk) ($rose(out_ready)) |-> ##2 (byte_num == 0);
endproperty
assert property(af_p34);

property af_p35;
@(posedge clk) ($rose(in_ready)) |-> ((byte_num >= 1) && (byte_num <= 8));
endproperty
assert property(af_p35);

property af_p36;
@(posedge clk) (in && !buffer_full) |=> (byte_num == $past(byte_num) + 1) && (byte_num >= 0 && byte_num <= 8);
endproperty
assert property(af_p36);

property af_p37;
@(posedge clk) (byte_num >= 0 && byte_num <= 8);
endproperty
assert property(af_p37);

property af_p38;
@(posedge clk) (byte_num == $countones(data));
endproperty
assert property(af_p38);

property af_p39;
@(posedge clk) (out_ready) |=> (byte_num == 0);
endproperty
assert property(af_p39);

property af_p40;
@(posedge clk) (in_ready) |-> (byte_num >= 1 && byte_num <= 8);
endproperty
assert property(af_p40);

property af_p41;
@(posedge clk) (out_ready) |=> (byte_num >= 0 && byte_num <= 8);
endproperty
assert property(af_p41);

property af_p42;
@(posedge clk) ($fell(buffer_full)) |=> (byte_num == $past(byte_num) + 1);
endproperty
assert property(af_p42);

property af_p43;
@(posedge clk) (buffer_full) |=> ((byte_num >= 0) && (byte_num <= 8));
endproperty
assert property(af_p43);

property af_p44;
@(posedge clk) (buffer_full) |=> ($stable(byte_num) && (byte_num >= 0) && (byte_num <= 8));
endproperty
assert property(af_p44);

property af_p45;
@(posedge clk) (!in_ready) |-> (byte_num == 0);
endproperty
assert property(af_p45);

property af_p46;
@(posedge clk) (in_ready) |-> ($stable(byte_num) && (byte_num >= 1) && (byte_num <= 8));
endproperty
assert property(af_p46);

property af_p47;
@(posedge clk) (in_ready) |=> (byte_num <= 8);
endproperty
assert property(af_p47);

property af_p48;
@(posedge clk) (out_ready) |-> ((byte_num >= 0) && (byte_num <= 8) && (byte_num == $countones(out)));
endproperty
assert property(af_p48);

property af_p49;
@(posedge clk) ($rose(in_ready)) |=> $stable(in_ready) ##1 $stable(data);
endproperty
assert property(af_p49);

property af_p50;
@(posedge clk) (1'b1) |-> ##1 $stable(byte_num);
endproperty
assert property(af_p50);

property af_p51;
@(posedge clk) (out_ready) |-> ##1 (out == $past(out)) || $changed(out);
endproperty
assert property(af_p51);

property af_p52;
@(posedge clk) ($changed(in_ready)) |-> $rose(clk);
endproperty
assert property(af_p52);

property af_p53;
@(posedge clk) (byte_num !== $past(byte_num)) |-> $rose(clk);
endproperty
assert property(af_p53);

property af_p54;
@(posedge clk) (1'b1) |=> $stable(byte_num);
endproperty
assert property(af_p54);

property af_p55;
@(posedge clk) (in_ready) |-> (data == $past(data)) || $stable(data);
endproperty
assert property(af_p55);

property af_p56;
@(posedge clk) (in_ready) |=> (byte_num == ($past(byte_num) + 1'b1));
endproperty
assert property(af_p56);

property af_p57;
@(posedge clk) ($fell(buffer_full)) |-> ##1 (buffer_full == 1'b0);
endproperty
assert property(af_p57);

property af_p58;
@(posedge clk) ($rose(in_ready)) |-> ##2 (data == $past(data,2));
endproperty
assert property(af_p58);

property af_p59;
@(posedge clk) $changed(buffer_full) |-> $stable(buffer_full) throughout (1'b1[*1]);
endproperty
assert property(af_p59);

property af_p60;
@(posedge clk) (in_ready) |-> ##1 $stable(data);
endproperty
assert property(af_p60);

property af_p61;
@(posedge clk) $changed(data) |-> $stable(data) until_with @(posedge clk);
endproperty
assert property(af_p61);

property af_p62;
@(posedge clk) $rose(buffer_full) |-> $stable(buffer_full);
endproperty
assert property(af_p62);

property af_p63;
@(posedge clk) $rose(buffer_full) |=> ##[1:$] $fell(buffer_full);
endproperty
assert property(af_p63);

property af_p64;
@(posedge clk) (out_ready) |=> (out === $past(out, 1)) or (out !== 'x);
endproperty
assert property(af_p64);

property af_p65;
@(posedge clk) (in_ready) |-> (data === $past(data,0));
endproperty
assert property(af_p65);

property af_p66;
@(posedge clk) (!out_ready) |-> $stable(out);
endproperty
assert property(af_p66);

property af_p67;
@(posedge clk) (out_ready === $past(out_ready)) or ($changed(out_ready) === 1'b1);
endproperty
assert property(af_p67);

property af_p68;
@(posedge clk) (in && !buffer_full) |=> ($past(data) === data);
endproperty
assert property(af_p68);

property af_p69;
@(posedge clk) (in_ready) |=> $stable(in);
endproperty
assert property(af_p69);

property af_p70;
@(posedge clk) !out_ready |-> $stable(out);
endproperty
assert property(af_p70);

property af_p71;
@(posedge clk) $changed(in) |=> $stable(in);
endproperty
assert property(af_p71);

property af_p72;
@(posedge clk) buffer_full |=> $stable(in);
endproperty
assert property(af_p72);

property af_p73;
@(posedge clk) $stable(data) |-> $stable(buffer_full);
endproperty
assert property(af_p73);

property af_p74;
@(posedge clk) out_ready |=> $stable(out);
endproperty
assert property(af_p74);

property af_p75;
@(posedge clk) in_ready |-> $stable(in);
endproperty
assert property(af_p75);

property af_p76;
@(posedge clk) $changed(out_ready) |-> $changed(out);
endproperty
assert property(af_p76);

property af_p77;
@(posedge clk) (is_last && in_ready) |-> (byte_num <= (DATA_WIDTH/8));
endproperty
assert property(af_p77);

property af_p78;
@(posedge clk) (in_ready && is_last && (byte_num == 0)) |-> !$isunknown(data);
endproperty
assert property(af_p78);

property af_p79;
@(posedge clk) (in_ready && is_last) |-> !$isunknown(data);
endproperty
assert property(af_p79);

property af_p80;
@(posedge clk) (in_ready && !buffer_full) |-> !$isunknown(data);
endproperty
assert property(af_p80);

property af_p81;
@(posedge clk) (in_ready && !buffer_full) |=> (in_ready |-> !$isunknown(data));
endproperty
assert property(af_p81);

property af_p82;
@(posedge clk) (data inside {[0:255]}) |=> (in_ready |-> (data inside {[0:255]}));
endproperty
assert property(af_p82);

property af_p83;
@(posedge clk) (byte_num == (DATA_WIDTH/8)) |-> !$isunknown(data[DATA_WIDTH-1:0]);
endproperty
assert property(af_p83);

property af_p84;
@(posedge clk) (in_ready) |-> !$isunknown(data);
endproperty
assert property(af_p84);

property af_p85;
@(posedge clk) (in_ready && (byte_num != 0) && (byte_num < (DATA_WIDTH/8))) |-> ((data & ((1 << (DATA_WIDTH - (byte_num*8))) - 1)) == '0);
endproperty
assert property(af_p85);

property af_p86;
@(posedge clk) (in_ready) |=> (in_ready |-> !$isunknown(data));
endproperty
assert property(af_p86);

property af_p87;
@(posedge clk) (out_ready && !$isunknown(out)) |-> ($past(data) !== data);
endproperty
assert property(af_p87);

property af_p88;
@(posedge clk) ($fell(reset)) |=> (in_ready |-> !$isunknown(data));
endproperty
assert property(af_p88);

property af_p89;
@(posedge clk) (in_ready && in_last) |-> !$isunknown(data[$bits(data)-1 -: (byte_num*8)]);
endproperty
assert property(af_p89);

property af_p90;
@(posedge clk) (in_ready && (byte_num != $bits(data)/8)) |-> !$isunknown(data[$bits(data)-1 -: (byte_num*8)]);
endproperty
assert property(af_p90);

property af_p91;
@(posedge clk) ($rose(in_ready)) |-> !$isunknown(data);
endproperty
assert property(af_p91);

property af_p92;
@(posedge clk) ($rose(in_ready)) |=> $stable(data);
endproperty
assert property(af_p92);

property af_p93;
@(posedge clk) (!in_ready) |-> $stable(data);
endproperty
assert property(af_p93);

property af_p94;
@(posedge clk) (in_ready && (byte_num == 1) && (data[DATA_WIDTH-1:DATA_WIDTH-8] == 8'h41)) |-> (data[DATA_WIDTH-9:0] == '0);
endproperty
assert property(af_p94);

property af_p95;
@(posedge clk) (in_ready && (byte_num == MAX_BYTE_NUM)) |-> !$isunknown(data);
endproperty
assert property(af_p95);

property af_p96;
@(posedge clk) (in_ready && is_last && (byte_num == 0)) |-> (byte_num == 0);
endproperty
assert property(af_p96);

property af_p97;
@(posedge clk) (data !== $past(data)) |-> $past(in_ready);
endproperty
assert property(af_p97);

property af_p98;
@(posedge clk) (buffer_full) |=> ($stable(data) || !buffer_full);
endproperty
assert property(af_p98);

property af_p99;
@(posedge clk) ($past(in_ready) && ($past(byte_num) == 0) && $past(is_last)) |-> 1'b1;
endproperty
assert property(af_p99);

property af_p100;
@(posedge clk) (!in_ready) |-> 1'b1;
endproperty
assert property(af_p100);

property af_p101;
@(posedge clk) (in_ready && (byte_num < MAX_BYTE_NUM)) |-> (!$isunknown(data[DATA_WIDTH-1 -: (byte_num*8)]) && (data[DATA_WIDTH-(byte_num*8)-1:0] == '0));
endproperty
assert property(af_p101);

property af_p102;
@(posedge clk) (buffer_full) |-> (in_ready == 1'b0);
endproperty
assert property(af_p102);

property af_p103;
@(posedge clk) (in && is_last) |-> !$isunknown(data[DATA_WIDTH-1 -: (byte_num*8)]);
endproperty
assert property(af_p103);

property af_p104;
@(posedge clk) ((in >= 1) && (in <= 50) && in_ready) |=> ($changed(data));
endproperty
assert property(af_p104);

property af_p105;
@(posedge clk) (buffer_full) |=> ($stable(in));
endproperty
assert property(af_p105);

property af_p106;
@(posedge clk) ((byte_num != 3'b000) && out_ready) |=> ($stable(out));
endproperty
assert property(af_p106);

property af_p107;
@(posedge clk) (!in_ready) |-> (in inside {in});
endproperty
assert property(af_p107);

property af_p108;
@(posedge clk) ((in >= 230) && (in <= 255)) |=> ((in >= 205) && (in <= 255));
endproperty
assert property(af_p108);

property af_p109;
@(posedge clk) (in_ready) |-> ((in != 64'b0) && (byte_num != 3'b000));
endproperty
assert property(af_p109);

property af_p110;
@(posedge clk) (in_ready && !buffer_full) |=> ($stable(in));
endproperty
assert property(af_p110);

property af_p111;
@(posedge clk) ($changed(in)) |-> (!out_ready throughout (out_ready[->1]));
endproperty
assert property(af_p111);

property af_p112;
@(posedge clk) (is_last) |=> ($stable(out) && !out_ready) until (in_ready);
endproperty
assert property(af_p112);

property af_p113;
@(posedge clk) ((in >= 0) && (in <= 64'hFFFFFFFFFFFFFFFF)) |-> (in_ready == 1'b1 || in_ready == 1'b0);
endproperty
assert property(af_p113);

property af_p114;
@(posedge clk) (buffer_full) |=> ($stable(in) throughout buffer_full[->1]);
endproperty
assert property(af_p114);

property af_p115;
@(posedge clk) (in_ready && !buffer_full) |-> ##1 $stable(in);
endproperty
assert property(af_p115);

property af_p116;
@(posedge clk) ((in >= 0) && (in <= 64'hFFFFFFFFFFFFFFFF) && in_ready) |=> (in >= 0) && (in <= 64'hFFFFFFFFFFFFFFFF);
endproperty
assert property(af_p116);

property af_p117;
@(posedge clk) (buffer_full) |=> $stable(in);
endproperty
assert property(af_p117);

property af_p118;
@(posedge clk) (in_ready) |-> (in >= 0) && (in <= 64'hFFFFFFFFFFFFFFFF);
endproperty
assert property(af_p118);

property af_p119;
@(posedge clk) (in_ready) |-> ##[1:$] (out_ready);
endproperty
assert property(af_p119);

property af_p120;
@(posedge clk) (byte_num != 3'b000) |-> ((in & ((1 << (byte_num*8)) - 1)) === in[(byte_num*8)-1:0]);
endproperty
assert property(af_p120);

property af_p121;
@(posedge clk) (in_ready) |=> $stable(in) === $past(in_ready) ? 1'b1 : 1'b1;
endproperty
assert property(af_p121);

property af_p122;
@(posedge clk) (!in_ready) |=> $stable(in);
endproperty
assert property(af_p122);

property af_p123;
@(posedge clk) (in_ready) |-> ((in >= 0) && (in <= 45))[*4];
endproperty
assert property(af_p123);

property af_p124;
@(posedge clk) ((in >= 138) && (in <= 153)) |-> ##1 ((in >= 98) && (in <= 153));
endproperty
assert property(af_p124);

property af_p125;
@(posedge clk) (in_ready) |-> ##3 ((in >= 83) && (in <= 165));
endproperty
assert property(af_p125);

property af_p126;
@(posedge clk) ($fell(buffer_full)) |-> ##1 (in !== $past(in));
endproperty
assert property(af_p126);

property af_p127;
@(posedge clk) (buffer_full) |-> $stable(in);
endproperty
assert property(af_p127);

property af_p128;
@(posedge clk) (!in_ready) |-> $stable(in);
endproperty
assert property(af_p128);

property af_p129;
@(posedge clk) (byte_num != 3'b000) |-> $stable(in) until_with (in_ready);
endproperty
assert property(af_p129);

property af_p130;
@(posedge clk) (in_ready) |-> $stable(in);
endproperty
assert property(af_p130);

property af_p131;
@(posedge clk) (buffer_full) |-> ##1 $stable(in);
endproperty
assert property(af_p131);

property af_p132;
@(posedge clk) in_ready |-> !buffer_full;
endproperty
assert property(af_p132);

property af_p133;
@(posedge clk) $rose(buffer_full) |-> !in_ready throughout (buffer_full[->1]);
endproperty
assert property(af_p133);

property af_p134;
@(posedge clk) $stable(data) || $stable(out) |-> $stable(in_ready);
endproperty
assert property(af_p134);

property af_p135;
@(posedge clk) (buffer_full) |-> !in_ready;
endproperty
assert property(af_p135);

property af_p136;
@(posedge clk) (out_ready && out) |-> !in_ready;
endproperty
assert property(af_p136);

property af_p137;
@(posedge clk) buffer_full |-> !in_ready;
endproperty
assert property(af_p137);

property af_p138;
@(posedge clk) in_ready |-> !out_ready;
endproperty
assert property(af_p138);

property af_p139;
@(posedge clk) in_ready |=> $stable(in);
endproperty
assert property(af_p139);

property af_p140;
@(posedge clk) $rose(buffer_full) |=> !in_ready;
endproperty
assert property(af_p140);

property af_p141;
@(posedge clk) (!buffer_full) |-> in_ready;
endproperty
assert property(af_p141);

property af_p142;
@(posedge clk) (in_ready && !buffer_full) |=> in_ready;
endproperty
assert property(af_p142);

property af_p143;
@(posedge clk) $fell(buffer_full) |=> in_ready;
endproperty
assert property(af_p143);

property af_p144;
@(posedge clk) (in_ready && in) |=> (byte_num == ($past(byte_num) + 1));
endproperty
assert property(af_p144);

property af_p145;
@(posedge clk) (in_ready) |-> ##0 (data == in);
endproperty
assert property(af_p145);

property af_p146;
@(posedge clk) (buffer_full) |-> (!in_ready) || (out_ready || !out_ready);
endproperty
assert property(af_p146);

property af_p147;
@(posedge clk) ($stable(buffer_full)) |-> $stable(in_ready);
endproperty
assert property(af_p147);

property af_p148;
@(posedge clk) $fell(out_ready) |-> in_ready;
endproperty
assert property(af_p148);

property af_p149;
@(posedge clk) (!$changed(buffer_full) && !$changed(data)) |-> $stable(in_ready);
endproperty
assert property(af_p149);

property af_p150;
@(posedge clk) ($past(in_ready) && $past(data)) |-> in_ready;
endproperty
assert property(af_p150);

property af_p151;
@(posedge clk) (buffer_full) |-> (!in_ready);
endproperty
assert property(af_p151);

property af_p152;
@(posedge clk) $fell(buffer_full) |=> $rose(in_ready);
endproperty
assert property(af_p152);

property af_p153;
@(posedge clk) $changed(buffer_full) |-> ##1 $stable(in_ready) || $changed(in_ready);
endproperty
assert property(af_p153);

property af_p154;
@(posedge clk) (in_ready && (byte_num > 0) && (byte_num <= 8)) |=> (in == $past(in));
endproperty
assert property(af_p154);

property af_p155;
@(posedge clk) (in_ready && (data !== '0)) |-> !buffer_full;
endproperty
assert property(af_p155);

property af_p156;
@(posedge clk) ((byte_num > 0) && (byte_num <= 8) && !buffer_full) |=> in_ready;
endproperty
assert property(af_p156);

property af_p157;
@(posedge clk) ($stable(buffer_full) && $stable(out_ready)) |-> $stable(in_ready);
endproperty
assert property(af_p157);

property af_p158;
@(posedge clk) $fell(buffer_full) |-> ##[1:3] in_ready;
endproperty
assert property(af_p158);

property af_p159;
@(posedge clk) ((byte_num == 0) || (byte_num > 8)) |-> !in_ready;
endproperty
assert property(af_p159);

property af_p160;
@(posedge clk) (in_ready && buffer_full) |=> !in_ready;
endproperty
assert property(af_p160);

property af_p161;
@(posedge clk) (in_ready && !buffer_full) |-> ##1 (!buffer_full |-> in_ready);
endproperty
assert property(af_p161);

property af_p162;
@(posedge clk) (in_ready && !buffer_full) |-> ##1 (data == $past(data));
endproperty
assert property(af_p162);

property af_p163;
@(posedge clk) $rose(out_ready) |-> ##1 $stable(out);
endproperty
assert property(af_p163);

property af_p164;
@(posedge clk) (!out_ready) |-> $stable(out);
endproperty
assert property(af_p164);

property af_p165;
@(posedge clk) ($past(last) && $past(in_ready) && !in_ready) |-> ##[1:16] (out_ready && (out == expected_hash));
endproperty
assert property(af_p165);

property af_p166;
@(posedge clk) (buffer_full && $stable(in)) |-> $stable(out);
endproperty
assert property(af_p166);

property af_p167;
@(posedge clk) (!out_ready) |-> (out == 512'b0);
endproperty
assert property(af_p167);

property af_p168;
@(posedge clk) (!in_ready && !buffer_full) |-> (out == '0);
endproperty
assert property(af_p168);

property af_p169;
@(posedge clk) (!out_ready) |-> (out == '0);
endproperty
assert property(af_p169);

property af_p170;
@(posedge clk) $rose(out_ready) |-> (out_ready throughout $stable(out)[*1:$]);
endproperty
assert property(af_p170);

property af_p171;
@(posedge clk) (!in_ready) |-> $stable(out);
endproperty
assert property(af_p171);

property af_p172;
@(posedge clk) (buffer_full) |-> $stable(out);
endproperty
assert property(af_p172);

property af_p173;
@(posedge clk) (out_ready) |-> ($past(in_last) && $past(in_ready));
endproperty
assert property(af_p173);

property af_p174;
@(posedge clk) ($changed(out)) |-> $rose(out_ready);
endproperty
assert property(af_p174);

property af_p175;
@(posedge clk) (in_ready && $changed(in) && $changed(byte_num)) |=> (out_ready throughout ##[1:$] (out_ready && (out != $past(out))));
endproperty
assert property(af_p175);

property af_p176;
@(posedge clk) ($rose(out_ready)) |-> ($past(in_last) && $fell(in_ready));
endproperty
assert property(af_p176);

property af_p177;
@(posedge clk) (out_ready) |-> ((out !== 512'bx) && $stable(out));
endproperty
assert property(af_p177);

property af_p178;
@(posedge clk) ($rose(out_ready)) |-> (out !== 512'bx);
endproperty
assert property(af_p178);

property af_p179;
@(posedge clk) ($fell(in_ready) && $past(in_last)) |-> ##[1:16] (out_ready && (out !== 512'bx));
endproperty
assert property(af_p179);

property af_p180;
@(posedge clk) !out_ready |=> $stable(out);
endproperty
assert property(af_p180);

property af_p181;
@(posedge clk) !out_ready |-> $stable(out);
endproperty
assert property(af_p181);

property af_p182;
@(posedge clk) (in_ready && $stable(data)) |-> (!out_ready) |=> ($stable(out) || out == '0);
endproperty
assert property(af_p182);

property af_p183;
@(posedge clk) (in_ready && $changed(data) && $changed(byte_num)) |=> (out_ready |-> $changed(out));
endproperty
assert property(af_p183);

property af_p184;
@(posedge clk) out_ready |=> $stable(out) throughout (!in_ready)[*1:$];
endproperty
assert property(af_p184);

property af_p185;
@(posedge clk) out_ready |=> $stable(out) throughout (out_ready)[*1:$];
endproperty
assert property(af_p185);

property af_p186;
@(posedge clk) buffer_full |-> $stable(out);
endproperty
assert property(af_p186);

property af_p187;
@(posedge clk) $fell(in_ready) |=> $stable(out) throughout (!in_ready)[*1:$] until_with (in_ready);
endproperty
assert property(af_p187);

property af_p188;
@(posedge clk) out_ready |-> $stable(out) throughout (!in_ready)[*1:$];
endproperty
assert property(af_p188);

property af_p189;
@(posedge clk) ($rose(out_ready)) |-> (out_ready throughout (out_ready[*byte_num]));
endproperty
assert property(af_p189);

property af_p190;
@(posedge clk) ($rose(out_ready)) |-> ($past(in_ready, byte_num) == 0);
endproperty
assert property(af_p190);

property af_p191;
@(posedge clk) (in_ready) |-> (!out_ready) throughout (in_ready[*1:$]);
endproperty
assert property(af_p191);

property af_p192;
@(posedge clk) ($rose(out_ready)) |-> ($stable(out) throughout (out_ready[->1]));
endproperty
assert property(af_p192);

property af_p193;
@(posedge clk) (in_ready) |-> (!out_ready);
endproperty
assert property(af_p193);

property af_p194;
@(posedge clk) (out_ready) |-> (out_ready throughout (##1 out_ready)) or (##1 !out_ready);
endproperty
assert property(af_p194);

property af_p195;
@(posedge clk) (!in_ready) |-> (!out_ready) throughout (!in_ready)[*1:$];
endproperty
assert property(af_p195);

property af_p196;
@(posedge clk) (out_ready) |-> ($stable(out) throughout (out_ready ##1 !out_ready));
endproperty
assert property(af_p196);

property af_p197;
@(posedge clk) ($rose(in_ready)) |-> (!out_ready)[*1:byte_num];
endproperty
assert property(af_p197);

property af_p198;
@(posedge clk) ($fell(out_ready) && $stable(out)) |-> (##1 !out_ready);
endproperty
assert property(af_p198);

property af_p199;
@(posedge clk) (in_ready && (in == '0)) |-> ##[1:4] out_ready;
endproperty
assert property(af_p199);

property af_p200;
@(posedge clk) (!buffer_full) |-> (!out_ready);
endproperty
assert property(af_p200);

property af_p201;
@(posedge clk) (out_ready == 1'b0) || (out_ready == 1'b1);
endproperty
assert property(af_p201);

property af_p202;
@(posedge clk) !(out_ready && in_ready);
endproperty
assert property(af_p202);

property af_p203;
@(posedge clk) $rose(out_ready) |-> $past(buffer_full, 1);
endproperty
assert property(af_p203);

property af_p204;
@(posedge clk) $rose(out_ready) |-> $past(buffer_full);
endproperty
assert property(af_p204);

property af_p205;
@(posedge clk) (out_ready) |-> ($stable(out) && ($bits(out) >= (byte_num*8)));
endproperty
assert property(af_p205);

property af_p206;
@(posedge clk) (out_ready && !buffer_full) |=> (!out_ready);
endproperty
assert property(af_p206);

property af_p207;
@(posedge clk) (byte_num == MAX_BYTE_NUM) |-> ##[1:2] out_ready;
endproperty
assert property(af_p207);

property af_p208;
@(posedge clk) (in_ready) |=> (out_ready ##1 !out_ready);
endproperty
assert property(af_p208);

property af_p209;
@(posedge clk) (buffer_full) |=> (out_ready throughout (##[1:$] !out_ready));
endproperty
assert property(af_p209);

property af_p210;
@(posedge clk) (out_ready) |-> (buffer_full || ##1 buffer_full);
endproperty
assert property(af_p210);

property af_p211;
@(posedge clk) (byte_num == 0) |=> (!out_ready);
endproperty
assert property(af_p211);

property af_p212;
@(posedge clk) (out_ready) |=> (!out_ready);
endproperty
assert property(af_p212);

property af_p213;
@(posedge clk) (out_ready) |=> $stable(out);
endproperty
assert property(af_p213);

property af_p214;
@(posedge clk) $stable(out_ready);
endproperty
assert property(af_p214);

property af_p215;
@(posedge clk) (buffer_full) |=> (out_ready);
endproperty
assert property(af_p215);

