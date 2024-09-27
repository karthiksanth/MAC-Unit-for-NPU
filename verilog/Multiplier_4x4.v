`include "verilog/Adder.v"
module Carry_Look_Ahead_Adder
        (   input [4:0] A,B,
            output [4:0] S
            );
            
    wire [4:0] P;
    wire [3:0] G;
    wire [3:0] C;   
    
        //first level
    assign P = A ^ B;
    assign G = A[3:0] & B[3:0];

    //second level
    // assign C[0] = cin;
    assign C[0] = G[0];
    assign C[1] = G[1] | (P[1] & G[0]) ;
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
            (P[3] & P[2] & P[1] & G[0]);

    //third level
    assign S[0] = P[0];
    assign S[4:1] = P[4:1] ^ C[3:0];

endmodule
module Multiplier_4x4 (
    output [7:0]Result,
    input  [3:0] In_1,
    input  [3:0] In_2,
    input  Sign

);
    genvar  i,j;
    wire And_array[3:0][3:0];

    //And Array 
    generate
        for (i=0 ; i<3 ; i=i+1)
    begin
        for (j=0; j< 3; j=j+1) begin
            assign And_array[i][j] = In_1[i]&In_2[j];
        end
    end
    endgenerate
    assign Result[0] = And_array[0][0];
    assign And_array[3][3]= In_2[3] ? In_1[3] : Sign;

    generate
        for(i=0;i<3;i=i+1) begin
            assign And_array[i][3]= (Sign ^ In_1[i]) & In_2[3];
        end
    endgenerate

    generate
        for(j=0;j<3;j=j+1) begin
            assign And_array[3][j]= Sign ^ (In_1[3] & In_2[j]);
        end
    endgenerate

    //Stage 1 Of Wallace Tree
    wire [5:0]Carry_1;
    wire [4:0]Sum_1;
    Half_Adder Ha_10(.Sum(Result[1]),
                    .Cout(Carry_1[0]),
                    .A(And_array[1][0]),
                    .B(And_array[0][1]));

    Full_Adder Fa_10 (.Sum(Sum_1[0]),
                    .Cout(Carry_1[1]),
                    .A(And_array[2][0]),
                    .B(And_array[1][1]),
                    .C(And_array[0][2]));
    Full_Adder  Fa_11 (.Sum(Sum_1[1]),
                    .Cout(Carry_1[2]),
                    .A(And_array[3][0]),
                    .B(And_array[2][1]),
                    .C(Sign));
    wire Complement;
    assign Complement = In_2[3] & Sign;
    Full_Adder  Fa_12 (.Sum(Sum_1[2]),
                    .Cout(Carry_1[3]),
                    .A(And_array[1][2]),
                    .B(And_array[0][3]),
                    .C(Complement));

    Full_Adder  Fa_13 (.Sum(Sum_1[3]),
                    .Cout(Carry_1[4]),
                    .A(And_array[3][1]),
                    .B(And_array[2][2]),
                    .C(And_array[1][3]));

    Half_Adder Ha_11 (.Sum(Sum_1[4]),
                    .Cout(Carry_1[5]),
                    .A(And_array[3][2]),
                    .B(And_array[2][3]));
    
    //Stage 2 Of Wallace Tree
    wire [4:0]Carry_2;wire [3:0]Sum_2;
    Half_Adder Ha_20(.Sum(Result[2]),
                    .Cout(Carry_2[0]),
                    .A(Carry_1[0]),
                    .B(Sum_1[0]));
            
    Full_Adder Fa_20(.Sum(Sum_2[0]),
                    .Cout(Carry_2[1]),
                    .A(Carry_1[1]),
                    .B(Sum_1[1]),
                    .C(Sum_1[2]));
    Full_Adder Fa_21(.Sum(Sum_2[1]),
                    .Cout(Carry_2[2]),
                    .A(Carry_1[2]),
                    .B(Carry_1[3]),
                    .C(Sum_1[3]));
    Half_Adder Ha_21(.Sum(Sum_2[2]),
                    .Cout(Carry_2[3]),
                    .A(Carry_1[4]),
                    .B(Sum_1[4]));
    Half_Adder Ha_22(.Sum(Sum_2[3]),
                    .Cout(Carry_2[4]),
                    .A(Carry_1[5]),
                    .B(And_array[3][3]));

    //Carry look ahead Adder Stage

    wire [4:0]Sum_Sign;
    assign Sum_Sign = {Sign,Sum_2};
    Carry_Look_Ahead_Adder CLA(.A(Sum_Sign),.B(Carry_2),.S(Result[7:3]));



endmodule