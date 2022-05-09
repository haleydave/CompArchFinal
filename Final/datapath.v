`include "mux2.v"
`include "adder.v"
`include "flopr.v"
`include "reg_file.v"
`include "alu.v"
`include "sl2.v"
`include "signext.v"
module datapath(input          clk, reset,
                input          memtoreg, pcsrc,
                input          alusrc, regdst,
                input          regwrite, jump,
                input   [2:0]  alucontrol,
                output         zero,
                output  [15:0] pc,
                input   [15:0] instr,
                output  [7:0] aluout, writedata,
                input   [15:0] readdata);

  wire [2:0]  writereg;
  //we do pcplus b/c instruction length is 16 bits, so to
  //get to next instruction, jump up 2 bytes
  wire [15:0] pcnext, pcnextbr, pcplus2, pcbranch;
  wire [15:0] signimm, signimmsh;
  wire [7:0] srca, srcb;
  wire [7:0] result;

  // next PC logic
  flopr #(16) pcreg(clk, reset, pcnext, pc);
  adder #(16)      pcadd1(pc, 16'b100, pcplus2);
  //sl2         immsh(signimm, signimmsh);
  adder #(16) pcadd2(pcplus2, {9'b000000000,instr[6:0]}, pcbranch);
  mux2 #(16)  pcbrmux(pcplus2, pcbranch, pcsrc, pcnextbr);
  mux2 #(16)  pcmux(pcnextbr, {pcplus2[15:12], 
                    instr[11:0]}, jump, pcnext);

  // register file logic
  reg_file     rf(writedata, , , , , , ,clk , reset);
  mux2 #(3)   wrmux(instr[8:6], instr[2:0],
                    regdst, writereg);
  mux2 #(16)  resmux(aluout, readdata, memtoreg, result);
  signext     se(instr[7:0], signimm);

  // ALU logic
  mux2 #(8)  srcbmux(writedata, {1'b0, instr[6:0]}, alusrc, srcb);
  alu         alu(srca, srcb, alucontrol, aluout, zero);
endmodule
