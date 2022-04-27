module signext(input   [7:0] a,
               output  [15:0] y);
              
  assign y = {{8{a[7]}}, a};
endmodule