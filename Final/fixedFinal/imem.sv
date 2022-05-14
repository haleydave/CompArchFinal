module imem(input  logic [2:0] a,
            output logic [15:0] rd);

  logic [2:0] RAM[0:15];

  initial
      $readmemh("memfile.dat",RAM);

  assign rd = RAM[a]; // word aligned
endmodule