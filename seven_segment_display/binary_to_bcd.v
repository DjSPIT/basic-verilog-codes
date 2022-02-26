`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dhananjay Joshi
// 
// Create Date:    19:28:36 02/17/2022 
// Design Name: 
// Module Name:    binary_to_bcd 
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
module binary_to_bcd(
							BCD,
							binary
						);
 
	input [9:0] binary;
	output [11:0] BCD;
 
	wire a0,a1,a2,a3;
	wire b0,b1,b2,b3;
	wire c0,c1,c2,c3;
	wire d0,d1,d2,d3,d4,d5,d6,d7;
	wire e0,e1,e2,e3,e4,e5,e6,e7;
	wire f0,f1,f2,f3,f4,f5,f6,f7;
	
	wire BCD_temp; //dummy
 
	assign BCD[0] = binary[0];
	
	add3 u1({a3,a2,a1,a0},{1'b0,binary[9],binary[8],binary[7]});
	add3 u2({b3,b2,b1,b0},{a2,a1,a0,binary[6]});
	add3 u3({c3,c2,c1,c0},{b2,b1,b0,binary[5]});
	add3 u4({d3,d2,d1,d0},{c2,c1,c0,binary[4]});
	add3 u5({e3,e2,e1,e0},{d2,d1,d0,binary[3]});
	add3 u6({f3,f2,f1,f0},{e2,e1,e0,binary[2]});
	add3 u7({BCD[4],BCD[3],BCD[2],BCD[1]},{f2,f1,f0,binary[1]});
	add3 u8({d7,d6,d5,d4},{1'b0,a3,b3,c3});
	add3 u9({e7,e6,e5,e4},{d6,d5,d4,d3});
	add3 u10({f7,f6,f5,f4},{e6,e5,e4,e3});
	add3 u11({BCD[8],BCD[7],BCD[6],BCD[5]},{f6,f5,f4,f3});
	add3 u12({BCD_temp,BCD[11],BCD[10],BCD[9]},{1'b0,d7,e7,f7});
	
endmodule
 
module add3(out,in);
 
	input [3:0] in;
	output reg [3:0] out;
 
	always @(in) 
	begin
		if(in > 4'd4) out <= in + 4'd3;
		else out <= in;
	end
	
endmodule
