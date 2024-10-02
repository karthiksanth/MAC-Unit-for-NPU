module Half_Adder (
    output Sum,
    output Cout,
    input  A,
    input  B    
);
    assign Sum = A ^ B;
    assign Cout = A & B;
endmodule

module Full_Adder (
    output Sum,
    output Cout,
    input  A,
    input  B,
    input  C   
);
    wire xor_ab,and_ab;
    assign xor_ab = A ^ B;
    assign Sum = xor_ab ^ C;
    assign and_ab = A & B;
    assign Cout = (xor_ab & C) | and_ab;
endmodule


