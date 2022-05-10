module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET) ;
 //Initalizing inputs
 input [2:0] INADDRESS;
 input [2:0] OUT1ADDRESS;
 input [2:0] OUT2ADDRESS;
 input WRITE;
 input CLK;
 input RESET;
 input [7:0] IN;
 //initializing outputs
 output [7:0] OUT1;
 output [7:0] OUT2;
 //initializing register variables
integer i; 
 //creating the register array
 reg [7:0] regFile [0:7]; 
 //resetting the registers if the reset is 1 as a level triggered input
 always@(*)
 if (RESET == 1) begin 
    #2
    for (i = 0; i < 8; i = i + 1) 
        begin
        regFile [i] = 16'b0000000000000000 ; 
        end 
 
 end 
 //this always block runs of the positive edge of the clock and write to the register if write is ennable
 always@(posedge CLK)
 begin 
    if(WRITE == 1'b1 && RESET == 1'b0) begin
    #2 regFile [INADDRESS] = IN; //this includes the write reg delay
    //$monitor($time,” %b”,regFile [INADDRESS]);
    end 
 end
 
 //this is for reading the inputs from the registers
 //this part was modified after the lab 5 part 3 submission
 assign #2 OUT1 = regFile[OUT1ADDRESS];
 assign #2 OUT2 = regFile[OUT2ADDRESS];
endmodule