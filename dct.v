`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UoH 
// Engineer: Piyush Kumar & Raviteja Kammari 
// 
// Create Date: 03/31/2018 10:23:57 AM
// Design Name: 
// Module Name: dct
// Project Name: 8 Point DCT
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

module dct(
	input clk,			                                   //	input clock
	input reset,		  	                                   //	reset
	input wr,		                                           //	writing data to memory
	input oe,		                                           //	displaying the final output
	input [7:0]x0,x1,x2,x3,x4,x5,x6,x7,	                                           //	8-bit data input
	output reg [15:0]Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7                                           //	8-bit data output
	);	                                        

reg signed [7:0] M0,M1,M2,M3,P0,P1,P2,P3;		            //	 wire for 1-stage butterfly
reg signed [7:0] P10,M10,P11,M11;		            //	wire for 2-stage butterfly
reg signed [7:0] P100,M100;                  // wire for 3-stage butterfly
reg signed [15:0] M1C7,M1C1,M3C5,M3C3,M0C5,M0C3,M1C5,M1C3,M3C1,M3C7,M2C1,M2C7,M11C6,M11C2,M0C7,M0C1,M2C5,M2C3,M10C6,M10C2;         // partial products
reg signed [15:0] X0,X1,X2,X3,X4,X5,X6,X7;                                                   // output drivers

wire [7:0] C5= 8'h46,//0.55,                                                  // 0.55  // ci = cos (i*pi/2*N)
		   C6= 8'h31,//0.38,                                                  // 0.38
		   C7= 8'h18,//0.19,                                                  // 0.19
		   C4= 8'h5A,//0.70,
		   C3= 8'h6A,//0.83,                                                   // 0.83 // si = sin (i*pi/2*N)
		   C2= 8'h76,//0.92,                                                   // 0.92
		   C1= 8'h7D;//0.98;                                                   // 0.98 
				
reg [7:0]x[7:0];	                                    //	8-bit 8 locations data storage after reading
integer i;
/****************************WRITING DATA TO MEMORY***********************/
always @( posedge clk) begin
    if(reset) begin 
        for (i = 0; i<8; i = i+1)
            x[i] = 0;
    end
    else if(wr) begin
        x[0] = x0;
		x[1] = x1;
		x[2] = x2;
		x[3] = x3;
		x[4] = x4;
		x[5] = x5;
		x[6] = x6;
		x[7] = x7;
    end;
end

always @(posedge clk) begin
    if(oe) begin
/*****************************1-STAGE BUTTERFLY****************************/
        P0 = x[0]+x[7];
        P1 = x[3]+x[4];
        P2 = x[1]+x[6];
        P3 = x[2]+x[5];

        M0 = x[0]-x[7];
        M1 = x[3]-x[4];
        M2 = x[1]-x[6];
        M3 = x[2]-x[5];

/******************************2-STAGE BUTTERFLY**************************/
        P10 = P0+P1;
        P11 = P2+P3;

        M10 = P0-P1;
        M11 = P2-P3;

        M1C7 = M1*C7;
        M1C1 = M1*C1;
        M0C7 = M0*C7;
        M0C1 = M0*C1;
        M3C5 = M3*C5;
        M3C3 = M3*C3;
        M2C5 = M2*C5;
        M2C3 = M2*C3;
        M0C5 = M0*C5;
        M0C3 = M0*C3;
        M1C5 = M1*C5;
        M1C3 = M1*C3;
        M3C1 = M3*C1;
        M3C7 = M3*C7;
        M2C1 = M2*C1;
        M2C7 = M2*C7;

/*****************************3-STAGE BUTTERFLY****************************/
        P100 = P10+P11;
        M100 = P10-P11;

        M11C6 = M11*C6;
        M11C2 = M11*C2;
        M10C6 = M10*C6;
        M10C2 = M10*C2;

        X0 = (P100*C4);       //X(0)
        X4 = (M100*C4);       //X(4)

        X2 = M11C6+M10C2;     //X(2)
        X6 = M10C6-M11C2;     //X(6)

        X1 = M1C7+M0C1+M3C5+M2C3;      //X(1)
        X7 = M3C3-M2C5+M0C7-M1C1;      //X(7)

        X3 = M0C3-M1C5-M2C7-M3C1;      //X(3)
        X5 = M0C5+M1C3-M2C1+M3C7;      //X(5)


/**************DISPLAY THE FINAL OUTPUT ACC. TO ADDRESS GIVEN*************/
    
        Y0= X0;
	    Y1= X1;
	    Y2= X2;
	    Y3= X3;
	    Y4= X4;
	    Y5= X5;
	    Y6= X6;
	    Y7= X7;
    end
    else begin
        Y0= 0;
	    Y1= 0;
	    Y2= 0;
	    Y3= 0;
	    Y4= 0;
	    Y5= 0;
	    Y6= 0;
	    Y7= 0;
    end
end
endmodule