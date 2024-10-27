`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 23:58:01
// Design Name: 
// Module Name: HealthBar
// Project Name: 
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


module HealthBar#(parameter R = 8,
          parameter DUTY1 = 8'd64,
                    DUTY2 = 8'd30,
                    DUTY3 = 8'd10)
                    (input clk,input [3:1] sw, output reg pwm_out);

///////////////////global parameter 
//`ifndef PARAMETERS
//`define PARAMETERS
          
//`endif

//////////////////////////////////////////////////////clks
wire clk_20hz;
flexi_clk clk20hzHB(clk, 32'd2499999,clk_20hz);

//////////////////////////////////resolution is 8, it's 8 bit countup to 255 (in total 256 counts)

reg [R-1:0] count = 0;
reg [R-1:0] duty;

///////////////////////////////////////////////////////sw
/////later implement 3 switches, so 3 switches represent value, where duty = value * (2**R), so 3 values would be 0.25 0.5 and 0.75

always@(posedge clk)
begin
    case(sw)
    3'b001: duty <= DUTY1;
    3'b010: duty <= DUTY2;
    3'b100: duty <= DUTY3;
    default: duty <= 0;
    endcase
end

////////////////////////////////////////////////increment duty cycle by 20hz
//always@(clk_20hz)
//begin
//    duty <= (duty == 8'd255)?0:duty + 1;
//end

always@(posedge clk)
begin
    count <= (count == 255)?0:count + 1;
end

always@(posedge clk)
begin
    pwm_out <= (count<duty)?1:0;
end
endmodule
