// AssertionForge baseline SVA for sha3_2
// 198 assertions captured from gen_plan.generate_svas

property af_p0;
@(posedge clk) buffer_full |=> (byte_num == $past(byte_num));
endproperty
assert property(af_p0);

property af_p1;
@(posedge clk) $rose(buffer_full) |-> (!in_ready until_with $fell(buffer_full));
endproperty
assert property(af_p1);

property af_p2;
@(posedge clk) (byte_num == 0) |=> !buffer_full;
endproperty
assert property(af_p2);

property af_p3;
@(posedge clk) buffer_full |-> ($stable(byte_num) until_with $fell(buffer_full));
endproperty
assert property(af_p3);

property af_p4;
@(posedge clk) buffer_full |=> $stable(data);
endproperty
assert property(af_p4);

property af_p5;
@(posedge clk) $fell(reset) |-> (!buffer_full[*3]) ##1 !in;
endproperty
assert property(af_p5);

property af_p6;
@(posedge clk) in_ready |-> !buffer_full;
endproperty
assert property(af_p6);

property af_p7;
@(posedge clk) $rose(buffer_full) |-> (byte_num == BYTE_NUM_MAX);
endproperty
assert property(af_p7);

property af_p8;
@(posedge clk) (out_ready && out) |=> !buffer_full;
endproperty
assert property(af_p8);

property af_p9;
@(posedge clk) (in && buffer_full) |=> $stable(data);
endproperty
assert property(af_p9);

property af_p10;
@(posedge clk) (byte_num < BUFFER_MAX_SIZE) |-> (!buffer_full);
endproperty
assert property(af_p10);

property af_p11;
@(posedge clk) ((byte_num == BUFFER_MAX_SIZE) && $stable(data) == 0) |=> (buffer_full);
endproperty
assert property(af_p11);

property af_p12;
@(posedge clk) (byte_num > BUFFER_MAX_SIZE) |=> (buffer_full);
endproperty
assert property(af_p12);

property af_p13;
@(posedge clk) (buffer_full && in_ready) |=> !(buffer_full && in_ready);
endproperty
assert property(af_p13);

property af_p14;
@(posedge clk) ((byte_num == BUFFER_MAX_SIZE) && data) |-> (buffer_full);
endproperty
assert property(af_p14);

property af_p15;
@(posedge clk) (buffer_full) |-> (!in_ready);
endproperty
assert property(af_p15);

property af_p16;
@(posedge clk) (buffer_full) |-> ##1 $stable(in) throughout (buffer_full == 1);
endproperty
assert property(af_p16);

property af_p17;
@(posedge clk) ($fell(in_ready)) |-> (buffer_full)[*1:$];
endproperty
assert property(af_p17);

property af_p18;
@(posedge clk) (buffer_full) |-> (buffer_full throughout (!(out_ready && out)))[*1:$] ##1 (out_ready && out) |=> (!buffer_full);
endproperty
assert property(af_p18);

property af_p19;
@(posedge clk) (in_ready) |-> (!buffer_full);
endproperty
assert property(af_p19);

property af_p20;
@(posedge clk) (in_ready && !out_ready) |=> !buffer_full;
endproperty
assert property(af_p20);

property af_p21;
@(posedge clk) buffer_full |-> !$changed(data);
endproperty
assert property(af_p21);

property af_p22;
@(posedge clk) out_ready |=> !buffer_full;
endproperty
assert property(af_p22);

property af_p23;
@(posedge clk) (byte_num == MAX_BYTE_NUM) |-> buffer_full;
endproperty
assert property(af_p23);

property af_p24;
@(posedge clk) buffer_full == (byte_num == MAX_BYTE_NUM);
endproperty
assert property(af_p24);

property af_p25;
@(posedge clk) $rose(out_ready) |=> !buffer_full;
endproperty
assert property(af_p25);

property af_p26;
@(posedge clk) buffer_full |-> !$stable(in) |-> $stable(data);
endproperty
assert property(af_p26);

property af_p27;
@(posedge clk) buffer_full |=> !in_ready;
endproperty
assert property(af_p27);

