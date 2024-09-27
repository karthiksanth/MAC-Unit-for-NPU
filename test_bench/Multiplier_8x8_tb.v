`timescale 1ns / 1ns
`include "verilog/Multiplier_8x8.v"
module Multiplier_8x8_tb ();
    
    reg [7:0] In_1,In_2;
    reg Sign;
    wire [15:0]Result_1;
    Multiplier_8x8 DUT(.Result(Result_1),
                       .In_1(In_1),
                       .In_2(In_2),
                       .Sign(Sign));
    // reg [3:0] In_1,In_2;
    // reg Sign;
    // wire [7:0]Result_1;
    // M_4x4_2 DUT(.Result(Result_1),
    //                    .A(In_1),
    //                    .B(In_2),
    //                    .Sign(Sign));
    initial begin
        $dumpfile("vcd/Multiplier_8x8_tb.vcd");
        $dumpvars(1,DUT);
        Sign = 1;
        for ( integer i=0;i<20 ;i=i+1 ) begin
            In_1 = $urandom_range(0, 15);
            In_2 = $urandom_range(0, 15); 
            #20; 
        end
        Sign = 0;
        for ( integer i=0;i<20 ;i=i+1 ) begin
            In_1 = $urandom_range(0, 15);
            In_2 = $urandom_range(0, 15); 
            #20; 
        end
        $finish();
    end

endmodule