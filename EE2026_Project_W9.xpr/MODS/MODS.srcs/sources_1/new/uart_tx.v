`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 14:34:52
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input tx_en,
    input [13:0] data,
    output reg tx
    );
    
    reg [3:0] bit_count = 0;
    reg [13:0] shift_reg;
    reg sending = 0;
    
    ///////////////////////////////////////////clk
    wire baud_clk;
    flexi_clk clk9600hz(clk,32'd5027, baud_clk);  
    
    always@(posedge baud_clk)
    begin
    ////////initialise
        if(tx_en)
        begin
            if(!sending)
            begin
                shift_reg <= data;
                bit_count <= 0;
                tx <= 0;
                sending <= 1;
            end
            else begin
                if(bit_count < 14) //////this is when we have not reached the end
                begin
                    tx <= shift_reg[0]; ///take the LSB, from the right
                    shift_reg <= {1'b0,shift_reg[13:1]}; //////replace MSB with a 0
                    bit_count <= bit_count + 1;
                end 
                else ////////this is when we reach the end of the message
                begin
                    tx <= 1;
                    sending <= 0; //finish sending 
                end
            end
         end
    end
endmodule
