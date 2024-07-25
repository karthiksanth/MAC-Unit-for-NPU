`timescale 1ns / 1ns
module Multiplier_tb ();
 reg [3:0]Multiplicant;
 wire [4:0]Result;
 reg Shift,Negation,Zero;
Multiplier_4X4 DUP (.Multiplicant(Multiplicant),
                      .Result(Result),
                      .Shift(Shift),
                      .Negation(Negation),
                      .Zero(Zero) );
 initial begin
    $dumpfile("VCD/Multiplier_4X4_tb.vcd");
    $dumpvars(0, Multiplier_tb);
    for (integer i = 0; i <= 7; i++) begin
      Multiplicant = 4'b1010;
      Shift = i>>1;
      Negation = i;
      Zero = i>>2;
      #20;
    end
  end
endmodule //Multiplier_tb