`timescale 1ns / 1ns
`include "verilog/Multiplier_8x8.v"
module Multiplier_8x8_tb ();
    reg Mode;
    reg [7:0] In_1,In_2;
    reg Sign;
    wire [15:0]Result_1;
    Multiplier_8x8 DUT(.Result(Result_1),
                       .In_1(In_1),
                       .In_2(In_2),
                       .Sign(Sign),
                       .Mode(Mode));
    // reg [3:0] In_1,In_2;
    // reg Sign;
    // wire [7:0]Result_1;
    // M_4x4_4 DUT(.Result(Result_1),
    //                    .A(In_1),
    //                    .B(In_2),
    //                    .Sign(Sign),.Mode(Mode));
    initial begin
        $dumpfile("vcd/Multiplier_8x8_tb_new.vcd");
        $dumpvars(1,DUT);
        Mode = 0;
        Sign = 1;
        for ( integer i=0;i<10 ;i=i+1 ) begin
            In_1 = $urandom_range(0, 255);
            In_2 = $urandom_range(0, 255); 
            #20; 
        end
        Sign = 0;
        for ( integer i=0;i<10 ;i=i+1 ) begin
            In_1 = $urandom_range(0, 255);
            In_2 = $urandom_range(0, 255); 
            #20; 
        end

        // In_1 = 4;
        // In_2 = 49;
        // #20
     
        $finish();
    end

endmodule