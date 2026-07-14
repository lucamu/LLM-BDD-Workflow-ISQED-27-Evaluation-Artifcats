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
