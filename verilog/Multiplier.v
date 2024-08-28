`timescale 1ns / 1ns
`include "Booth_Radix_Table.v"
`include "Multiplier_Sub_Module.v"
`include "Booth_Radix_Table_Initial.v"
module Multiplier_4X4 (
    input [3:0]Multiplicant,
    Multiplier,
    output reg [7:0]Result
);
  wire [1:0]Shift,Negation,Zero;
  wire [4:0][1:0]Result_wire;
  Booth_Radix_Table_Initial instant_1(.In(Multiplier[1:0]),
                                    .Shift(Shift[0]),
                                    .Negation(Negation[0]),
                                    .Zero(Zero[0]));
  Multiplier_Sub_Module instant_1(.Multiplicant(Multiplicant[3:0]),
                                  .Shift(Shift[0]),
                                  .Zero(Zero[0]),
                                  .Negation(Negation[0]),
                                  .Result(Result_wire[0][4:0]));
  Booth_Radix_Table_Initial instant_2(.In(Multiplier[3:0]),
                                    .Shift(Shift[1]),
                                    .Negation(Negation[1]),
                                    .Zero(Zero[1]));
  Multiplier_Sub_Module instant_2(.Multiplicant(Multiplicant[3:0]),
                                  .Shift(Shift[1]),
                                  .Zero(Zero[1]),
                                  .Negation(Negation[1]),
                                  .Result(Result_wire[1][4:0]));
endmodule //Multiplier