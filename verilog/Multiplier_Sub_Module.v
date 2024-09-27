`timescale 1ns / 1ns
// `include "Booth_Radix_Table"

module Multiplier_Sub_Module #(parameter Data_Width = 8)(
    input  [Data_Width-1:0] Multiplicant,
    input Shift,Negation,Zero,
    output reg [Data_Width:0] Result
);
wire [1:0]sel = {Shift,Negation};

initial Result=0;
  always @(Multiplicant or Shift or Negation or Zero) begin
    if (Zero) begin
        Result= 0;
    end
    else begin
        // if(!(Shift | Negation))Result=Multiplicant; 
        // if((Shift & !Negation))Result = Multiplicant<<1;
        // if((!Shift & Negation))Result= ~ Multiplicant;
        // if((Shift& Negation)) Result= (~ Multiplicant)<<1;
        case (sel)
            2'b00: Result=Multiplicant; 
            2'b10: Result = Multiplicant<<1;
            2'b01: begin
                Result= (~ Multiplicant)+1;
            end
            2'b11: begin
                Result= (~ Multiplicant+1)<<1;
            end    
           
        endcase
    end
end
endmodule
