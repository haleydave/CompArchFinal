'timescale 1ns/1ps

module control(
    input [15:0] instr,
    output reg reg_write,
    output reg alu_mx_ctrl,
    output reg alu_op, 
    output reg branch_mux,
    output reg [3:0] rs,
    output reg [3:0] rt.
    output reg [3:0] rd,
    output reg print_signal
);

reg [3:0] opcode;
assign opcode = instr[15-:4];
alu_op
rd = instr[11-:4];
rs = instr[7-:4];
rt = instr[3-:4];
always @(*)
    case (opcode)
        4'd0: //addition
            alu_op <= 4'b0000;
            reg_write <= 1;
            branch_mux <=0;
            print_signal <=0;
        end
        4'd1: //subtraction
            alu_op <= 4'b0001;
            
            print_signal<=0;

        end
        4'd2://AND
            alu_op <= 4'b0010;
            print_signal<=0;
        end
        4'd3://OR
            alu_op <= 4'b0011;
            
        end
        4'd4://AND
            alu_op <= 4'b0010;
            print_signal<=0;
        end
