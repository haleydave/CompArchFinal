
`timescale 10ms/100   us // 1ms period, 10us precision
module mips_single_cycle_tb();

  reg       clk;
  logic       reset;

  input logic [7:0] writedata;
  input [2:0] dataadr;
  input        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);
  
  initial
  begin
      $dumpfile("mips_single_cycle_test.vcd");
      $dumpvars(0,clk,reset,writedata,dataadr,memwrite);
      $display("writedata\tdataadr\tmemwrite");
      $monitor("%9d\t%7d\t%8d",writedata,dataadr,memwrite);
      // $dumpvars(0,clk,a,b,ctrl,result,zero,negative,carryOut,overflow);
      // $display("Ctl Z  N  O  C  A                    B                    ALUresult");
      // $monitor("%3b %b  %b  %b  %b  %8b (0x%2h;%3d)  %8b (0x%2h;%3d)  %8b (0x%2h;%3d)",ctrl,zero,negative,overflow,carryOut,a,a,a,b,b,b,result,result,result);
  end

  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end
  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end
  // check results
  always @(negedge clk)
    begin
      if(memwrite) begin
        // if(dataadr === 84 & writedata === 7) begin
        if(dataadr === 60 & writedata === 28) begin
          $display("Simulation succeeded");
          $finish;
        end
        else if (dataadr !== 80) begin
          $display("Simulation failed");
          $finish;
        end
      end
    end
endmodule

module top(input  logic        clk, reset, 
           output logic [7:0] writedata, 
           output logic [2:0]dataadr, 
           output logic        memwrite);

  logic [15:0] pc, instr;
  logic [7:0] readdata; 
  // instantiate processor and memories
  mips mips(clk, reset, pc, instr, memwrite, {5'b00000,dataadr}, 
            writedata, readdata);
  imem imem(pc[7:5], instr);
  dmem dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule

module adder #(parameter WIDTH = 8)
             (input   [WIDTH-1:0] a, b,
             output  [WIDTH-1:0] y);

  assign y = a + b;
endmodule

module alu(input logic   [7:0] a, b,
           input logic  [2:0]  alucontrol,
           output logic [7:0] result,
           output  logic       zero);

  logic [7:0] condinvb, sum;

  assign condinvb = alucontrol[2] ? ~b : b;
  assign sum = a + condinvb + alucontrol[2];

  always @*
    case (alucontrol[1:0])
      2'b00: result = a & b;
      2'b01: result = a | b;
      2'b10: result = sum;
      2'b11: result = sum[7];
    endcase

  assign zero = (result == 8'b0);
endmodule

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
module maindec(input logic [2:0] op,
               output  logic     memtoreg, memwrite,
               output  logic      branch, alusrc,
               output  logic      regdst, regwrite,
               output  logic      jump,
               output  logic [1:0] aluop);

  logic [8:0] controls;

  assign {regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump, aluop} = controls;

  always @*
    case(op)
      3'b000: controls <= 9'b110000010; // RTYPE
      3'b001: controls <= 9'b101001000; // LW
      3'b010: controls <= 9'b001010000; // SW
      3'b011: controls <= 9'b000100001; // BEQ
      3'b100: controls <= 9'b101000000; // ADDI
      3'b101: controls <= 9'b000000100; // J
      default:   controls <= 9'bxxxxxxxxx; // illegal op
    endcase
endmodule
module controller(input logic  [2:0] op, 
                  input  logic [3:0] funct,
                  input  logic       zero,
                  output logic       memtoreg, memwrite,
                  output  logic       pcsrc, alusrc,
                  output logic       regdst, regwrite,
                  output logic       jump,
                  output logic [2:0] alucontrol);

    logic [1:0] aluop;
    logic branch;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump, aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcsrc = branch & zero;
endmodule

module mux2 #(parameter WIDTH = 8)
             (input logic  [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module reg_file(input          clk, 
               input         we3, 
               input   [2:0]  ra1, ra2, wa3, 
               input   [7:0] wd3, 
               output  [7:0] rd1, rd2);

  logic [7:0] rf[7:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clk
  // register 0 hardwired to 0
  // note: for pipelined processor, write third port
  // on falling edge of clk

  always @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module signext(input logic  [7:0] a,
               output logic [15:0] y);
              
  assign y = {{8{a[7]}}, a};
endmodule

module sl2(input logic  [15:0] a,
           output logic [15:0] y);

  // shift left by 2
  assign y = {a[13:0], 2'b00};
endmodule

module imem(input  logic [2:0] a,
            output logic [15:0] rd);

  logic [2:0] RAM[0:15];

  initial
      $readmemh("memfile.dat",RAM);

  assign rd = RAM[a]; // word aligned
endmodule

module dmem(input  logic        clk, we,
            input  logic [2:0] a, 
            input logic [7:0] wd,
            output logic [7:0] rd);

  logic [7:0] RAM[0:7];

  assign rd = RAM[a[7:2]]; // word aligned

  always @(posedge clk)
    if (we) RAM[a[7:2]] <= wd;
endmodule

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

module mips(input   logic       clk, reset,
            output  logic [15:0] pc,
            input logic   [15:0] instr,
            output  logic       memwrite,
            output  logic [7:0] aluout, writedata,
            input logic  [7:0] readdata);

logic      memtoreg, alusrc, regdst, 
              regwrite, jump, pcsrc, zero;
logic [2:0] alucontrol;

controller c(instr[15:13], instr[3:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump,
               alucontrol);
datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump,
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);

endmodule

module flopr #(parameter WIDTH = 8)
              (input  logic            clk, reset,
               input logic  [WIDTH-1:0] d, 
               output logic  [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

