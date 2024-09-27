`timescale 1ns / 1ns

module Multiplier_4x4_tb ();
    
    reg [3:0] In_1,In_2;reg Sign;
    wire [7:0]Result;
    Multiplier_4x4 DUT(.Result(Result),
                       .In_1(In_1),
                       .In_2(In_2),
                       .Sign(Sign));
    initial begin
        $dumpfile("vcd/Multiplier_4x4_tb.vcd");
        $dumpvars(1,DUT);
        Sign = 0;
        for ( integer i=0;i<9 ;i=i+1 ) begin
            In_1 = $urandom_range(0, 15);
            In_2 = $urandom_range(0, 15); 
            #20; 
        end
        Sign = 1;
        for ( integer i=0;i<9 ;i=i+1 ) begin
            In_1 = $urandom_range(0, 15);
            In_2 = $urandom_range(0, 15); 
            #20 ;
        end

        $finish();
    end

endmodule