property af_p28;
@(posedge clk) (in_ready && !$isunknown(in)) |-> !buffer_full;
endproperty
assert property(af_p28);

property af_p29;
@(posedge clk) (in_ready && out_ready) |=> (byte_num == 0);
endproperty
assert property(af_p29);

property af_p30;
@(posedge clk) $fell(in_ready) |-> ((byte_num >= 0) && (byte_num <= 4)) [*3];
endproperty
assert property(af_p30);

property af_p31;
@(posedge clk) $rose(buffer_full) |=> $stable(byte_num);
endproperty
assert property(af_p31);

property af_p32;
@(posedge clk) (buffer_full) |-> (byte_num <= 4);
endproperty
assert property(af_p32);

property af_p33;
@(posedge clk) (!in_ready && !buffer_full) |-> ($stable(byte_num));
endproperty
assert property(af_p33);

property af_p34;
@(posedge clk) (byte_num >= 0) && (byte_num <= 4);
endproperty
assert property(af_p34);

property af_p35;
@(posedge clk) (in_ready) |-> ((byte_num >= 1) && (byte_num <= 4) && $stable(byte_num));
endproperty
assert property(af_p35);

property af_p36;
@(posedge clk) ($fell(buffer_full)) |-> ##1 (byte_num == 0);
endproperty
assert property(af_p36);

property af_p37;
@(posedge clk) (in_ready) |-> (byte_num >= 0) && (byte_num <= 4);
endproperty
assert property(af_p37);

property af_p38;
@(posedge clk) ($changed(byte_num)) |-> $changed(in);
endproperty
assert property(af_p38);

property af_p39;
@(posedge clk) ($rose(in_ready)) |-> (byte_num >= 1) && (byte_num <= 4);
endproperty
assert property(af_p39);

