module dmem(ADD, WE,WRITE, RD, CLK);
input [2:0] ADD;
input WE;
input [7:0] WRITE;
output [7:0] RD;
input CLK;


 reg [7:0] RAM [0:7];

 assign RD = RAM[ADD[7:2]];

 always @(posedge CLK)
    if (WE) RAM[ADD[7:2]] <= WRITE;

endmodule