`include "verilog/Adder.v"
`include "verilog/Look_Ahead_Adder.v"
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
module M4_Carry_Look_Ahead_Adder (
    output [4:0]  S,
    input  [4:0] A,
    input  [3:0] B
    );
    wire [4:0] P;
    wire [3:0] G;
    wire [3:0] C;   
    
    //first level
    assign P[4] =A[4];
    assign P[3:0] = A[3:0] ^ B;
    assign G = A[3:0] & B;

    //second level
    assign C[0] = G[0];
    assign C[1] = G[1] | (P[1] & G[0]) ;
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
            (P[3] & P[2] & P[1] & G[0]);

    //third level
    assign S[0] = P[0];
    assign S[4:1] = P[4:1] ^ C[3:0];   
endmodule
module M_4x4_1 (
    output [7:0] Result,
    input  [3:0] A,
    input  [3:0] B  
);
    wire And_array[3:0][3:0];
    genvar i,j;
    generate
        for (i =0 ;i<4 ;i=i+1 ) begin
            for ( j=0 ;j<4 ;j=j+1 ) begin
                assign And_array[i][j] = A[i] & B[j];
            end
        end
    endgenerate
    assign Result[0] = And_array[0][0];
    //Stage 1 Wallace Tree
    wire [3:0]Sum_1;
    wire [4:0]Carry_1;
    Half_Adder Ha_M4_10(.Sum(Result[1]),
                        .Cout(Carry_1[0]),
                        .A(And_array[1][0]),
                        .B(And_array[0][1]));
    Full_Adder Fa_M4_10(.Sum(Sum_1[0]),
                        .Cout(Carry_1[1]),
                        .A(And_array[2][0]),
                        .B(And_array[1][1]),
                        .C(And_array[0][2]));
    Full_Adder Fa_M4_11(.Sum(Sum_1[1]),
                        .Cout(Carry_1[2]),
                        .A(And_array[3][0]),
                        .B(And_array[2][1]),
                        .C(And_array[1][2]));
    Full_Adder Fa_M4_12(.Sum(Sum_1[2]),
                        .Cout(Carry_1[3]),
                        .A(And_array[3][1]),
                        .B(And_array[2][2]),
                        .C(And_array[1][3]));

    Half_Adder Ha_M4_11(.Sum(Sum_1[3]),
                        .Cout(Carry_1[4]),
                        .A(And_array[3][2]),
                        .B(And_array[2][3]));

    //Stage 2 Wallace Tree
    wire [3:0]Sum_2;
    wire [4:0]Carry_2;
    Half_Adder Ha_M4_20(.Sum(Result[2]),
                        .Cout(Carry_2[0]),
                        .A(Sum_1[0]),
                        .B(Carry_1[0]));
    
    Full_Adder Fa_M4_20 (.Sum(Sum_2[0]),
                        .Cout(Carry_2[1]),
                        .A(Sum_1[1]),
                        .B(Carry_1[1]),
                        .C(And_array[0][3]));
    
    Half_Adder Ha_M4_21 (.Sum(Sum_2[1]),
                        .Cout(Carry_2[2]),
                        .A(Sum_1[2]),
                        .B(Carry_1[2]));

    Half_Adder Ha_M4_22 (.Sum(Sum_2[2]),
                        .Cout(Carry_2[3]),
                        .A(Sum_1[3]),
                        .B(Carry_1[3]));

    Half_Adder Ha_M4_23 (.Sum(Sum_2[3]),
                        .Cout(Carry_2[4]),
                        .A(And_array[3][3]),
                        .B(Carry_1[4]));

    //Carry Look ahead Adder Stage
    M4_Carry_Look_Ahead_Adder CLA_4_0(.S(Result[7:3]),.A(Carry_2),.B(Sum_2));

endmodule

module M_4x4_2 (
    output [7:0] Result,
    input  [3:0] A,
    input  [3:0] B,
    input  Sign  
);
    wire [3:0][3:0]And_array;
    genvar i,j;
    generate
        for (i =0 ;i<3 ;i=i+1 ) begin
            for ( j=0 ;j<4 ;j=j+1 ) begin
                assign And_array[i][j] = A[i] & B[j];
            end
        end
    endgenerate
    generate
        for(i=0;i<4;i=i+1) begin
            assign And_array[3][i]= Sign ^ (A[3] & B[i]);
        end
    endgenerate
    assign Result[0] = And_array[0][0];
    //Stage 1 Wallace Tree
    wire [3:0]Sum_1;
    wire [4:0]Carry_1;
    Half_Adder Ha_M4_10(.Sum(Result[1]),
                        .Cout(Carry_1[0]),
                        .A(And_array[1][0]),
                        .B(And_array[0][1]));
    Full_Adder Fa_M4_10(.Sum(Sum_1[0]),
                        .Cout(Carry_1[1]),
                        .A(And_array[2][0]),
                        .B(And_array[1][1]),
                        .C(And_array[0][2]));
    Full_Adder Fa_M4_11(.Sum(Sum_1[1]),
                        .Cout(Carry_1[2]),
                        .A(And_array[3][0]),
                        .B(And_array[2][1]),
                        .C(And_array[1][2]));
    Full_Adder Fa_M4_12(.Sum(Sum_1[2]),
                        .Cout(Carry_1[3]),
                        .A(And_array[3][1]),
                        .B(And_array[2][2]),
                        .C(And_array[1][3]));

    Half_Adder Ha_M4_11(.Sum(Sum_1[3]),
                        .Cout(Carry_1[4]),
                        .A(And_array[3][2]),
                        .B(And_array[2][3]));

    //Stage 2 Wallace Tree
    wire [3:0]Sum_2;
    wire [4:0]Carry_2;
    Half_Adder Ha_M4_20(.Sum(Result[2]),
                        .Cout(Carry_2[0]),
                        .A(Sum_1[0]),
                        .B(Carry_1[0]));
    
    Full_Adder Fa_M4_20 (.Sum(Sum_2[0]),
                        .Cout(Carry_2[1]),
                        .A(Sum_1[1]),
                        .B(Carry_1[1]),
                        .C(And_array[0][3]));
    
    Half_Adder Ha_M4_21 (.Sum(Sum_2[1]),
                        .Cout(Carry_2[2]),
                        .A(Sum_1[2]),
                        .B(Carry_1[2]));

    Half_Adder Ha_M4_22 (.Sum(Sum_2[2]),
                        .Cout(Carry_2[3]),
                        .A(Sum_1[3]),
                        .B(Carry_1[3]));

    Half_Adder Ha_M4_23 (.Sum(Sum_2[3]),
                        .Cout(Carry_2[4]),
                        .A(And_array[3][3]),
                        .B(Carry_1[4]));

    //Carry Look ahead Adder Stage
    M4_Carry_Look_Ahead_Adder CLA_4_1(.S(Result[7:3]),.A(Carry_2),.B(Sum_2));

