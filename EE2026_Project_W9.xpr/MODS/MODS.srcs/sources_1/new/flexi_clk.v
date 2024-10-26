`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 20:54:04
// Design Name: 
// Module Name: flexi_clk
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


module flexi_clk(
    input clk,
    input [31:0] max_count,
    output reg slow_clk
    );
    
    reg [31:0] count;
    
    always@(posedge clk)
    begin
        count <= (count == max_count)?0:count + 1;
        slow_clk <= (count == 0)?~slow_clk:slow_clk;
    end
    
endmodule
