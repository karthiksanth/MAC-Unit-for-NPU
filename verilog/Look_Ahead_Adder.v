`timescale 1ns / 1ns
module Look_Ahead_Adder(A,B,S,Cout,Cin);
input [3:0] A,B;
output [3:0] S;
output Cout;
input Cin;
wire P0,P1,P2,P3;
wire G0,G1,G2,G3;
wire C1,C2,C3,C4;
ha X1(A[0],B[0],P0,G0);
ha X2(A[1],B[1],P1,G1);
ha X3(A[2],B[2],P2,G2);
ha X4(A[3],B[3],P3,G3);
assign C1 = G0 | P0&Cin;
assign C2 = G1 | P1&G0 | P1&P0&Cin;
assign C3 = G2 | P2&G1 | P2&P1&G0 | P2&P1&P0&Cin;
assign C4 = G3 | P3&G2 | P3&P2&G1 | P2&P1&G0 | P3&P2&P1&P0&Cin;
assign S[0] = P0 ^ Cin;
assign S[1] = P1 ^ C1;
assign S[2] = P2 ^ C2;
assign S[3] = P3 ^ C3;
assign Cout = C4;
endmodule

module Look_Ahead_Adder_No_Cin(A,B,S,Cout);
input [3:0] A,B;
output [3:0] S;
output Cout;
wire P0,P1,P2,P3;
wire G0,G1,G2,G3;
wire C1,C2,C3,C4;
ha X1(A[0],B[0],P0,G0);
ha X2(A[1],B[1],P1,G1);
ha X3(A[2],B[2],P2,G2);
ha X4(A[3],B[3],P3,G3);
assign C1 = G0 ;
assign C2 = G1 | P1&G0 ;
assign C3 = G2 | P2&G1 | P2&P1&G0 ;
assign C4 = G3 | P3&G2 | P3&P2&G1 | P3&P2&P1&G0 ;
assign S[0] = P0 ;
assign S[1] = P1 ^ C1;
assign S[2] = P2 ^ C2;
assign S[3] = P3 ^ C3;
assign Cout = C4;
endmodule

module ha(
  input a,b,
  output sum,co
    );
assign sum = a^b;
assign co = a&b;
endmodule

module Increment (
  input  [2:0] A,
  input  B,
  output [2:0] S  
);
  wire P,G;
  assign P = A[0] ^ B;
  assign G = A[0] & B;
  wire C1,C2,C3;
  assign C1 = G ;
  assign C2 = A[1]&G;
  assign C3 = A[2]&A[1]&G ;
  assign S[0] = P ;
  assign S[1] = A[1] ^ C1;
  assign S[2] = A[2]^ C2;

endmodule