`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 15:33:07
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input rx,
    input rx_en,
    output reg [13:0] received_score
    );
    
    reg [3:0] bit_count = 0;
    reg [13:0] shift_reg;
    reg receiving = 0;
    
    //////////////////////////clk
    wire baud_clk;
    flexi_clk clk9600hz(clk,32'd5027, baud_clk);  
    
    always@(posedge baud_clk)
    begin
        if(rx_en)
        begin
            if(!receiving && rx)
            begin
                bit_count <= 0;
                receiving <= 1;
            end
            else if (receiving)
            begin
                if(bit_count < 14)
                begin
                    shift_reg[bit_count] <= rx;
                    bit_count <= bit_count + 1;
                end
                else if(bit_count == 14)
                begin
                    received_score <= shift_reg;
                    bit_count <= 0;
                    receiving <= 0;
                end
            end
        end
    end
endmodule
