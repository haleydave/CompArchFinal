module sl2(input   [7:0] a,
           output  [7:0] y);

  // shift left by 2
  assign y = {a[5:0], 2'b00};
endmodule