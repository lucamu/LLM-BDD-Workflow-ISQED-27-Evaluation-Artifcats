/*
 * Copyright 2012, Homer Hsing <homer.hsing@gmail.com>
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

module aes_128(clk, state, key, out);
    input          clk;
    input  [127:0] state, key;
    output [127:0] out;
    reg    [127:0] s0, k0;
    wire   [127:0] s1, s2, s3, s4, s5, s6, s7, s8, s9,
                   k1, k2, k3, k4, k5, k6, k7, k8, k9,
                   k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8b, k9b;

    always @ (posedge clk)
      begin
        s0 <= state ^ key;
        k0 <= key;
      end

    expand_key_128
        a1 (clk, k0, k1, k0b, 8'h1),
        a2 (clk, k1, k2, k1b, 8'h2),
        a3 (clk, k2, k3, k2b, 8'h4),
        a4 (clk, k3, k4, k3b, 8'h8),
        a5 (clk, k4, k5, k4b, 8'h10),
        a6 (clk, k5, k6, k5b, 8'h20),
        a7 (clk, k6, k7, k6b, 8'h40),
        a8 (clk, k7, k8, k7b, 8'h80),
        a9 (clk, k8, k9, k8b, 8'h1b),
       a10 (clk, k9,   , k9b, 8'h36);

    one_round
        r1 (clk, s0, k0b, s1),
        r2 (clk, s1, k1b, s2),
        r3 (clk, s2, k2b, s3),
        r4 (clk, s3, k3b, s4),
        r5 (clk, s4, k4b, s5),
        r6 (clk, s5, k5b, s6),
        r7 (clk, s6, k6b, s7),
        r8 (clk, s7, k7b, s8),
        r9 (clk, s8, k8b, s9);

    final_round
        rf (clk, s9, k9b, out);
    // --- Formal assertions ---
    // AssertionForge baseline SVA for tiny_aes
    // 200 assertions captured from gen_plan.generate_svas

    property af_p0;
    @(posedge clk) (1) |-> ##1 state == $past(state, 1) || state != $past(state, 1);
    endproperty
    assert property(af_p0);



















    property af_p19;
    @(posedge clk) (1) |=> (out == $past(state));
    endproperty
    assert property(af_p19);






    property af_p25;
    @(posedge clk) 1'b1 |=> $stable(state);
    endproperty
    assert property(af_p25);



    property af_p28;
    @(posedge clk) 1'b1 |=> $stable(out);
    endproperty
    assert property(af_p28);
































    property af_p60;
    @(posedge clk) (!state) |-> (out == 0);
    endproperty
    assert property(af_p60);




    property af_p64;
    @(posedge clk) (!state) |-> ##1 $stable(out);
    endproperty
    assert property(af_p64);

    property af_p65;
    @(posedge clk) $rose(state) |-> $stable(out)[*1];
    endproperty
    assert property(af_p65);

    property af_p66;
    @(posedge clk) $rose(state) |-> ##[1:19] $stable(out);
    endproperty
    assert property(af_p66);


    property af_p68;
    @(posedge clk) (state) |-> (out >= 0) && (out <= 255);
    endproperty
    assert property(af_p68);



    property af_p71;
    @(posedge clk) $changed(state) |=> (out >= 0 && out <= 255);
    endproperty
    assert property(af_p71);








    property af_p79;
    @(posedge clk) $stable(state) |-> $stable(out);
    endproperty
    assert property(af_p79);



    property af_p82;
    @(posedge clk) 1'b1 |-> ((out[7:0] >= 0) && (out[7:0] <= 255));
    endproperty
    assert property(af_p82);



    property af_p85;
    @(posedge clk) 1'b1 |-> !$isunknown(out);
    endproperty
    assert property(af_p85);



    property af_p88;
    @(posedge clk) $stable(out) |-> ##1 $stable(out);
    endproperty
    assert property(af_p88);

    property af_p89;
    @(posedge clk) (state) |-> $stable(out);
    endproperty
    assert property(af_p89);
















































































    property af_p169;
    @(posedge clk) (state == $past(state)) |-> (out == $past(out));
    endproperty
    assert property(af_p169);



    property af_p172;
    @(posedge clk) $changed(state) |-> ##1 $changed(out);
    endproperty
    assert property(af_p172);



    property af_p175;
    @(posedge clk) $changed(state) |-> $changed(out);
    endproperty
    assert property(af_p175);


    property af_p177;
    @(posedge clk) 1 |-> ##2 (state != $past(state,2));
    endproperty
    assert property(af_p177);


    property af_p179;
    @(posedge clk) 1 |-> ##2 (state != $past(state));
    endproperty
    assert property(af_p179);

    property af_p180;
    @(posedge clk) $past(state,2) != state |-> $changed(state);
    endproperty
    assert property(af_p180);



    property af_p183;
    @(posedge clk) (1'b1) |-> ##1 (state == ($past(state) + 1));
    endproperty
    assert property(af_p183);





    property af_p188;
    @(posedge clk) (1'b1) |-> ##1 ($bits(state) == $bits($past(state)));
    endproperty
    assert property(af_p188);


    property af_p190;
    @(posedge clk) (1'b1) |-> ##1 $stable(state);
    endproperty
    assert property(af_p190);




    property af_p194;
    @(posedge clk) (state == $past(state,2)) |-> (out == $past(out,2));
    endproperty
    assert property(af_p194);





    property af_p199;
    @(posedge clk) 1'b1 |-> !$isunknown(state);
    endproperty
    assert property(af_p199);




endmodule

module expand_key_128(clk, in, out_1, out_2, rcon);
    input              clk;
    input      [127:0] in;
    input      [7:0]   rcon;
    output reg [127:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3,
                       v0, v1, v2, v3;
    reg        [31:0]  k0a, k1a, k2a, k3a;
    wire       [31:0]  k0b, k1b, k2b, k3b, k4a;

    assign {k0, k1, k2, k3} = in;
    
    assign v0 = {k0[31:24] ^ rcon, k0[23:0]};
    assign v1 = v0 ^ k1;
    assign v2 = v1 ^ k2;
    assign v3 = v2 ^ k3;

    always @ (posedge clk)
        {k0a, k1a, k2a, k3a} <= {v0, v1, v2, v3};

    S4
        S4_0 (clk, {k3[23:0], k3[31:24]}, k4a);

    assign k0b = k0a ^ k4a;
    assign k1b = k1a ^ k4a;
    assign k2b = k2a ^ k4a;
    assign k3b = k3a ^ k4a;

    always @ (posedge clk)
        out_1 <= {k0b, k1b, k2b, k3b};

    assign out_2 = {k0b, k1b, k2b, k3b};
endmodule

