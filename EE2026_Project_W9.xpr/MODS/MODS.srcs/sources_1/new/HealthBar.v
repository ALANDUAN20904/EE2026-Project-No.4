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


module HealthBar#(parameter R = 10,
          parameter DUTY1 = 10'd1,
                    DUTY2 = 10'd3,
                    DUTY3 = 10'd10,
                    DUTY4 = 10'd30,
                    DUTY5 = 10'd70,
                    DUTY6 = 10'd150,
                    DUTY7 = 10'd300,
                    DUTY8 = 10'd500,
                    DUTY9 = 10'd750,
                    DUTY10 = 10'd1000
                    )
                    (input clk,input [3:1] sw, output reg pwm_out);

///////////////////global parameter 
//`ifndef PARAMETERS
//`define PARAMETERS
          
//`endif

//////////////////////////////////////////////////////clks
wire clk_1hz;
flexi_clk clk1hzHB(clk, 32'd49999999,clk_1hz);
    
//////////////////////////////////resolution is 8, it's 8 bit countup to 255 (in total 256 counts)

reg [R-1:0] count = 0;
reg [R-1:0] duty;

///////////////////////////////////////////////////////sw
/////later implement 3 switches, so 3 switches represent value, where duty = value * (2**R), so 3 values would be 0.25 0.5 and 0.75
reg [9:0]duty_counter = 0;

always@(posedge clk_1hz)
begin
    duty_counter <= (duty_counter == 10)?0: duty_counter + 1;
end
always@(posedge clk)
begin
    case(duty_counter)
        4'd0: duty = DUTY1;
        4'd1: duty = DUTY2;
        4'd2: duty = DUTY3;
        4'd3: duty = DUTY4;
        4'd4: duty = DUTY5;
        4'd5: duty = DUTY6;
        4'd6: duty = DUTY7;
        4'd7: duty = DUTY8;
        4'd8: duty = DUTY9;
        4'd9: duty = DUTY10;
        default: duty <= 0;
    endcase
end

always@(posedge clk)
begin
    count <= (count == 1023)?0:count + 1;
end

always@(posedge clk)
begin
    pwm_out <= (count<duty)?1:0;
end
endmodule
