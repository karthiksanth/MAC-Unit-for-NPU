`timescale 1ns / 1ns
 module Look_Ahead_Adder_tb (
 );
 reg [3:0] in1,in2;wire [3:0]sum;
 wire cout;reg c0;
 Look_Ahead_Adder instant_1(.a(in1),
                            .b(in2),
                            .s(sum),
                            .cout(cout),
                            .c0(c0));
initial begin
    $dumpfile("vcd/Look_Ahead_Adder.vcd");
    $dumpvars(0, Look_Ahead_Adder_tb );
    for(integer i=0;i<15;i++)begin
        in1=i;
        in2=i+10;
        c0=0;
        #20;
    end
end
 endmodule //Look_Ahead_Adder_tb