module dmem(input  logic        clk, we,
            input  logic [2:0] a, 
            input logic [7:0] wd,
            output logic [7:0] rd);

  logic [7:0] RAM[0:7];

  assign rd = RAM[a[7:2]]; // word aligned

  always @(posedge clk)
    if (we) RAM[a[7:2]] <= wd;
endmodule