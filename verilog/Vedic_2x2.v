`include "Half_Adder.v"
module Vedic_2x2 (
    output [3:0] Result,
    input  [1:0] In_1,
    input  [1:0] In_2  
);
    wire [2:0]temp; wire Sum_1;
    assign Result[0] = In_1[0] & In_2[0];
    assign temp[0] = In_1[1] & In_2[0];
    assign temp[1] = In_1[0] & In_2[1];
    assign temp[2] = In_1[1] & In_2[1];
    Half_Adder H1(.Sum(Result[1]),.Cout(Sum_1),.A(temp[0]),.B(temp[1]));
    Half_Adder H2(.Sum(Result[2]),.Cout(Result[3]),.A(temp[2]),.B(Sum_1));
endmodule

