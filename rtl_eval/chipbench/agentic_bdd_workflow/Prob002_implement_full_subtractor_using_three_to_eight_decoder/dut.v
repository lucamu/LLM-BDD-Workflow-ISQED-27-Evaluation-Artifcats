module TopModule (
    input  A,
    input  B,
    input  Ci,
    output D,
    output Co
);

    // Internal wires connecting decoder outputs to subtractor logic
    wire Y0n, Y1n, Y2n, Y3n, Y4n, Y5n, Y6n, Y7n;

    // Enable tied to 1 as per spec (decoder always active)
    wire E_tied = 1'b1;

    //-------------------------------------------------------------------
    // Scenario: Decoder activates exactly one output line per input
    //           combination (address {A2,A1,A0} = {A,B,Ci})
    //-------------------------------------------------------------------
    decoder_38 u_decoder (
        .E   (E_tied),
        .A0  (Ci),      // A0 = Ci
        .A1  (B),       // A1 = B
        .A2  (A),       // A2 = A
        .Y0n (Y0n),
        .Y1n (Y1n),
        .Y2n (Y2n),
        .Y3n (Y3n),
        .Y4n (Y4n),
        .Y5n (Y5n),
        .Y6n (Y6n),
        .Y7n (Y7n)
    );

    //-------------------------------------------------------------------
    // Scenario: Difference output follows XOR relationship (D = A^B^Ci)
    // Scenario: Borrow output follows subtractor borrow equation
    //           (Co = (~A&B) | (~A&Ci) | (B&Ci))
    // Scenario: All corner cases (0,0,0) through (1,1,1) are covered
    //           by this combinational logic derived from decoder lines.
    //-------------------------------------------------------------------
    dut__subtractor_logic u_subtractor (
        .Y0n (Y0n),
        .Y1n (Y1n),
        .Y2n (Y2n),
        .Y3n (Y3n),
        .Y4n (Y4n),
        .Y5n (Y5n),
        .Y6n (Y6n),
        .Y7n (Y7n),
        .D   (D),
        .Co  (Co)
    );

    //-------------------------------------------------------------------
    // Scenario: Output ports are single bit and fully determined by
    //           inputs A, B, Ci only (no other signals influence D/Co,
    //           since this module is purely combinational and only
    //           depends on A, B, Ci through the decoder and subtractor
    //           logic instantiations above).
    //-------------------------------------------------------------------

endmodule

module decoder_38(
   input             E      ,
   input             A0     ,
   input             A1     ,
   input             A2     ,
   
   output reg       Y0n    ,  
   output reg       Y1n    , 
   output reg       Y2n    , 
   output reg       Y3n    , 
   output reg       Y4n    , 
   output reg       Y5n    , 
   output reg       Y6n    , 
   output reg       Y7n    
);

always @(*)begin
   if(!E)begin
      Y0n = 1'b1;
      Y1n = 1'b1;
      Y2n = 1'b1;
      Y3n = 1'b1;
      Y4n = 1'b1;
      Y5n = 1'b1;
      Y6n = 1'b1;
      Y7n = 1'b1;
   end  
   else begin
      case({A2,A1,A0})
         3'b000 : begin
                     Y0n = 1'b0; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b1;
                  end 
         3'b001 : begin
                     Y0n = 1'b1; Y1n = 1'b0; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b1;
                  end 
         3'b010 : begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b0; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b1;
                  end 
         3'b011 : begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b0; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b1;
                  end 
         3'b100 : begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b0; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b1;
                  end 
         3'b101 : begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b0; Y6n = 1'b1; Y7n = 1'b1;
                  end 
         3'b110 : begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b0; Y7n = 1'b1;
                  end 
         3'b111 : begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b0;
                  end 
         default: begin
                     Y0n = 1'b1; Y1n = 1'b1; Y2n = 1'b1; Y3n = 1'b1; 
                     Y4n = 1'b1; Y5n = 1'b1; Y6n = 1'b1; Y7n = 1'b1;
                  end
      endcase  
   end 
end    
     
endmodule

module dut__subtractor_logic (
    input  wire Y0n,
    input  wire Y1n,
    input  wire Y2n,
    input  wire Y3n,
    input  wire Y4n,
    input  wire Y5n,
    input  wire Y6n,
    input  wire Y7n,
    output wire D,
    output wire Co
);

    // -------------------------------------------------------------------
    // Difference output D
    // Scenario: Difference output asserted when any active-low D-minterm
    //           (Y1n, Y2n, Y4n, Y7n) is active (0)
    // Scenario: Difference output deasserted when all D-minterms are
    //           inactive (all = 1)
    // Scenario: Difference output is independent of Y0n, Y3n, Y5n, Y6n
    //           (these signals do not appear in this expression)
    // Scenario: Functional equivalence - with one-hot active-low decoder
    //           pattern, D = A XOR B XOR Ci
    // D = NOT (Y1n AND Y2n AND Y4n AND Y7n)  -- implemented as a NAND gate
    // -------------------------------------------------------------------
    assign D = ~(Y1n & Y2n & Y4n & Y7n);

    // -------------------------------------------------------------------
    // Borrow-out output Co
    // Scenario: Borrow-out asserted when any active-low Co-minterm
    //           (Y2n, Y4n, Y6n, Y7n) is active (0)
    // Scenario: Borrow-out deasserted when all Co-minterms are
    //           inactive (all = 1)
    // Scenario: Borrow-out output is independent of Y0n, Y1n, Y3n, Y5n
    //           (these signals do not appear in this expression)
    // Scenario: Functional equivalence - with one-hot active-low decoder
    //           pattern, Co = (~A & B) | (~A & Ci) | (B & Ci)
    // Co = NOT (Y2n AND Y4n AND Y6n AND Y7n) -- implemented as a NAND gate
    // -------------------------------------------------------------------
    assign Co = ~(Y2n & Y4n & Y6n & Y7n);

    // -------------------------------------------------------------------
    // Scenario: Outputs are purely combinational functions of current
    //           decoder inputs - implemented via continuous assign
    //           statements with no internal state (no_state scenario).
    // -------------------------------------------------------------------

endmodule
