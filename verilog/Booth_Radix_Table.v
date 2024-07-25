`timescale 1ns / 1ns

module Booth_Radix_Table (
    input wire [2:0] In,
    output wire Shift,
    Negation,Zero
);
  assign Zero = In[2] ?In[1] & In[0]: !(In[1] | In[0]);
  assign Shift = In[2] ? !(In[1] | In[0]) : In[1] & In[0];
  assign Negation = In[2] & !(In[1] & In[0]);
endmodule  //Booth_Radix_Table


