`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dhananjay Joshi
// 
// Create Date:    18:54:09 02/17/2022 
// Design Name: 
// Module Name:    seven_segment_top 
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
module seven_segment_top(
									output a,
									output b,
									output c,
									output d,
									output e,
									output f,
									output g,
									output h,
									output enable_pin_1,
									output enable_pin_2,
									output enable_pin_3,
									input direct_binary_input,
									input clk,
									input reset
								);
 
	//10-bit count value
	reg [9:0] count = 10'd0;
	
	// direction = 1/0 means up/down counter respectively	
	reg direction_counter = 1'b1; 
	
	//the 3 separate digits of count
	wire [3:0] digit0,digit1,digit2; 
	
	//value of current digit being displayed
	reg [3:0] currentDig; 
	//which digit is being currently displayed
	reg [1:0] digitNum = 2'd0; 
	
	//enable only the digit that is being displayed
	reg digit0en, digit1en, digit2en; 
	assign enable_pin_1 = digit2en; 
	assign enable_pin_2 = digit1en; 
	assign enable_pin_3 = digit0en;
 
	//digit switching clock
	reg [15:0] dispClk = 16'd0; 
	
	//1sec clock
	reg [26:0] cnt1sec = 27'd0; 
	wire clk1sec; 
	
	assign clk1sec = (cnt1sec == 27'd100000000);
	wire direct_binary_inputDB;
 
	binary_to_bcd v1({digit2,digit1,digit0}, count); //shift add3
	bcd_to_seven_segment v2(a,b,c,d,e,f,g,h,currentDig);
	debounce db1(direct_binary_inputDB, direct_binary_input,clk); //debounce made into a module
 
	always @(posedge clk or negedge reset) 
	begin
		if(!reset) 
		begin
			dispClk <= 16'd0;
			cnt1sec <= 27'd0; 
		end
		
		else 
		begin
			dispClk <= dispClk + 1'b1;
			if(cnt1sec == 27'd100000000) cnt1sec <= 27'd0;
			else cnt1sec <= cnt1sec + 1'b1;
		end
	end
 
	always @(posedge direct_binary_inputDB or negedge reset)
	begin
	if(direct_binary_inputDB)
		begin
			if(!reset) direction_counter <= 1'b1;
			else direction_counter <= !direction_counter;
		end
	end
 
	always @(posedge clk1sec or negedge reset) 
	begin
		if(clk1sec)
			begin
				if(!reset) 
					begin 
						count<=10'd0; 
					end
				else 
					begin
						if(direction_counter) 
							begin
								if(count == 10'd999) count <= 10'd0;
								else count <= count+1; 
							end
						else 
							begin
								if(count == 10'd0) count <= 10'd999;
								else count <= count - 1; 
							end
					end
			end
	end
 
	always @(posedge dispClk[15]) begin
		case (digitNum)
			2'd0: 
			begin //units place-always displayed
				digitNum <= 2'd1;
				digit2en <= 1'b1;
				digit1en <= 1'b1;
				digit0en <= 1'b0;
				currentDig <= digit0;
			end
			2'd1: 
			begin //tens place only if non zero
			digitNum <= 2'd2;
			if(digit1 == 4'd0 & digit2==4'd0) 
				begin 
					digit2en <= 1'b1;
					digit1en <= 1'b1;
					digit0en <= 1'b1; 
				end
			else 
				begin 
					digit2en <= 1'b1;
					digit1en <= 1'b0;
					digit0en <= 1'b1; 
					currentDig <= digit1; 
				end
			end
			2'd2: 
			begin
				digitNum <= 2'd0; //hundred's place only if non zero
				if(digit2==4'd0) 
					begin 
						digit2en <= 1'b1;
						digit1en <= 1'b1;
						digit0en <= 1'b1; 
					end
				else 
					begin 
						digit2en <= 1'b0;
						digit1en <= 1'b1;
						digit0en <= 1'b1; 
						currentDig <= digit2; 
					end
			end
		endcase
	end
endmodule
 
 
module bcd_to_seven_segment(a,b,c,d,e,f,g,h,DisplayNum);
 
input [3:0] DisplayNum;
output reg a,b,c,d,e,f,g;
output reg h = 1;
 
 
 
	always @(DisplayNum) 
	begin
		case (DisplayNum)
			0 : {a,b,c,d,e,f,g} <= 7'b0000001;
			1 : {a,b,c,d,e,f,g} <= 7'b1001111;
			2 : {a,b,c,d,e,f,g} <= 7'b0010010;
			3 : {a,b,c,d,e,f,g} <= 7'b0000110;
			4 : {a,b,c,d,e,f,g} <= 7'b1001100;
			5 : {a,b,c,d,e,f,g} <= 7'b0100100;
			6 : {a,b,c,d,e,f,g} <= 7'b0100000;
			7 : {a,b,c,d,e,f,g} <= 7'b0001111;
			8 : {a,b,c,d,e,f,g} <= 7'b0000000;
			9 : {a,b,c,d,e,f,g} <= 7'b0000100;
			default : {a,b,c,d,e,f,g} <= 7'b1111111;
		endcase
	end
	
endmodule
 
 
module debounce(buttonDB,button,clk);
input button,clk;
output buttonDB;
					
 
	reg [24:0] debounceCnt = 25'd0;
	reg pressed = 1'b0;
	wire buttonDB;
	assign buttonDB = &debounceCnt;
 
	always @(negedge button or posedge buttonDB)
		if(buttonDB) pressed <= 0;
		else pressed <= 1;
 
	always @(posedge clk)
		if(pressed) debounceCnt <= debounceCnt+1;
		else debounceCnt <= 0;
		
endmodule
