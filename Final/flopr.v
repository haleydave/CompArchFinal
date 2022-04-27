module flopr (input clk,
               input reset,
               input   d, 
               output reg   q);




always @(posedge clk, posedge reset)
    if (reset) q<=0;
    else q<=d;

endmodule
