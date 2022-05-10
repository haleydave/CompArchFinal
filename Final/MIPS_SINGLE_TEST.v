`include "imem.v"
`include "dmem.v"
`include "mips.v"

`timescale 10ms/100   us // 1ms period, 10us precision
module mips_single_cycle_tb();

  input        clk;
  input        reset;

  input [7:0] writedata;
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

module top(input  wire        clk, reset, 
           output wire [7:0] writedata, 
           output wire [7:0] dataadr, 
           output wire        memwrite);

  wire [15:0] pc, instr;
  wire [7:0] readdata; 
  // instantiate processor and memories
  mips mips(clk, reset, pc, instr, memwrite, dataadr, 
            writedata, readdata);
  imem imem(pc[7:2], instr);
  
  dmem dmem (dataadr, memwrite, writedata, readdata, clk);
endmodule