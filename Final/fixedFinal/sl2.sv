module sl2(input logic  [15:0] a,
           output logic [15:0] y);

  // shift left by 2
  assign y = {a[13:0], 2'b00};
endmodule