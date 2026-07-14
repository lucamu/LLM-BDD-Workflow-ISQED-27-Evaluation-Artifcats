/*
 * Copyright 2013, Homer Hsing <homer.hsing@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* "is_last" == 0 means byte number is 8, no matter what value "byte_num" is. */
/* if "in_ready" == 0, then "is_last" should be 0. */
/* the user switch to next "in" only if "ack" == 1. */

`define low_pos(w,b)      ((w)*64 + (b)*8)
`define low_pos2(w,b)     `low_pos(w,7-b)
`define high_pos(w,b)     (`low_pos(w,b) + 7)
`define high_pos2(w,b)    (`low_pos2(w,b) + 7)

module keccak(clk, reset, in, in_ready, is_last, byte_num, buffer_full, out, out_ready);
    input              clk, reset;
    input      [31:0]  in;
    input              in_ready, is_last;
    input      [1:0]   byte_num;
    output             buffer_full; /* to "user" module */
    output     [511:0] out;
    output reg         out_ready;

    reg                state;     /* state == 0: user will send more input data
                                   * state == 1: user will not send any data */
    wire       [575:0] padder_out,
                       padder_out_1; /* before reorder byte */
    wire               padder_out_ready;
    wire               f_ack;
    wire      [1599:0] f_out;
    wire               f_out_ready;
    wire       [511:0] out1;      /* before reorder byte */
    reg        [22:0]  i;         /* gen "out_ready" */

    genvar w, b;

    assign out1 = f_out[1599:1599-511];

    always @ (posedge clk)
      if (reset)
        i <= 0;
      else
        i <= {i[21:0], state & f_ack};

    always @ (posedge clk)
      if (reset)
        state <= 0;
      else if (is_last)
        state <= 1;

    /* reorder byte ~ ~ */
    generate
      for(w=0; w<8; w=w+1)
        begin : L0
          for(b=0; b<8; b=b+1)
            begin : L1
              assign out[`high_pos(w,b):`low_pos(w,b)] = out1[`high_pos2(w,b):`low_pos2(w,b)];
            end
        end
    endgenerate

    /* reorder byte ~ ~ */
    generate
      for(w=0; w<9; w=w+1)
        begin : L2
          for(b=0; b<8; b=b+1)
            begin : L3
              assign padder_out[`high_pos(w,b):`low_pos(w,b)] = padder_out_1[`high_pos2(w,b):`low_pos2(w,b)];
            end
        end
    endgenerate

    always @ (posedge clk)
      if (reset)
        out_ready <= 0;
      else if (i[22])
        out_ready <= 1;

    padder
      padder_ (clk, reset, in, in_ready, is_last, byte_num, buffer_full, padder_out_1, padder_out_ready, f_ack);

    f_permutation
      f_permutation_ (clk, reset, padder_out, padder_out_ready, f_ack, f_out, f_out_ready);
    // --- Formal assertions ---
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


    property af_p5;
    @(posedge clk) $fell(reset) |-> (!buffer_full[*3]) ##1 !in;
    endproperty
    assert property(af_p5);

    property af_p6;
    @(posedge clk) in_ready |-> !buffer_full;
    endproperty
    assert property(af_p6);


    property af_p8;
    @(posedge clk) (out_ready && out) |=> !buffer_full;
    endproperty
    assert property(af_p8);





    property af_p13;
    @(posedge clk) (buffer_full && in_ready) |=> !(buffer_full && in_ready);
    endproperty
    assert property(af_p13);


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


    property af_p22;
    @(posedge clk) out_ready |=> !buffer_full;
    endproperty
    assert property(af_p22);



    property af_p25;
    @(posedge clk) $rose(out_ready) |=> !buffer_full;
    endproperty
    assert property(af_p25);


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


    property af_p51;
    @(posedge clk) ($stable(clk)) |-> ($stable(out) && $stable(out_ready) && $stable(buffer_full));
    endproperty
    assert property(af_p51);


    property af_p53;
    @(posedge clk) $fell(buffer_full) |-> (out_ready && !$isunknown(out));
    endproperty
    assert property(af_p53);

    property af_p54;
    @(posedge clk) out_ready |-> (out !== 'x);
    endproperty
    assert property(af_p54);



    property af_p57;
    @(posedge clk) (out_ready) |=> $stable(out);
    endproperty
    assert property(af_p57);

    property af_p58;
    @(posedge clk) (in_ready) |-> $stable(in);
    endproperty
    assert property(af_p58);





    property af_p63;
    @(posedge clk) (in_ready) |-> ##[1:$] (buffer_full);
    endproperty
    assert property(af_p63);


    property af_p65;
    @(posedge clk) 1 |-> $stable(out) until_with (out !== $past(out));
    endproperty
    assert property(af_p65);

    property af_p66;
    @(posedge clk) 1 |-> ($past(byte_num) != byte_num) |-> ##1 $stable(byte_num);
    endproperty
    assert property(af_p66);


    property af_p68;
    @(posedge clk) in_ready |-> (in == $past(in));
    endproperty
    assert property(af_p68);


    property af_p70;
    @(posedge clk) (!in_ready) |-> $stable(in);
    endproperty
    assert property(af_p70);


    property af_p72;
    @(posedge clk) (out_ready ##1 out_ready) |-> ($past(out_ready) == out_ready);
    endproperty
    assert property(af_p72);


    property af_p74;
    @(posedge clk) out_ready |-> $isunknown(out) == 0;
    endproperty
    assert property(af_p74);

    property af_p75;
    @(posedge clk) 1 |-> $stable(out_ready) throughout (@(negedge clk) 1);
    endproperty
    assert property(af_p75);












    property af_p87;
    @(posedge clk) (!in_ready) |=> $stable(buffer_full);
    endproperty
    assert property(af_p87);















    property af_p102;
    @(posedge clk) (out_ready) |-> $stable(out);
    endproperty
    assert property(af_p102);


    property af_p104;
    @(posedge clk) (!in_ready) |-> (1'b1);
    endproperty
    assert property(af_p104);

    property af_p105;
    @(posedge clk) ((in >= 100) && (in <= 127)) |=> ((in >= 90) && (in <= 127));
    endproperty
    assert property(af_p105);


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



    property af_p131;
    @(posedge clk) (in_ready && !buffer_full) |-> ((in >= 64'h0) && (in <= 64'hFFFFFFFFFFFFFFFF));
    endproperty
    assert property(af_p131);


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


    property af_p152;
    @(posedge clk) (buffer_full) |-> (!in_ready) throughout (buffer_full[*1:$]);
    endproperty
    assert property(af_p152);



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


    property af_p190;
    @(posedge clk) $rose(out_ready) |-> $past(!in_ready, 1);
    endproperty
    assert property(af_p190);

    property af_p191;
    @(posedge clk) $rose(out_ready) |=> !out_ready;
    endproperty
    assert property(af_p191);


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




endmodule

`undef low_pos
`undef low_pos2
`undef high_pos
`undef high_pos2
