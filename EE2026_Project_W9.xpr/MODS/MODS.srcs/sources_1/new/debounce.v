`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 23:48:00
// Design Name: 
// Module Name: debounce
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


module debounce(
    input btnU,
    input btnC,
    input btnL,
    input btnR,
    input btnD,
    input clk,
    output  btnU_d,
    output  btnC_d,
    output  btnL_d,
    output  btnR_d,
    output  btnD_d
);

////////////////////////////////////// 500Hz clk for 20ms debounce check time
wire clk_4hz;
flexi_clk clk500hz (clk, 32'd12499999, clk_4hz); 

////////////////////////////////// DFF for each button
wire Q1_U, Q2_U;
dff dff1U(.clk(clk_4hz), .D(btnU), .Q(Q1_U));
dff dff2U(.clk(clk_4hz), .D(Q1_U), .Q(Q2_U));
assign btnU_d = Q1_U & ~Q2_U;

wire Q1_C, Q2_C;
dff dff1C(.clk(clk_4hz), .D(btnC), .Q(Q1_C));
dff dff2C(.clk(clk_4hz), .D(Q1_C), .Q(Q2_C));
assign btnC_d = Q1_C & ~Q2_C;

wire Q1_L, Q2_L;
dff dff1L(.clk(clk_4hz), .D(btnL), .Q(Q1_L));
dff dff2L(.clk(clk_4hz), .D(Q1_L), .Q(Q2_L));
assign btnL_d = Q1_L & ~Q2_L;

wire Q1_R, Q2_R;
dff dff1R(.clk(clk_4hz), .D(btnR), .Q(Q1_R));
dff dff2R(.clk(clk_4hz), .D(Q1_R), .Q(Q2_R));
assign btnR_d = Q1_R & ~Q2_R;

wire Q1_D, Q2_D;
dff dff1D(.clk(clk_4hz), .D(btnD), .Q(Q1_D));
dff dff2D(.clk(clk_4hz), .D(Q1_D), .Q(Q2_D));
assign btnD_d = Q1_D & ~Q2_D;

endmodule