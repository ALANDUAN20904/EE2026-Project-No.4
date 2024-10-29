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
                    (input[9:0] health,input clk, output reg [9:0]led);

///////////////////global parameter 
//`ifndef PARAMETERS
//`define PARAMETERS
          
//`endif

//////////////////////////////////////////////////////clks
//wire clk_1hz;
//flexi_clk clk1hzHB(clk, 32'd49999999,clk_1hz);

/////////////////////////////////receiving health variable from the main module


//////////////////////////////////resolution is 8, it's 8 bit countup to 255 (in total 256 counts)

reg [R-1:0] count = 0;
reg [R-1:0] duty;



//reg [9:0]duty_counter = 0;

//always@(posedge clk_1hz)
//begin
//    duty_counter <= (duty_counter == 10)?0: duty_counter + 1;
//end

/////////////////////////////////health point divider

reg [9:0] health_divide;
reg [9:0] health_mod;


always@(posedge clk)
begin
health_mod <= health % 10;
    case(health_mod)
        10'd0: duty = DUTY1;
        10'd1: duty = DUTY2;
        10'd2: duty = DUTY3;
        10'd3: duty = DUTY4;
        10'd4: duty = DUTY5;
        10'd5: duty = DUTY6;
        10'd6: duty = DUTY7;
        10'd7: duty = DUTY8;
        10'd8: duty = DUTY9;
        10'd9: duty = DUTY10;
        default: duty <= 0;
    endcase
end

always@(posedge clk)
begin
    count <= (count == 1023)?0:count + 1;
end

always@(posedge clk)
begin

    health_divide <= health / 10;  
    ////////first led
    if (health_divide < 1 )
    begin
        led[9:1] <= 9'b000000000;
        led[0] <= (count<duty)?1:0;
    end
    
    /////////second led
    if (health_divide >= 1 && health_divide < 2)
    begin
        led[9:2] <= 8'b00000000;
        led[1] <= (count<duty)?1:0;
        led[0] <= 1;
    end
    
    /////////third led
    if (health_divide >= 2 && health_divide < 3)
    begin
        led[9:3] <= 7'b0000000;
        led[2] <= (count<duty)?1:0;
        led[1:0] <= 2'b11;
    end
    
    /////////fourth led
    if (health_divide >= 3 && health_divide < 4)
    begin
        led[9:4] <= 6'b000000;
        led[3] <= (count<duty)?1:0;
        led[2:0] <= 3'b111;
    end
    
    /////////fifth led
    if (health_divide >= 4 && health_divide < 5)
    begin
        led[9:5] <= 5'b00000;
        led[4] <= (count<duty)?1:0;
        led[3:0] <= 4'b1111;
    end
    
    /////////sixth led
    if (health_divide >= 5 && health_divide < 6)
    begin
        led[9:6] <= 4'b0000;
        led[5] <= (count<duty)?1:0;
        led[4:0] <= 5'b11111;
    end
    
    /////////seventh led
    if (health_divide >= 6 && health_divide < 7)
    begin
        led[9:7] <= 3'b000;
        led[6] <= (count<duty)?1:0;
        led[5:0] <= 6'b111111;
    end
    
    /////////eighth led
    if (health_divide >= 7 && health_divide < 8)
    begin
        led[9:8] <= 2'b00;
        led[7] <= (count<duty)?1:0;
        led[6:0] <= 7'b1111111;
    end
    
    /////////nineth led
    if (health_divide >= 8 && health_divide < 9)
    begin
        led[9] <= 1'b0;
        led[8] <= (count<duty)?1:0;
        led[7:0] <= 8'b11111111;
    end
    
    /////////tenth led
    if (health_divide >= 9 && health_divide < 10)
    begin
        led[9] <= (count<duty)?1:0;
        led[8:0] <= 9'b111111111;
    end
    
    if(health_divide == 10)
    begin
        led[9:0] <= 10'b1111111111;
    end
end
endmodule
