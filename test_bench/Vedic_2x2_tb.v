`timescale 1ns / 1ns
module Vedic_2x2_tb();

     reg [1:0]In_1;reg [1:0]In_2;
     wire [3:0]Result;

     Vedic_2x2 DUI(.In_1(In_1),.In_2(In_2),.Result(Result));

     initial begin
    $dumpfile("vcd/Vedic_2x2_tb.vcd");
    $dumpvars(0, Vedic_2x2_tb);
    for (integer i=0; i<4 ; i++ ) begin
         In_1 = i;
        for (integer j =0 ;j<4 ;j++ ) begin
            In_2 = j;
            #20;
        end
    end 
    $finish();

end
    
endmodule