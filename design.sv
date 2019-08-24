// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pravin T
// 
// Create Date:    00:33:06 01/31/2019 
// Design Name: 
// Module Name:    matrix 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module matrix(
    input clk,
	 input start,
  input reg [2:0] M1Xin, //first matrix  x
  input reg [2:0] M1Yin,  //first matrix y
  input reg [2:0] M2Xin, //second matrix  x
  input reg [2:0] M2Yin,  //second matrix y
  input reg [7:0] data_in,
  input reg program_dim,
  input reg program_val,
  input reg result_read_ready,
  output reg result_read_valid,
    output reg ready,
  output   reg err,
  output reg [15:0] op,
  output reg [2:0] i,
  output reg [2:0] j
    );
  reg val_programed = 0;
  reg dim_programmed = 0;
  reg [7:0] a[7:0][7:0];// = {1,2,3,4,5,6,7,8,9};
	//  1 2 3
	//  4 5 6
	//  7 8 9
  reg [7:0] b[7:0][7:0];// = {1,2,3,4,5,6,7,8,9};
	//  1 2 3
	//  4 5 6
	//  7 8 9
  reg [15:0] zm[7:0][7:0];// = {0,0,0,0,0,0,0,0,0};

	// Outputs
  reg [15:0] num_elements =0;
	wire [15:0] zc;
  reg [15:0] x=0,y=0,z,acc=0;
  reg [2:0] cnt_a=0,cnt_b=0,cnt_c=0,i_idx=0,j_idx=0;
  reg [5:0] cnt = 0;
  reg int_ready = 0;
  reg mat1_done = 0;
  reg mat2_done = 0;
  reg stop = 0;
  
    
	// Instantiate the Unit Under Test (UUT)
	multiplier uut (
		.a(x), 
		.b(y), 
		.c(zc)
	);
  
  always @(posedge clk)begin
    
    if(start ==1 && (M1Yin != M2Xin))begin
      err = 1;
    end else begin
      err = 0;
    end
    if(program_dim && start == 0)begin
      //num_elements = zc;
      $display("num elements %d",num_elements);
    end
    
    if(program_val && start == 0)begin
      if(mat1_done ==0)begin
         a[i_idx][j_idx] = data_in;
        $display("loading a[%d][%d] = %d",i_idx,j_idx,data_in);
          j_idx = j_idx +1;
          
           if(j_idx ==M1Yin)begin
           j_idx = 0;
             $display("Clear J idx");
           i_idx = i_idx + 1;
             $display("Incr I idx %d",i_idx);
             if(i_idx == M1Xin)begin
                 i_idx =0;
                 mat1_done = 1;
             end  
          end
           
       end
      if(mat1_done ==1 && mat2_done==0)begin
          //i =  i_idx;
          //j =  j_idx;
           b[i_idx][j_idx] = data_in;
        $display("loading b[%d][%d] = %d",i_idx,j_idx,data_in);
          //if(j_idx < 3 )
          j_idx = j_idx +1;
          //else
        if(j_idx ==M2Yin)begin
           j_idx = 0;
           i_idx = i_idx + 1;
          if(i_idx == M2Xin)begin
                 i_idx =0;
                 mat2_done = 1;
             end  
          end
           
       end
     end
  end
 
	 always @(posedge clk)begin
       if(start == 1)begin  
         if(cnt<30)
	  cnt = cnt+1;
	  else
	  cnt = 0;
       end  
       
	 end
	 
  always @(posedge clk)begin
       if(start == 1)begin
         if(cnt_a <M1Yin) begin
           if(cnt_c <M2Xin)begin
				  x = a[cnt_a][cnt_c];
				  y =  b[cnt_c][cnt_b];
				  cnt_c = cnt_c +1;
				  acc = acc + zc;
				 end
         
			 
           if(cnt_b< M1Yin) begin
			   	 zm[cnt_a][cnt_b] = acc;
             $display("compute z[%d][%d] = %d",cnt_a,cnt_b,acc);
             if(cnt_c == M2Xin)begin
				  acc = 0;
				  cnt_c = 0;
                 //if(cnt_b <=1)
				  cnt_b =cnt_b + 1;
				 end
			 end
           
           ////if(cnt_a < 3) begin
           if(cnt_b == M1Yin)begin
				   cnt_b = 0;
				   cnt_a = cnt_a +1;
				 end
		//	 end
         end
         else begin
           ready = 1;
           int_ready = 1;
         end
       end //start
       else begin
         if(program_dim)begin
           x = M1Xin;
           y = M2Yin;
            num_elements = zc; //why not assigning
         end else begin
         x = a[0][0];
         y =  b[0][0];
         ready = 0;
         end
       end
	 end

  always @(posedge clk)begin
    if(int_ready == 1)begin
      if(stop)
        result_read_valid = 0;
      if(result_read_ready && stop ==0)begin
      i =  i_idx;
      j =  j_idx;
      op =zm[i][j];
        result_read_valid = 1;
      $display("z[%d][%d] = %d",i,j,op);
      //if(j_idx < 3 )
      j_idx = j_idx +1;
      //else
      if(j_idx ==M2Yin)begin
        j_idx = 0;
        i_idx = i_idx + 1;
        if(i_idx == M1Xin)begin
          i_idx =0;
          //result_read_valid = 0;
          stop = 1;
        end
      end
    end  
   end else begin
     result_read_valid = 0;
   end
  end

endmodule
