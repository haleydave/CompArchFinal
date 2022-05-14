module signext(input logic  [7:0] a,
               output logic [15:0] y);
              
  assign y = {{8{a[7]}}, a};
endmodule