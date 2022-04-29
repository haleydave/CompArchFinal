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
                output  [7:0] pc,
                input   [15:0] instr,
                output  [7:0] aluout, writedata,
                input   [7:0] readdata);

  wire [2:0]  writereg;
  wire [7:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [15:0] signimm, signimmsh;
  wire [7:0] srca, srcb;
  wire [7:0] result;

  // next PC logic
  flopr #(8) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 8'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(8)  pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
  mux2 #(8)  pcmux(pcnextbr, {pcplus4[7], 
                    instr[15:0], 2'b00}, jump, pcnext);

  // register file logic
  reg_file     rf(writedata, , , , , , ,clk , reset);
  mux2 #(3)   wrmux(instr[8:6], instr[2:0],
                    regdst, writereg);
  mux2 #(8)  resmux(aluout, readdata, memtoreg, result);
  signext     se(instr[7:0], signimm);

  // ALU logic
  mux2 #(8)  srcbmux(writedata, signimm, alusrc, srcb);
  alu         alu(srca, srcb, alucontrol, aluout, zero);
endmodule
