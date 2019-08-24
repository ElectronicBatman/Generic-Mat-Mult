// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:19:07 01/31/2019
// Design Name:   multiplier
// Module Name:   F:/MIMAS V2/Projects/matrix/multtb.v
// Project Name:  matrix
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multtb;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;
	reg clk=0,my_start=0,my_ready;
  reg [2:0] M1Xin; 
  reg [2:0] M1Yin;
  reg [2:0] M2Xin; //second matrix  x
  reg [2:0] M2Yin;  //second matrix y
  reg [7:0] data_in;
   reg program_dim;
   reg program_val; 
  reg result_read_ready = 0;

	// Outputs
	wire [15:0] c;

	// Instantiate the Unit Under Test (UUT)
	//multiplier uut (
		//.a(a), 
	//	.b(b), 
//		.c(c)
	//);
   
  matrix uut(
    .clk(clk),
	  .start(my_start),
    .M1Xin(M1Xin),
    .M1Yin(M1Yin),
    .M2Xin(M2Xin),
    .M2Yin(M2Yin),
    .data_in(data_in),
    .result_read_ready(result_read_ready),
    .program_dim(program_dim),
    .program_val(program_val),
    .ready(my_ready)
    );
	 always 
	  clk = #10 ~clk;
	  
	initial begin
		// Initialize Inputs
      $dumpfile("dump.vcd");
      $dumpvars;
		a = 0;
		b = 0;
        #10
        M1Xin = 3;
        M1Yin = 5;
        M2Xin = 5;
        M2Yin = 5;
        program_dim = 1;
        #30
      program_dim = 0;
        data_in = 1;
        program_val = 1;
      
		// Wait 100 ns for global reset to finish
		#1980;
        my_start = 1;
		// Add stimulus here
		a = 1;
		b = 2;
		#100;
		
		a = 2;
		b = 2;
		#100;
		
		a = 4;
		b = 8;
		#100;
		
		a = 15;
		b = 2;
		#100;
		
	   a = 63;
		b = 2;
		#100;	
	#1000
     result_read_ready =1 ; 
    #2000
      $finish;
	end
      
endmodule

