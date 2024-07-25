`timescale 1ns / 1ns
module Look_Ahead_Adder(a,b,s,cout,c0);
input [3:0] a,b;
output [3:0] s;
output cout;
input c0;
wire p0,p1,p2,p3;
wire g0,g1,g2,g3;
wire c1,c2,c3,c4;
ha X1(a[0],b[0],p0,g0);
ha X2(a[1],b[1],p1,g1);
ha X3(a[2],b[2],p2,g2);
ha X4(a[3],b[3],p3,g3);
assign c1 = g0 | p0&c0;
assign c2 = g1 | p1&g0 | p1&p0&c0;
assign c3 = g2 | p2&g1 | p2&p1&g0 | p2&p1&p0&c0;
assign c4 = g3 | p3&g2 | p3&p2&g1 | p3&p2&p1&p0&c0;
assign s[0] = p0 ^ c0;
assign s[1] = p1 ^ c1;
assign s[2] = p2 ^ c2;
assign s[3] = p3 ^ c3;
assign cout = c4;
endmodule


module ha(
  input a,b,
  output sum,co
    );
assign sum = a^b;
assign co = a&b;
endmodule