endmodule


module M_4x4_3 (
    output [7:0]Result,
    input  [3:0] A,
    input  [3:0] B,
    input  Sign

);
    genvar  i,j;
    wire [3:0][3:0]And_array;

    //And Array 
    generate
        for (i=0 ; i<4 ; i=i+1)
    begin
        for (j=0; j< 3; j=j+1) begin
            assign And_array[i][j] = A[i]&B[j];
        end
    end
    endgenerate
    assign Result[0] = And_array[0][0];

    generate
        for(i=0;i<4;i=i+1) begin
            assign And_array[i][3]= (Sign ^ A[i]) & B[3];
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
    assign Complement = B[3] & Sign;
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

    M4_Carry_Look_Ahead_Adder CLA_4_2(.S(Result[7:3]),.A(Carry_2),.B(Sum_2));



endmodule


module M_4x4_4 (
    output [7:0] Result,
    input  [3:0] A,
    input  [3:0] B,
    input  Sign ,
    input Mode
);
        genvar  i,j;
    wire And_array[3:0][3:0];

    //And Array 
    generate
        for (i=0 ; i<3 ; i=i+1)
    begin
        for (j=0; j< 3; j=j+1) begin
            assign And_array[i][j] = A[i]&B[j];
        end
    end
    endgenerate
    assign Result[0] = And_array[0][0];
    assign And_array[3][3]= B[3] ? A[3] : Sign;

    generate
        for(i=0;i<3;i=i+1) begin
            assign And_array[i][3]= (Sign ^ A[i]) & B[3];
        end
    endgenerate

    generate
        for(j=0;j<3;j=j+1) begin
            assign And_array[3][j]= Sign ^ (A[3] & B[j]);
        end
    endgenerate

    //Stage 1 Of Wallace Tree
    wire [5:0]Carry_1;
    wire [4:0]Sum_1;
    wire Mode_sign;
    assign Mode_sign = Mode & Sign;
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
                    .C(Mode_sign));
    wire Complement;
    assign Complement = B[3] & Sign & Mode;
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

module Multiplier_8x8 (
    output [15:0] Result,
    input  [7:0] In_1,
    input  [7:0] In_2,
    input  Sign,
    input Mode
);
    wire [3:0][7:0]Partial_Product;
    wire [7:0]Sum_R123; 
    wire [7:0]Cout_R123;
    wire  [1:0]Cout;
    M_4x4_1 PP_0(.A(In_1[3:0]),.B(In_2[3:0]),.Result(Partial_Product[0][7:0]));
    M_4x4_2 PP_1(.A(In_1[7:4]),.B(In_2[3:0]),.Sign(Sign),.Result(Partial_Product[1][7:0]));
    M_4x4_3 PP_2(.A(In_1[3:0]),.B(In_2[7:4]),.Sign(Sign),.Result(Partial_Product[2][7:0]));
    M_4x4_4 PP_3(.A(In_1[7:4]),.B(In_2[7:4]),.Sign(Sign),.Result(Partial_Product[3][7:0]),.Mode(Mode)); 
    assign Result[3:0]=Partial_Product[0][3:0];
    wire [7:0] Partial_Product_Inter = {Partial_Product[3][3:0],Partial_Product[0][7:4]};
    assign Sum_R123 = Partial_Product_Inter  ^ Partial_Product[1] ^ Partial_Product[2];
    assign Cout_R123 = Partial_Product_Inter  & Partial_Product[1] | 
                       Partial_Product_Inter & Partial_Product[2] |
                       Partial_Product[1] & Partial_Product[2] ;

    
    assign Result[4] = Sum_R123[0];
    wire [7:0]Sum_R123_1;
    Look_Ahead_Adder_No_Cin CLA_1(.A(Sum_R123[4:1]),
                                  .B(Cout_R123[3:0]),
                                  .S(Sum_R123_1[3:0]),
                                  .Cout(Cout[0]));
    Look_Ahead_Adder CLA_2(.A(Cout_R123[7:4]),
                           .B({Partial_Product[3][4],Sum_R123[7:5]}),
                           .Cin(Cout[0]),
                           .S(Sum_R123_1[7:4]),
                           .Cout(Cout[1]));

    assign Result[12:5]= Sum_R123_1;

    Increment I0(.A(Partial_Product[3][7:5]),
                  .B(Cout[1]),
                  .S(Result[15:13]));

    
endmodule