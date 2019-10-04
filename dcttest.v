`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UoH
// Engineer: Piyush Kumar & Raviteja Kammari 
// 
// Create Date: 03/31/2018 11:53:57 AM
// Design Name: 
// Module Name: dcttest
// Project Name: 8 point DCT
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dcttest();

    reg clk;			                                   //	input clock
	reg reset;		  	                                   //	reset
	reg wr;		                                           //	writing data to memory
	reg oe;		                                           //	displaying the final output
	reg [7:0]x0,x1,x2,x3,x4,x5,x6,x7;	                                           //	8-bit data input
	wire [15:0]y0,y1,y2,y3,y4,y5,y6,y7;
	
	integer i;
	
	dct d1(clk,reset,wr,oe,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7);
	
	initial begin
	    clk = 0;
	    reset = 0;
	    oe = 0;
	    wr = 0;
	    forever #5 clk = ~clk;
	end
	
	initial begin
	    
	    #5 reset = 1;
	    #5 wr = 1;reset = 0;
	    
	    x0=1;x1=1;x2=1;x3=1;x4=1;x5=1;x6=1;x7=1;
	    #10 oe = 1; wr = 0;
	    #10 wr = 1; x0=1;x1=0;x2=0;x3=0;x4=0;x5=0;x6=0;x7=0;
        #20 x0=1;x1=-1;x2=-1;x3=1;x4=-1;x5=1;x6=-1;x7=1;
        #20 x0=5;x1=5;x2=5;x3=5;x4=0;x5=0;x6=0;x7=0;	    
        #30 $stop;
	end        
	
endmodule
