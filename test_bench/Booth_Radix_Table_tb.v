`timescale 1ns / 1ns
// `include "Booth_Radix_Table.v"
module Booth_Radix_Table_tb ();
  reg [2:0] In;
  wire Shift, Negation,Zero;
  Booth_Radix_Table uup (
      .In(In),
      .Shift(Shift),
      .Negation(Negation),
      .Zero(Zero)
  );
  initial begin
    $dumpfile("Booth_Radix_Table_tb.vcd");
    $dumpvars(0, Booth_Radix_Table_tb);
    for (integer i = 0; i <= 7; i++) begin
      In = i;
      #20;
    end
  end
endmodule