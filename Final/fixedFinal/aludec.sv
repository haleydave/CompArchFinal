module aludec(input logic  [3:0] funct,
              input logic  [1:0] aluop,
              output  logic [2:0] alucontrol);

  always @*
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add (for lw/sw/addi) I TYPE
      2'b01: alucontrol <= 3'b110;  // sub (for beq) CBZ
      default: case(funct)          // R-type instructions
          4'b0001: alucontrol <= 3'b010; // add
          4'b0010: alucontrol <= 3'b110; // sub
          4'b0011: alucontrol <= 3'b000; // and
          4'b0100: alucontrol <= 3'b001; // or
          4'b0101: alucontrol <= 3'b111; // slt: sets to 1 if a<b
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase
endmodule
