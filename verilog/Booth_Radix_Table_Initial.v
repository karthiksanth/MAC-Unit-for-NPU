`timescale 1ns/1ns
module Booth_Radix_Table_Initial (
    input [1:0]In,
    output wire Shift,
    Negation,Zero
);
assign Zero = !(In[0]&In[1]);
assign Negation = In[1];
assign Shift= In[1]&!In[0];
endmodule //Booth_Radix_Table_Initial