property af_p40;
@(posedge clk) (1'b1) |-> (byte_num >= 0) && (byte_num <= 4);
endproperty
assert property(af_p40);

property af_p41;
@(posedge clk) (byte_num == 4) |-> ##1 (out_ready |-> (byte_num >= 0) && (byte_num <= 4));
endproperty
assert property(af_p41);

property af_p42;
@(posedge clk) (byte_num >= 1 && byte_num <= 4) |=> (byte_num >= 0 && byte_num <= 4);
endproperty
assert property(af_p42);

property af_p43;
@(posedge clk) ((byte_num >= 1 && byte_num <= 4) && !in_ready) |=> (byte_num >= 1 && byte_num <= 4);
endproperty
assert property(af_p43);

property af_p44;
@(posedge clk) (buffer_full) |=> (byte_num == $past(byte_num)) && (byte_num >= 0 && byte_num <= 4);
endproperty
assert property(af_p44);

property af_p45;
@(posedge clk) (out_ready) |-> (byte_num >= 0 && byte_num <= 4);
endproperty
assert property(af_p45);

property af_p46;
@(posedge clk) (in_ready && !buffer_full) |=> (byte_num == $past(byte_num) + 1);
endproperty
assert property(af_p46);

property af_p47;
@(posedge clk) ($isunknown(in) == 0) |-> (byte_num >= 1 && byte_num <= 4);
endproperty
assert property(af_p47);

property af_p48;
@(posedge clk) in_ready |=> (byte_num == ($past(byte_num) + 1));
endproperty
assert property(af_p48);

property af_p49;
@(posedge clk) in_ready |-> (in !== 'x);
endproperty
assert property(af_p49);

property af_p50;
@(posedge clk) (($time - $past($time)) == CLK_PERIOD) and @(negedge clk) (in_ready == $past(in_ready));
endproperty
assert property(af_p50);

property af_p51;
@(posedge clk) ($stable(clk)) |-> ($stable(out) && $stable(out_ready) && $stable(buffer_full));
endproperty
assert property(af_p51);

property af_p52;
@(posedge clk) (($time - $past($time)) == CLK_PERIOD);
endproperty
assert property(af_p52);

property af_p53;
@(posedge clk) $fell(buffer_full) |-> (out_ready && !$isunknown(out));
endproperty
assert property(af_p53);

property af_p54;
@(posedge clk) out_ready |-> (out !== 'x);
endproperty
assert property(af_p54);

property af_p55;
@(posedge clk) $rose(in_ready) |-> ##3 (buffer_full == (byte_num == RATE));
endproperty
assert property(af_p55);

property af_p56;
@(posedge clk) (in_ready && !buffer_full) |=> (buffer_full == (byte_num == RATE));
endproperty
assert property(af_p56);

property af_p57;
@(posedge clk) (out_ready) |=> $stable(out);
endproperty
assert property(af_p57);

property af_p58;
@(posedge clk) (in_ready) |-> $stable(in);
endproperty
assert property(af_p58);

property af_p59;
@(posedge clk) (in_ready) |-> (data == $past(data));
endproperty
assert property(af_p59);

property af_p60;
@(posedge clk) (in_ready && (byte_num == byte_num_max)) |-> buffer_full;
endproperty
assert property(af_p60);

property af_p61;
@(posedge clk) (in_ready) |=> ($past(data) == data);
endproperty
assert property(af_p61);

property af_p62;
@(posedge clk) (in_ready) |-> ##[1:$] (out == (data ^ byte_num));
endproperty
assert property(af_p62);

property af_p63;
@(posedge clk) (in_ready) |-> ##[1:$] (buffer_full);
endproperty
assert property(af_p63);

property af_p64;
@(posedge clk) (in_ready) |=> (state == $past(data));
endproperty
assert property(af_p64);

property af_p65;
@(posedge clk) 1 |-> $stable(out) until_with (out !== $past(out));
endproperty
assert property(af_p65);

property af_p66;
@(posedge clk) 1 |-> ($past(byte_num) != byte_num) |-> ##1 $stable(byte_num);
endproperty
assert property(af_p66);

property af_p67;
@(posedge clk) (in_ready && data) |-> ##[1:5] out_ready;
endproperty
assert property(af_p67);

property af_p68;
@(posedge clk) in_ready |-> (in == $past(in));
endproperty
assert property(af_p68);

property af_p69;
@(posedge clk) 1 |-> $stable(data);
endproperty
assert property(af_p69);

property af_p70;
@(posedge clk) (!in_ready) |-> $stable(in);
endproperty
assert property(af_p70);

property af_p71;
@(posedge clk) 1 |-> $stable(data) throughout (@(negedge clk) 1);
endproperty
assert property(af_p71);

property af_p72;
@(posedge clk) (out_ready ##1 out_ready) |-> ($past(out_ready) == out_ready);
endproperty
assert property(af_p72);

property af_p73;
@(posedge clk) (!$changed(data)) |-> $stable(byte_num);
endproperty
assert property(af_p73);

property af_p74;
@(posedge clk) out_ready |-> $isunknown(out) == 0;
endproperty
assert property(af_p74);

property af_p75;
@(posedge clk) 1 |-> $stable(out_ready) throughout (@(negedge clk) 1);
endproperty
assert property(af_p75);

property af_p76;
@(posedge clk) (in_ready && byte_num == 1) |-> (!$isunknown(data[$bits(data)-1 -:8]));
endproperty
assert property(af_p76);

property af_p77;
@(posedge clk) ($rose(in_ready) && is_last && byte_num < ($bits(data)/8)) |=> (!$isunknown(data[$bits(data)-1 -: byte_num*8]));
endproperty
assert property(af_p77);

property af_p78;
@(posedge clk) (out_ready && in_ready) |-> (!$isunknown(data));
endproperty
assert property(af_p78);

property af_p79;
@(posedge clk) (byte_num == 0 && in_ready) |=> ($isunknown(data) || data == data);
endproperty
assert property(af_p79);

property af_p80;
@(posedge clk) buffer_full |=> $stable(data);
endproperty
assert property(af_p80);

property af_p81;
@(posedge clk) (byte_num != 0 && byte_num < ($bits(data)/8) && in_ready) |-> ##[1:$] (out_ready == out_ready);
endproperty
assert property(af_p81);

property af_p82;
@(posedge clk) (byte_num != 0 && byte_num < ($bits(data)/8)) |-> (data[($bits(data)-1)-(byte_num*8):0] == '0);
endproperty
assert property(af_p82);

property af_p83;
@(posedge clk) (!in_ready) |=> $stable(data);
endproperty
assert property(af_p83);

property af_p84;
@(posedge clk) buffer_full |-> (data == $past(data));
endproperty
assert property(af_p84);

property af_p85;
@(posedge clk) (in_ready && !is_last) |-> (byte_num == ($bits(data)/8));
endproperty
assert property(af_p85);

property af_p86;
@(posedge clk) (in_ready && is_last) |-> (byte_num <= ($bits(data)/8)) && !$isunknown(data[($bits(data))-1 -: byte_num*8]);
endproperty
assert property(af_p86);

property af_p87;
@(posedge clk) (!in_ready) |=> $stable(buffer_full);
endproperty
assert property(af_p87);

property af_p88;
@(posedge clk) (in_ready && (byte_num == $bits(data)/8)) |-> !$isunknown(data);
endproperty
assert property(af_p88);

property af_p89;
@(posedge clk) (in_ready && is_last && (byte_num == 0)) |-> (data == '0);
endproperty
assert property(af_p89);

property af_p90;
@(posedge clk) (in_ready) |-> !$isunknown(data);
endproperty
assert property(af_p90);

property af_p91;
@(posedge clk) (in_ready && is_last) |-> !$isunknown(data[($bits(data))-1 -: byte_num*8]);
endproperty
assert property(af_p91);

property af_p92;
@(posedge clk) (in_ready && !buffer_full) |=> !$isunknown(data);
endproperty
assert property(af_p92);

property af_p93;
@(posedge clk) (in_ready) |=> $stable(data);
endproperty
assert property(af_p93);

property af_p94;
@(posedge clk) $fell(rst) |=> !$isunknown(data);
endproperty
assert property(af_p94);

property af_p95;
@(posedge clk) (in_ready && (byte_num < ($bits(data)/8))) |-> is_last;
endproperty
assert property(af_p95);

property af_p96;
@(posedge clk) (in_ready && (byte_num == ($bits(data)/8))) |-> (data[$bits(data)-1:0] === data);
endproperty
assert property(af_p96);

property af_p97;
@(posedge clk) (in_ready) |-> ##1 $stable(data);
endproperty
assert property(af_p97);

property af_p98;
@(posedge clk) ($rose(in_ready)) |=> $stable(data);
endproperty
assert property(af_p98);

property af_p99;
@(posedge clk) (in_ready && (byte_num == $bits(data)/8)) |-> (!$isunknown(data));
endproperty
assert property(af_p99);

property af_p100;
@(posedge clk) (!in_ready) |-> (out !== $past(data));
endproperty
assert property(af_p100);

property af_p101;
@(posedge clk) (buffer_full) |=> $stable(data);
endproperty
assert property(af_p101);

property af_p102;
@(posedge clk) (out_ready) |-> $stable(out);
endproperty
assert property(af_p102);

property af_p103;
@(posedge clk) (in_ready && (byte_num < ($bits(data)/8))) |-> (!$isunknown(data[$bits(data)-1 -: (byte_num*8)]));
endproperty
assert property(af_p103);

property af_p104;
@(posedge clk) (!in_ready) |-> (1'b1);
endproperty
assert property(af_p104);

property af_p105;
@(posedge clk) ((in >= 100) && (in <= 127)) |=> ((in >= 90) && (in <= 127));
endproperty
assert property(af_p105);

property af_p106;
@(posedge clk) buffer_full |-> (data != in);
endproperty
assert property(af_p106);

property af_p107;
@(posedge clk) (buffer_full && $past(buffer_full)) |-> $stable(in);
endproperty
assert property(af_p107);

property af_p108;
@(posedge clk) buffer_full |=> $stable(in);
endproperty
assert property(af_p108);

property af_p109;
@(posedge clk) (!in_ready)[*3] |-> ($stable(out_ready) && $stable(out));
endproperty
assert property(af_p109);

property af_p110;
@(posedge clk) (!in_ready || buffer_full) |-> $stable(in);
endproperty
assert property(af_p110);

property af_p111;
@(posedge clk) $rose(buffer_full) |=> $stable(in);
endproperty
assert property(af_p111);

property af_p112;
@(posedge clk) in_ready |-> ##3 (out_ready -> (out == in));
endproperty
assert property(af_p112);

property af_p113;
@(posedge clk) (in_ready && !buffer_full) |-> ((in >= 1) && (in <= 254));
endproperty
assert property(af_p113);

property af_p114;
@(posedge clk) (byte_num != 3'b111) |-> (in[63:(byte_num*8)] == '0);
endproperty
assert property(af_p114);

property af_p115;
@(posedge clk) (in_ready && (in >= 0) && (in <= 4294967295)) |-> $stable(in);
endproperty
assert property(af_p115);

property af_p116;
@(posedge clk) (in_ready && (byte_num != 3'b000)) |-> $stable(in);
endproperty
assert property(af_p116);

property af_p117;
@(posedge clk) (buffer_full) |-> $stable(in);
endproperty
assert property(af_p117);

property af_p118;
@(posedge clk) $rose(in_ready) |-> ##2 ((in >= 10) && (in <= 200));
endproperty
assert property(af_p118);

property af_p119;
@(posedge clk) (!in_ready) |-> $stable(in);
endproperty
assert property(af_p119);

property af_p120;
@(posedge clk) $fell(buffer_full) |=> !$stable(in);
endproperty
assert property(af_p120);

property af_p121;
@(posedge clk) (in_ready) |-> ((in >= 0) && (in <= 64'hFFFFFFFFFFFFFFFF));
endproperty
assert property(af_p121);

property af_p122;
@(posedge clk) $rose(in_ready) |-> ##3 ((in >= 0) && (in <= 63));
endproperty
assert property(af_p122);

property af_p123;
@(posedge clk) $rose(in_ready) |=> $stable(in);
endproperty
assert property(af_p123);

property af_p124;
@(posedge clk) (!in_ready) |-> ((in >= 0) && (in <= 64'hFFFFFFFFFFFFFFFF));
endproperty
assert property(af_p124);

property af_p125;
@(posedge clk) (in_ready) |-> (in == $past(in)) until (!buffer_full);
endproperty
assert property(af_p125);

property af_p126;
@(posedge clk) ($rose(in_ready)) |-> ($past(in) !== 'x);
endproperty
assert property(af_p126);

property af_p127;
@(posedge clk) ((in >= 50) && (in <= 75)) |-> ##1 ((in >= 30) && (in <= 90));
endproperty
assert property(af_p127);

property af_p128;
@(posedge clk) ((in >= 200) && (in <= 255) && in_ready) |-> ##1 (out == $past(in));
endproperty
assert property(af_p128);

property af_p129;
@(posedge clk) (in_ready && !buffer_full) |-> (hash_in == in);
endproperty
assert property(af_p129);

property af_p130;
@(posedge clk) (byte_num != 3'b000) |-> (in[63:(byte_num*8)] == '0);
endproperty
assert property(af_p130);

property af_p131;
@(posedge clk) (in_ready && !buffer_full) |-> ((in >= 64'h0) && (in <= 64'hFFFFFFFFFFFFFFFF));
endproperty
assert property(af_p131);

property af_p132;
@(posedge clk) ((in >= 1000) && (in <= 2000) && in_ready) |-> ##1 (data == in);
endproperty
assert property(af_p132);

property af_p133;
@(posedge clk) ($rose(buffer_full)) |-> ##1 ($stable(in));
endproperty
assert property(af_p133);

property af_p134;
@(posedge clk) (in_ready && !buffer_full) |-> ##2 ($stable(in));
endproperty
assert property(af_p134);

property af_p135;
@(posedge clk) ($rose(buffer_full)) |=> (!in_ready) ##1 (!in_ready);
endproperty
assert property(af_p135);

property af_p136;
@(posedge clk) ($changed(buffer_full)) |=> ($changed(in_ready) || (in_ready == !buffer_full));
endproperty
assert property(af_p136);

property af_p137;
@(posedge clk) (buffer_full) |=> (!in_ready);
endproperty
assert property(af_p137);

property af_p138;
@(posedge clk) ($fell(buffer_full)) |=> (in_ready);
endproperty
assert property(af_p138);

property af_p139;
@(posedge clk) ($stable(buffer_full)) |-> ($stable(in_ready));
endproperty
assert property(af_p139);

property af_p140;
@(posedge clk) ($rose(out_ready)) |=> (in_ready);
endproperty
assert property(af_p140);

property af_p141;
@(posedge clk) (in_ready) |-> ##1 $stable(byte_num);
endproperty
assert property(af_p141);

property af_p142;
@(posedge clk) (in_ready && !buffer_full) |-> ##1 (!buffer_full |-> in_ready);
endproperty
assert property(af_p142);

property af_p143;
@(posedge clk) (in_ready) |-> ##1 $isunknown(in) == 0;
endproperty
assert property(af_p143);

property af_p144;
@(posedge clk) (in_ready) |-> ($isunknown(in) == 0);
endproperty
assert property(af_p144);

property af_p145;
@(posedge clk) (byte_num < 8'd8) |-> !in_ready;
endproperty
assert property(af_p145);

property af_p146;
@(posedge clk) (in_ready && !$isunknown(byte_num)) |-> ##1 $isunknown(in) == 0;
endproperty
assert property(af_p146);

property af_p147;
@(posedge clk) (!buffer_full) |-> in_ready;
endproperty
assert property(af_p147);

property af_p148;
@(posedge clk) (in_ready) |-> (!out_ready);
endproperty
assert property(af_p148);

property af_p149;
@(posedge clk) ($rose(buffer_full)) |-> (!in_ready);
endproperty
assert property(af_p149);

property af_p150;
@(posedge clk) (in_ready) |-> (byte_num == $countones(in));
endproperty
assert property(af_p150);

property af_p151;
@(posedge clk) (in_ready) |=> (data == $past(in));
endproperty
assert property(af_p151);

property af_p152;
@(posedge clk) (buffer_full) |-> (!in_ready) throughout (buffer_full[*1:$]);
endproperty
assert property(af_p152);

property af_p153;
@(posedge clk) (!in_ready) |=> (data == $past(data));
endproperty
assert property(af_p153);

property af_p154;
@(posedge clk) $rose(out_ready) |-> (!$isunknown(out)) ##1 (out_ready |-> $stable(out));
endproperty
assert property(af_p154);

property af_p155;
@(posedge clk) (!out_ready) |-> ((out == '0) || $isunknown(out));
endproperty
assert property(af_p155);

property af_p156;
@(posedge clk) (!out_ready) |-> $stable(out);
endproperty
assert property(af_p156);

property af_p157;
@(posedge clk) (out_ready && !(in_ready && in)) |-> $stable(out);
endproperty
assert property(af_p157);

property af_p158;
@(posedge clk) (!in_ready) |-> !($isunknown(out) && out_ready);
endproperty
assert property(af_p158);

property af_p159;
@(posedge clk) (in_ready && (byte_num == 3'b000) && in) |-> ##[1:16] (out_ready && $stable(out));
endproperty
assert property(af_p159);

property af_p160;
@(posedge clk) $rose(out_ready) |-> ##1 $stable(out);
endproperty
assert property(af_p160);

property af_p161;
@(posedge clk) $rose(out_ready) |-> (out_ready && $stable(out))[*1] ##1 (!(in_ready && in) throughout (out_ready && $stable(out)));
endproperty
assert property(af_p161);

property af_p162;
@(posedge clk) buffer_full |-> $stable(out);
endproperty
assert property(af_p162);

property af_p163;
@(posedge clk) $rose(out_ready) |=> ($stable(out) until $rose(out_ready));
endproperty
assert property(af_p163);

property af_p164;
@(posedge clk) !in_ready |-> ($stable(out) until out_ready);
endproperty
assert property(af_p164);

property af_p165;
@(posedge clk) in_ready |-> $stable(out);
endproperty
assert property(af_p165);

property af_p166;
@(posedge clk) $rose(out_ready) |=> ($stable(out) until (!out_ready));
endproperty
assert property(af_p166);

property af_p167;
@(posedge clk) (in && in_ready) |-> ##[1:$] (out_ready && $stable(out));
endproperty
assert property(af_p167);

property af_p168;
@(posedge clk) !out_ready |-> $stable(out);
endproperty
assert property(af_p168);

property af_p169;
@(posedge clk) out_ready |-> $stable(out);
endproperty
assert property(af_p169);

property af_p170;
@(posedge clk) buffer_full |-> ($stable(out) until (!buffer_full && out_ready));
endproperty
assert property(af_p170);

property af_p171;
@(posedge clk) out_ready |-> !$isunknown(out);
endproperty
assert property(af_p171);

property af_p172;
@(posedge clk) (!buffer_full && in_ready) |-> (out == $past(out)) until_with (out_ready);
endproperty
assert property(af_p172);

property af_p173;
@(posedge clk) (!out_ready) |-> (out == '0);
endproperty
assert property(af_p173);

property af_p174;
@(posedge clk) (in_ready && byte_num != 0) [*1:$] ##1 out_ready |-> $stable(out) && (out != 512'b0);
endproperty
assert property(af_p174);

property af_p175;
@(posedge clk) (out_ready) |-> (out !== 512'bx);
endproperty
assert property(af_p175);

property af_p176;
@(posedge clk) ($past(out_ready) && out_ready) |-> (out != $past(out));
endproperty
assert property(af_p176);

property af_p177;
@(posedge clk) (!in_ready) |-> $stable(out);
endproperty
assert property(af_p177);

property af_p178;
@(posedge clk) (out_ready && $past(out_ready)) |-> $stable(out);
endproperty
assert property(af_p178);

property af_p179;
@(posedge clk) !(out_ready && buffer_full);
endproperty
assert property(af_p179);

property af_p180;
@(posedge clk) (out_ready) |=> (!out_ready);
endproperty
assert property(af_p180);

property af_p181;
@(posedge clk) (out_ready) |-> ($stable(out) || out_ready throughout out_ready[->1]);
endproperty
assert property(af_p181);

property af_p182;
@(posedge clk) (in_ready) |-> (out_ready == 1'b0);
endproperty
assert property(af_p182);

property af_p183;
@(posedge clk) (out_ready) |-> ($stable(out) throughout out_ready[->1]);
endproperty
assert property(af_p183);

property af_p184;
@(posedge clk) ($fell(in_ready)) |-> (out_ready == 1'b0);
endproperty
assert property(af_p184);

property af_p185;
@(posedge clk) ($rose(out_ready)) |-> (out_ready ##1 !out_ready);
endproperty
assert property(af_p185);

property af_p186;
@(posedge clk) (buffer_full) |-> !out_ready;
endproperty
assert property(af_p186);

property af_p187;
@(posedge clk) (in_ready && $stable(in)) [*1] |=> ##[1:$] $rose(out_ready);
endproperty
assert property(af_p187);

property af_p188;
@(posedge clk) $rose(out_ready) |-> ($stable(out) && !$isunknown(out));
endproperty
assert property(af_p188);

property af_p189;
@(posedge clk) $rose(out_ready) |-> (byte_num == BYTE_NUM_FINAL);
endproperty
assert property(af_p189);

property af_p190;
@(posedge clk) $rose(out_ready) |-> $past(!in_ready, 1);
endproperty
assert property(af_p190);

property af_p191;
@(posedge clk) $rose(out_ready) |=> !out_ready;
endproperty
assert property(af_p191);

property af_p192;
@(posedge clk) $rose(out_ready) |-> $past(byte_num == 0) && $past(data == data);
endproperty
assert property(af_p192);

property af_p193;
@(posedge clk) $rose(out_ready) |-> $stable(out) throughout (out_ready[->1]);
endproperty
assert property(af_p193);

property af_p194;
@(posedge clk) (in_ready && $past(byte_num) == 0) |-> ##[1:16] out_ready;
endproperty
assert property(af_p194);

property af_p195;
@(posedge clk) buffer_full |-> !out_ready;
endproperty
assert property(af_p195);

property af_p196;
@(posedge clk) in_ready |-> !out_ready;
endproperty
assert property(af_p196);

property af_p197;
@(posedge clk) $fell(in_ready) |-> ##[1:16] $rose(out_ready);
endproperty
assert property(af_p197);

