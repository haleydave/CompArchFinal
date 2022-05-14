`include "mux2.sv"
`include "adder.sv"
`include "flopr.sv"
`include "reg_file.sv"
`include "alu.sv"
`include "sl2.sv"
`include "signext.sv"
module datapath(input logic         clk, reset,
                input logic         memtoreg, pcsrc,
                input  logic        alusrc, regdst,
                input  logic        regwrite, jump,
                input logic  [2:0]  alucontrol,
                output logic        zero,
                output logic [15:0] pc,
                input  logic [15:0] instr,
                output logic [7:0] aluout, writedata,
                input logic [7:0] readdata);

  logic [2:0]  writereg;
  //we do pcplus2 b/c instruction length is 16 bits, so to
  //get to next instruction, jump up 2 bytes
  logic [15:0] pcnext, pcnextbr, pcplus2, pcbranch;
  logic [15:0] signimm, signimmsh;
  logic [7:0] srca, srcb;
  logic [7:0] result;

  // next PC logic
  flopr #(16) pcreg(clk, reset, pcnext, pc);
  adder #(16)      pcadd1(pc, 16'b100, pcplus2);
  //sl2         immsh(signimm, signimmsh);
  adder #(16) pcadd2(pcplus2, {9'b000000000,instr[6:0]}, pcbranch);
  mux2 #(16)  pcbrmux(pcplus2, pcbranch, pcsrc, pcnextbr);
  mux2 #(16)  pcmux(pcnextbr, {pcplus2[15:12], 
                    instr[11:0]}, jump, pcnext);

  // register file logic
  reg_file     rf(clk, regwrite, instr[12:10], instr[9:7], 
                 writereg, result, srca, writedata);
  mux2 #(3)   wrmux(instr[8:6], instr[2:0],
                    regdst, writereg);
  mux2 #(8)  resmux(aluout, readdata, memtoreg, result);
  signext     se(instr[7:0], signimm);

  // ALU logic
  mux2 #(8)  srcbmux(writedata, {1'b0, instr[6:0]}, alusrc, srcb);
  alu         alu(srca, srcb, alucontrol, aluout, zero);
endmodule
